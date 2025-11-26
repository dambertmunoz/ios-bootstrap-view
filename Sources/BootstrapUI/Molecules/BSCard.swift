// BSCard.swift
// BootstrapUI
//
// Card component for content containers
// Follows Composition - provides flexible content container

import SwiftUI

// MARK: - Card Variant

/// Available card visual variants
public enum BSCardVariant: String, CaseIterable, Sendable {
    case elevated
    case outlined
    case filled
}

// MARK: - Card Component

/// A flexible card container component
///
/// Example usage:
/// ```swift
/// BSCard {
///     VStack {
///         Text("Card Title")
///         Text("Card content goes here")
///     }
/// }
///
/// BSCard(variant: .outlined, padding: .md) {
///     // Content
/// }
/// ```
public struct BSCard<Content: View>: View {

    // MARK: - Properties

    private let variant: BSCardVariant
    private let padding: CGFloat?
    private let cornerRadius: CGFloat?
    private let isInteractive: Bool
    private let onTap: (() -> Void)?
    private let content: () -> Content

    @Environment(\.theme) private var theme
    @State private var isPressed = false

    // MARK: - Initialization

    /// Creates a card container
    /// - Parameters:
    ///   - variant: Visual variant (default: .elevated)
    ///   - padding: Content padding (nil uses theme default)
    ///   - cornerRadius: Corner radius (nil uses theme default)
    ///   - isInteractive: Whether card responds to taps
    ///   - onTap: Action when tapped
    ///   - content: Card content
    public init(
        variant: BSCardVariant = .elevated,
        padding: CGFloat? = nil,
        cornerRadius: CGFloat? = nil,
        isInteractive: Bool = false,
        onTap: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.variant = variant
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.isInteractive = isInteractive || onTap != nil
        self.onTap = onTap
        self.content = content
    }

    // MARK: - Body

    public var body: some View {
        content()
            .padding(padding ?? theme.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(backgroundColor)
            .cornerRadius(cornerRadius ?? theme.radiusLg)
            .overlay(borderOverlay)
            .shadow(
                color: shadowColor,
                radius: shadowRadius,
                x: 0,
                y: shadowY
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: theme.durationFast), value: isPressed)
            .onTapGesture {
                if isInteractive {
                    onTap?()
                }
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if isInteractive { isPressed = true }
                    }
                    .onEnded { _ in
                        isPressed = false
                    }
            )
    }

    // MARK: - Computed Properties

    private var backgroundColor: Color {
        switch variant {
        case .elevated, .outlined:
            return theme.background
        case .filled:
            return theme.surface
        }
    }

    @ViewBuilder
    private var borderOverlay: some View {
        if variant == .outlined {
            RoundedRectangle(cornerRadius: cornerRadius ?? theme.radiusLg)
                .stroke(theme.border, lineWidth: 1)
        }
    }

    private var shadowColor: Color {
        variant == .elevated ? theme.shadowMd.color : .clear
    }

    private var shadowRadius: CGFloat {
        variant == .elevated ? theme.shadowMd.radius : 0
    }

    private var shadowY: CGFloat {
        variant == .elevated ? theme.shadowMd.y : 0
    }
}

// MARK: - Image Card

/// A card with a header image
public struct BSImageCard<Content: View>: View {

    private let imageURL: URL?
    private let image: Image?
    private let imageHeight: CGFloat
    private let variant: BSCardVariant
    private let onTap: (() -> Void)?
    private let content: () -> Content

    @Environment(\.theme) private var theme

    public init(
        imageURL: URL?,
        imageHeight: CGFloat = 180,
        variant: BSCardVariant = .elevated,
        onTap: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.imageURL = imageURL
        self.image = nil
        self.imageHeight = imageHeight
        self.variant = variant
        self.onTap = onTap
        self.content = content
    }

    public init(
        image: Image,
        imageHeight: CGFloat = 180,
        variant: BSCardVariant = .elevated,
        onTap: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.imageURL = nil
        self.image = image
        self.imageHeight = imageHeight
        self.variant = variant
        self.onTap = onTap
        self.content = content
    }

    public var body: some View {
        BSCard(variant: variant, padding: 0, onTap: onTap) {
            VStack(spacing: 0) {
                // Image
                Group {
                    if let imageURL = imageURL {
                        AsyncImage(url: imageURL) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            case .failure:
                                imagePlaceholder
                            case .empty:
                                ProgressView()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            @unknown default:
                                imagePlaceholder
                            }
                        }
                    } else if let image = image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        imagePlaceholder
                    }
                }
                .frame(height: imageHeight)
                .clipped()

                // Content
                content()
                    .padding(theme.md)
            }
        }
    }

    private var imagePlaceholder: some View {
        Rectangle()
            .fill(theme.surface)
            .overlay(
                Image(systemName: "photo")
                    .font(.largeTitle)
                    .foregroundColor(theme.placeholder)
            )
    }
}

// MARK: - Action Card

/// A card with action buttons
public struct BSActionCard<Content: View>: View {

    private let title: String
    private let subtitle: String?
    private let icon: String?
    private let variant: BSCardVariant
    private let primaryAction: (title: String, action: () -> Void)?
    private let secondaryAction: (title: String, action: () -> Void)?
    private let content: (() -> Content)?

    @Environment(\.theme) private var theme

    public init(
        title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        variant: BSCardVariant = .elevated,
        primaryAction: (title: String, action: () -> Void)? = nil,
        secondaryAction: (title: String, action: () -> Void)? = nil
    ) where Content == EmptyView {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.variant = variant
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.content = nil
    }

    public init(
        title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        variant: BSCardVariant = .elevated,
        primaryAction: (title: String, action: () -> Void)? = nil,
        secondaryAction: (title: String, action: () -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.variant = variant
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.content = content
    }

    public var body: some View {
        BSCard(variant: variant) {
            VStack(alignment: .leading, spacing: theme.md) {
                // Header
                HStack(spacing: theme.sm) {
                    if let icon = icon {
                        BSCircularIcon(icon, size: .lg)
                    }

                    VStack(alignment: .leading, spacing: theme.xxs) {
                        BSText(title, style: .headline)

                        if let subtitle = subtitle {
                            BSText(subtitle, style: .subheadline, color: .secondary)
                        }
                    }

                    Spacer()
                }

                // Custom content
                if let content = content {
                    content()
                }

                // Actions
                if primaryAction != nil || secondaryAction != nil {
                    HStack(spacing: theme.sm) {
                        Spacer()

                        if let secondary = secondaryAction {
                            BSButton(secondary.title, style: .ghost, size: .small, action: secondary.action)
                        }

                        if let primary = primaryAction {
                            BSButton(primary.title, style: .primary, size: .small, action: primary.action)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct BSCard_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 16) {
                BSCard {
                    VStack(alignment: .leading, spacing: 8) {
                        BSText("Elevated Card", style: .headline)
                        BSText("This is the default card style with shadow", style: .body, color: .secondary)
                    }
                }

                BSCard(variant: .outlined) {
                    VStack(alignment: .leading, spacing: 8) {
                        BSText("Outlined Card", style: .headline)
                        BSText("Card with border outline", style: .body, color: .secondary)
                    }
                }

                BSCard(variant: .filled) {
                    VStack(alignment: .leading, spacing: 8) {
                        BSText("Filled Card", style: .headline)
                        BSText("Card with filled background", style: .body, color: .secondary)
                    }
                }

                BSActionCard(
                    title: "Action Card",
                    subtitle: "Card with actions",
                    icon: "star.fill",
                    primaryAction: ("Confirm", {}),
                    secondaryAction: ("Cancel", {})
                )

                BSCard(isInteractive: true, onTap: {}) {
                    HStack {
                        BSText("Interactive Card", style: .headline)
                        Spacer()
                        BSIcon("chevron.right", size: .sm, color: .gray)
                    }
                }
            }
            .padding()
        }
        .withTheme()
    }
}
#endif
