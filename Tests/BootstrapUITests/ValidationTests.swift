// ValidationTests.swift
// BootstrapUITests
//
// Unit tests for validation rules and validators

import XCTest
@testable import BootstrapUI

final class ValidationTests: XCTestCase {

    // MARK: - Required Rule Tests

    func testRequiredRuleWithEmptyString() {
        let rule = BSRequiredRule()
        let result = rule.validate("")

        XCTAssertTrue(result.isInvalid)
        XCTAssertEqual(result.errorMessage, "This field is required")
    }

    func testRequiredRuleWithWhitespace() {
        let rule = BSRequiredRule()
        let result = rule.validate("   ")

        XCTAssertTrue(result.isInvalid)
    }

    func testRequiredRuleWithValue() {
        let rule = BSRequiredRule()
        let result = rule.validate("Hello")

        XCTAssertTrue(result.isValid)
    }

    func testRequiredRuleCustomMessage() {
        let rule = BSRequiredRule(message: "Custom error")
        let result = rule.validate("")

        XCTAssertEqual(result.errorMessage, "Custom error")
    }

    // MARK: - Email Rule Tests

    func testEmailRuleWithValidEmail() {
        let rule = BSEmailRule()

        XCTAssertTrue(rule.validate("test@example.com").isValid)
        XCTAssertTrue(rule.validate("user.name@domain.co.uk").isValid)
        XCTAssertTrue(rule.validate("user+tag@example.org").isValid)
    }

    func testEmailRuleWithInvalidEmail() {
        let rule = BSEmailRule()

        XCTAssertTrue(rule.validate("invalid").isInvalid)
        XCTAssertTrue(rule.validate("test@").isInvalid)
        XCTAssertTrue(rule.validate("@example.com").isInvalid)
        XCTAssertTrue(rule.validate("test@example").isInvalid)
    }

    // MARK: - Min Length Rule Tests

    func testMinLengthRuleWithValidLength() {
        let rule = BSMinLengthRule(minLength: 5)
        let result = rule.validate("Hello")

        XCTAssertTrue(result.isValid)
    }

    func testMinLengthRuleWithShortString() {
        let rule = BSMinLengthRule(minLength: 5)
        let result = rule.validate("Hi")

        XCTAssertTrue(result.isInvalid)
        XCTAssertEqual(result.errorMessage, "Must be at least 5 characters")
    }

    func testMinLengthRuleWithExactLength() {
        let rule = BSMinLengthRule(minLength: 5)
        let result = rule.validate("12345")

        XCTAssertTrue(result.isValid)
    }

    // MARK: - Max Length Rule Tests

    func testMaxLengthRuleWithValidLength() {
        let rule = BSMaxLengthRule(maxLength: 10)
        let result = rule.validate("Hello")

        XCTAssertTrue(result.isValid)
    }

    func testMaxLengthRuleWithLongString() {
        let rule = BSMaxLengthRule(maxLength: 5)
        let result = rule.validate("Hello World")

        XCTAssertTrue(result.isInvalid)
    }

    // MARK: - Phone Rule Tests

    func testPhoneRuleWithValidNumbers() {
        let rule = BSPhoneRule()

        XCTAssertTrue(rule.validate("1234567890").isValid)
        XCTAssertTrue(rule.validate("+1-234-567-8900").isValid)
        XCTAssertTrue(rule.validate("(123) 456-7890").isValid)
    }

    func testPhoneRuleWithInvalidNumbers() {
        let rule = BSPhoneRule()

        XCTAssertTrue(rule.validate("abc").isInvalid)
        XCTAssertTrue(rule.validate("123-abc-4567").isInvalid)
    }

    // MARK: - URL Rule Tests

    func testURLRuleWithValidURLs() {
        let rule = BSURLRule()

        XCTAssertTrue(rule.validate("https://example.com").isValid)
        XCTAssertTrue(rule.validate("http://example.com/path").isValid)
        XCTAssertTrue(rule.validate("https://sub.example.com").isValid)
    }

    func testURLRuleWithInvalidURLs() {
        let rule = BSURLRule()

        XCTAssertTrue(rule.validate("not a url").isInvalid)
        XCTAssertTrue(rule.validate("example.com").isInvalid)
    }

    // MARK: - Password Rule Tests

    func testPasswordRuleWithStrongPassword() {
        let rule = BSPasswordRule()
        let result = rule.validate("Password123")

        XCTAssertTrue(result.isValid)
    }

    func testPasswordRuleWithWeakPassword() {
        let rule = BSPasswordRule()

        XCTAssertTrue(rule.validate("pass").isInvalid) // Too short
        XCTAssertTrue(rule.validate("password").isInvalid) // No uppercase
        XCTAssertTrue(rule.validate("PASSWORD").isInvalid) // No lowercase
        XCTAssertTrue(rule.validate("Password").isInvalid) // No number
    }

    func testPasswordRuleWithSpecialCharRequired() {
        let rule = BSPasswordRule(requiresSpecialChar: true)

        XCTAssertTrue(rule.validate("Password123").isInvalid)
        XCTAssertTrue(rule.validate("Password123!").isValid)
    }

    // MARK: - Match Rule Tests

    func testMatchRuleWithMatchingValues() {
        let rule = BSMatchRule(otherValue: "password")
        let result = rule.validate("password")

        XCTAssertTrue(result.isValid)
    }

    func testMatchRuleWithNonMatchingValues() {
        let rule = BSMatchRule(otherValue: "password")
        let result = rule.validate("different")

        XCTAssertTrue(result.isInvalid)
        XCTAssertEqual(result.errorMessage, "Values do not match")
    }

    // MARK: - Regex Rule Tests

    func testRegexRuleWithMatch() {
        let rule = BSRegexRule(pattern: "^[0-9]+$", message: "Numbers only")
        let result = rule.validate("12345")

        XCTAssertTrue(result.isValid)
    }

    func testRegexRuleWithNoMatch() {
        let rule = BSRegexRule(pattern: "^[0-9]+$", message: "Numbers only")
        let result = rule.validate("123abc")

        XCTAssertTrue(result.isInvalid)
        XCTAssertEqual(result.errorMessage, "Numbers only")
    }

    // MARK: - Validator Tests

    func testValidatorWithAllRulesPassing() {
        let validator = BSValidator(rules: [
            BSRequiredRule(),
            BSMinLengthRule(minLength: 3),
            BSMaxLengthRule(maxLength: 10)
        ])

        let result = validator.validate("Hello")

        XCTAssertTrue(result.isValid)
    }

    func testValidatorWithFirstRuleFailing() {
        let validator = BSValidator(rules: [
            BSRequiredRule(),
            BSMinLengthRule(minLength: 3)
        ])

        let result = validator.validate("")

        XCTAssertTrue(result.isInvalid)
        XCTAssertEqual(result.errorMessage, "This field is required")
    }

    func testValidatorWithSecondRuleFailing() {
        let validator = BSValidator(rules: [
            BSRequiredRule(),
            BSMinLengthRule(minLength: 10)
        ])

        let result = validator.validate("Hello")

        XCTAssertTrue(result.isInvalid)
        XCTAssertEqual(result.errorMessage, "Must be at least 10 characters")
    }

    func testValidatorWithEmptyRules() {
        let validator = BSValidator(rules: [])
        let result = validator.validate("anything")

        XCTAssertFalse(result.isValid)
        XCTAssertFalse(result.isInvalid)
    }

    // MARK: - BSInputValidation Tests

    func testInputValidationIsValid() {
        XCTAssertTrue(BSInputValidation.valid.isValid)
        XCTAssertFalse(BSInputValidation.none.isValid)
        XCTAssertFalse(BSInputValidation.invalid("error").isValid)
    }

    func testInputValidationIsInvalid() {
        XCTAssertTrue(BSInputValidation.invalid("error").isInvalid)
        XCTAssertFalse(BSInputValidation.valid.isInvalid)
        XCTAssertFalse(BSInputValidation.none.isInvalid)
    }

    func testInputValidationErrorMessage() {
        XCTAssertEqual(BSInputValidation.invalid("Error message").errorMessage, "Error message")
        XCTAssertNil(BSInputValidation.valid.errorMessage)
        XCTAssertNil(BSInputValidation.none.errorMessage)
    }
}
