// BSPullToRefresh.swift
// BootstrapUI
//
// Custom pull-to-refresh implementation
// Provides customizable refresh indicator and behavior

import SwiftUI

// MARK: - BSPullToRefresh

/// A custom pull-to-refresh modifier
public struct BSPullToRefresh: ViewModifier {

    private let onRefresh: (@escaping () -> Void) -> Void
    private let style: Style

    @State private var isRefreshing = false

    public enum Style {
        case standard
        case minimal
        case custom(AnyView)
    }

    public init(
        style: Style = .standard,
        onRefresh: @escaping (@escaping () -> Void) -> Void
    ) {
        self.style = style
        self.onRefresh = onRefresh
    }

    public func body(content: Content) -> some View {
        content
            .refreshable {
                await withCheckedContinuation { continuation in
                    onRefresh {
                        continuation.resume()
                    }
                }
            }
    }
}

extension View {
    /// Adds pull-to-refresh functionality
    public func bsPullToRefresh(
        style: BSPullToRefresh.Style = .standard,
        onRefresh: @escaping (@escaping () -> Void) -> Void
    ) -> some View {
        modifier(BSPullToRefresh(style: style, onRefresh: onRefresh))
    }
}

// MARK: - BSRefreshableScrollView

/// A scroll view with custom pull-to-refresh
public struct BSRefreshableScrollView<Content: View>: View {

    private let showsIndicators: Bool
    private let onRefresh: () async -> Void
    private let content: () -> Content

    @State private var refreshState: RefreshState = .idle
    @State private var scrollOffset: CGFloat = 0

    @Environment(\.theme) private var theme

    private enum RefreshState {
        case idle
        case pulling(CGFloat)
        case refreshing
        case finishing
    }

    private let threshold: CGFloat = 80

    public init(
        showsIndicators: Bool = true,
        onRefresh: @escaping () async -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.showsIndicators = showsIndicators
        self.onRefresh = onRefresh
        self.content = content
    }

    public var body: some View {
        ScrollView(showsIndicators: showsIndicators) {
            VStack(spacing: 0) {
                // Refresh indicator
                refreshIndicator
                    .frame(height: refreshIndicatorHeight)

                // Content
                content()
            }
            .background(
                GeometryReader { geometry in
                    Color.clear.preference(
                        key: ScrollOffsetPreferenceKey.self,
                        value: geometry.frame(in: .named("scroll")).minY
                    )
                }
            )
        }
        .coordinateSpace(name: "scroll")
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
            handleScrollChange(value)
        }
    }

    private var refreshIndicatorHeight: CGFloat {
        switch refreshState {
        case .idle:
            return 0
        case .pulling(let progress):
            return threshold * progress
        case .refreshing, .finishing:
            return threshold
        }
    }

    @ViewBuilder
    private var refreshIndicator: some View {
        VStack {
            switch refreshState {
            case .idle:
                EmptyView()
            case .pulling(let progress):
                pullIndicator(progress: progress)
            case .refreshing:
                loadingIndicator
            case .finishing:
                finishingIndicator
            }
        }
        .frame(maxWidth: .infinity)
    }

    private func pullIndicator(progress: CGFloat) -> some View {
        VStack(spacing: theme.xs) {
            Image(systemName: "arrow.down")
                .font(.system(size: 20))
                .foregroundColor(theme.primary)
                .rotationEffect(.degrees(progress >= 1 ? 180 : 0))
                .animation(.easeInOut(duration: 0.2), value: progress >= 1)

            Text(progress >= 1 ? "Release to refresh" : "Pull to refresh")
                .font(theme.caption1)
                .foregroundColor(theme.placeholder)
        }
        .opacity(progress)
    }

    private var loadingIndicator: some View {
        VStack(spacing: theme.xs) {
            ProgressView()
                .tint(theme.primary)

            Text("Refreshing...")
                .font(theme.caption1)
                .foregroundColor(theme.placeholder)
        }
    }

    private var finishingIndicator: some View {
        VStack(spacing: theme.xs) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(theme.success)

            Text("Done")
                .font(theme.caption1)
                .foregroundColor(theme.placeholder)
        }
    }

    private func handleScrollChange(_ offset: CGFloat) {
        guard case .idle = refreshState else { return }

        if offset > 0 {
            let progress = min(offset / threshold, 1)
            refreshState = .pulling(progress)

            if offset > threshold {
                triggerRefresh()
            }
        } else {
            refreshState = .idle
        }
    }

    private func triggerRefresh() {
        guard case .pulling = refreshState else { return }

        withAnimation(.spring(response: 0.3)) {
            refreshState = .refreshing
        }

        Task {
            await onRefresh()

            await MainActor.run {
                withAnimation(.spring(response: 0.3)) {
                    refreshState = .finishing
                }
            }

            try? await Task.sleep(nanoseconds: 500_000_000)

            await MainActor.run {
                withAnimation(.spring(response: 0.3)) {
                    refreshState = .idle
                }
            }
        }
    }
}

// MARK: - Scroll Offset Preference Key

private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - BSLoadMoreView

/// A view that triggers loading more content when visible
public struct BSLoadMoreView: View {

    private let isLoading: Bool
    private let hasMore: Bool
    private let onLoadMore: () -> Void

    @State private var hasTriggered = false

    @Environment(\.theme) private var theme

    public init(
        isLoading: Bool,
        hasMore: Bool = true,
        onLoadMore: @escaping () -> Void
    ) {
        self.isLoading = isLoading
        self.hasMore = hasMore
        self.onLoadMore = onLoadMore
    }

    public var body: some View {
        Group {
            if hasMore {
                if isLoading {
                    HStack(spacing: theme.sm) {
                        ProgressView()
                            .tint(theme.primary)
                        BSText("Loading more...", style: .caption1, color: .secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(theme.md)
                } else {
                    Color.clear
                        .frame(height: 1)
                        .onAppear {
                            if !hasTriggered {
                                hasTriggered = true
                                onLoadMore()
                            }
                        }
                        .onDisappear {
                            hasTriggered = false
                        }
                }
            } else {
                BSText("No more items", style: .caption1, color: .secondary)
                    .frame(maxWidth: .infinity)
                    .padding(theme.md)
            }
        }
    }
}

// MARK: - BSInfiniteScrollList

/// A list with infinite scrolling support
public struct BSInfiniteScrollList<Item: Identifiable, Content: View>: View {

    private let items: [Item]
    private let isLoading: Bool
    private let hasMore: Bool
    private let onLoadMore: () -> Void
    private let onRefresh: (() async -> Void)?
    private let content: (Item) -> Content

    @Environment(\.theme) private var theme

    public init(
        items: [Item],
        isLoading: Bool = false,
        hasMore: Bool = true,
        onLoadMore: @escaping () -> Void,
        onRefresh: (() async -> Void)? = nil,
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.items = items
        self.isLoading = isLoading
        self.hasMore = hasMore
        self.onLoadMore = onLoadMore
        self.onRefresh = onRefresh
        self.content = content
    }

    public var body: some View {
        List {
            ForEach(items) { item in
                content(item)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
            }

            BSLoadMoreView(
                isLoading: isLoading,
                hasMore: hasMore,
                onLoadMore: onLoadMore
            )
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .refreshable {
            if let onRefresh = onRefresh {
                await onRefresh()
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct BSPullToRefresh_Previews: PreviewProvider {
    static var previews: some View {
        BSRefreshableScrollView(
            onRefresh: {
                try? await Task.sleep(nanoseconds: 2_000_000_000)
            }
        ) {
            VStack(spacing: 16) {
                ForEach(0..<20) { i in
                    Text("Item \(i)")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .withTheme()
    }
}
#endif
