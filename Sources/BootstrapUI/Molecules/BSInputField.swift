// BSInputField.swift
// BootstrapUI
//
// Enhanced input field with label, validation, and helper text
// Follows Composition - combines atoms into a complete form field

import SwiftUI

// MARK: - Input Field Validation

/// Validation result for input fields
public enum BSInputValidation: Equatable {
    case none
    case valid
    case invalid(String)

    var state: BSTextFieldState {
        switch self {
        case .none: return .normal
        case .valid: return .success
        case .invalid(let message): return .error(message)
        }
    }
}

// MARK: - Input Field Component

/// An enhanced input field combining label, text field, validation, and helper text
///
/// Example usage:
/// ```swift
/// @State private var email = ""
/// @State private var validation: BSInputValidation = .none
///
/// BSInputField(
///     label: "Email Address",
///     text: $email,
///     placeholder: "you@example.com",
///     helperText: "We'll never share your email",
///     validation: validation,
///     icon: "envelope"
/// )
/// ```
public struct BSInputField: View {

    // MARK: - Properties

    private let label: String
    @Binding private var text: String
    private let placeholder: String
    private let helperText: String?
    private let validation: BSInputValidation
    private let style: BSTextFieldStyle
    private let icon: String?
    private let trailingIcon: String?
    private let isSecure: Bool
    private let isRequired: Bool
    private let isDisabled: Bool
    private let characterLimit: Int?
    private let keyboardType: UIKeyboardType
    private let autocapitalization: TextInputAutocapitalization
    private let submitLabel: SubmitLabel
    private let onSubmit: (() -> Void)?
    private let onTrailingIconTap: (() -> Void)?

    @Environment(\.theme) private var theme
    @FocusState private var isFocused: Bool

    // MARK: - Initialization

    /// Creates an enhanced input field
    /// - Parameters:
    ///   - label: Field label
    ///   - text: Binding to text value
    ///   - placeholder: Placeholder text
    ///   - helperText: Optional helper text below the field
    ///   - validation: Validation state
    ///   - style: Visual style
    ///   - icon: Leading icon
    ///   - trailingIcon: Trailing icon
    ///   - isSecure: Whether to mask input
    ///   - isRequired: Whether field is required
    ///   - isDisabled: Whether field is disabled
    ///   - characterLimit: Optional character limit
    ///   - keyboardType: Keyboard type
    ///   - autocapitalization: Autocapitalization behavior
    ///   - submitLabel: Submit button label
    ///   - onSubmit: Action when submit is pressed
    ///   - onTrailingIconTap: Action when trailing icon is tapped
    public init(
        label: String,
        text: Binding<String>,
        placeholder: String = "",
        helperText: String? = nil,
        validation: BSInputValidation = .none,
        style: BSTextFieldStyle = .outlined,
        icon: String? = nil,
        trailingIcon: String? = nil,
        isSecure: Bool = false,
        isRequired: Bool = false,
        isDisabled: Bool = false,
        characterLimit: Int? = nil,
        keyboardType: UIKeyboardType = .default,
        autocapitalization: TextInputAutocapitalization = .sentences,
        submitLabel: SubmitLabel = .done,
        onSubmit: (() -> Void)? = nil,
        onTrailingIconTap: (() -> Void)? = nil
    ) {
        self.label = label
        self._text = text
        self.placeholder = placeholder
        self.helperText = helperText
        self.validation = validation
        self.style = style
        self.icon = icon
        self.trailingIcon = trailingIcon
        self.isSecure = isSecure
        self.isRequired = isRequired
        self.isDisabled = isDisabled
        self.characterLimit = characterLimit
        self.keyboardType = keyboardType
        self.autocapitalization = autocapitalization
        self.submitLabel = submitLabel
        self.onSubmit = onSubmit
        self.onTrailingIconTap = onTrailingIconTap
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: theme.xs) {
            // Label with required indicator
            labelView

            // Text field
            BSTextField(
                "",
                text: $text,
                state: fieldState,
                placeholder: placeholder,
                style: style,
                icon: icon,
                trailingIcon: effectiveTrailingIcon,
                isSecure: isSecure && !showPassword,
                keyboardType: keyboardType,
                autocapitalization: autocapitalization,
                submitLabel: submitLabel,
                onSubmit: onSubmit,
                onTrailingIconTap: handleTrailingIconTap
            )

            // Footer (helper text, character count, or validation message)
            footerView
        }
    }

    // MARK: - Private Views

    private var labelView: some View {
        HStack(spacing: theme.xxs) {
            Text(label)
                .font(theme.subheadline)
                .fontWeight(.medium)
                .foregroundColor(labelColor)

            if isRequired {
                Text("*")
                    .foregroundColor(theme.error)
            }
        }
    }

    @ViewBuilder
    private var footerView: some View {
        HStack {
            // Helper text or validation message
            if case .invalid(let message) = validation {
                Text(message)
                    .font(theme.caption1)
                    .foregroundColor(theme.error)
            } else if let helperText = helperText {
                Text(helperText)
                    .font(theme.caption1)
                    .foregroundColor(theme.placeholder)
            }

            Spacer()

            // Character count
            if let limit = characterLimit {
                Text("\(text.count)/\(limit)")
                    .font(theme.caption1)
                    .foregroundColor(text.count > limit ? theme.error : theme.placeholder)
            }
        }
    }

    // MARK: - Computed Properties

    @State private var showPassword = false

    private var fieldState: BSTextFieldState {
        if isDisabled { return .disabled }
        return validation.state
    }

    private var labelColor: Color {
        switch validation {
        case .invalid: return theme.error
        default: return theme.onSurface.opacity(0.7)
        }
    }

    private var effectiveTrailingIcon: String? {
        if isSecure {
            return showPassword ? "eye.slash" : "eye"
        }
        return trailingIcon
    }

    private func handleTrailingIconTap() {
        if isSecure {
            showPassword.toggle()
        } else {
            onTrailingIconTap?()
        }
    }
}

// MARK: - Password Field

/// A specialized input field for passwords with visibility toggle
public struct BSPasswordField: View {

    private let label: String
    @Binding private var text: String
    private let placeholder: String
    private let validation: BSInputValidation
    private let showStrengthIndicator: Bool

    @State private var showPassword = false
    @Environment(\.theme) private var theme

    public init(
        label: String = "Password",
        text: Binding<String>,
        placeholder: String = "Enter your password",
        validation: BSInputValidation = .none,
        showStrengthIndicator: Bool = false
    ) {
        self.label = label
        self._text = text
        self.placeholder = placeholder
        self.validation = validation
        self.showStrengthIndicator = showStrengthIndicator
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: theme.xs) {
            BSInputField(
                label: label,
                text: $text,
                placeholder: placeholder,
                validation: validation,
                icon: "lock",
                isSecure: true
            )

            if showStrengthIndicator && !text.isEmpty {
                passwordStrengthIndicator
            }
        }
    }

    private var passwordStrengthIndicator: some View {
        VStack(alignment: .leading, spacing: theme.xxs) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(theme.border)
                        .frame(height: 4)

                    Rectangle()
                        .fill(strengthColor)
                        .frame(width: geometry.size.width * strengthProgress, height: 4)
                        .animation(.easeInOut, value: strengthProgress)
                }
                .cornerRadius(2)
            }
            .frame(height: 4)

            Text(strengthLabel)
                .font(theme.caption2)
                .foregroundColor(strengthColor)
        }
    }

    private var passwordStrength: Int {
        var score = 0
        if text.count >= 8 { score += 1 }
        if text.count >= 12 { score += 1 }
        if text.range(of: "[A-Z]", options: .regularExpression) != nil { score += 1 }
        if text.range(of: "[0-9]", options: .regularExpression) != nil { score += 1 }
        if text.range(of: "[^A-Za-z0-9]", options: .regularExpression) != nil { score += 1 }
        return score
    }

    private var strengthProgress: CGFloat {
        CGFloat(passwordStrength) / 5.0
    }

    private var strengthLabel: String {
        switch passwordStrength {
        case 0...1: return "Weak"
        case 2...3: return "Medium"
        case 4: return "Strong"
        default: return "Very Strong"
        }
    }

    private var strengthColor: Color {
        switch passwordStrength {
        case 0...1: return theme.error
        case 2...3: return theme.warning
        default: return theme.success
        }
    }
}

// MARK: - Preview

#if DEBUG
struct BSInputField_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 24) {
                BSInputField(
                    label: "Email Address",
                    text: .constant(""),
                    placeholder: "you@example.com",
                    helperText: "We'll never share your email",
                    icon: "envelope",
                    isRequired: true
                )

                BSInputField(
                    label: "Username",
                    text: .constant("john_doe"),
                    validation: .valid,
                    icon: "person"
                )

                BSInputField(
                    label: "Website",
                    text: .constant("invalid"),
                    validation: .invalid("Please enter a valid URL"),
                    icon: "globe"
                )

                BSInputField(
                    label: "Bio",
                    text: .constant("Hello world"),
                    helperText: "Tell us about yourself",
                    characterLimit: 100
                )

                BSPasswordField(
                    text: .constant("password123"),
                    showStrengthIndicator: true
                )
            }
            .padding()
        }
        .withTheme()
    }
}
#endif
