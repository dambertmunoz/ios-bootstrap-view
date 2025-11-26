// BSListTemplate.swift
// BootstrapUI
//
// List layout templates for displaying collections
// Follows Template Method Pattern - provides reusable list structures

import SwiftUI

// MARK: - Basic List Template

/// A template for displaying lists with sections
public struct BSListTemplate<Item: Identifiable, ItemContent: View>: View {

    private let items: [Item]
    private let header: AnyView?
    private let emptyState: EmptyStateConfig?
    private let hasRefresh: Bool
    private let onRefresh: (() async -> Void)?
    private let onDelete: ((IndexSet) -> Void)?
    private let itemContent: (Item) -> ItemContent

    @Environment(\.theme) private var theme

    public struct EmptyStateConfig {
        public let icon: String
        public let title: String
        public let message: String
        public let actionTitle: String?
        public let action: (() -> Void)?

        public init(
            icon: String = "tray",
            title: String,
            message: String,
            actionTitle: String? = nil,
            action: (() -> Void)? = nil
        ) {
            self.icon = icon
            self.title = title
            self.message = message
            self.actionTitle = actionTitle
            self.action = action
        }
    }

    public init(
        items: [Item],
        emptyState: EmptyStateConfig? = nil,
        hasRefresh: Bool = false,
        onRefresh: (() async -> Void)? = nil,
        onDelete: ((IndexSet) -> Void)? = nil,
        @ViewBuilder itemContent: @escaping (Item) -> ItemContent
    ) {
        self.items = items
        self.header = nil
        self.emptyState = emptyState
        self.hasRefresh = hasRefresh
        self.onRefresh = onRefresh
        self.onDelete = onDelete
        self.itemContent = itemContent
    }

    public init<Header: View>(
        items: [Item],
        emptyState: EmptyStateConfig? = nil,
        hasRefresh: Bool = false,
        onRefresh: (() async -> Void)? = nil,
        onDelete: ((IndexSet) -> Void)? = nil,
        @ViewBuilder header: () -> Header,
        @ViewBuilder itemContent: @escaping (Item) -> ItemContent
    ) {
        self.items = items
        self.header = AnyView(header())
        self.emptyState = emptyState
        self.hasRefresh = hasRefresh
        self.onRefresh = onRefresh
        self.onDelete = onDelete
        self.itemContent = itemContent
    }

    public var body: some View {
        Group {
            if items.isEmpty, let empty = emptyState {
                emptyStateView(empty)
            } else {
                listContent
            }
        }
    }

    private var listContent: some View {
        List {
            if let header = header {
                Section {
                    header
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                }
            }

            ForEach(items) { item in
                itemContent(item)
                    .listRowBackground(theme.background)
            }
            .onDelete { indexSet in
                onDelete?(indexSet)
            }
        }
        .listStyle(.plain)
        .refreshable {
            if hasRefresh {
                await onRefresh?()
            }
        }
    }

    private func emptyStateView(_ config: EmptyStateConfig) -> some View {
        BSEmptyState(
            icon: config.icon,
            title: config.title,
            message: config.message,
            action: config.actionTitle != nil ? (config.actionTitle!, { config.action?() }) : nil
        )
    }
}

// MARK: - Grouped List Template

/// A template for displaying grouped lists with sections
public struct BSGroupedListTemplate<Section: Identifiable, Item: Identifiable, SectionHeader: View, ItemContent: View>: View {

    private let sections: [Section]
    private let itemsInSection: (Section) -> [Item]
    private let sectionHeader: (Section) -> SectionHeader
    private let itemContent: (Item) -> ItemContent
    private let hasRefresh: Bool
    private let onRefresh: (() async -> Void)?

    @Environment(\.theme) private var theme

    public init(
        sections: [Section],
        itemsInSection: @escaping (Section) -> [Item],
        hasRefresh: Bool = false,
        onRefresh: (() async -> Void)? = nil,
        @ViewBuilder sectionHeader: @escaping (Section) -> SectionHeader,
        @ViewBuilder itemContent: @escaping (Item) -> ItemContent
    ) {
        self.sections = sections
        self.itemsInSection = itemsInSection
        self.sectionHeader = sectionHeader
        self.itemContent = itemContent
        self.hasRefresh = hasRefresh
        self.onRefresh = onRefresh
    }

    public var body: some View {
        List {
            ForEach(sections) { section in
                SwiftUI.Section {
                    ForEach(itemsInSection(section)) { item in
                        itemContent(item)
                    }
                } header: {
                    sectionHeader(section)
                }
            }
        }
        .listStyle(.insetGrouped)
        .refreshable {
            if hasRefresh {
                await onRefresh?()
            }
        }
    }
}

// MARK: - Grid List Template

/// A template for displaying items in a grid layout
public struct BSGridListTemplate<Item: Identifiable, ItemContent: View>: View {

    private let items: [Item]
    private let columns: Int
    private let spacing: CGFloat?
    private let hasRefresh: Bool
    private let onRefresh: (() async -> Void)?
    private let itemContent: (Item) -> ItemContent

    @Environment(\.theme) private var theme

    public init(
        items: [Item],
        columns: Int = 2,
        spacing: CGFloat? = nil,
        hasRefresh: Bool = false,
        onRefresh: (() async -> Void)? = nil,
        @ViewBuilder itemContent: @escaping (Item) -> ItemContent
    ) {
        self.items = items
        self.columns = columns
        self.spacing = spacing
        self.hasRefresh = hasRefresh
        self.onRefresh = onRefresh
        self.itemContent = itemContent
    }

    public var body: some View {
        ScrollView {
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: spacing ?? theme.md), count: columns),
                spacing: spacing ?? theme.md
            ) {
                ForEach(items) { item in
                    itemContent(item)
                }
            }
            .padding(spacing ?? theme.md)
        }
        .refreshable {
            if hasRefresh {
                await onRefresh?()
            }
        }
    }
}

// MARK: - Search List Template

/// A list template with integrated search functionality
public struct BSSearchListTemplate<Item: Identifiable, ItemContent: View>: View {

    @Binding private var searchText: String
    private let items: [Item]
    private let filterPredicate: (Item, String) -> Bool
    private let placeholder: String
    private let emptySearchMessage: String
    private let itemContent: (Item) -> ItemContent

    @Environment(\.theme) private var theme

    public init(
        searchText: Binding<String>,
        items: [Item],
        placeholder: String = "Search...",
        emptySearchMessage: String = "No results found",
        filterPredicate: @escaping (Item, String) -> Bool,
        @ViewBuilder itemContent: @escaping (Item) -> ItemContent
    ) {
        self._searchText = searchText
        self.items = items
        self.placeholder = placeholder
        self.emptySearchMessage = emptySearchMessage
        self.filterPredicate = filterPredicate
        self.itemContent = itemContent
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Search bar
            BSSearchBar(text: $searchText, placeholder: placeholder)
                .padding(.horizontal, theme.md)
                .padding(.vertical, theme.sm)

            // Results
            if filteredItems.isEmpty && !searchText.isEmpty {
                BSEmptyState(
                    icon: "magnifyingglass",
                    title: "No Results",
                    message: emptySearchMessage
                )
            } else {
                List {
                    ForEach(filteredItems) { item in
                        itemContent(item)
                            .listRowBackground(theme.background)
                    }
                }
                .listStyle(.plain)
            }
        }
    }

    private var filteredItems: [Item] {
        if searchText.isEmpty {
            return items
        }
        return items.filter { filterPredicate($0, searchText) }
    }
}

// MARK: - Paginated List Template

/// A list template with pagination support
public struct BSPaginatedListTemplate<Item: Identifiable, ItemContent: View>: View {

    private let items: [Item]
    private let isLoading: Bool
    private let hasMoreItems: Bool
    private let onLoadMore: () -> Void
    private let itemContent: (Item) -> ItemContent

    @Environment(\.theme) private var theme

    public init(
        items: [Item],
        isLoading: Bool = false,
        hasMoreItems: Bool = true,
        onLoadMore: @escaping () -> Void,
        @ViewBuilder itemContent: @escaping (Item) -> ItemContent
    ) {
        self.items = items
        self.isLoading = isLoading
        self.hasMoreItems = hasMoreItems
        self.onLoadMore = onLoadMore
        self.itemContent = itemContent
    }

    public var body: some View {
        List {
            ForEach(items) { item in
                itemContent(item)
                    .listRowBackground(theme.background)
                    .onAppear {
                        if item.id == items.last?.id as? Item.ID && hasMoreItems && !isLoading {
                            onLoadMore()
                        }
                    }
            }

            if isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                        .padding()
                    Spacer()
                }
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
    }
}

// MARK: - Preview

#if DEBUG
struct BSListTemplate_Previews: PreviewProvider {
    struct SampleItem: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
    }

    static let sampleItems = (1...10).map {
        SampleItem(title: "Item \($0)", subtitle: "Description for item \($0)")
    }

    static var previews: some View {
        BSListTemplate(
            items: sampleItems,
            emptyState: .init(
                title: "No Items",
                message: "Add your first item to get started"
            )
        ) { item in
            BSListItem(
                title: item.title,
                subtitle: item.subtitle,
                showsChevron: true
            )
        }
        .withTheme()
    }
}
#endif
