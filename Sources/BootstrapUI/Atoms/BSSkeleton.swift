// BSSkeleton.swift
// BootstrapUI
//
// Skeleton loading placeholders with shimmer effect
// Perfect for loading states in modern apps

import SwiftUI

// MARK: - Skeleton Shape

/// Available skeleton shapes
public enum BSSkeletonShape {
    case rectangle
    case roundedRectangle(cornerRadius: CGFloat)
    case circle
    case capsule
}

// MARK: - Shimmer Effect

/// Shimmer animation modifier
struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    let duration: Double
    let bounce: Bool

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .clear,
                            .white.opacity(0.4),
                            .clear
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * 2)
                    .offset(x: -geometry.size.width + (geometry.size.width * 2 * phase))
                }
            )
            .mask(content)
            .onAppear {
                withAnimation(
                    .linear(duration: duration)
                    .repeatForever(autoreverses: bounce)
                ) {
                    phase = 1
                }
            }
    }
}

extension View {
    /// Apply shimmer effect to any view
    public func shimmer(duration: Double = 1.5, bounce: Bool = false) -> some View {
        modifier(ShimmerModifier(duration: duration, bounce: bounce))
    }
}

// MARK: - Skeleton View

/// A skeleton placeholder view with shimmer animation
///
/// Example usage:
/// ```swift
/// BSSkeletonView(shape: .roundedRectangle(cornerRadius: 8))
///     .frame(height: 100)
///
/// BSSkeletonView(shape: .circle)
///     .frame(width: 50, height: 50)
/// ```
public struct BSSkeletonView: View {

    private let shape: BSSkeletonShape
    private let animated: Bool

    @Environment(\.theme) private var theme

    public init(
        shape: BSSkeletonShape = .roundedRectangle(cornerRadius: 8),
        animated: Bool = true
    ) {
        self.shape = shape
        self.animated = animated
    }

    public var body: some View {
        skeletonShape
            .foregroundColor(theme.surface)
            .modifier(ConditionalShimmer(isAnimated: animated))
    }

    @ViewBuilder
    private var skeletonShape: some View {
        switch shape {
        case .rectangle:
            Rectangle()
        case .roundedRectangle(let cornerRadius):
            RoundedRectangle(cornerRadius: cornerRadius)
        case .circle:
            Circle()
        case .capsule:
            Capsule()
        }
    }
}

private struct ConditionalShimmer: ViewModifier {
    let isAnimated: Bool

    func body(content: Content) -> some View {
        if isAnimated {
            content.shimmer()
        } else {
            content
        }
    }
}

// MARK: - Skeleton Text

/// A skeleton placeholder for text content
public struct BSSkeletonText: View {

    private let lines: Int
    private let lineHeight: CGFloat
    private let spacing: CGFloat
    private let lastLineWidth: CGFloat

    @Environment(\.theme) private var theme

    public init(
        lines: Int = 3,
        lineHeight: CGFloat = 16,
        spacing: CGFloat = 8,
        lastLineWidth: CGFloat = 0.6
    ) {
        self.lines = max(1, lines)
        self.lineHeight = lineHeight
        self.spacing = spacing
        self.lastLineWidth = lastLineWidth
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            ForEach(0..<lines, id: \.self) { index in
                BSSkeletonView(shape: .roundedRectangle(cornerRadius: 4))
                    .frame(height: lineHeight)
                    .frame(
                        maxWidth: index == lines - 1 ? .infinity : .infinity,
                        alignment: .leading
                    )
                    .scaleEffect(
                        x: index == lines - 1 ? lastLineWidth : 1,
                        y: 1,
                        anchor: .leading
                    )
            }
        }
    }
}

// MARK: - Skeleton Avatar

/// A skeleton placeholder for avatar/profile images
public struct BSSkeletonAvatar: View {

    public enum Size {
        case small, medium, large, xlarge

        var dimension: CGFloat {
            switch self {
            case .small: return 32
            case .medium: return 44
            case .large: return 64
            case .xlarge: return 96
            }
        }
    }

    private let size: Size
    private let shape: BSSkeletonShape

    public init(size: Size = .medium, isCircle: Bool = true) {
        self.size = size
        self.shape = isCircle ? .circle : .roundedRectangle(cornerRadius: 8)
    }

    public var body: some View {
        BSSkeletonView(shape: shape)
            .frame(width: size.dimension, height: size.dimension)
    }
}

// MARK: - Skeleton Card

/// A complete skeleton card placeholder
public struct BSSkeletonCard: View {

    private let hasImage: Bool
    private let imageHeight: CGFloat
    private let textLines: Int

    @Environment(\.theme) private var theme

    public init(
        hasImage: Bool = true,
        imageHeight: CGFloat = 150,
        textLines: Int = 3
    ) {
        self.hasImage = hasImage
        self.imageHeight = imageHeight
        self.textLines = textLines
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if hasImage {
                BSSkeletonView(shape: .rectangle)
                    .frame(height: imageHeight)
            }

            VStack(alignment: .leading, spacing: theme.sm) {
                // Title
                BSSkeletonView(shape: .roundedRectangle(cornerRadius: 4))
                    .frame(height: 20)
                    .frame(maxWidth: .infinity)
                    .scaleEffect(x: 0.7, y: 1, anchor: .leading)

                // Content
                BSSkeletonText(lines: textLines, lineHeight: 14)
            }
            .padding(theme.md)
        }
        .background(theme.background)
        .cornerRadius(theme.radiusLg)
        .shadow(color: theme.shadowSm.color, radius: theme.shadowSm.radius)
    }
}

// MARK: - Skeleton List Item

/// A skeleton placeholder for list items
public struct BSSkeletonListItem: View {

    private let hasLeadingImage: Bool
    private let hasTrailingContent: Bool

    @Environment(\.theme) private var theme

    public init(
        hasLeadingImage: Bool = true,
        hasTrailingContent: Bool = false
    ) {
        self.hasLeadingImage = hasLeadingImage
        self.hasTrailingContent = hasTrailingContent
    }

    public var body: some View {
        HStack(spacing: theme.md) {
            if hasLeadingImage {
                BSSkeletonAvatar(size: .medium)
            }

            VStack(alignment: .leading, spacing: theme.xs) {
                BSSkeletonView(shape: .roundedRectangle(cornerRadius: 4))
                    .frame(height: 16)
                    .frame(maxWidth: 150)

                BSSkeletonView(shape: .roundedRectangle(cornerRadius: 4))
                    .frame(height: 12)
                    .frame(maxWidth: 100)
            }

            Spacer()

            if hasTrailingContent {
                BSSkeletonView(shape: .roundedRectangle(cornerRadius: 4))
                    .frame(width: 60, height: 14)
            }
        }
        .padding(.vertical, theme.sm)
    }
}

// MARK: - Skeleton Profile

/// A skeleton placeholder for profile headers
public struct BSSkeletonProfile: View {

    @Environment(\.theme) private var theme

    public init() {}

    public var body: some View {
        VStack(spacing: theme.lg) {
            BSSkeletonAvatar(size: .xlarge)

            VStack(spacing: theme.sm) {
                BSSkeletonView(shape: .roundedRectangle(cornerRadius: 4))
                    .frame(width: 150, height: 20)

                BSSkeletonView(shape: .roundedRectangle(cornerRadius: 4))
                    .frame(width: 100, height: 14)
            }

            HStack(spacing: theme.xl) {
                ForEach(0..<3, id: \.self) { _ in
                    VStack(spacing: theme.xs) {
                        BSSkeletonView(shape: .roundedRectangle(cornerRadius: 4))
                            .frame(width: 40, height: 18)

                        BSSkeletonView(shape: .roundedRectangle(cornerRadius: 4))
                            .frame(width: 50, height: 12)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(theme.lg)
    }
}

// MARK: - Redacted Modifier

extension View {
    /// Apply skeleton loading state to any view
    public func bsRedacted(_ isLoading: Bool) -> some View {
        self
            .redacted(reason: isLoading ? .placeholder : [])
            .shimmer(duration: 1.5)
            .disabled(isLoading)
    }
}

// MARK: - Preview

#if DEBUG
struct BSSkeleton_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Basic shapes
                HStack(spacing: 16) {
                    BSSkeletonView(shape: .circle)
                        .frame(width: 50, height: 50)

                    BSSkeletonView(shape: .roundedRectangle(cornerRadius: 8))
                        .frame(width: 100, height: 50)

                    BSSkeletonView(shape: .capsule)
                        .frame(width: 80, height: 30)
                }

                // Text
                BSSkeletonText(lines: 4)

                // Card
                BSSkeletonCard()

                // List items
                VStack(spacing: 0) {
                    ForEach(0..<5, id: \.self) { _ in
                        BSSkeletonListItem()
                        BSDivider()
                    }
                }

                // Profile
                BSSkeletonProfile()
            }
            .padding()
        }
        .withTheme()
    }
}
#endif
