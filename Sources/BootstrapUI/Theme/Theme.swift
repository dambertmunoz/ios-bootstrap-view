// Theme.swift
// BootstrapUI
//
// Main Theme structure implementing all design tokens
// Follows Open/Closed Principle - open for extension, closed for modification

import SwiftUI

// MARK: - Theme Structure

/// Main Theme structure containing all design tokens
/// Use Theme.light or Theme.dark for default themes, or create custom themes
public struct Theme: ThemeProviding, Equatable, Sendable {

    // MARK: - Properties

    public let name: String
    public let isDark: Bool

    // MARK: - Color Tokens

    public let primary: Color
    public let primaryVariant: Color
    public let onPrimary: Color

    public let secondary: Color
    public let secondaryVariant: Color
    public let onSecondary: Color

    public let background: Color
    public let surface: Color
    public let onBackground: Color
    public let onSurface: Color

    public let error: Color
    public let onError: Color
    public let success: Color
    public let warning: Color
    public let info: Color

    public let border: Color
    public let divider: Color
    public let disabled: Color
    public let placeholder: Color

    // MARK: - Typography Tokens

    public let largeTitle: Font
    public let title1: Font
    public let title2: Font
    public let title3: Font
    public let headline: Font
    public let body: Font
    public let callout: Font
    public let subheadline: Font
    public let footnote: Font
    public let caption1: Font
    public let caption2: Font

    // MARK: - Spacing Tokens

    public let none: CGFloat
    public let xxs: CGFloat
    public let xs: CGFloat
    public let sm: CGFloat
    public let md: CGFloat
    public let lg: CGFloat
    public let xl: CGFloat
    public let xxl: CGFloat
    public let xxxl: CGFloat

    // MARK: - Border Tokens

    public let radiusNone: CGFloat
    public let radiusSm: CGFloat
    public let radiusMd: CGFloat
    public let radiusLg: CGFloat
    public let radiusXl: CGFloat
    public let radiusFull: CGFloat

    public let widthNone: CGFloat
    public let widthThin: CGFloat
    public let widthMedium: CGFloat
    public let widthThick: CGFloat

    // MARK: - Shadow Tokens

    public let shadowNone: ShadowStyle
    public let shadowSm: ShadowStyle
    public let shadowMd: ShadowStyle
    public let shadowLg: ShadowStyle
    public let shadowXl: ShadowStyle

    // MARK: - Animation Tokens

    public let durationFast: Double
    public let durationNormal: Double
    public let durationSlow: Double

    public let springResponse: Double
    public let springDamping: Double

    // MARK: - Initialization

    /// Creates a custom theme with all design tokens
    public init(
        name: String,
        isDark: Bool = false,
        // Colors
        primary: Color,
        primaryVariant: Color,
        onPrimary: Color,
        secondary: Color,
        secondaryVariant: Color,
        onSecondary: Color,
        background: Color,
        surface: Color,
        onBackground: Color,
        onSurface: Color,
        error: Color,
        onError: Color,
        success: Color,
        warning: Color,
        info: Color,
        border: Color,
        divider: Color,
        disabled: Color,
        placeholder: Color,
        // Typography
        largeTitle: Font = .largeTitle,
        title1: Font = .title,
        title2: Font = .title2,
        title3: Font = .title3,
        headline: Font = .headline,
        body: Font = .body,
        callout: Font = .callout,
        subheadline: Font = .subheadline,
        footnote: Font = .footnote,
        caption1: Font = .caption,
        caption2: Font = .caption2,
        // Spacing
        none: CGFloat = 0,
        xxs: CGFloat = 2,
        xs: CGFloat = 4,
        sm: CGFloat = 8,
        md: CGFloat = 16,
        lg: CGFloat = 24,
        xl: CGFloat = 32,
        xxl: CGFloat = 48,
        xxxl: CGFloat = 64,
        // Border Radius
        radiusNone: CGFloat = 0,
        radiusSm: CGFloat = 4,
        radiusMd: CGFloat = 8,
        radiusLg: CGFloat = 12,
        radiusXl: CGFloat = 16,
        radiusFull: CGFloat = 9999,
        // Border Width
        widthNone: CGFloat = 0,
        widthThin: CGFloat = 1,
        widthMedium: CGFloat = 2,
        widthThick: CGFloat = 4,
        // Shadows
        shadowNone: ShadowStyle = .none,
        shadowSm: ShadowStyle? = nil,
        shadowMd: ShadowStyle? = nil,
        shadowLg: ShadowStyle? = nil,
        shadowXl: ShadowStyle? = nil,
        // Animation
        durationFast: Double = 0.15,
        durationNormal: Double = 0.3,
        durationSlow: Double = 0.5,
        springResponse: Double = 0.3,
        springDamping: Double = 0.7
    ) {
        self.name = name
        self.isDark = isDark

        // Colors
        self.primary = primary
        self.primaryVariant = primaryVariant
        self.onPrimary = onPrimary
        self.secondary = secondary
        self.secondaryVariant = secondaryVariant
        self.onSecondary = onSecondary
        self.background = background
        self.surface = surface
        self.onBackground = onBackground
        self.onSurface = onSurface
        self.error = error
        self.onError = onError
        self.success = success
        self.warning = warning
        self.info = info
        self.border = border
        self.divider = divider
        self.disabled = disabled
        self.placeholder = placeholder

        // Typography
        self.largeTitle = largeTitle
        self.title1 = title1
        self.title2 = title2
        self.title3 = title3
        self.headline = headline
        self.body = body
        self.callout = callout
        self.subheadline = subheadline
        self.footnote = footnote
        self.caption1 = caption1
        self.caption2 = caption2

        // Spacing
        self.none = none
        self.xxs = xxs
        self.xs = xs
        self.sm = sm
        self.md = md
        self.lg = lg
        self.xl = xl
        self.xxl = xxl
        self.xxxl = xxxl

        // Border
        self.radiusNone = radiusNone
        self.radiusSm = radiusSm
        self.radiusMd = radiusMd
        self.radiusLg = radiusLg
        self.radiusXl = radiusXl
        self.radiusFull = radiusFull
        self.widthNone = widthNone
        self.widthThin = widthThin
        self.widthMedium = widthMedium
        self.widthThick = widthThick

        // Shadows
        self.shadowNone = shadowNone
        let shadowColor = isDark ? Color.white.opacity(0.1) : Color.black.opacity(0.1)
        self.shadowSm = shadowSm ?? ShadowStyle(color: shadowColor, radius: 2, x: 0, y: 1)
        self.shadowMd = shadowMd ?? ShadowStyle(color: shadowColor, radius: 4, x: 0, y: 2)
        self.shadowLg = shadowLg ?? ShadowStyle(color: shadowColor, radius: 8, x: 0, y: 4)
        self.shadowXl = shadowXl ?? ShadowStyle(color: shadowColor, radius: 16, x: 0, y: 8)

        // Animation
        self.durationFast = durationFast
        self.durationNormal = durationNormal
        self.durationSlow = durationSlow
        self.springResponse = springResponse
        self.springDamping = springDamping
    }
}

// MARK: - Default Themes

extension Theme {

    /// Default light theme
    public static let light = Theme(
        name: "Light",
        isDark: false,
        primary: Color(hex: "#007AFF"),
        primaryVariant: Color(hex: "#0056B3"),
        onPrimary: .white,
        secondary: Color(hex: "#5856D6"),
        secondaryVariant: Color(hex: "#3634A3"),
        onSecondary: .white,
        background: Color(hex: "#FFFFFF"),
        surface: Color(hex: "#F2F2F7"),
        onBackground: Color(hex: "#1C1C1E"),
        onSurface: Color(hex: "#1C1C1E"),
        error: Color(hex: "#FF3B30"),
        onError: .white,
        success: Color(hex: "#34C759"),
        warning: Color(hex: "#FF9500"),
        info: Color(hex: "#5AC8FA"),
        border: Color(hex: "#C6C6C8"),
        divider: Color(hex: "#E5E5EA"),
        disabled: Color(hex: "#8E8E93"),
        placeholder: Color(hex: "#C7C7CC")
    )

    /// Default dark theme
    public static let dark = Theme(
        name: "Dark",
        isDark: true,
        primary: Color(hex: "#0A84FF"),
        primaryVariant: Color(hex: "#409CFF"),
        onPrimary: .white,
        secondary: Color(hex: "#5E5CE6"),
        secondaryVariant: Color(hex: "#7D7AFF"),
        onSecondary: .white,
        background: Color(hex: "#000000"),
        surface: Color(hex: "#1C1C1E"),
        onBackground: Color(hex: "#FFFFFF"),
        onSurface: Color(hex: "#FFFFFF"),
        error: Color(hex: "#FF453A"),
        onError: .white,
        success: Color(hex: "#32D74B"),
        warning: Color(hex: "#FF9F0A"),
        info: Color(hex: "#64D2FF"),
        border: Color(hex: "#38383A"),
        divider: Color(hex: "#38383A"),
        disabled: Color(hex: "#636366"),
        placeholder: Color(hex: "#636366")
    )

    /// System adaptive theme (follows system appearance)
    public static var system: Theme {
        #if os(iOS)
        return UITraitCollection.current.userInterfaceStyle == .dark ? .dark : .light
        #elseif os(macOS)
        return NSApp?.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua ? .dark : .light
        #else
        return .light
        #endif
    }
}

// MARK: - Theme Builder (Builder Pattern)

/// Builder for creating custom themes with fluent API
public class ThemeBuilder {
    private var name: String = "Custom"
    private var isDark: Bool = false

    // Colors with defaults from light theme
    private var primary: Color = Theme.light.primary
    private var primaryVariant: Color = Theme.light.primaryVariant
    private var onPrimary: Color = Theme.light.onPrimary
    private var secondary: Color = Theme.light.secondary
    private var secondaryVariant: Color = Theme.light.secondaryVariant
    private var onSecondary: Color = Theme.light.onSecondary
    private var background: Color = Theme.light.background
    private var surface: Color = Theme.light.surface
    private var onBackground: Color = Theme.light.onBackground
    private var onSurface: Color = Theme.light.onSurface
    private var error: Color = Theme.light.error
    private var onError: Color = Theme.light.onError
    private var success: Color = Theme.light.success
    private var warning: Color = Theme.light.warning
    private var info: Color = Theme.light.info
    private var border: Color = Theme.light.border
    private var divider: Color = Theme.light.divider
    private var disabled: Color = Theme.light.disabled
    private var placeholder: Color = Theme.light.placeholder

    public init() {}

    // MARK: - Builder Methods

    @discardableResult
    public func name(_ name: String) -> ThemeBuilder {
        self.name = name
        return self
    }

    @discardableResult
    public func isDark(_ isDark: Bool) -> ThemeBuilder {
        self.isDark = isDark
        return self
    }

    @discardableResult
    public func primary(_ color: Color) -> ThemeBuilder {
        self.primary = color
        return self
    }

    @discardableResult
    public func primaryVariant(_ color: Color) -> ThemeBuilder {
        self.primaryVariant = color
        return self
    }

    @discardableResult
    public func onPrimary(_ color: Color) -> ThemeBuilder {
        self.onPrimary = color
        return self
    }

    @discardableResult
    public func secondary(_ color: Color) -> ThemeBuilder {
        self.secondary = color
        return self
    }

    @discardableResult
    public func secondaryVariant(_ color: Color) -> ThemeBuilder {
        self.secondaryVariant = color
        return self
    }

    @discardableResult
    public func onSecondary(_ color: Color) -> ThemeBuilder {
        self.onSecondary = color
        return self
    }

    @discardableResult
    public func background(_ color: Color) -> ThemeBuilder {
        self.background = color
        return self
    }

    @discardableResult
    public func surface(_ color: Color) -> ThemeBuilder {
        self.surface = color
        return self
    }

    @discardableResult
    public func onBackground(_ color: Color) -> ThemeBuilder {
        self.onBackground = color
        return self
    }

    @discardableResult
    public func onSurface(_ color: Color) -> ThemeBuilder {
        self.onSurface = color
        return self
    }

    @discardableResult
    public func error(_ color: Color) -> ThemeBuilder {
        self.error = color
        return self
    }

    @discardableResult
    public func success(_ color: Color) -> ThemeBuilder {
        self.success = color
        return self
    }

    @discardableResult
    public func warning(_ color: Color) -> ThemeBuilder {
        self.warning = color
        return self
    }

    @discardableResult
    public func info(_ color: Color) -> ThemeBuilder {
        self.info = color
        return self
    }

    /// Build the theme with all configured values
    public func build() -> Theme {
        Theme(
            name: name,
            isDark: isDark,
            primary: primary,
            primaryVariant: primaryVariant,
            onPrimary: onPrimary,
            secondary: secondary,
            secondaryVariant: secondaryVariant,
            onSecondary: onSecondary,
            background: background,
            surface: surface,
            onBackground: onBackground,
            onSurface: onSurface,
            error: error,
            onError: onError,
            success: success,
            warning: warning,
            info: info,
            border: border,
            divider: divider,
            disabled: disabled,
            placeholder: placeholder
        )
    }
}

// MARK: - Equatable Conformance

extension Theme {
    public static func == (lhs: Theme, rhs: Theme) -> Bool {
        lhs.name == rhs.name && lhs.isDark == rhs.isDark
    }
}
