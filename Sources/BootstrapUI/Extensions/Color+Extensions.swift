// Color+Extensions.swift
// BootstrapUI
//
// Color extensions for enhanced functionality

import SwiftUI

// MARK: - Hex Color Support

extension Color {

    /// Initialize a Color from a hex string
    /// - Parameter hex: Hex color string (with or without #, supports 3, 6, or 8 character formats)
    public init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    /// Convert Color to hex string
    /// - Returns: Hex string representation of the color
    public var hexString: String {
        #if os(iOS) || os(tvOS) || os(watchOS)
        guard let components = UIColor(self).cgColor.components else {
            return "#000000"
        }
        #elseif os(macOS)
        guard let color = NSColor(self).usingColorSpace(.deviceRGB),
              let components = color.cgColor.components else {
            return "#000000"
        }
        #endif

        let r = components.count > 0 ? components[0] : 0
        let g = components.count > 1 ? components[1] : 0
        let b = components.count > 2 ? components[2] : 0

        return String(
            format: "#%02lX%02lX%02lX",
            lround(Double(r * 255)),
            lround(Double(g * 255)),
            lround(Double(b * 255))
        )
    }
}

// MARK: - Color Manipulation

extension Color {

    /// Returns a lighter version of the color
    /// - Parameter amount: Amount to lighten (0-1)
    /// - Returns: Lighter color
    public func lighter(by amount: CGFloat = 0.2) -> Color {
        adjust(by: abs(amount))
    }

    /// Returns a darker version of the color
    /// - Parameter amount: Amount to darken (0-1)
    /// - Returns: Darker color
    public func darker(by amount: CGFloat = 0.2) -> Color {
        adjust(by: -abs(amount))
    }

    private func adjust(by amount: CGFloat) -> Color {
        #if os(iOS) || os(tvOS) || os(watchOS)
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        UIColor(self).getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        return Color(
            hue: Double(hue),
            saturation: Double(saturation),
            brightness: Double(min(max(brightness + amount, 0), 1)),
            opacity: Double(alpha)
        )
        #elseif os(macOS)
        guard let color = NSColor(self).usingColorSpace(.deviceRGB) else {
            return self
        }

        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        return Color(
            hue: Double(hue),
            saturation: Double(saturation),
            brightness: Double(min(max(brightness + amount, 0), 1)),
            opacity: Double(alpha)
        )
        #else
        return self
        #endif
    }

    /// Returns the color with modified opacity
    /// - Parameter opacity: New opacity value (0-1)
    /// - Returns: Color with new opacity
    public func withOpacity(_ opacity: Double) -> Color {
        self.opacity(opacity)
    }
}

// MARK: - Semantic Colors (Convenience)

extension Color {

    /// Semantic color for destructive actions
    public static var destructive: Color {
        ThemeManager.shared.currentTheme.error
    }

    /// Semantic color for success states
    public static var successColor: Color {
        ThemeManager.shared.currentTheme.success
    }

    /// Semantic color for warning states
    public static var warningColor: Color {
        ThemeManager.shared.currentTheme.warning
    }

    /// Semantic color for informational states
    public static var infoColor: Color {
        ThemeManager.shared.currentTheme.info
    }
}
