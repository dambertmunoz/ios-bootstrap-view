// BSFAB.swift
// BootstrapUI
//
// Floating Action Button (FAB) component
// Material Design inspired floating buttons

import SwiftUI

// MARK: - FAB Size

/// Available FAB sizes
public enum BSFABSize {
    case small
    case regular
    case large

    var dimension: CGFloat {
        switch self {
        case .small: return 40
        case .regular: return 56
        case .large: return 72
        }
    }

    var iconSize: CGFloat {
        switch self {
        case .small: return 18
        case .regular: return 24
        case .large: return 32
        }
    }

    var shadowRadius: CGFloat {
        switch self {
        case .small: return 4
        case .regular: return 6
        case .large: return 8
        }
    }
}

// MARK: - FAB Style

/// Available FAB styles
public enum BSFABStyle {
    case primary
    case secondary
    case surface
    case custom(background: Color, foreground: Color)
}

// MARK: - FAB Component

/// A Floating Action Button component
///
/// Example usage:
/// ```swift
/// BSFAB(icon: "plus") {
///     print("FAB tapped")
/// }
///
/// BSFAB(icon: "plus", label: "Add Item", size: .regular) {
///     addNewItem()
/// }
/// ```
public struct BSFAB: View {

    // MARK: - Properties

    private let icon: String
    private let label: String?
    private let size: BSFABSize
    private let style: BSFABStyle
    private let isExtended: Bool
    private let action: () -> Void

    @Environment(\.theme) private var theme
    @State private var isPressed = false

    // MARK: - Initialization

    public init(
        icon: String,
        label: String? = nil,
        size: BSFABSize = .regular,
        style: BSFABStyle = .primary,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.label = label
        self.size = size
        self.style = style
        self.isExtended = label != nil
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        Button(action: action) {
            HStack(spacing: theme.sm) {
                Image(systemName: icon)
                    .font(.system(size: size.iconSize, weight: .semibold))

                if let label = label {
                    Text(label)
                        .font(theme.subheadline)
                        .fontWeight(.semibold)
                }
            }
            .foregroundColor(foregroundColor)
            .frame(
                width: isExtended ? nil : size.dimension,
                height: size.dimension
            )
            .padding(.horizontal, isExtended ? theme.lg : 0)
            .background(backgroundColor)
            .clipShape(isExtended ? AnyShape(Capsule()) : AnyShape(Circle()))
            .shadow(
                color: shadowColor,
                radius: isPressed ? size.shadowRadius / 2 : size.shadowRadius,
                y: isPressed ? 2 : 4
            )
            .scaleEffect(isPressed ? 0.95 : 1)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
        .animation(.spring(response: 0.3), value: isPressed)
    }

    // MARK: - Colors

    private var backgroundColor: Color {
        switch style {
        case .primary:
            return theme.primary
        case .secondary:
            return theme.secondary
        case .surface:
            return theme.surface
        case .custom(let bg, _):
            return bg
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .primary:
            return theme.onPrimary
        case .secondary:
            return theme.onSecondary
        case .surface:
            return theme.primary
        case .custom(_, let fg):
            return fg
        }
    }

    private var shadowColor: Color {
        theme.shadowMd.color
    }
}

// MARK: - AnyShape Helper

struct AnyShape: Shape {
    private let pathBuilder: (CGRect) -> Path

    init<S: Shape>(_ shape: S) {
        pathBuilder = { rect in
            shape.path(in: rect)
        }
    }

    func path(in rect: CGRect) -> Path {
        pathBuilder(rect)
    }
}

// MARK: - Expandable FAB

/// An expandable FAB with multiple action items
public struct BSExpandableFAB: View {

    // MARK: - Properties

    public struct FABItem: Identifiable {
        public let id = UUID()
        public let icon: String
        public let label: String
        public let color: Color?
        public let action: () -> Void

        public init(
            icon: String,
            label: String,
            color: Color? = nil,
            action: @escaping () -> Void
        ) {
            self.icon = icon
            self.label = label
            self.color = color
            self.action = action
        }
    }

    private let icon: String
    private let expandedIcon: String
    private let items: [FABItem]
    private let style: BSFABStyle

    @State private var isExpanded = false
    @Environment(\.theme) private var theme

    // MARK: - Initialization

    public init(
        icon: String = "plus",
        expandedIcon: String = "xmark",
        items: [FABItem],
        style: BSFABStyle = .primary
    ) {
        self.icon = icon
        self.expandedIcon = expandedIcon
        self.items = items
        self.style = style
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .trailing, spacing: theme.md) {
            // Expanded items
            if isExpanded {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    fabItem(item, delay: Double(items.count - index) * 0.05)
                }
            }

            // Main FAB
            BSFAB(
                icon: isExpanded ? expandedIcon : icon,
                style: style
            ) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isExpanded.toggle()
                }
            }
            .rotationEffect(.degrees(isExpanded ? 180 : 0))
            .animation(.spring(response: 0.3), value: isExpanded)
        }
    }

    // MARK: - FAB Item

    private func fabItem(_ item: FABItem, delay: Double) -> some View {
        HStack(spacing: theme.sm) {
            // Label
            Text(item.label)
                .font(theme.subheadline)
                .fontWeight(.medium)
                .foregroundColor(theme.onSurface)
                .padding(.horizontal, theme.sm)
                .padding(.vertical, theme.xs)
                .background(theme.surface)
                .cornerRadius(theme.radiusSm)
                .shadow(color: theme.shadowSm.color, radius: theme.shadowSm.radius)

            // Mini FAB
            Button(action: {
                item.action()
                withAnimation {
                    isExpanded = false
                }
            }) {
                Image(systemName: item.icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(item.color ?? theme.primary)
                    .clipShape(Circle())
                    .shadow(color: theme.shadowSm.color, radius: theme.shadowSm.radius)
            }
        }
        .transition(.asymmetric(
            insertion: .scale.combined(with: .opacity).animation(.spring(response: 0.3).delay(delay)),
            removal: .scale.combined(with: .opacity).animation(.spring(response: 0.2))
        ))
    }
}

// MARK: - Speed Dial FAB

/// A speed dial FAB that expands in a circle
public struct BSSpeedDialFAB: View {

    private let icon: String
    private let items: [BSExpandableFAB.FABItem]
    private let radius: CGFloat

    @State private var isExpanded = false
    @Environment(\.theme) private var theme

    public init(
        icon: String = "plus",
        items: [BSExpandableFAB.FABItem],
        radius: CGFloat = 80
    ) {
        self.icon = icon
        self.items = items
        self.radius = radius
    }

    public var body: some View {
        ZStack {
            // Items in circle
            if isExpanded {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    let angle = itemAngle(for: index)

                    Button(action: {
                        item.action()
                        withAnimation(.spring()) {
                            isExpanded = false
                        }
                    }) {
                        Image(systemName: item.icon)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(item.color ?? theme.secondary)
                            .clipShape(Circle())
                            .shadow(color: theme.shadowSm.color, radius: theme.shadowSm.radius)
                    }
                    .offset(
                        x: cos(angle) * radius,
                        y: sin(angle) * radius
                    )
                    .transition(.scale.combined(with: .opacity))
                }
            }

            // Main FAB
            BSFAB(icon: isExpanded ? "xmark" : icon) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    isExpanded.toggle()
                }
            }
            .rotationEffect(.degrees(isExpanded ? 45 : 0))
        }
    }

    private func itemAngle(for index: Int) -> CGFloat {
        let totalItems = items.count
        let startAngle: CGFloat = -.pi / 2 // Start from top
        let endAngle: CGFloat = 0 // End at right
        let angleRange = endAngle - startAngle
        let angleStep = angleRange / CGFloat(max(1, totalItems - 1))
        return startAngle + angleStep * CGFloat(index)
    }
}

// MARK: - FAB Container

/// A container that positions a FAB at the bottom right
public struct BSFABContainer<Content: View, FABContent: View>: View {

    private let content: () -> Content
    private let fab: () -> FABContent

    @Environment(\.theme) private var theme

    public init(
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder fab: @escaping () -> FABContent
    ) {
        self.content = content
        self.fab = fab
    }

    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            content()

            fab()
                .padding(theme.lg)
        }
    }
}

// MARK: - View Extension

extension View {
    /// Add a FAB to any view
    public func withFAB(
        icon: String,
        style: BSFABStyle = .primary,
        action: @escaping () -> Void
    ) -> some View {
        BSFABContainer(content: { self }) {
            BSFAB(icon: icon, style: style, action: action)
        }
    }

    /// Add an expandable FAB to any view
    public func withExpandableFAB(
        icon: String = "plus",
        items: [BSExpandableFAB.FABItem]
    ) -> some View {
        BSFABContainer(content: { self }) {
            BSExpandableFAB(icon: icon, items: items)
        }
    }
}

// MARK: - Preview

#if DEBUG
struct BSFAB_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray.opacity(0.1).ignoresSafeArea()

            VStack(spacing: 40) {
                // Basic FAB
                Text("Basic FAB").font(.headline)
                HStack(spacing: 20) {
                    BSFAB(icon: "plus", size: .small) {}
                    BSFAB(icon: "plus", size: .regular) {}
                    BSFAB(icon: "plus", size: .large) {}
                }

                // Extended FAB
                Text("Extended FAB").font(.headline)
                BSFAB(icon: "plus", label: "Add Item") {}

                // Styles
                Text("Styles").font(.headline)
                HStack(spacing: 20) {
                    BSFAB(icon: "heart.fill", style: .primary) {}
                    BSFAB(icon: "star.fill", style: .secondary) {}
                    BSFAB(icon: "bookmark.fill", style: .surface) {}
                }

                Spacer()
            }
            .padding()

            // Expandable FAB
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    BSExpandableFAB(items: [
                        .init(icon: "camera.fill", label: "Camera", color: .orange) {},
                        .init(icon: "photo.fill", label: "Gallery", color: .green) {},
                        .init(icon: "doc.fill", label: "Document", color: .blue) {}
                    ])
                    .padding()
                }
            }
        }
        .withTheme()
    }
}
#endif
