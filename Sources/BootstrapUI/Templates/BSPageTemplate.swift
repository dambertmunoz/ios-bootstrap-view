// BSPageTemplate.swift
// BootstrapUI
//
// Page layout templates for common screen patterns
// Follows Template Method Pattern - provides reusable page structures

import SwiftUI

// MARK: - Basic Page Template

/// A basic page template with header and content areas
public struct BSPageTemplate<Header: View, Content: View>: View {

    private let header: () -> Header
    private let content: () -> Content
    private let backgroundColor: Color?
    private let showsScrollIndicators: Bool
    private let hasRefresh: Bool
    private let onRefresh: (() async -> Void)?

    @Environment(\.theme) private var theme

    public init(
        backgroundColor: Color? = nil,
        showsScrollIndicators: Bool = true,
        hasRefresh: Bool = false,
        onRefresh: (() async -> Void)? = nil,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.backgroundColor = backgroundColor
        self.showsScrollIndicators = showsScrollIndicators
        self.hasRefresh = hasRefresh
        self.onRefresh = onRefresh
        self.header = header
        self.content = content
    }

    public var body: some View {
        VStack(spacing: 0) {
            header()

            ScrollView(showsIndicators: showsScrollIndicators) {
                content()
            }
            .refreshable {
                if hasRefresh {
                    await onRefresh?()
                }
            }
        }
        .background(backgroundColor ?? theme.background)
    }
}

// MARK: - Page Template without Header

extension BSPageTemplate where Header == EmptyView {
    public init(
        backgroundColor: Color? = nil,
        showsScrollIndicators: Bool = true,
        hasRefresh: Bool = false,
        onRefresh: (() async -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.backgroundColor = backgroundColor
        self.showsScrollIndicators = showsScrollIndicators
        self.hasRefresh = hasRefresh
        self.onRefresh = onRefresh
        self.header = { EmptyView() }
        self.content = content
    }
}

// MARK: - Loading Page Template

/// A page template with loading, error, and content states
public struct BSStatefulPageTemplate<Content: View>: View {

    public enum LoadingState {
        case loading
        case loaded
        case error(String)
        case empty(title: String, message: String)
    }

    private let state: LoadingState
    private let onRetry: (() -> Void)?
    private let content: () -> Content

    @Environment(\.theme) private var theme

    public init(
        state: LoadingState,
        onRetry: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.state = state
        self.onRetry = onRetry
        self.content = content
    }

    public var body: some View {
        Group {
            switch state {
            case .loading:
                loadingView
            case .loaded:
                content()
            case .error(let message):
                errorView(message)
            case .empty(let title, let message):
                emptyView(title: title, message: message)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.background)
    }

    private var loadingView: some View {
        VStack(spacing: theme.md) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading...")
                .font(theme.subheadline)
                .foregroundColor(theme.placeholder)
        }
    }

    private func errorView(_ message: String) -> some View {
        VStack(spacing: theme.lg) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundColor(theme.error)

            VStack(spacing: theme.sm) {
                Text("Something went wrong")
                    .font(theme.headline)
                    .foregroundColor(theme.onSurface)

                Text(message)
                    .font(theme.body)
                    .foregroundColor(theme.placeholder)
                    .multilineTextAlignment(.center)
            }

            if let retry = onRetry {
                BSButton("Try Again", style: .primary, action: retry)
            }
        }
        .padding(theme.xl)
    }

    private func emptyView(title: String, message: String) -> some View {
        BSEmptyState(
            title: title,
            message: message,
            action: onRetry != nil ? ("Refresh", { onRetry?() }) : nil
        )
    }
}

// MARK: - Scrollable Page with Sticky Header

/// A page with a sticky header that remains visible during scroll
public struct BSStickyHeaderPage<Header: View, Content: View>: View {

    private let header: () -> Header
    private let content: () -> Content
    private let headerHeight: CGFloat
    private let collapseHeader: Bool

    @State private var scrollOffset: CGFloat = 0
    @Environment(\.theme) private var theme

    public init(
        headerHeight: CGFloat = 60,
        collapseHeader: Bool = false,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.headerHeight = headerHeight
        self.collapseHeader = collapseHeader
        self.header = header
        self.content = content
    }

    public var body: some View {
        ZStack(alignment: .top) {
            // Content
            ScrollView {
                VStack(spacing: 0) {
                    // Spacer for header
                    Color.clear
                        .frame(height: headerHeight)

                    content()
                }
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .preference(
                                key: ScrollOffsetKey.self,
                                value: proxy.frame(in: .named("scroll")).minY
                            )
                    }
                )
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetKey.self) { value in
                scrollOffset = value
            }

            // Sticky header
            header()
                .frame(height: headerHeight)
                .background(theme.background)
                .shadow(
                    color: scrollOffset < -10 ? theme.shadowSm.color : .clear,
                    radius: theme.shadowSm.radius,
                    y: theme.shadowSm.y
                )
        }
    }
}

private struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Tab Page Template

/// A page template with tab navigation
public struct BSTabPageTemplate<TabType: Hashable, Content: View>: View {

    @Binding private var selectedTab: TabType
    private let tabs: [BSTabBar<TabType>.TabBarItem<TabType>]
    private let tabBarStyle: BSTabBar<TabType>.TabBarStyle
    private let content: (TabType) -> Content

    @Environment(\.theme) private var theme

    public init(
        selectedTab: Binding<TabType>,
        tabs: [BSTabBar<TabType>.TabBarItem<TabType>],
        tabBarStyle: BSTabBar<TabType>.TabBarStyle = .standard,
        @ViewBuilder content: @escaping (TabType) -> Content
    ) {
        self._selectedTab = selectedTab
        self.tabs = tabs
        self.tabBarStyle = tabBarStyle
        self.content = content
    }

    public var body: some View {
        VStack(spacing: 0) {
            content(selectedTab)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            BSTabBar(selection: $selectedTab, items: tabs, style: tabBarStyle)
        }
        .background(theme.background)
    }
}

// MARK: - Split Page Template (iPad)

/// A split view template for larger screens
public struct BSSplitPageTemplate<Sidebar: View, Detail: View>: View {

    private let sidebar: () -> Sidebar
    private let detail: () -> Detail
    private let sidebarWidth: CGFloat

    @Environment(\.theme) private var theme
    @Environment(\.horizontalSizeClass) private var sizeClass

    public init(
        sidebarWidth: CGFloat = 320,
        @ViewBuilder sidebar: @escaping () -> Sidebar,
        @ViewBuilder detail: @escaping () -> Detail
    ) {
        self.sidebarWidth = sidebarWidth
        self.sidebar = sidebar
        self.detail = detail
    }

    public var body: some View {
        Group {
            if sizeClass == .regular {
                // iPad layout
                HStack(spacing: 0) {
                    sidebar()
                        .frame(width: sidebarWidth)
                        .background(theme.surface)

                    BSDivider(orientation: .vertical)

                    detail()
                        .frame(maxWidth: .infinity)
                }
            } else {
                // iPhone layout - just show detail
                detail()
            }
        }
        .background(theme.background)
    }
}

// MARK: - Preview

#if DEBUG
struct BSPageTemplate_Previews: PreviewProvider {
    static var previews: some View {
        BSPageTemplate(hasRefresh: true) {
            BSNavigationBar(
                title: "Home",
                displayMode: .large
            )
        } content: {
            VStack(spacing: 16) {
                ForEach(0..<10) { i in
                    BSCard {
                        BSText("Card \(i + 1)", style: .headline)
                    }
                }
            }
            .padding()
        }
        .withTheme()
    }
}
#endif
