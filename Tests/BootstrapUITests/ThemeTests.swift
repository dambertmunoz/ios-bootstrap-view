// ThemeTests.swift
// BootstrapUITests
//
// Unit tests for Theme and ThemeManager

import XCTest
import SwiftUI
@testable import BootstrapUI

final class ThemeTests: XCTestCase {

    // MARK: - Theme Tests

    func testLightThemeProperties() {
        let theme = Theme.light

        XCTAssertEqual(theme.name, "Light")
        XCTAssertFalse(theme.isDark)
        XCTAssertNotNil(theme.primary)
        XCTAssertNotNil(theme.secondary)
        XCTAssertNotNil(theme.background)
    }

    func testDarkThemeProperties() {
        let theme = Theme.dark

        XCTAssertEqual(theme.name, "Dark")
        XCTAssertTrue(theme.isDark)
        XCTAssertNotNil(theme.primary)
        XCTAssertNotNil(theme.secondary)
        XCTAssertNotNil(theme.background)
    }

    func testThemeEquality() {
        let light1 = Theme.light
        let light2 = Theme.light
        let dark = Theme.dark

        XCTAssertEqual(light1, light2)
        XCTAssertNotEqual(light1, dark)
    }

    func testThemeSpacingTokens() {
        let theme = Theme.light

        XCTAssertEqual(theme.none, 0)
        XCTAssertEqual(theme.xxs, 2)
        XCTAssertEqual(theme.xs, 4)
        XCTAssertEqual(theme.sm, 8)
        XCTAssertEqual(theme.md, 16)
        XCTAssertEqual(theme.lg, 24)
        XCTAssertEqual(theme.xl, 32)
        XCTAssertEqual(theme.xxl, 48)
        XCTAssertEqual(theme.xxxl, 64)
    }

    func testThemeBorderTokens() {
        let theme = Theme.light

        XCTAssertEqual(theme.radiusNone, 0)
        XCTAssertEqual(theme.radiusSm, 4)
        XCTAssertEqual(theme.radiusMd, 8)
        XCTAssertEqual(theme.radiusLg, 12)
        XCTAssertEqual(theme.radiusXl, 16)
        XCTAssertEqual(theme.radiusFull, 9999)

        XCTAssertEqual(theme.widthNone, 0)
        XCTAssertEqual(theme.widthThin, 1)
        XCTAssertEqual(theme.widthMedium, 2)
        XCTAssertEqual(theme.widthThick, 4)
    }

    func testThemeAnimationTokens() {
        let theme = Theme.light

        XCTAssertEqual(theme.durationFast, 0.15)
        XCTAssertEqual(theme.durationNormal, 0.3)
        XCTAssertEqual(theme.durationSlow, 0.5)
        XCTAssertEqual(theme.springResponse, 0.3)
        XCTAssertEqual(theme.springDamping, 0.7)
    }

    // MARK: - Theme Builder Tests

    func testThemeBuilder() {
        let customTheme = ThemeBuilder()
            .name("Custom")
            .isDark(true)
            .primary(.red)
            .secondary(.blue)
            .build()

        XCTAssertEqual(customTheme.name, "Custom")
        XCTAssertTrue(customTheme.isDark)
    }

    func testThemeBuilderChaining() {
        let builder = ThemeBuilder()
            .name("Test")
            .primary(.green)
            .background(.white)

        let theme = builder.build()

        XCTAssertEqual(theme.name, "Test")
    }

    // MARK: - Shadow Style Tests

    func testShadowStyleNone() {
        let shadow = ShadowStyle.none

        XCTAssertEqual(shadow.radius, 0)
        XCTAssertEqual(shadow.x, 0)
        XCTAssertEqual(shadow.y, 0)
    }

    func testShadowStyleEquality() {
        let shadow1 = ShadowStyle(color: .black, radius: 4, x: 0, y: 2)
        let shadow2 = ShadowStyle(color: .black, radius: 4, x: 0, y: 2)

        XCTAssertEqual(shadow1, shadow2)
    }
}

// MARK: - Theme Manager Tests

@MainActor
final class ThemeManagerTests: XCTestCase {

    func testSharedInstance() {
        let manager1 = ThemeManager.shared
        let manager2 = ThemeManager.shared

        XCTAssertTrue(manager1 === manager2)
    }

    func testDefaultTheme() {
        let manager = ThemeManager(theme: .light)

        XCTAssertEqual(manager.currentTheme, Theme.light)
    }

    func testSetTheme() {
        let manager = ThemeManager(theme: .light)

        manager.setTheme(.dark)

        XCTAssertEqual(manager.currentTheme, Theme.dark)
    }

    func testToggleTheme() {
        let manager = ThemeManager(theme: .light)

        manager.toggleTheme()
        XCTAssertTrue(manager.currentTheme.isDark)

        manager.toggleTheme()
        XCTAssertFalse(manager.currentTheme.isDark)
    }

    func testResetToDefault() {
        let manager = ThemeManager(theme: .dark)

        manager.resetToDefault()

        XCTAssertEqual(manager.currentTheme, Theme.light)
    }
}
