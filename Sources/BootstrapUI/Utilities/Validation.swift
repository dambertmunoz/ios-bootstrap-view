// Validation.swift
// BootstrapUI
//
// Input validation utilities
// Follows Strategy Pattern - different validation strategies

import Foundation

// MARK: - Validation Rule Protocol

/// Protocol for validation rules
public protocol BSValidationRule {
    func validate(_ value: String) -> BSInputValidation
}

// MARK: - Common Validation Rules

/// Validates that a field is not empty
public struct BSRequiredRule: BSValidationRule {
    private let message: String

    public init(message: String = "This field is required") {
        self.message = message
    }

    public func validate(_ value: String) -> BSInputValidation {
        value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? .invalid(message)
            : .valid
    }
}

/// Validates email format
public struct BSEmailRule: BSValidationRule {
    private let message: String

    public init(message: String = "Please enter a valid email address") {
        self.message = message
    }

    public func validate(_ value: String) -> BSInputValidation {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: value) ? .valid : .invalid(message)
    }
}

/// Validates minimum length
public struct BSMinLengthRule: BSValidationRule {
    private let minLength: Int
    private let message: String

    public init(minLength: Int, message: String? = nil) {
        self.minLength = minLength
        self.message = message ?? "Must be at least \(minLength) characters"
    }

    public func validate(_ value: String) -> BSInputValidation {
        value.count >= minLength ? .valid : .invalid(message)
    }
}

/// Validates maximum length
public struct BSMaxLengthRule: BSValidationRule {
    private let maxLength: Int
    private let message: String

    public init(maxLength: Int, message: String? = nil) {
        self.maxLength = maxLength
        self.message = message ?? "Must be no more than \(maxLength) characters"
    }

    public func validate(_ value: String) -> BSInputValidation {
        value.count <= maxLength ? .valid : .invalid(message)
    }
}

/// Validates using a regular expression
public struct BSRegexRule: BSValidationRule {
    private let pattern: String
    private let message: String

    public init(pattern: String, message: String) {
        self.pattern = pattern
        self.message = message
    }

    public func validate(_ value: String) -> BSInputValidation {
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: value) ? .valid : .invalid(message)
    }
}

/// Validates phone number format
public struct BSPhoneRule: BSValidationRule {
    private let message: String

    public init(message: String = "Please enter a valid phone number") {
        self.message = message
    }

    public func validate(_ value: String) -> BSInputValidation {
        let phoneRegex = "^[+]?[(]?[0-9]{1,4}[)]?[-\\s.]?[0-9]{1,4}[-\\s.]?[0-9]{1,9}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: value) ? .valid : .invalid(message)
    }
}

/// Validates URL format
public struct BSURLRule: BSValidationRule {
    private let message: String

    public init(message: String = "Please enter a valid URL") {
        self.message = message
    }

    public func validate(_ value: String) -> BSInputValidation {
        guard let url = URL(string: value),
              url.scheme != nil,
              url.host != nil else {
            return .invalid(message)
        }
        return .valid
    }
}

/// Validates password strength
public struct BSPasswordRule: BSValidationRule {
    private let minLength: Int
    private let requiresUppercase: Bool
    private let requiresLowercase: Bool
    private let requiresNumber: Bool
    private let requiresSpecialChar: Bool

    public init(
        minLength: Int = 8,
        requiresUppercase: Bool = true,
        requiresLowercase: Bool = true,
        requiresNumber: Bool = true,
        requiresSpecialChar: Bool = false
    ) {
        self.minLength = minLength
        self.requiresUppercase = requiresUppercase
        self.requiresLowercase = requiresLowercase
        self.requiresNumber = requiresNumber
        self.requiresSpecialChar = requiresSpecialChar
    }

    public func validate(_ value: String) -> BSInputValidation {
        if value.count < minLength {
            return .invalid("Password must be at least \(minLength) characters")
        }

        if requiresUppercase && value.range(of: "[A-Z]", options: .regularExpression) == nil {
            return .invalid("Password must contain an uppercase letter")
        }

        if requiresLowercase && value.range(of: "[a-z]", options: .regularExpression) == nil {
            return .invalid("Password must contain a lowercase letter")
        }

        if requiresNumber && value.range(of: "[0-9]", options: .regularExpression) == nil {
            return .invalid("Password must contain a number")
        }

        if requiresSpecialChar && value.range(of: "[^A-Za-z0-9]", options: .regularExpression) == nil {
            return .invalid("Password must contain a special character")
        }

        return .valid
    }
}

/// Validates that two fields match
public struct BSMatchRule: BSValidationRule {
    private let otherValue: String
    private let message: String

    public init(otherValue: String, message: String = "Values do not match") {
        self.otherValue = otherValue
        self.message = message
    }

    public func validate(_ value: String) -> BSInputValidation {
        value == otherValue ? .valid : .invalid(message)
    }
}

// MARK: - Validator

/// Validator that combines multiple rules
public struct BSValidator {
    private let rules: [BSValidationRule]

    public init(rules: [BSValidationRule]) {
        self.rules = rules
    }

    /// Validate a value against all rules
    /// - Parameter value: The value to validate
    /// - Returns: First failing validation or .valid if all pass
    public func validate(_ value: String) -> BSInputValidation {
        for rule in rules {
            let result = rule.validate(value)
            if case .invalid = result {
                return result
            }
        }
        return rules.isEmpty ? .none : .valid
    }
}

// MARK: - Convenience Extensions

extension BSInputValidation {

    /// Check if validation passed
    public var isValid: Bool {
        if case .valid = self { return true }
        return false
    }

    /// Check if validation failed
    public var isInvalid: Bool {
        if case .invalid = self { return true }
        return false
    }

    /// Get the error message if invalid
    public var errorMessage: String? {
        if case .invalid(let message) = self {
            return message
        }
        return nil
    }
}
