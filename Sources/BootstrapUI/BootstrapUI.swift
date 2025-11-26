// BootstrapUI - A comprehensive SwiftUI component library following Atomic Design principles
// Version: 1.0.0
// Author: BootstrapUI Team
// License: MIT

import SwiftUI

// MARK: - Public API Exports

// Theme System
@_exported import struct BootstrapUI.Theme
@_exported import class BootstrapUI.ThemeManager
@_exported import protocol BootstrapUI.ThemeProviding

/// BootstrapUI Library namespace
public enum BootstrapUI {
    /// Current library version
    public static let version = "1.0.0"

    /// Initialize the library with a custom theme
    /// - Parameter theme: The theme to use throughout the application
    public static func configure(with theme: Theme) {
        ThemeManager.shared.setTheme(theme)
    }

    /// Reset to the default theme
    public static func resetToDefaultTheme() {
        ThemeManager.shared.resetToDefault()
    }
}
