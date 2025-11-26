// BSNavigation.swift
// BootstrapUI
//
// Navigation components including navigation bar and tab bar
// Follows Composition - combines atoms for navigation UI

import SwiftUI

// MARK: - Navigation Bar

/// A custom navigation bar component
public struct BSNavigationBar: View {

    private let title: String
    private let displayMode: DisplayMode
    private let leadingItems: [NavBarItem]
    private let trailingItems: [NavBarItem]
    private let backgroundColor: Color?

    @Environment(\.theme) private var theme

    public enum DisplayMode {
        case inline
        case large
    }

    public struct NavBarItem: Identifiable {
        public let id = UUID()
        public let content: NavBarItemContent
        public let action: () -> Void

        public enum NavBarItemContent {
            case icon(String)
            case text(String)
            case avatar(URL?)
        }

        public init(icon: String, action: @escaping () -> Void) {
            self.content = .icon(icon)
            self.action = action
        }

        public init(text: String, action: @escaping () -> Void) {
            self.content = .text(text)
            self.action = action
        }

        public init(avatarURL: URL?, action: @escaping () -> Void) {
            self.content = .avatar(avatarURL)
            self.action = action
        }
    }

    public init(
        title: String,
        displayMode: DisplayMode = .inline,
        leadingItems: [NavBarItem] = [],
        trailingItems: [NavBarItem] = [],
        backgroundColor: Color? = nil
    ) {
        self.title = title
        self.displayMode = displayMode
        self.leadingItems = leadingItems
        self.trailingItems = trailingItems
        self.backgroundColor = backgroundColor
    }

    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                // Leading items
                HStack(spacing: theme.sm) {
                    ForEach(leadingItems) { item in
                        navBarButton(item)
                    }
                }
                .frame(minWidth: 60, alignment: .leading)

                Spacer()

                // Title (inline mode)
                if displayMode == .inline {
                    Text(title)
                        .font(theme.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(theme.onSurface)
                }

                Spacer()

                // Trailing items
                HStack(spacing: theme.sm) {
                    ForEach(trailingItems) { item in
                        navBarButton(item)
                    }
                }
                .frame(minWidth: 60, alignment: .trailing)
            }
            .padding(.horizontal, theme.md)
            .padding(.vertical, theme.sm)

            // Large title
            if displayMode == .large {
                HStack {
                    Text(title)
                        .font(theme.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(theme.onSurface)
                    Spacer()
                }
                .padding(.horizontal, theme.md)
                .padding(.bottom, theme.sm)
            }
        }
        .background(backgroundColor ?? theme.background)
    }

    @ViewBuilder
    private func navBarButton(_ item: NavBarItem) -> some View {
        Button(action: item.action) {
            switch item.content {
            case .icon(let name):
                Image(systemName: name)
                    .font(.system(size: 18))
                    .foregroundColor(theme.primary)
                    .frame(width: 44, height: 44)
            case .text(let text):
                Text(text)
                    .font(theme.body)
                    .foregroundColor(theme.primary)
            case .avatar(let url):
                BSAvatar(imageURL: url, size: .sm)
            }
        }
    }
}

// MARK: - Tab Bar

/// A custom tab bar component
public struct BSTabBar<T: Hashable>: View {

    @Binding private var selection: T
    private let items: [TabBarItem<T>]
    private let style: TabBarStyle

    @Environment(\.theme) private var theme

    public enum TabBarStyle {
        case standard
        case floating
        case minimal
    }

    public struct TabBarItem<T: Hashable>: Identifiable {
        public let id: T
        public let icon: String
        public let selectedIcon: String?
        public let title: String
        public let badge: Int?

        public init(
            id: T,
            icon: String,
            selectedIcon: String? = nil,
            title: String,
            badge: Int? = nil
        ) {
            self.id = id
            self.icon = icon
            self.selectedIcon = selectedIcon
            self.title = title
            self.badge = badge
        }
    }

    public init(
        selection: Binding<T>,
        items: [TabBarItem<T>],
        style: TabBarStyle = .standard
    ) {
        self._selection = selection
        self.items = items
        self.style = style
    }

    public var body: some View {
        Group {
            switch style {
            case .standard:
                standardTabBar
            case .floating:
                floatingTabBar
            case .minimal:
                minimalTabBar
            }
        }
    }

    private var standardTabBar: some View {
        HStack(spacing: 0) {
            ForEach(items) { item in
                tabButton(item)
            }
        }
        .padding(.top, theme.sm)
        .padding(.bottom, theme.sm)
        .background(theme.surface)
        .overlay(
            BSDivider()
                .frame(maxWidth: .infinity, maxHeight: 1, alignment: .top),
            alignment: .top
        )
    }

    private var floatingTabBar: some View {
        HStack(spacing: theme.lg) {
            ForEach(items) { item in
                tabButton(item, showTitle: false)
            }
        }
        .padding(.horizontal, theme.xl)
        .padding(.vertical, theme.sm + 4)
        .background(theme.surface)
        .cornerRadius(theme.radiusFull)
        .shadow(
            color: theme.shadowLg.color,
            radius: theme.shadowLg.radius,
            x: theme.shadowLg.x,
            y: theme.shadowLg.y
        )
        .padding(.horizontal, theme.md)
        .padding(.bottom, theme.sm)
    }

    private var minimalTabBar: some View {
        HStack(spacing: 0) {
            ForEach(items) { item in
                minimalTabButton(item)
            }
        }
        .padding(.vertical, theme.sm)
        .background(theme.background)
    }

    @ViewBuilder
    private func tabButton(_ item: TabBarItem<T>, showTitle: Bool = true) -> some View {
        Button(action: { selection = item.id }) {
            VStack(spacing: theme.xxs) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: isSelected(item) ? (item.selectedIcon ?? item.icon) : item.icon)
                        .font(.system(size: 22))
                        .symbolVariant(isSelected(item) ? .fill : .none)

                    if let badge = item.badge, badge > 0 {
                        BSCountBadge(badge, size: .small)
                            .offset(x: 8, y: -4)
                    }
                }

                if showTitle {
                    Text(item.title)
                        .font(theme.caption2)
                        .fontWeight(isSelected(item) ? .semibold : .regular)
                }
            }
            .foregroundColor(isSelected(item) ? theme.primary : theme.placeholder)
            .frame(maxWidth: .infinity)
        }
    }

    @ViewBuilder
    private func minimalTabButton(_ item: TabBarItem<T>) -> some View {
        Button(action: { selection = item.id }) {
            VStack(spacing: 4) {
                Image(systemName: isSelected(item) ? (item.selectedIcon ?? item.icon) : item.icon)
                    .font(.system(size: 24))
                    .symbolVariant(isSelected(item) ? .fill : .none)

                if isSelected(item) {
                    Circle()
                        .fill(theme.primary)
                        .frame(width: 4, height: 4)
                }
            }
            .foregroundColor(isSelected(item) ? theme.primary : theme.placeholder)
            .frame(maxWidth: .infinity)
        }
    }

    private func isSelected(_ item: TabBarItem<T>) -> Bool {
        selection == item.id
    }
}

// MARK: - Bottom Navigation

/// A bottom navigation component with center action button
public struct BSBottomNavigation<T: Hashable>: View {

    @Binding private var selection: T
    private let items: [BSTabBar<T>.TabBarItem<T>]
    private let centerAction: (() -> Void)?
    private let centerIcon: String

    @Environment(\.theme) private var theme

    public init(
        selection: Binding<T>,
        items: [BSTabBar<T>.TabBarItem<T>],
        centerIcon: String = "plus",
        centerAction: (() -> Void)? = nil
    ) {
        self._selection = selection
        self.items = items
        self.centerIcon = centerIcon
        self.centerAction = centerAction
    }

    public var body: some View {
        ZStack {
            // Tab bar background
            HStack(spacing: 0) {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    if centerAction != nil && index == items.count / 2 {
                        Spacer()
                            .frame(width: 60)
                    }

                    Button(action: { selection = item.id }) {
                        VStack(spacing: theme.xxs) {
                            Image(systemName: selection == item.id ? (item.selectedIcon ?? item.icon) : item.icon)
                                .font(.system(size: 22))
                                .symbolVariant(selection == item.id ? .fill : .none)

                            Text(item.title)
                                .font(theme.caption2)
                        }
                        .foregroundColor(selection == item.id ? theme.primary : theme.placeholder)
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(.top, theme.sm)
            .padding(.bottom, theme.sm)
            .background(theme.surface)

            // Center button
            if let action = centerAction {
                Button(action: action) {
                    Image(systemName: centerIcon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(theme.onPrimary)
                        .frame(width: 56, height: 56)
                        .background(theme.primary)
                        .clipShape(Circle())
                        .shadow(
                            color: theme.primary.opacity(0.3),
                            radius: 8,
                            x: 0,
                            y: 4
                        )
                }
                .offset(y: -20)
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct BSNavigation_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            BSNavigationBar(
                title: "Home",
                displayMode: .large,
                leadingItems: [
                    .init(icon: "line.3.horizontal", action: {})
                ],
                trailingItems: [
                    .init(icon: "magnifyingglass", action: {}),
                    .init(icon: "bell", action: {})
                ]
            )

            Spacer()

            BSTabBar(
                selection: .constant(0),
                items: [
                    .init(id: 0, icon: "house", selectedIcon: "house.fill", title: "Home"),
                    .init(id: 1, icon: "magnifyingglass", title: "Search"),
                    .init(id: 2, icon: "bell", selectedIcon: "bell.fill", title: "Notifications", badge: 5),
                    .init(id: 3, icon: "person", selectedIcon: "person.fill", title: "Profile")
                ]
            )
        }
        .withTheme()
    }
}
#endif
