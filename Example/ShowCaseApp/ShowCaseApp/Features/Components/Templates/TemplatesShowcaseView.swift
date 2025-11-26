// TemplatesShowcaseView.swift
// ShowCaseApp
//
// Showcase for all Template components

import SwiftUI
import BootstrapUI

struct TemplatesShowcaseView: View {
    @Environment(\.theme) var theme

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: theme.lg) {
                    ComponentLinkCard(
                        title: "BSPageTemplate",
                        description: "Basic page layouts with headers and content",
                        icon: "doc"
                    ) {
                        PageTemplateShowcaseView()
                    }

                    ComponentLinkCard(
                        title: "BSListTemplate",
                        description: "List layouts with search and empty states",
                        icon: "list.bullet.rectangle"
                    ) {
                        ListTemplateShowcaseView()
                    }

                    ComponentLinkCard(
                        title: "BSDetailTemplate",
                        description: "Detail page layouts for content display",
                        icon: "doc.richtext"
                    ) {
                        DetailTemplateShowcaseView()
                    }
                }
                .padding(theme.md)
            }
            .background(theme.background)
            .navigationTitle("Templates")
        }
    }
}

// MARK: - Page Template Showcase

struct PageTemplateShowcaseView: View {
    @State private var selectedExample = 0
    @Environment(\.theme) var theme

    var body: some View {
        VStack(spacing: 0) {
            // Selector
            Picker("Example", selection: $selectedExample) {
                Text("Basic").tag(0)
                Text("Stateful").tag(1)
                Text("Sticky Header").tag(2)
            }
            .pickerStyle(.segmented)
            .padding(theme.md)

            // Content
            switch selectedExample {
            case 0:
                basicPageExample
            case 1:
                statefulPageExample
            case 2:
                stickyHeaderExample
            default:
                basicPageExample
            }
        }
        .navigationTitle("BSPageTemplate")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var basicPageExample: some View {
        BSPageTemplate(hasRefresh: true) {
            BSLargeTitleHeader(title: "Basic Page", subtitle: "Pull to refresh")
        } content: {
            VStack(spacing: theme.md) {
                ForEach(1...10, id: \.self) { index in
                    BSCard {
                        VStack(alignment: .leading, spacing: theme.xs) {
                            BSText("Card \(index)", style: .headline)
                            BSText("This is a sample card in the page template.", style: .body, color: .secondary)
                        }
                    }
                }
            }
            .padding(theme.md)
        } onRefresh: {
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            BSToastManager.shared.success("Refreshed!")
        }
    }

    @State private var loadingState: BSStatefulPageTemplate<AnyView>.LoadingState = .loaded

    private var statefulPageExample: some View {
        VStack {
            // State controls
            HStack(spacing: theme.sm) {
                BSButton("Loading", style: .outline, size: .small) {
                    loadingState = .loading
                }
                BSButton("Loaded", style: .outline, size: .small) {
                    loadingState = .loaded
                }
                BSButton("Error", style: .outline, size: .small) {
                    loadingState = .error("Failed to load data")
                }
                BSButton("Empty", style: .outline, size: .small) {
                    loadingState = .empty(title: "No Data", message: "There's nothing here yet")
                }
            }
            .padding(theme.md)

            BSStatefulPageTemplate(state: loadingState, onRetry: {
                loadingState = .loading
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    loadingState = .loaded
                }
            }) {
                AnyView(
                    VStack(spacing: theme.md) {
                        ForEach(1...5, id: \.self) { index in
                            BSCard {
                                BSText("Loaded Item \(index)", style: .headline)
                            }
                        }
                    }
                    .padding(theme.md)
                )
            }
        }
    }

    private var stickyHeaderExample: some View {
        BSStickyHeaderPage(headerHeight: 60) {
            BSPageHeader(
                title: "Sticky Header",
                trailingActions: [
                    .init(icon: "magnifyingglass", action: {}),
                    .init(icon: "ellipsis", action: {})
                ]
            )
            .frame(maxWidth: .infinity)
        } content: {
            VStack(spacing: theme.md) {
                ForEach(1...20, id: \.self) { index in
                    BSCard {
                        VStack(alignment: .leading, spacing: theme.xs) {
                            BSText("Item \(index)", style: .headline)
                            BSText("Scroll to see the sticky header effect", style: .body, color: .secondary)
                        }
                    }
                }
            }
            .padding(theme.md)
        }
    }
}

// MARK: - List Template Showcase

struct ListTemplateShowcaseView: View {
    @State private var selectedExample = 0
    @State private var searchText = ""

    @Environment(\.theme) var theme

    // Sample data
    struct SampleItem: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
        let icon: String
    }

    let sampleItems = [
        SampleItem(title: "Apple", subtitle: "A sweet red fruit", icon: "applelogo"),
        SampleItem(title: "Banana", subtitle: "A yellow tropical fruit", icon: "leaf"),
        SampleItem(title: "Cherry", subtitle: "A small red stone fruit", icon: "heart"),
        SampleItem(title: "Date", subtitle: "A sweet brown fruit", icon: "calendar"),
        SampleItem(title: "Elderberry", subtitle: "A dark purple berry", icon: "drop"),
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Selector
            Picker("Example", selection: $selectedExample) {
                Text("Basic").tag(0)
                Text("Search").tag(1)
                Text("Grid").tag(2)
                Text("Empty").tag(3)
            }
            .pickerStyle(.segmented)
            .padding(theme.md)

            // Content
            switch selectedExample {
            case 0:
                basicListExample
            case 1:
                searchListExample
            case 2:
                gridListExample
            case 3:
                emptyListExample
            default:
                basicListExample
            }
        }
        .navigationTitle("BSListTemplate")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var basicListExample: some View {
        BSListTemplate(
            items: sampleItems,
            hasRefresh: true,
            onRefresh: {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
            }
        ) { item in
            BSListItem(
                title: item.title,
                subtitle: item.subtitle,
                leadingIcon: item.icon,
                showsChevron: true
            ) {
                BSToastManager.shared.info("Selected: \(item.title)")
            }
        }
    }

    private var searchListExample: some View {
        BSSearchListTemplate(
            searchText: $searchText,
            items: sampleItems,
            placeholder: "Search fruits...",
            emptySearchMessage: "No fruits match your search"
        ) { item, query in
            item.title.localizedCaseInsensitiveContains(query) ||
            item.subtitle.localizedCaseInsensitiveContains(query)
        } itemContent: { item in
            BSListItem(
                title: item.title,
                subtitle: item.subtitle,
                leadingIcon: item.icon,
                showsChevron: true
            )
        }
    }

    private var gridListExample: some View {
        BSGridListTemplate(
            items: sampleItems,
            columns: 2,
            hasRefresh: true
        ) { item in
            BSCard {
                VStack(spacing: theme.sm) {
                    Image(systemName: item.icon)
                        .font(.system(size: 32))
                        .foregroundColor(theme.primary)

                    BSText(item.title, style: .headline)
                    BSText(item.subtitle, style: .caption1, color: .secondary, alignment: .center, lineLimit: 2)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, theme.sm)
            }
        } onRefresh: {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
        }
    }

    private var emptyListExample: some View {
        BSListTemplate(
            items: [SampleItem](),
            emptyState: .init(
                icon: "tray",
                title: "No Items",
                message: "You haven't added any items yet. Tap the button below to add your first item.",
                actionTitle: "Add Item",
                action: {
                    BSToastManager.shared.info("Add item tapped!")
                }
            )
        ) { item in
            BSListItem(title: item.title)
        }
    }
}

// MARK: - Detail Template Showcase

struct DetailTemplateShowcaseView: View {
    @State private var selectedExample = 0
    @Environment(\.theme) var theme
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {
            // Selector
            Picker("Example", selection: $selectedExample) {
                Text("Basic").tag(0)
                Text("Profile").tag(1)
                Text("Product").tag(2)
                Text("Article").tag(3)
            }
            .pickerStyle(.segmented)
            .padding(theme.md)

            // Content
            switch selectedExample {
            case 0:
                basicDetailExample
            case 1:
                profileDetailExample
            case 2:
                productDetailExample
            case 3:
                articleDetailExample
            default:
                basicDetailExample
            }
        }
        .navigationTitle("BSDetailTemplate")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var basicDetailExample: some View {
        BSDetailTemplate(
            navigationTitle: "Details",
            showsBackButton: false
        ) {
            // Header
            Rectangle()
                .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(height: 200)
                .overlay(
                    VStack {
                        Image(systemName: "star.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.white)
                        BSText("Featured Item", style: .title2, weight: .bold)
                            .foregroundColor(.white)
                    }
                )
        } content: {
            VStack(alignment: .leading, spacing: theme.lg) {
                VStack(alignment: .leading, spacing: theme.sm) {
                    BSText("About", style: .headline)
                    BSText("This is a basic detail template with a header image, content area, and footer actions. It's perfect for displaying detailed information about an item.", style: .body, color: .secondary)
                }

                BSFormSection(title: "Details") {
                    BSFormRow(label: "Category") { Text("Featured") }
                    BSFormRow(label: "Date") { Text("Nov 26, 2025") }
                    BSFormRow(label: "Status", showsDivider: false) {
                        BSStatusBadge(.active)
                    }
                }
            }
            .padding(.horizontal, theme.md)
        } footer: {
            HStack(spacing: theme.md) {
                BSButton("Share", style: .outline, icon: "square.and.arrow.up") {}
                BSButton("Save", style: .primary, icon: "bookmark", isFullWidth: true) {
                    BSToastManager.shared.success("Saved!")
                }
            }
            .padding(theme.md)
            .background(theme.surface)
        }
    }

    private var profileDetailExample: some View {
        BSProfileDetailTemplate(
            name: "Jane Smith",
            subtitle: "@janesmith · Product Designer",
            avatarInitials: "JS",
            stats: [
                .init(value: "2.4K", label: "Followers"),
                .init(value: "180", label: "Following"),
                .init(value: "89", label: "Projects")
            ]
        ) {
            VStack(spacing: theme.lg) {
                // Bio section
                VStack(alignment: .leading, spacing: theme.sm) {
                    BSText("About", style: .headline)
                    BSText("Product designer passionate about creating beautiful and functional user experiences. Currently working on design systems and component libraries.", style: .body, color: .secondary)
                }

                // Recent work
                VStack(alignment: .leading, spacing: theme.sm) {
                    BSSectionHeader("Recent Work", action: ("View All", {}))

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: theme.md) {
                            ForEach(1...4, id: \.self) { index in
                                BSCard(variant: .outlined, padding: theme.sm) {
                                    VStack {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(width: 120, height: 80)
                                            .cornerRadius(theme.radiusSm)
                                        BSText("Project \(index)", style: .caption1)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } actions: {
            HStack(spacing: theme.md) {
                BSButton("Message", style: .outline, icon: "message", isFullWidth: true) {}
                BSButton("Follow", style: .primary, icon: "plus", isFullWidth: true) {
                    BSToastManager.shared.success("Following Jane!")
                }
            }
        }
    }

    private var productDetailExample: some View {
        BSProductDetailTemplate(
            title: "Premium Headphones",
            subtitle: "Wireless • Noise Cancelling",
            price: "$299.99"
        ) {
            // Gallery placeholder
            TabView {
                ForEach(1...3, id: \.self) { index in
                    Rectangle()
                        .fill(LinearGradient(colors: [.gray.opacity(0.3), .gray.opacity(0.1)], startPoint: .top, endPoint: .bottom))
                        .overlay(
                            Image(systemName: "headphones")
                                .font(.system(size: 80))
                                .foregroundColor(.gray)
                        )
                }
            }
            .tabViewStyle(.page)
            .frame(height: 300)
        } info: {
            VStack(alignment: .leading, spacing: theme.lg) {
                // Features
                VStack(alignment: .leading, spacing: theme.sm) {
                    BSText("Features", style: .headline)

                    VStack(alignment: .leading, spacing: theme.xs) {
                        FeatureRow(icon: "waveform", text: "Active Noise Cancellation")
                        FeatureRow(icon: "battery.100", text: "30 hours battery life")
                        FeatureRow(icon: "wifi", text: "Bluetooth 5.2")
                        FeatureRow(icon: "mic", text: "Built-in microphone")
                    }
                }

                // Color selection
                VStack(alignment: .leading, spacing: theme.sm) {
                    BSText("Color", style: .headline)
                    HStack(spacing: theme.md) {
                        ColorOption(color: .black, isSelected: true)
                        ColorOption(color: .white, isSelected: false)
                        ColorOption(color: .blue, isSelected: false)
                    }
                }
            }
        } actions: {
            HStack(spacing: theme.md) {
                BSIconButton(icon: "heart", style: .outline, size: .large) {}
                BSButton("Add to Cart", style: .primary, icon: "cart", isFullWidth: true) {
                    BSToastManager.shared.success("Added to cart!")
                }
            }
        }
    }

    private var articleDetailExample: some View {
        BSArticleDetailTemplate(
            title: "Building Design Systems with SwiftUI",
            author: "John Developer",
            date: Date(),
            readTime: "5 min read"
        ) {
            // Header image
            Rectangle()
                .fill(LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(height: 220)
                .overlay(
                    Image(systemName: "swift")
                        .font(.system(size: 60))
                        .foregroundColor(.white.opacity(0.8))
                )
        } content: {
            VStack(alignment: .leading, spacing: theme.lg) {
                BSText("Design systems are crucial for maintaining consistency across large applications. In this article, we'll explore how to build a comprehensive design system using SwiftUI.", style: .body)

                BSText("Why Design Systems Matter", style: .headline)

                BSText("A well-designed system helps teams work more efficiently by providing reusable components and consistent patterns. This reduces development time and ensures a cohesive user experience.", style: .body, color: .secondary)

                BSText("Key Components", style: .headline)

                VStack(alignment: .leading, spacing: theme.xs) {
                    BSLabel("Typography system", icon: "textformat")
                    BSLabel("Color tokens", icon: "paintpalette")
                    BSLabel("Spacing scale", icon: "ruler")
                    BSLabel("Component library", icon: "square.stack.3d.up")
                }

                BSText("Getting started with BootstrapUI is easy. Simply add the package to your project and start using components right away.", style: .body, color: .secondary)
            }
        }
    }
}

// MARK: - Supporting Views

struct FeatureRow: View {
    let icon: String
    let text: String

    @Environment(\.theme) var theme

    var body: some View {
        HStack(spacing: theme.sm) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(theme.primary)
                .frame(width: 24)

            BSText(text, style: .body)
        }
    }
}

struct ColorOption: View {
    let color: Color
    let isSelected: Bool

    @Environment(\.theme) var theme

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 32, height: 32)
            .overlay(
                Circle()
                    .stroke(isSelected ? theme.primary : theme.border, lineWidth: isSelected ? 3 : 1)
            )
            .overlay(
                isSelected ? Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(color == .white ? .black : .white) : nil
            )
    }
}

#Preview {
    TemplatesShowcaseView()
        .withTheme()
        .withToasts()
}
