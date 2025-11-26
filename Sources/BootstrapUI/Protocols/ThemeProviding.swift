// ThemeProviding.swift
// BootstrapUI
//
// Protocol definitions for the theming system following Interface Segregation Principle (ISP)

import SwiftUI

// MARK: - Color Providing Protocol

/// Protocol for providing color tokens
/// Follows Interface Segregation Principle - clients only depend on colors they need
public protocol ColorProviding {
    // Primary colors
    var primary: Color { get }
    var primaryVariant: Color { get }
    var onPrimary: Color { get }

    // Secondary colors
    var secondary: Color { get }
    var secondaryVariant: Color { get }
    var onSecondary: Color { get }

    // Background colors
    var background: Color { get }
    var surface: Color { get }
    var onBackground: Color { get }
    var onSurface: Color { get }

    // Semantic colors
    var error: Color { get }
    var onError: Color { get }
    var success: Color { get }
    var warning: Color { get }
    var info: Color { get }

    // Neutral colors
    var border: Color { get }
    var divider: Color { get }
    var disabled: Color { get }
    var placeholder: Color { get }
}

// MARK: - Typography Providing Protocol

/// Protocol for providing typography tokens
public protocol TypographyProviding {
    var largeTitle: Font { get }
    var title1: Font { get }
    var title2: Font { get }
    var title3: Font { get }
    var headline: Font { get }
    var body: Font { get }
    var callout: Font { get }
    var subheadline: Font { get }
    var footnote: Font { get }
    var caption1: Font { get }
    var caption2: Font { get }
}

// MARK: - Spacing Providing Protocol

/// Protocol for providing spacing tokens
public protocol SpacingProviding {
    var none: CGFloat { get }
    var xxs: CGFloat { get }
    var xs: CGFloat { get }
    var sm: CGFloat { get }
    var md: CGFloat { get }
    var lg: CGFloat { get }
    var xl: CGFloat { get }
    var xxl: CGFloat { get }
    var xxxl: CGFloat { get }
}

// MARK: - Border Providing Protocol

/// Protocol for providing border tokens
public protocol BorderProviding {
    var radiusNone: CGFloat { get }
    var radiusSm: CGFloat { get }
    var radiusMd: CGFloat { get }
    var radiusLg: CGFloat { get }
    var radiusXl: CGFloat { get }
    var radiusFull: CGFloat { get }

    var widthNone: CGFloat { get }
    var widthThin: CGFloat { get }
    var widthMedium: CGFloat { get }
    var widthThick: CGFloat { get }
}

// MARK: - Shadow Providing Protocol

/// Protocol for providing shadow tokens
public protocol ShadowProviding {
    var shadowNone: ShadowStyle { get }
    var shadowSm: ShadowStyle { get }
    var shadowMd: ShadowStyle { get }
    var shadowLg: ShadowStyle { get }
    var shadowXl: ShadowStyle { get }
}

/// Shadow style configuration
public struct ShadowStyle: Equatable, Sendable {
    public let color: Color
    public let radius: CGFloat
    public let x: CGFloat
    public let y: CGFloat

    public init(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }

    public static let none = ShadowStyle(color: .clear, radius: 0, x: 0, y: 0)
}

// MARK: - Animation Providing Protocol

/// Protocol for providing animation tokens
public protocol AnimationProviding {
    var durationFast: Double { get }
    var durationNormal: Double { get }
    var durationSlow: Double { get }

    var springResponse: Double { get }
    var springDamping: Double { get }
}

// MARK: - Complete Theme Protocol

/// Complete theme protocol combining all design token providers
/// Follows Dependency Inversion Principle - high-level modules depend on abstractions
public protocol ThemeProviding: ColorProviding, TypographyProviding, SpacingProviding, BorderProviding, ShadowProviding, AnimationProviding {
    var name: String { get }
    var isDark: Bool { get }
}
