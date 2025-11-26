// BSIcon.swift
// BootstrapUI
//
// Icon component with consistent styling
// Follows Single Responsibility Principle - handles icon presentation only

import SwiftUI

// MARK: - Icon Size

/// Available icon sizes
public enum BSIconSize: String, CaseIterable, Sendable {
    case xs
    case sm
    case md
    case lg
    case xl
    case xxl

    var pointSize: CGFloat {
        switch self {
        case .xs: return 12
        case .sm: return 16
        case .md: return 20
        case .lg: return 24
        case .xl: return 32
        case .xxl: return 48
        }
    }
}

// MARK: - Icon Component

/// A styled icon component using SF Symbols
///
/// Example usage:
/// ```swift
/// BSIcon("star.fill", size: .lg, color: .yellow)
/// BSIcon("heart", size: .md, weight: .bold)
/// ```
public struct BSIcon: View {

    // MARK: - Properties

    private let name: String
    private let size: BSIconSize
    private let color: Color?
    private let weight: Font.Weight
    private let renderingMode: Image.TemplateRenderingMode

    @Environment(\.theme) private var theme

    // MARK: - Initialization

    /// Creates an icon from SF Symbols
    /// - Parameters:
    ///   - name: SF Symbol name
    ///   - size: Icon size (default: .md)
    ///   - color: Icon color (nil uses theme primary)
    ///   - weight: Font weight (default: .regular)
    ///   - renderingMode: Rendering mode (default: .template)
    public init(
        _ name: String,
        size: BSIconSize = .md,
        color: Color? = nil,
        weight: Font.Weight = .regular,
        renderingMode: Image.TemplateRenderingMode = .template
    ) {
        self.name = name
        self.size = size
        self.color = color
        self.weight = weight
        self.renderingMode = renderingMode
    }

    // MARK: - Body

    public var body: some View {
        Image(systemName: name)
            .font(.system(size: size.pointSize, weight: weight))
            .foregroundColor(color ?? theme.onSurface)
            .renderingMode(renderingMode)
    }
}

// MARK: - Circular Icon

/// An icon displayed within a circular background
public struct BSCircularIcon: View {

    private let icon: String
    private let size: BSIconSize
    private let iconColor: Color?
    private let backgroundColor: Color?
    private let hasBorder: Bool

    @Environment(\.theme) private var theme

    public init(
        _ icon: String,
        size: BSIconSize = .md,
        iconColor: Color? = nil,
        backgroundColor: Color? = nil,
        hasBorder: Bool = false
    ) {
        self.icon = icon
        self.size = size
        self.iconColor = iconColor
        self.backgroundColor = backgroundColor
        self.hasBorder = hasBorder
    }

    public var body: some View {
        BSIcon(icon, size: size, color: iconColor ?? theme.primary)
            .frame(width: circleSize, height: circleSize)
            .background(backgroundColor ?? theme.primary.opacity(0.1))
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(theme.border, lineWidth: hasBorder ? 1 : 0)
            )
    }

    private var circleSize: CGFloat {
        size.pointSize * 2.5
    }
}

// MARK: - Icon with Badge

/// An icon with a notification badge
public struct BSIconWithBadge: View {

    private let icon: String
    private let size: BSIconSize
    private let badgeCount: Int
    private let badgeColor: Color?
    private let iconColor: Color?

    @Environment(\.theme) private var theme

    public init(
        _ icon: String,
        size: BSIconSize = .md,
        badgeCount: Int = 0,
        badgeColor: Color? = nil,
        iconColor: Color? = nil
    ) {
        self.icon = icon
        self.size = size
        self.badgeCount = badgeCount
        self.badgeColor = badgeColor
        self.iconColor = iconColor
    }

    public var body: some View {
        ZStack(alignment: .topTrailing) {
            BSIcon(icon, size: size, color: iconColor)

            if badgeCount > 0 {
                Text(badgeCount > 99 ? "99+" : "\(badgeCount)")
                    .font(.system(size: badgeFontSize, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(badgeColor ?? theme.error)
                    .clipShape(Capsule())
                    .offset(x: badgeOffset, y: -badgeOffset)
            }
        }
    }

    private var badgeFontSize: CGFloat {
        switch size {
        case .xs, .sm: return 8
        case .md: return 10
        case .lg, .xl, .xxl: return 12
        }
    }

    private var badgeOffset: CGFloat {
        switch size {
        case .xs, .sm: return 4
        case .md: return 6
        case .lg, .xl, .xxl: return 8
        }
    }
}

// MARK: - Animated Icon

/// An icon with built-in animations
public struct BSAnimatedIcon: View {

    public enum AnimationType {
        case pulse
        case rotate
        case bounce
        case shake
    }

    private let icon: String
    private let size: BSIconSize
    private let color: Color?
    private let animation: AnimationType
    private let isAnimating: Bool

    @State private var animationState: Bool = false
    @Environment(\.theme) private var theme

    public init(
        _ icon: String,
        size: BSIconSize = .md,
        color: Color? = nil,
        animation: AnimationType = .pulse,
        isAnimating: Bool = true
    ) {
        self.icon = icon
        self.size = size
        self.color = color
        self.animation = animation
        self.isAnimating = isAnimating
    }

    public var body: some View {
        BSIcon(icon, size: size, color: color)
            .modifier(animationModifier)
            .onAppear {
                if isAnimating {
                    withAnimation(animationStyle.repeatForever(autoreverses: true)) {
                        animationState = true
                    }
                }
            }
    }

    @ViewBuilder
    private var animationModifier: some View {
        switch animation {
        case .pulse:
            BSIcon(icon, size: size, color: color)
                .scaleEffect(animationState ? 1.2 : 1.0)
        case .rotate:
            BSIcon(icon, size: size, color: color)
                .rotationEffect(.degrees(animationState ? 360 : 0))
        case .bounce:
            BSIcon(icon, size: size, color: color)
                .offset(y: animationState ? -4 : 0)
        case .shake:
            BSIcon(icon, size: size, color: color)
                .offset(x: animationState ? 2 : -2)
        }
    }

    private var animationStyle: Animation {
        switch animation {
        case .pulse: return .easeInOut(duration: 1.0)
        case .rotate: return .linear(duration: 2.0)
        case .bounce: return .easeInOut(duration: 0.5)
        case .shake: return .easeInOut(duration: 0.1)
        }
    }
}

// MARK: - Preview

#if DEBUG
struct BSIcon_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 24) {
            HStack(spacing: 16) {
                BSIcon("star.fill", size: .xs)
                BSIcon("star.fill", size: .sm)
                BSIcon("star.fill", size: .md)
                BSIcon("star.fill", size: .lg)
                BSIcon("star.fill", size: .xl)
            }

            HStack(spacing: 16) {
                BSCircularIcon("person.fill", size: .sm)
                BSCircularIcon("heart.fill", size: .md, iconColor: .red)
                BSCircularIcon("star.fill", size: .lg, backgroundColor: .yellow.opacity(0.2))
            }

            HStack(spacing: 24) {
                BSIconWithBadge("bell.fill", badgeCount: 5)
                BSIconWithBadge("envelope.fill", size: .lg, badgeCount: 99)
                BSIconWithBadge("cart.fill", badgeCount: 150)
            }
        }
        .padding()
        .withTheme()
    }
}
#endif
