# Generate BootstrapUI List

Generate a SwiftUI list view using BootstrapUI components for: $ARGUMENTS

## Instructions

Create a complete list view with search, filtering, and infinite scroll:

```swift
import SwiftUI
import BootstrapUI

struct [ListName]View: View {
    @State private var items: [Item] = []
    @State private var searchText = ""
    @State private var isLoading = false
    @State private var hasMore = true

    @Environment(\.theme) private var theme

    var body: some View {
        BSListTemplate(
            items: filteredItems,
            emptyState: .noResults(searchTerm: searchText),
            isLoading: isLoading
        ) { item in
            BSListItem(
                title: item.title,
                subtitle: item.subtitle,
                leadingIcon: "star.fill",
                showsChevron: true
            ) {
                // Navigate to detail
            }
        }
        .searchable(text: $searchText)
        .refreshable {
            await refresh()
        }
    }

    private var filteredItems: [Item] {
        guard !searchText.isEmpty else { return items }
        return items.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
}
```

## Available List Components

### BSListTemplate
```swift
BSListTemplate(
    items: items,
    emptyState: .noData(title: "No Items"),
    isLoading: isLoading,
    onRefresh: { await refresh() }
) { item in
    // Row content
}
```

### BSListItem Variants
```swift
// Basic
BSListItem(title: "Item Title")

// With subtitle
BSListItem(title: "Title", subtitle: "Subtitle description")

// With icon
BSListItem(title: "Settings", leadingIcon: "gear")

// With chevron (navigable)
BSListItem(title: "Profile", showsChevron: true) { navigate() }

// With trailing content
BSListItem(title: "Notifications") {
    BSToggle(isOn: $enabled)
}

// With avatar
BSListItem(
    title: "John Doe",
    subtitle: "john@example.com",
    leadingView: {
        BSAvatar(name: "John Doe", size: .md)
    }
)
```

### BSInfiniteScrollList
```swift
BSInfiniteScrollList(
    items: items,
    isLoading: isLoading,
    hasMore: hasMore,
    onLoadMore: loadMore,
    onRefresh: refresh
) { item in
    BSListItem(title: item.title)
}
```

### BSSearchBar
```swift
BSSearchBar(
    text: $searchText,
    placeholder: "Search items...",
    showsCancelButton: true
)
```

## Empty State Options

```swift
BSEmptyState.noResults(searchTerm: searchText)
BSEmptyState.noData(title: "No Items", description: "Add your first item")
BSEmptyState.noConnection(onRetry: { refresh() })
BSEmptyState.error(onRetry: { refresh() })
```

## Swipe Actions

```swift
BSListItem(title: item.title)
    .swipeActions(edge: .trailing) {
        Button(role: .destructive) { delete(item) } label: {
            Label("Delete", systemImage: "trash")
        }
        Button { edit(item) } label: {
            Label("Edit", systemImage: "pencil")
        }
    }
```

## Skeleton Loading

```swift
if isLoading {
    ForEach(0..<5, id: \.self) { _ in
        BSSkeletonListItem()
    }
} else {
    ForEach(items) { item in
        BSListItem(title: item.title)
    }
}
```

Generate the list view based on the user's requirements using these patterns.
