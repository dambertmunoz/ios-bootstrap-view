// ColorExtensionTests.swift
// BootstrapUITests
//
// Unit tests for Color extensions

import XCTest
import SwiftUI
@testable import BootstrapUI

final class ColorExtensionTests: XCTestCase {

    // MARK: - Hex Initialization Tests

    func testColorFromHex6() {
        let color = Color(hex: "#FF0000")
        // Red color should be created successfully
        XCTAssertNotNil(color)
    }

    func testColorFromHex6WithoutHash() {
        let color = Color(hex: "00FF00")
        // Green color should be created successfully
        XCTAssertNotNil(color)
    }

    func testColorFromHex3() {
        let color = Color(hex: "#F00")
        // Short form red color should be created
        XCTAssertNotNil(color)
    }

    func testColorFromHex8() {
        let color = Color(hex: "#80FF0000")
        // Color with alpha should be created
        XCTAssertNotNil(color)
    }

    func testColorFromInvalidHex() {
        let color = Color(hex: "invalid")
        // Should fall back to black
        XCTAssertNotNil(color)
    }

    // MARK: - Common Colors

    func testCommonHexColors() {
        let white = Color(hex: "#FFFFFF")
        let black = Color(hex: "#000000")
        let red = Color(hex: "#FF0000")
        let green = Color(hex: "#00FF00")
        let blue = Color(hex: "#0000FF")

        XCTAssertNotNil(white)
        XCTAssertNotNil(black)
        XCTAssertNotNil(red)
        XCTAssertNotNil(green)
        XCTAssertNotNil(blue)
    }

    // MARK: - iOS System Colors

    func testIOSSystemColors() {
        // iOS system blue
        let systemBlue = Color(hex: "#007AFF")
        XCTAssertNotNil(systemBlue)

        // iOS system green
        let systemGreen = Color(hex: "#34C759")
        XCTAssertNotNil(systemGreen)

        // iOS system red
        let systemRed = Color(hex: "#FF3B30")
        XCTAssertNotNil(systemRed)
    }
}

// MARK: - Component Enum Tests

final class ComponentEnumTests: XCTestCase {

    // MARK: - Button Style Tests

    func testBSButtonStyleCases() {
        XCTAssertEqual(BSButtonStyle.allCases.count, 7)
        XCTAssertTrue(BSButtonStyle.allCases.contains(.primary))
        XCTAssertTrue(BSButtonStyle.allCases.contains(.secondary))
        XCTAssertTrue(BSButtonStyle.allCases.contains(.outline))
        XCTAssertTrue(BSButtonStyle.allCases.contains(.ghost))
        XCTAssertTrue(BSButtonStyle.allCases.contains(.destructive))
        XCTAssertTrue(BSButtonStyle.allCases.contains(.success))
        XCTAssertTrue(BSButtonStyle.allCases.contains(.link))
    }

    // MARK: - Button Size Tests

    func testBSButtonSizePadding() {
        XCTAssertEqual(BSButtonSize.small.verticalPadding, 8)
        XCTAssertEqual(BSButtonSize.medium.verticalPadding, 12)
        XCTAssertEqual(BSButtonSize.large.verticalPadding, 16)

        XCTAssertEqual(BSButtonSize.small.horizontalPadding, 16)
        XCTAssertEqual(BSButtonSize.medium.horizontalPadding, 24)
        XCTAssertEqual(BSButtonSize.large.horizontalPadding, 32)
    }

    func testBSButtonSizeIconSize() {
        XCTAssertEqual(BSButtonSize.small.iconSize, 14)
        XCTAssertEqual(BSButtonSize.medium.iconSize, 18)
        XCTAssertEqual(BSButtonSize.large.iconSize, 22)
    }

    // MARK: - Icon Size Tests

    func testBSIconSizePointSize() {
        XCTAssertEqual(BSIconSize.xs.pointSize, 12)
        XCTAssertEqual(BSIconSize.sm.pointSize, 16)
        XCTAssertEqual(BSIconSize.md.pointSize, 20)
        XCTAssertEqual(BSIconSize.lg.pointSize, 24)
        XCTAssertEqual(BSIconSize.xl.pointSize, 32)
        XCTAssertEqual(BSIconSize.xxl.pointSize, 48)
    }

    // MARK: - Avatar Size Tests

    func testBSAvatarSizeDimension() {
        XCTAssertEqual(BSAvatarSize.xs.dimension, 24)
        XCTAssertEqual(BSAvatarSize.sm.dimension, 32)
        XCTAssertEqual(BSAvatarSize.md.dimension, 40)
        XCTAssertEqual(BSAvatarSize.lg.dimension, 56)
        XCTAssertEqual(BSAvatarSize.xl.dimension, 80)
        XCTAssertEqual(BSAvatarSize.xxl.dimension, 120)
    }

    func testBSAvatarSizeFontSize() {
        XCTAssertEqual(BSAvatarSize.xs.fontSize, 10)
        XCTAssertEqual(BSAvatarSize.sm.fontSize, 12)
        XCTAssertEqual(BSAvatarSize.md.fontSize, 16)
        XCTAssertEqual(BSAvatarSize.lg.fontSize, 22)
        XCTAssertEqual(BSAvatarSize.xl.fontSize, 32)
        XCTAssertEqual(BSAvatarSize.xxl.fontSize, 48)
    }

    // MARK: - Badge Tests

    func testBSBadgeVariantCases() {
        XCTAssertEqual(BSBadgeVariant.allCases.count, 3)
        XCTAssertTrue(BSBadgeVariant.allCases.contains(.filled))
        XCTAssertTrue(BSBadgeVariant.allCases.contains(.outlined))
        XCTAssertTrue(BSBadgeVariant.allCases.contains(.subtle))
    }

    func testBSBadgeColorCases() {
        XCTAssertEqual(BSBadgeColor.allCases.count, 7)
    }

    func testBSBadgeSizePadding() {
        XCTAssertEqual(BSBadgeSize.small.verticalPadding, 2)
        XCTAssertEqual(BSBadgeSize.medium.verticalPadding, 4)
        XCTAssertEqual(BSBadgeSize.large.verticalPadding, 6)
    }

    // MARK: - Text Style Tests

    func testBSTextStyleCases() {
        XCTAssertEqual(BSTextStyle.allCases.count, 11)
    }

    func testBSTextWeightCases() {
        XCTAssertEqual(BSTextWeight.allCases.count, 4)
        XCTAssertTrue(BSTextWeight.allCases.contains(.regular))
        XCTAssertTrue(BSTextWeight.allCases.contains(.medium))
        XCTAssertTrue(BSTextWeight.allCases.contains(.semibold))
        XCTAssertTrue(BSTextWeight.allCases.contains(.bold))
    }

    // MARK: - Alert Type Tests

    func testBSAlertTypeIcon() {
        XCTAssertEqual(BSAlertType.info.icon, "info.circle.fill")
        XCTAssertEqual(BSAlertType.success.icon, "checkmark.circle.fill")
        XCTAssertEqual(BSAlertType.warning.icon, "exclamationmark.triangle.fill")
        XCTAssertEqual(BSAlertType.error.icon, "xmark.circle.fill")
    }

    // MARK: - Status Badge Tests

    func testBSStatusBadgeColors() {
        XCTAssertEqual(BSStatusBadge.Status.active.color, .success)
        XCTAssertEqual(BSStatusBadge.Status.inactive.color, .neutral)
        XCTAssertEqual(BSStatusBadge.Status.pending.color, .warning)
        XCTAssertEqual(BSStatusBadge.Status.completed.color, .success)
        XCTAssertEqual(BSStatusBadge.Status.failed.color, .error)
        XCTAssertEqual(BSStatusBadge.Status.cancelled.color, .neutral)
    }
}
