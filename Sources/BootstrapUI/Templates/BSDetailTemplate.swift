// BSDetailTemplate.swift
// BootstrapUI
//
// Detail view templates for displaying item details
// Follows Template Method Pattern - provides reusable detail structures

import SwiftUI

// MARK: - Basic Detail Template

/// A template for displaying item details with header and content sections
public struct BSDetailTemplate<Header: View, Content: View, Footer: View>: View {

    private let header: () -> Header
    private let content: () -> Content
    private let footer: () -> Footer
    private let navigationTitle: String?
    private let showsBackButton: Bool
    private let onBack: (() -> Void)?

    @Environment(\.theme) private var theme

    public init(
        navigationTitle: String? = nil,
        showsBackButton: Bool = true,
        onBack: (() -> Void)? = nil,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        self.navigationTitle = navigationTitle
        self.showsBackButton = showsBackButton
        self.onBack = onBack
        self.header = header
        self.content = content
        self.footer = footer
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Navigation
            if navigationTitle != nil || showsBackButton {
                BSNavigationBar(
                    title: navigationTitle ?? "",
                    displayMode: .inline,
                    leadingItems: showsBackButton ? [
                        .init(icon: "chevron.left", action: { onBack?() })
                    ] : []
                )
            }

            // Scrollable content
            ScrollView {
                VStack(spacing: theme.lg) {
                    header()
                    content()
                }
                .padding(.bottom, theme.xl)
            }

            // Footer
            footer()
        }
        .background(theme.background)
    }
}

// MARK: - Without Footer

extension BSDetailTemplate where Footer == EmptyView {
    public init(
        navigationTitle: String? = nil,
        showsBackButton: Bool = true,
        onBack: (() -> Void)? = nil,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.navigationTitle = navigationTitle
        self.showsBackButton = showsBackButton
        self.onBack = onBack
        self.header = header
        self.content = content
        self.footer = { EmptyView() }
    }
}

// MARK: - Profile Detail Template

/// A specialized template for profile/user detail pages
public struct BSProfileDetailTemplate<Content: View, Actions: View>: View {

    private let name: String
    private let subtitle: String?
    private let avatarURL: URL?
    private let avatarInitials: String?
    private let coverImageURL: URL?
    private let stats: [BSProfileHeader.ProfileStat]
    private let content: () -> Content
    private let actions: () -> Actions

    @Environment(\.theme) private var theme

    public init(
        name: String,
        subtitle: String? = nil,
        avatarURL: URL? = nil,
        avatarInitials: String? = nil,
        coverImageURL: URL? = nil,
        stats: [BSProfileHeader.ProfileStat] = [],
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder actions: @escaping () -> Actions
    ) {
        self.name = name
        self.subtitle = subtitle
        self.avatarURL = avatarURL
        self.avatarInitials = avatarInitials
        self.coverImageURL = coverImageURL
        self.stats = stats
        self.content = content
        self.actions = actions
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Cover image
                if let coverURL = coverImageURL {
                    AsyncImage(url: coverURL) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        default:
                            Rectangle()
                                .fill(theme.surface)
                        }
                    }
                    .frame(height: 200)
                    .clipped()
                }

                // Profile header
                VStack(spacing: theme.md) {
                    // Avatar
                    Group {
                        if let url = avatarURL {
                            BSAvatar(imageURL: url, size: .xxl, hasBorder: true, borderColor: theme.background)
                        } else if let initials = avatarInitials {
                            BSAvatar(initials: initials, size: .xxl, hasBorder: true, borderColor: theme.background)
                        } else {
                            BSAvatar(icon: "person.fill", size: .xxl, hasBorder: true, borderColor: theme.background)
                        }
                    }
                    .offset(y: coverImageURL != nil ? -60 : 0)
                    .padding(.bottom, coverImageURL != nil ? -60 : 0)

                    // Name and subtitle
                    VStack(spacing: theme.xxs) {
                        Text(name)
                            .font(theme.title2)
                            .fontWeight(.bold)
                            .foregroundColor(theme.onSurface)

                        if let subtitle = subtitle {
                            Text(subtitle)
                                .font(theme.subheadline)
                                .foregroundColor(theme.placeholder)
                        }
                    }

                    // Stats
                    if !stats.isEmpty {
                        HStack(spacing: theme.xl) {
                            ForEach(stats) { stat in
                                VStack(spacing: theme.xxs) {
                                    Text(stat.value)
                                        .font(theme.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(theme.onSurface)

                                    Text(stat.label)
                                        .font(theme.caption1)
                                        .foregroundColor(theme.placeholder)
                                }
                            }
                        }
                        .padding(.top, theme.sm)
                    }

                    // Action buttons
                    actions()
                        .padding(.top, theme.sm)
                }
                .padding(theme.md)

                BSDivider()

                // Content
                content()
                    .padding(theme.md)
            }
        }
        .background(theme.background)
    }
}

// MARK: - Product Detail Template

/// A template for product/item detail pages
public struct BSProductDetailTemplate<Gallery: View, Info: View, Actions: View>: View {

    private let title: String
    private let subtitle: String?
    private let price: String?
    private let gallery: () -> Gallery
    private let info: () -> Info
    private let actions: () -> Actions

    @Environment(\.theme) private var theme

    public init(
        title: String,
        subtitle: String? = nil,
        price: String? = nil,
        @ViewBuilder gallery: @escaping () -> Gallery,
        @ViewBuilder info: @escaping () -> Info,
        @ViewBuilder actions: @escaping () -> Actions
    ) {
        self.title = title
        self.subtitle = subtitle
        self.price = price
        self.gallery = gallery
        self.info = info
        self.actions = actions
    }

    public var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: theme.lg) {
                    // Image gallery
                    gallery()

                    // Product info
                    VStack(alignment: .leading, spacing: theme.md) {
                        // Title and price
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: theme.xxs) {
                                Text(title)
                                    .font(theme.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(theme.onSurface)

                                if let subtitle = subtitle {
                                    Text(subtitle)
                                        .font(theme.subheadline)
                                        .foregroundColor(theme.placeholder)
                                }
                            }

                            Spacer()

                            if let price = price {
                                Text(price)
                                    .font(theme.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(theme.primary)
                            }
                        }

                        BSDivider()

                        // Additional info
                        info()
                    }
                    .padding(.horizontal, theme.md)
                }
            }

            // Bottom actions
            VStack(spacing: 0) {
                BSDivider()
                actions()
                    .padding(theme.md)
            }
            .background(theme.surface)
        }
        .background(theme.background)
    }
}

// MARK: - Article Detail Template

/// A template for article/content detail pages
public struct BSArticleDetailTemplate<Header: View, Content: View>: View {

    private let title: String
    private let author: String?
    private let date: Date?
    private let readTime: String?
    private let header: () -> Header
    private let content: () -> Content

    @Environment(\.theme) private var theme

    public init(
        title: String,
        author: String? = nil,
        date: Date? = nil,
        readTime: String? = nil,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.author = author
        self.date = date
        self.readTime = readTime
        self.header = header
        self.content = content
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: theme.lg) {
                // Header image
                header()

                VStack(alignment: .leading, spacing: theme.md) {
                    // Title
                    Text(title)
                        .font(theme.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(theme.onSurface)

                    // Meta info
                    HStack(spacing: theme.md) {
                        if let author = author {
                            HStack(spacing: theme.xs) {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 12))
                                Text(author)
                            }
                            .font(theme.caption1)
                            .foregroundColor(theme.placeholder)
                        }

                        if let date = date {
                            HStack(spacing: theme.xs) {
                                Image(systemName: "calendar")
                                    .font(.system(size: 12))
                                Text(date, style: .date)
                            }
                            .font(theme.caption1)
                            .foregroundColor(theme.placeholder)
                        }

                        if let readTime = readTime {
                            HStack(spacing: theme.xs) {
                                Image(systemName: "clock")
                                    .font(.system(size: 12))
                                Text(readTime)
                            }
                            .font(theme.caption1)
                            .foregroundColor(theme.placeholder)
                        }
                    }

                    BSDivider()

                    // Content
                    content()
                }
                .padding(.horizontal, theme.md)
            }
            .padding(.bottom, theme.xl)
        }
        .background(theme.background)
    }
}

// MARK: - Preview

#if DEBUG
struct BSDetailTemplate_Previews: PreviewProvider {
    static var previews: some View {
        BSDetailTemplate(
            navigationTitle: "Details",
            onBack: {}
        ) {
            // Header
            BSImageCard(imageURL: nil, imageHeight: 200) {
                EmptyView()
            }
        } content: {
            // Content
            VStack(alignment: .leading, spacing: 16) {
                BSText("Product Title", style: .title2, weight: .bold)
                BSText("This is a description of the product with more details about its features and benefits.", style: .body, color: .secondary)

                BSFormSection(title: "Specifications") {
                    BSFormRow(label: "Size") {
                        Text("Medium")
                    }
                    BSFormRow(label: "Color") {
                        Text("Blue")
                    }
                    BSFormRow(label: "Material", showsDivider: false) {
                        Text("Cotton")
                    }
                }
            }
            .padding(.horizontal)
        } footer: {
            // Footer
            BSButton("Add to Cart", style: .primary, isFullWidth: true) {}
                .padding()
        }
        .withTheme()
    }
}
#endif
