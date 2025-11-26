// BSSegmentedControl.swift
// BootstrapUI
//
// Segmented control components with various styles
// Provides tab-like selection UI

import SwiftUI

// MARK: - BSSegmentedControl

/// A segmented control for switching between options
public struct BSSegmentedControl<T: Hashable>: View {

    @Binding private var selection: T
    private let options: [T]
    private let labelProvider: (T) -> String
    private let style: Style
    private let size: Size

    @Namespace private var namespace

    @Environment(\.theme) private var theme

    public enum Style {
        case filled
        case outlined
        case underlined
        case pill
    }

    public enum Size {
        case small
        case medium
        case large

        var height: CGFloat {
            switch self {
            case .small: return 32
            case .medium: return 40
            case .large: return 48
            }
        }

        var font: Font {
            switch self {
            case .small: return .caption
            case .medium: return .subheadline
            case .large: return .body
            }
        }
    }

    public init(
        selection: Binding<T>,
        options: [T],
        labelProvider: @escaping (T) -> String,
        style: Style = .filled,
        size: Size = .medium
    ) {
        self._selection = selection
        self.options = options
        self.labelProvider = labelProvider
        self.style = style
        self.size = size
    }

    public var body: some View {
        Group {
            switch style {
            case .filled:
                filledStyle
            case .outlined:
                outlinedStyle
            case .underlined:
                underlinedStyle
            case .pill:
                pillStyle
            }
        }
    }

    // MARK: - Filled Style

    private var filledStyle: some View {
        HStack(spacing: 0) {
            ForEach(options, id: \.self) { option in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selection = option
                    }
                } label: {
                    Text(labelProvider(option))
                        .font(size.font)
                        .fontWeight(selection == option ? .semibold : .regular)
                        .foregroundColor(selection == option ? theme.onPrimary : theme.onSurface)
                        .frame(maxWidth: .infinity)
                        .frame(height: size.height)
                        .background(
                            ZStack {
                                if selection == option {
                                    RoundedRectangle(cornerRadius: theme.radiusSm)
                                        .fill(theme.primary)
                                        .matchedGeometryEffect(id: "selection", in: namespace)
                                }
                            }
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(theme.surface)
        .cornerRadius(theme.radiusMd)
    }

    // MARK: - Outlined Style

    private var outlinedStyle: some View {
        HStack(spacing: -1) {
            ForEach(Array(options.enumerated()), id: \.element) { index, option in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selection = option
                    }
                } label: {
                    Text(labelProvider(option))
                        .font(size.font)
                        .fontWeight(selection == option ? .semibold : .regular)
                        .foregroundColor(selection == option ? theme.primary : theme.onSurface)
                        .frame(maxWidth: .infinity)
                        .frame(height: size.height)
                        .background(selection == option ? theme.primary.opacity(0.1) : Color.clear)
                        .overlay(
                            Rectangle()
                                .stroke(theme.border, lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
                .clipShape(
                    RoundedCornerShape(
                        radius: theme.radiusMd,
                        corners: cornerForIndex(index)
                    )
                )
            }
        }
    }

    // MARK: - Underlined Style

    private var underlinedStyle: some View {
        HStack(spacing: theme.md) {
            ForEach(options, id: \.self) { option in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selection = option
                    }
                } label: {
                    VStack(spacing: theme.xs) {
                        Text(labelProvider(option))
                            .font(size.font)
                            .fontWeight(selection == option ? .semibold : .regular)
                            .foregroundColor(selection == option ? theme.primary : theme.placeholder)

                        if selection == option {
                            Rectangle()
                                .fill(theme.primary)
                                .frame(height: 2)
                                .matchedGeometryEffect(id: "underline", in: namespace)
                        } else {
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: 2)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Pill Style

    private var pillStyle: some View {
        HStack(spacing: theme.sm) {
            ForEach(options, id: \.self) { option in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selection = option
                    }
                } label: {
                    Text(labelProvider(option))
                        .font(size.font)
                        .fontWeight(selection == option ? .semibold : .regular)
                        .foregroundColor(selection == option ? theme.onPrimary : theme.onSurface)
                        .padding(.horizontal, theme.md)
                        .frame(height: size.height)
                        .background(
                            Capsule()
                                .fill(selection == option ? theme.primary : theme.surface)
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func cornerForIndex(_ index: Int) -> UIRectCorner {
        if options.count == 1 {
            return .allCorners
        } else if index == 0 {
            return [.topLeft, .bottomLeft]
        } else if index == options.count - 1 {
            return [.topRight, .bottomRight]
        } else {
            return []
        }
    }
}

// MARK: - BSIconSegmentedControl

/// A segmented control with icons
public struct BSIconSegmentedControl<T: Hashable>: View {

    @Binding private var selection: T
    private let options: [(T, String, String?)] // (value, icon, label)
    private let showLabels: Bool

    @Namespace private var namespace

    @Environment(\.theme) private var theme

    public init(
        selection: Binding<T>,
        options: [(T, String, String?)],
        showLabels: Bool = true
    ) {
        self._selection = selection
        self.options = options
        self.showLabels = showLabels
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<options.count, id: \.self) { index in
                let option = options[index]
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selection = option.0
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: option.1)
                            .font(.system(size: 20))

                        if showLabels, let label = option.2 {
                            Text(label)
                                .font(theme.caption2)
                        }
                    }
                    .foregroundColor(selection == option.0 ? theme.onPrimary : theme.placeholder)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, theme.sm)
                    .background(
                        ZStack {
                            if selection == option.0 {
                                RoundedRectangle(cornerRadius: theme.radiusSm)
                                    .fill(theme.primary)
                                    .matchedGeometryEffect(id: "iconSelection", in: namespace)
                            }
                        }
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(theme.surface)
        .cornerRadius(theme.radiusMd)
    }
}

// MARK: - BSTabSegmentedControl

/// A tab-style segmented control
public struct BSTabSegmentedControl<T: Hashable>: View {

    @Binding private var selection: T
    private let tabs: [Tab]

    @Namespace private var namespace

    @Environment(\.theme) private var theme

    public struct Tab: Identifiable {
        public let id: T
        public let title: String
        public let icon: String?
        public let badge: Int?

        public init(
            id: T,
            title: String,
            icon: String? = nil,
            badge: Int? = nil
        ) {
            self.id = id
            self.title = title
            self.icon = icon
            self.badge = badge
        }
    }

    public init(
        selection: Binding<T>,
        tabs: [Tab]
    ) {
        self._selection = selection
        self.tabs = tabs
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(tabs) { tab in
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selection = tab.id
                        }
                    } label: {
                        VStack(spacing: theme.xs) {
                            HStack(spacing: theme.xs) {
                                if let icon = tab.icon {
                                    Image(systemName: icon)
                                        .font(.system(size: 14))
                                }

                                Text(tab.title)
                                    .font(theme.subheadline)
                                    .fontWeight(selection == tab.id ? .semibold : .regular)

                                if let badge = tab.badge, badge > 0 {
                                    BSCountBadge(badge)
                                }
                            }
                            .foregroundColor(selection == tab.id ? theme.primary : theme.placeholder)
                            .padding(.horizontal, theme.md)
                            .padding(.vertical, theme.sm)

                            // Underline indicator
                            if selection == tab.id {
                                Rectangle()
                                    .fill(theme.primary)
                                    .frame(height: 2)
                                    .matchedGeometryEffect(id: "tabIndicator", in: namespace)
                            } else {
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(height: 2)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .background(
            VStack {
                Spacer()
                Rectangle()
                    .fill(theme.border)
                    .frame(height: 1)
            }
        )
    }
}

// MARK: - Helper Shape

private struct RoundedCornerShape: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Convenience Extensions

extension BSSegmentedControl where T == String {
    public init(
        selection: Binding<String>,
        options: [String],
        style: Style = .filled,
        size: Size = .medium
    ) {
        self._selection = selection
        self.options = options
        self.labelProvider = { $0 }
        self.style = style
        self.size = size
    }
}

// MARK: - Preview

#if DEBUG
struct BSSegmentedControl_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 32) {
                BSSegmentedControl(
                    selection: .constant("First"),
                    options: ["First", "Second", "Third"]
                )

                BSSegmentedControl(
                    selection: .constant("A"),
                    options: ["A", "B", "C"],
                    style: .outlined
                )

                BSSegmentedControl(
                    selection: .constant("Tab 1"),
                    options: ["Tab 1", "Tab 2", "Tab 3"],
                    style: .underlined
                )

                BSSegmentedControl(
                    selection: .constant("One"),
                    options: ["One", "Two", "Three"],
                    style: .pill
                )

                BSIconSegmentedControl(
                    selection: .constant(0),
                    options: [
                        (0, "list.bullet", "List"),
                        (1, "square.grid.2x2", "Grid"),
                        (2, "map", "Map")
                    ]
                )

                BSTabSegmentedControl(
                    selection: .constant("all"),
                    tabs: [
                        .init(id: "all", title: "All", icon: "tray.full"),
                        .init(id: "unread", title: "Unread", icon: "envelope.badge", badge: 5),
                        .init(id: "starred", title: "Starred", icon: "star")
                    ]
                )
            }
            .padding()
        }
        .withTheme()
    }
}
#endif
