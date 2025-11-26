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

// MARK: - Predefined Themes

extension Theme {

    // MARK: - Material Design Themes

    /// Material Design 3 Light Theme
    public static let materialLight = Theme(
        name: "Material Light",
        isDark: false,
        primary: Color(hex: "#6750A4"),
        primaryVariant: Color(hex: "#4F378B"),
        onPrimary: .white,
        secondary: Color(hex: "#625B71"),
        secondaryVariant: Color(hex: "#4A4458"),
        onSecondary: .white,
        background: Color(hex: "#FFFBFE"),
        surface: Color(hex: "#FFFBFE"),
        onBackground: Color(hex: "#1C1B1F"),
        onSurface: Color(hex: "#1C1B1F"),
        error: Color(hex: "#B3261E"),
        onError: .white,
        success: Color(hex: "#386A20"),
        warning: Color(hex: "#7D5700"),
        info: Color(hex: "#0061A4"),
        border: Color(hex: "#79747E"),
        divider: Color(hex: "#CAC4D0"),
        disabled: Color(hex: "#1C1B1F").opacity(0.38),
        placeholder: Color(hex: "#49454F")
    )

    /// Material Design 3 Dark Theme
    public static let materialDark = Theme(
        name: "Material Dark",
        isDark: true,
        primary: Color(hex: "#D0BCFF"),
        primaryVariant: Color(hex: "#EADDFF"),
        onPrimary: Color(hex: "#381E72"),
        secondary: Color(hex: "#CCC2DC"),
        secondaryVariant: Color(hex: "#E8DEF8"),
        onSecondary: Color(hex: "#332D41"),
        background: Color(hex: "#1C1B1F"),
        surface: Color(hex: "#1C1B1F"),
        onBackground: Color(hex: "#E6E1E5"),
        onSurface: Color(hex: "#E6E1E5"),
        error: Color(hex: "#F2B8B5"),
        onError: Color(hex: "#601410"),
        success: Color(hex: "#A6D388"),
        warning: Color(hex: "#FFCF70"),
        info: Color(hex: "#9ECAFF"),
        border: Color(hex: "#938F99"),
        divider: Color(hex: "#49454F"),
        disabled: Color(hex: "#E6E1E5").opacity(0.38),
        placeholder: Color(hex: "#CAC4D0")
    )

    // MARK: - Nord Themes

    /// Nord Light Theme - Arctic, north-bluish color palette
    public static let nordLight = Theme(
        name: "Nord Light",
        isDark: false,
        primary: Color(hex: "#5E81AC"),
        primaryVariant: Color(hex: "#81A1C1"),
        onPrimary: .white,
        secondary: Color(hex: "#88C0D0"),
        secondaryVariant: Color(hex: "#8FBCBB"),
        onSecondary: Color(hex: "#2E3440"),
        background: Color(hex: "#ECEFF4"),
        surface: Color(hex: "#E5E9F0"),
        onBackground: Color(hex: "#2E3440"),
        onSurface: Color(hex: "#2E3440"),
        error: Color(hex: "#BF616A"),
        onError: .white,
        success: Color(hex: "#A3BE8C"),
        warning: Color(hex: "#EBCB8B"),
        info: Color(hex: "#81A1C1"),
        border: Color(hex: "#D8DEE9"),
        divider: Color(hex: "#D8DEE9"),
        disabled: Color(hex: "#4C566A").opacity(0.5),
        placeholder: Color(hex: "#4C566A")
    )

    /// Nord Dark Theme - Arctic, north-bluish color palette
    public static let nordDark = Theme(
        name: "Nord Dark",
        isDark: true,
        primary: Color(hex: "#88C0D0"),
        primaryVariant: Color(hex: "#81A1C1"),
        onPrimary: Color(hex: "#2E3440"),
        secondary: Color(hex: "#5E81AC"),
        secondaryVariant: Color(hex: "#81A1C1"),
        onSecondary: .white,
        background: Color(hex: "#2E3440"),
        surface: Color(hex: "#3B4252"),
        onBackground: Color(hex: "#ECEFF4"),
        onSurface: Color(hex: "#E5E9F0"),
        error: Color(hex: "#BF616A"),
        onError: .white,
        success: Color(hex: "#A3BE8C"),
        warning: Color(hex: "#EBCB8B"),
        info: Color(hex: "#81A1C1"),
        border: Color(hex: "#4C566A"),
        divider: Color(hex: "#434C5E"),
        disabled: Color(hex: "#D8DEE9").opacity(0.5),
        placeholder: Color(hex: "#D8DEE9")
    )

    // MARK: - Dracula Theme

    /// Dracula Dark Theme - Popular dark theme for developers
    public static let dracula = Theme(
        name: "Dracula",
        isDark: true,
        primary: Color(hex: "#BD93F9"),
        primaryVariant: Color(hex: "#FF79C6"),
        onPrimary: Color(hex: "#282A36"),
        secondary: Color(hex: "#50FA7B"),
        secondaryVariant: Color(hex: "#8BE9FD"),
        onSecondary: Color(hex: "#282A36"),
        background: Color(hex: "#282A36"),
        surface: Color(hex: "#44475A"),
        onBackground: Color(hex: "#F8F8F2"),
        onSurface: Color(hex: "#F8F8F2"),
        error: Color(hex: "#FF5555"),
        onError: Color(hex: "#F8F8F2"),
        success: Color(hex: "#50FA7B"),
        warning: Color(hex: "#FFB86C"),
        info: Color(hex: "#8BE9FD"),
        border: Color(hex: "#6272A4"),
        divider: Color(hex: "#6272A4"),
        disabled: Color(hex: "#6272A4"),
        placeholder: Color(hex: "#6272A4")
    )

    // MARK: - Solarized Themes

    /// Solarized Light Theme - Precision colors for human perception
    public static let solarizedLight = Theme(
        name: "Solarized Light",
        isDark: false,
        primary: Color(hex: "#268BD2"),
        primaryVariant: Color(hex: "#2AA198"),
        onPrimary: .white,
        secondary: Color(hex: "#859900"),
        secondaryVariant: Color(hex: "#B58900"),
        onSecondary: .white,
        background: Color(hex: "#FDF6E3"),
        surface: Color(hex: "#EEE8D5"),
        onBackground: Color(hex: "#657B83"),
        onSurface: Color(hex: "#586E75"),
        error: Color(hex: "#DC322F"),
        onError: .white,
        success: Color(hex: "#859900"),
        warning: Color(hex: "#B58900"),
        info: Color(hex: "#268BD2"),
        border: Color(hex: "#93A1A1"),
        divider: Color(hex: "#EEE8D5"),
        disabled: Color(hex: "#93A1A1"),
        placeholder: Color(hex: "#93A1A1")
    )

    /// Solarized Dark Theme - Precision colors for human perception
    public static let solarizedDark = Theme(
        name: "Solarized Dark",
        isDark: true,
        primary: Color(hex: "#268BD2"),
        primaryVariant: Color(hex: "#2AA198"),
        onPrimary: Color(hex: "#002B36"),
        secondary: Color(hex: "#859900"),
        secondaryVariant: Color(hex: "#B58900"),
        onSecondary: Color(hex: "#002B36"),
        background: Color(hex: "#002B36"),
        surface: Color(hex: "#073642"),
        onBackground: Color(hex: "#839496"),
        onSurface: Color(hex: "#93A1A1"),
        error: Color(hex: "#DC322F"),
        onError: .white,
        success: Color(hex: "#859900"),
        warning: Color(hex: "#B58900"),
        info: Color(hex: "#268BD2"),
        border: Color(hex: "#586E75"),
        divider: Color(hex: "#073642"),
        disabled: Color(hex: "#586E75"),
        placeholder: Color(hex: "#586E75")
    )

    // MARK: - Ocean Theme

    /// Ocean Dark Theme - Deep blue oceanic palette
    public static let ocean = Theme(
        name: "Ocean",
        isDark: true,
        primary: Color(hex: "#00B4D8"),
        primaryVariant: Color(hex: "#0077B6"),
        onPrimary: .white,
        secondary: Color(hex: "#90E0EF"),
        secondaryVariant: Color(hex: "#CAF0F8"),
        onSecondary: Color(hex: "#03045E"),
        background: Color(hex: "#03045E"),
        surface: Color(hex: "#023E8A"),
        onBackground: Color(hex: "#CAF0F8"),
        onSurface: Color(hex: "#CAF0F8"),
        error: Color(hex: "#FF6B6B"),
        onError: .white,
        success: Color(hex: "#4ECDC4"),
        warning: Color(hex: "#FFE66D"),
        info: Color(hex: "#90E0EF"),
        border: Color(hex: "#0077B6"),
        divider: Color(hex: "#023E8A"),
        disabled: Color(hex: "#48CAE4").opacity(0.5),
        placeholder: Color(hex: "#48CAE4")
    )

    // MARK: - Forest Theme

    /// Forest Theme - Natural green palette
    public static let forest = Theme(
        name: "Forest",
        isDark: true,
        primary: Color(hex: "#95D5B2"),
        primaryVariant: Color(hex: "#74C69D"),
        onPrimary: Color(hex: "#1B4332"),
        secondary: Color(hex: "#B7E4C7"),
        secondaryVariant: Color(hex: "#D8F3DC"),
        onSecondary: Color(hex: "#1B4332"),
        background: Color(hex: "#1B4332"),
        surface: Color(hex: "#2D6A4F"),
        onBackground: Color(hex: "#D8F3DC"),
        onSurface: Color(hex: "#D8F3DC"),
        error: Color(hex: "#E76F51"),
        onError: .white,
        success: Color(hex: "#95D5B2"),
        warning: Color(hex: "#E9C46A"),
        info: Color(hex: "#74C69D"),
        border: Color(hex: "#40916C"),
        divider: Color(hex: "#40916C"),
        disabled: Color(hex: "#95D5B2").opacity(0.5),
        placeholder: Color(hex: "#95D5B2")
    )

    // MARK: - Sunset Theme

    /// Sunset Theme - Warm orange and purple gradient palette
    public static let sunset = Theme(
        name: "Sunset",
        isDark: true,
        primary: Color(hex: "#F72585"),
        primaryVariant: Color(hex: "#B5179E"),
        onPrimary: .white,
        secondary: Color(hex: "#7209B7"),
        secondaryVariant: Color(hex: "#560BAD"),
        onSecondary: .white,
        background: Color(hex: "#240046"),
        surface: Color(hex: "#3C096C"),
        onBackground: Color(hex: "#FFE5EC"),
        onSurface: Color(hex: "#FFE5EC"),
        error: Color(hex: "#FF595E"),
        onError: .white,
        success: Color(hex: "#8AC926"),
        warning: Color(hex: "#FFCA3A"),
        info: Color(hex: "#6A4C93"),
        border: Color(hex: "#7209B7"),
        divider: Color(hex: "#560BAD"),
        disabled: Color(hex: "#F72585").opacity(0.5),
        placeholder: Color(hex: "#FF8FA3")
    )

    // MARK: - Midnight Theme

    /// Midnight Theme - Ultra dark with subtle blues
    public static let midnight = Theme(
        name: "Midnight",
        isDark: true,
        primary: Color(hex: "#3A86FF"),
        primaryVariant: Color(hex: "#8338EC"),
        onPrimary: .white,
        secondary: Color(hex: "#FF006E"),
        secondaryVariant: Color(hex: "#FB5607"),
        onSecondary: .white,
        background: Color(hex: "#0D1117"),
        surface: Color(hex: "#161B22"),
        onBackground: Color(hex: "#C9D1D9"),
        onSurface: Color(hex: "#C9D1D9"),
        error: Color(hex: "#F85149"),
        onError: .white,
        success: Color(hex: "#56D364"),
        warning: Color(hex: "#E3B341"),
        info: Color(hex: "#58A6FF"),
        border: Color(hex: "#30363D"),
        divider: Color(hex: "#21262D"),
        disabled: Color(hex: "#484F58"),
        placeholder: Color(hex: "#8B949E")
    )

    // MARK: - Rose Theme

    /// Rose Light Theme - Soft pink and rose palette
    public static let roseLight = Theme(
        name: "Rose Light",
        isDark: false,
        primary: Color(hex: "#E11D48"),
        primaryVariant: Color(hex: "#BE123C"),
        onPrimary: .white,
        secondary: Color(hex: "#DB2777"),
        secondaryVariant: Color(hex: "#C026D3"),
        onSecondary: .white,
        background: Color(hex: "#FFF1F2"),
        surface: Color(hex: "#FFE4E6"),
        onBackground: Color(hex: "#4C0519"),
        onSurface: Color(hex: "#881337"),
        error: Color(hex: "#DC2626"),
        onError: .white,
        success: Color(hex: "#16A34A"),
        warning: Color(hex: "#EA580C"),
        info: Color(hex: "#2563EB"),
        border: Color(hex: "#FECDD3"),
        divider: Color(hex: "#FECDD3"),
        disabled: Color(hex: "#FDA4AF"),
        placeholder: Color(hex: "#FB7185")
    )

    // MARK: - Monokai Theme

    /// Monokai Pro Theme - Classic developer theme
    public static let monokai = Theme(
        name: "Monokai",
        isDark: true,
        primary: Color(hex: "#A6E22E"),
        primaryVariant: Color(hex: "#F92672"),
        onPrimary: Color(hex: "#272822"),
        secondary: Color(hex: "#66D9EF"),
        secondaryVariant: Color(hex: "#AE81FF"),
        onSecondary: Color(hex: "#272822"),
        background: Color(hex: "#272822"),
        surface: Color(hex: "#3E3D32"),
        onBackground: Color(hex: "#F8F8F2"),
        onSurface: Color(hex: "#F8F8F2"),
        error: Color(hex: "#F92672"),
        onError: .white,
        success: Color(hex: "#A6E22E"),
        warning: Color(hex: "#E6DB74"),
        info: Color(hex: "#66D9EF"),
        border: Color(hex: "#75715E"),
        divider: Color(hex: "#49483E"),
        disabled: Color(hex: "#75715E"),
        placeholder: Color(hex: "#75715E")
    )

    // MARK: - Cyberpunk Theme

    /// Cyberpunk Theme - Neon colors on dark background
    public static let cyberpunk = Theme(
        name: "Cyberpunk",
        isDark: true,
        primary: Color(hex: "#00F0FF"),
        primaryVariant: Color(hex: "#FF00FF"),
        onPrimary: Color(hex: "#0A0A0A"),
        secondary: Color(hex: "#FFFF00"),
        secondaryVariant: Color(hex: "#FF6600"),
        onSecondary: Color(hex: "#0A0A0A"),
        background: Color(hex: "#0A0A0A"),
        surface: Color(hex: "#1A1A2E"),
        onBackground: Color(hex: "#EAEAEA"),
        onSurface: Color(hex: "#EAEAEA"),
        error: Color(hex: "#FF0040"),
        onError: Color(hex: "#0A0A0A"),
        success: Color(hex: "#00FF9F"),
        warning: Color(hex: "#FFE600"),
        info: Color(hex: "#00F0FF"),
        border: Color(hex: "#FF00FF"),
        divider: Color(hex: "#2A2A4E"),
        disabled: Color(hex: "#4A4A6E"),
        placeholder: Color(hex: "#8888AA")
    )

    // MARK: - Theme Catalog

    /// All available predefined themes
    public static let allThemes: [Theme] = [
        .light,
        .dark,
        .materialLight,
        .materialDark,
        .nordLight,
        .nordDark,
        .dracula,
        .solarizedLight,
        .solarizedDark,
        .ocean,
        .forest,
        .sunset,
        .midnight,
        .roseLight,
        .monokai,
        .cyberpunk
    ]

    /// All light themes
    public static let lightThemes: [Theme] = allThemes.filter { !$0.isDark }

    /// All dark themes
    public static let darkThemes: [Theme] = allThemes.filter { $0.isDark }
}
