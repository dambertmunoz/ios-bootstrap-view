// ExtrasShowcaseView.swift
// ShowCaseApp
//
// Showcase for all new/extra components

import SwiftUI
import BootstrapUI

struct ExtrasShowcaseView: View {
    @Environment(\.theme) var theme

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: theme.lg) {
                    // New Atoms
                    BSSectionHeader("New Components")

                    ComponentLinkCard(
                        title: "BSSkeleton",
                        description: "Loading placeholders with shimmer animation",
                        icon: "rectangle.dashed"
                    ) {
                        SkeletonShowcaseView()
                    }

                    ComponentLinkCard(
                        title: "BSChip",
                        description: "Tags, filters, and selectable chips",
                        icon: "tag.fill"
                    ) {
                        ChipShowcaseView()
                    }

                    ComponentLinkCard(
                        title: "BSRating",
                        description: "Star ratings and review components",
                        icon: "star.fill"
                    ) {
                        RatingShowcaseView()
                    }

                    ComponentLinkCard(
                        title: "BSStepIndicator",
                        description: "Progress steps and wizards",
                        icon: "list.number"
                    ) {
                        StepIndicatorShowcaseView()
                    }

                    ComponentLinkCard(
                        title: "BSFAB",
                        description: "Floating Action Buttons",
                        icon: "plus.circle.fill"
                    ) {
                        FABShowcaseView()
                    }

                    ComponentLinkCard(
                        title: "BSChart",
                        description: "Bar, Line, and Pie charts",
                        icon: "chart.bar.fill"
                    ) {
                        ChartShowcaseView()
                    }

                    // Domain-specific components
                    BSSectionHeader("Domain Components")

                    ComponentLinkCard(
                        title: "E-commerce",
                        description: "Product cards, cart, and checkout",
                        icon: "cart.fill"
                    ) {
                        EcommerceShowcaseView()
                    }

                    ComponentLinkCard(
                        title: "Social",
                        description: "Posts, comments, stories, and reactions",
                        icon: "person.2.fill"
                    ) {
                        SocialShowcaseView()
                    }

                    ComponentLinkCard(
                        title: "Chat",
                        description: "Messages, bubbles, and conversations",
                        icon: "bubble.left.and.bubble.right.fill"
                    ) {
                        ChatShowcaseView()
                    }

                    // Customization
                    BSSectionHeader("Customization")

                    ComponentLinkCard(
                        title: "Themes",
                        description: "16+ predefined themes and theme picker",
                        icon: "paintpalette.fill"
                    ) {
                        ThemeShowcaseView()
                    }

                    ComponentLinkCard(
                        title: "Onboarding",
                        description: "Welcome screens and walkthroughs",
                        icon: "hand.wave.fill"
                    ) {
                        OnboardingShowcaseView()
                    }

                    ComponentLinkCard(
                        title: "Swipe Cards",
                        description: "Tinder-style swipeable cards",
                        icon: "rectangle.stack.fill"
                    ) {
                        SwipeCardShowcaseView()
                    }
                }
                .padding(theme.md)
            }
            .background(theme.background)
            .navigationTitle("Extras")
        }
    }
}

// MARK: - Skeleton Showcase

struct SkeletonShowcaseView: View {
    @State private var isLoading = true
    @Environment(\.theme) var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.xl) {
                ShowcaseSection(title: "Toggle Loading") {
                    BSButton(isLoading ? "Show Content" : "Show Skeleton", style: .outline) {
                        isLoading.toggle()
                    }
                }

                ShowcaseSection(title: "Text Skeleton") {
                    VStack(alignment: .leading, spacing: theme.sm) {
                        if isLoading {
                            BSSkeletonText(lines: 3)
                        } else {
                            BSText("This is the actual content that appears after loading. It can be multiple lines of text that describe something important.", style: .body)
                        }
                    }
                }

                ShowcaseSection(title: "Avatar Skeleton") {
                    HStack(spacing: theme.md) {
                        if isLoading {
                            BSSkeletonAvatar(size: .sm)
                            BSSkeletonAvatar(size: .md)
                            BSSkeletonAvatar(size: .lg)
                        } else {
                            BSAvatar(initials: "A", size: .sm)
                            BSAvatar(initials: "B", size: .md)
                            BSAvatar(initials: "C", size: .lg)
                        }
                    }
                }

                ShowcaseSection(title: "Card Skeleton") {
                    if isLoading {
                        BSSkeletonCard()
                    } else {
                        BSCard {
                            HStack(spacing: theme.md) {
                                BSAvatar(initials: "JD", size: .md)
                                VStack(alignment: .leading) {
                                    BSText("John Doe", style: .headline)
                                    BSText("Software Engineer", style: .caption1, color: .secondary)
                                }
                                Spacer()
                            }
                        }
                    }
                }

                ShowcaseSection(title: "List Item Skeleton") {
                    VStack(spacing: theme.sm) {
                        if isLoading {
                            ForEach(0..<3) { _ in
                                BSSkeletonListItem()
                            }
                        } else {
                            ForEach(1...3, id: \.self) { i in
                                BSListItem(
                                    title: "Item \(i)",
                                    subtitle: "Description for item \(i)",
                                    showsDivider: i < 3
                                )
                            }
                        }
                    }
                }

                ShowcaseSection(title: "Profile Skeleton") {
                    if isLoading {
                        BSSkeletonProfile()
                    } else {
                        VStack(spacing: theme.md) {
                            BSAvatar(initials: "JD", size: .xl)
                            BSText("John Doe", style: .title2)
                            BSText("iOS Developer at Apple", style: .body, color: .secondary)
                        }
                    }
                }
            }
            .padding(theme.md)
        }
        .background(theme.background)
        .navigationTitle("BSSkeleton")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Chip Showcase

struct ChipShowcaseView: View {
    @State private var selectedChip: String? = "Swift"
    @State private var selectedChips: Set<String> = ["iOS", "SwiftUI"]
    @State private var inputChips: [String] = ["Tag 1", "Tag 2"]
    @State private var newTag = ""

    @Environment(\.theme) var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.xl) {
                ShowcaseSection(title: "Basic Chips") {
                    HStack(spacing: theme.sm) {
                        BSChip("Swift", variant: .filled)
                        BSChip("iOS", variant: .outlined)
                        BSChip("Xcode", variant: .subtle)
                    }
                }

                ShowcaseSection(title: "Chip Colors") {
                    VStack(spacing: theme.sm) {
                        HStack(spacing: theme.sm) {
                            BSChip("Primary", color: .primary)
                            BSChip("Success", color: .success)
                            BSChip("Warning", color: .warning)
                        }
                        HStack(spacing: theme.sm) {
                            BSChip("Error", color: .error)
                            BSChip("Info", color: .info)
                            BSChip("Neutral", color: .neutral)
                        }
                    }
                }

                ShowcaseSection(title: "Chips with Icons") {
                    HStack(spacing: theme.sm) {
                        BSChip("Star", icon: "star.fill")
                        BSChip("Heart", icon: "heart.fill", color: .error)
                        BSChip("Location", icon: "location.fill", color: .info)
                    }
                }

                ShowcaseSection(title: "Deletable Chips") {
                    HStack(spacing: theme.sm) {
                        BSChip("Remove me", isDeletable: true) {
                            // Handle delete
                        }
                        BSChip("Delete", icon: "trash", isDeletable: true, color: .error) {
                            // Handle delete
                        }
                    }
                }

                ShowcaseSection(title: "Single Selection Group") {
                    BSChipGroup(
                        options: ["Swift", "Kotlin", "Flutter", "React Native"],
                        selected: $selectedChip
                    )

                    if let selected = selectedChip {
                        BSText("Selected: \(selected)", style: .caption1, color: .secondary)
                    }
                }

                ShowcaseSection(title: "Multi Selection Group") {
                    BSMultiChipGroup(
                        options: ["iOS", "Android", "SwiftUI", "Compose", "Flutter"],
                        selected: $selectedChips
                    )

                    BSText("Selected: \(selectedChips.sorted().joined(separator: ", "))", style: .caption1, color: .secondary)
                }

                ShowcaseSection(title: "Input Chips") {
                    VStack(spacing: theme.sm) {
                        BSInputChip(chips: $inputChips, placeholder: "Add tag...")
                        BSText("Tags: \(inputChips.joined(separator: ", "))", style: .caption1, color: .secondary)
                    }
                }
            }
            .padding(theme.md)
        }
        .background(theme.background)
        .navigationTitle("BSChip")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Rating Showcase

struct RatingShowcaseView: View {
    @State private var rating1: Double = 3.5
    @State private var rating2: Double = 4.0
    @Environment(\.theme) var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.xl) {
                ShowcaseSection(title: "Interactive Rating") {
                    VStack(spacing: theme.md) {
                        BSRating(value: $rating1)
                        BSText("Rating: \(String(format: "%.1f", rating1))", style: .caption1, color: .secondary)
                    }
                }

                ShowcaseSection(title: "Rating Sizes") {
                    VStack(spacing: theme.md) {
                        BSRating(value: $rating1, size: .small)
                        BSRating(value: $rating1, size: .medium)
                        BSRating(value: $rating1, size: .large)
                    }
                }

                ShowcaseSection(title: "Custom Icons") {
                    VStack(spacing: theme.md) {
                        BSRating(value: $rating2, icon: .heart)
                        BSRating(value: $rating2, icon: .circle)
                        BSRating(value: $rating2, icon: .custom("flame.fill"))
                    }
                }

                ShowcaseSection(title: "Rating Display (Read-only)") {
                    VStack(spacing: theme.md) {
                        BSRatingDisplay(value: 4.5)
                        BSRatingDisplay(value: 3.0, maxValue: 5, showValue: true)
                        BSRatingDisplay(value: 4.8, reviewCount: 1234)
                    }
                }

                ShowcaseSection(title: "Rating Bar") {
                    VStack(spacing: theme.sm) {
                        BSRatingBar(stars: 5, percentage: 0.6, count: 120)
                        BSRatingBar(stars: 4, percentage: 0.25, count: 50)
                        BSRatingBar(stars: 3, percentage: 0.1, count: 20)
                        BSRatingBar(stars: 2, percentage: 0.03, count: 6)
                        BSRatingBar(stars: 1, percentage: 0.02, count: 4)
                    }
                }

                ShowcaseSection(title: "Rating Summary") {
                    BSRatingSummary(
                        averageRating: 4.5,
                        totalReviews: 200,
                        distribution: [
                            (5, 120),
                            (4, 50),
                            (3, 20),
                            (2, 6),
                            (1, 4)
                        ]
                    )
                }
            }
            .padding(theme.md)
        }
        .background(theme.background)
        .navigationTitle("BSRating")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Step Indicator Showcase

struct StepIndicatorShowcaseView: View {
    @State private var currentStep = 1
    @Environment(\.theme) var theme

    let steps = ["Account", "Profile", "Settings", "Review"]

    var body: some View {
        ScrollView {
            VStack(spacing: theme.xl) {
                ShowcaseSection(title: "Controls") {
                    HStack(spacing: theme.md) {
                        BSButton("Previous", style: .outline, isDisabled: currentStep == 0) {
                            if currentStep > 0 { currentStep -= 1 }
                        }
                        BSButton("Next", style: .primary, isDisabled: currentStep == steps.count - 1) {
                            if currentStep < steps.count - 1 { currentStep += 1 }
                        }
                    }
                }

                ShowcaseSection(title: "Numbered Steps") {
                    BSStepIndicator(
                        steps: steps,
                        currentStep: currentStep,
                        style: .numbered
                    )
                }

                ShowcaseSection(title: "Icon Steps") {
                    BSStepIndicator(
                        steps: steps,
                        currentStep: currentStep,
                        style: .icon
                    )
                }

                ShowcaseSection(title: "Dot Steps") {
                    BSStepIndicator(
                        steps: steps,
                        currentStep: currentStep,
                        style: .dots
                    )
                }

                ShowcaseSection(title: "Vertical Steps") {
                    BSVerticalStepIndicator(
                        steps: steps,
                        currentStep: currentStep
                    )
                }

                ShowcaseSection(title: "Progress Bar") {
                    BSStepProgressBar(
                        currentStep: currentStep,
                        totalSteps: steps.count
                    )
                }
            }
            .padding(theme.md)
        }
        .background(theme.background)
        .navigationTitle("BSStepIndicator")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - FAB Showcase

struct FABShowcaseView: View {
    @State private var showToast = false
    @Environment(\.theme) var theme

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: theme.xl) {
                    ShowcaseSection(title: "FAB Sizes") {
                        HStack(spacing: theme.lg) {
                            BSFAB(icon: "plus", size: .small) {
                                BSToastManager.shared.info("Small FAB tapped")
                            }
                            BSFAB(icon: "plus", size: .regular) {
                                BSToastManager.shared.info("Regular FAB tapped")
                            }
                            BSFAB(icon: "plus", size: .large) {
                                BSToastManager.shared.info("Large FAB tapped")
                            }
                        }
                    }

                    ShowcaseSection(title: "FAB Colors") {
                        HStack(spacing: theme.lg) {
                            BSFAB(icon: "heart.fill", color: .red) {
                                BSToastManager.shared.error("Red FAB")
                            }
                            BSFAB(icon: "star.fill", color: .orange) {
                                BSToastManager.shared.warning("Orange FAB")
                            }
                            BSFAB(icon: "checkmark", color: .green) {
                                BSToastManager.shared.success("Green FAB")
                            }
                        }
                    }

                    ShowcaseSection(title: "Extended FAB") {
                        VStack(spacing: theme.md) {
                            BSFAB(icon: "plus", label: "Create", size: .regular) {
                                BSToastManager.shared.info("Create tapped")
                            }
                            BSFAB(icon: "square.and.arrow.up", label: "Share", size: .regular) {
                                BSToastManager.shared.info("Share tapped")
                            }
                        }
                    }

                    ShowcaseSection(title: "Speed Dial FAB") {
                        BSText("Tap the FAB in bottom-right corner to see speed dial actions", style: .caption1, color: .secondary)
                            .padding(.vertical, theme.xxl)
                    }

                    // Spacer for FAB
                    Color.clear.frame(height: 100)
                }
                .padding(theme.md)
            }
            .background(theme.background)

            // Speed Dial FAB
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    BSSpeedDialFAB(
                        icon: "plus",
                        actions: [
                            .init(icon: "camera.fill", label: "Camera", color: .blue) {
                                BSToastManager.shared.info("Camera selected")
                            },
                            .init(icon: "photo.fill", label: "Photos", color: .green) {
                                BSToastManager.shared.info("Photos selected")
                            },
                            .init(icon: "doc.fill", label: "Files", color: .orange) {
                                BSToastManager.shared.info("Files selected")
                            }
                        ]
                    )
                    .padding(theme.lg)
                }
            }
        }
        .navigationTitle("BSFAB")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Chart Showcase

struct ChartShowcaseView: View {
    @Environment(\.theme) var theme

    let barData: [BSBarChart.DataPoint] = [
        .init(label: "Jan", value: 120),
        .init(label: "Feb", value: 180),
        .init(label: "Mar", value: 90),
        .init(label: "Apr", value: 210),
        .init(label: "May", value: 150),
        .init(label: "Jun", value: 240)
    ]

    let lineData: [BSLineChart.DataPoint] = [
        .init(x: 0, y: 10),
        .init(x: 1, y: 25),
        .init(x: 2, y: 15),
        .init(x: 3, y: 40),
        .init(x: 4, y: 30),
        .init(x: 5, y: 55)
    ]

    let pieData: [BSPieChart.Slice] = [
        .init(value: 35, label: "iOS", color: .blue),
        .init(value: 30, label: "Android", color: .green),
        .init(value: 20, label: "Web", color: .orange),
        .init(value: 15, label: "Other", color: .gray)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: theme.xl) {
                ShowcaseSection(title: "Bar Chart") {
                    BSBarChart(data: barData)
                        .frame(height: 200)
                }

                ShowcaseSection(title: "Line Chart") {
                    BSLineChart(data: lineData)
                        .frame(height: 200)
                }

                ShowcaseSection(title: "Pie Chart") {
                    BSPieChart(slices: pieData, showLegend: true)
                        .frame(height: 250)
                }

                ShowcaseSection(title: "Progress Rings") {
                    HStack(spacing: theme.xl) {
                        BSProgressRing(progress: 0.75, label: "75%")
                            .frame(width: 80, height: 80)
                        BSProgressRing(progress: 0.45, color: .orange, label: "45%")
                            .frame(width: 80, height: 80)
                        BSProgressRing(progress: 0.90, color: .green, label: "90%")
                            .frame(width: 80, height: 80)
                    }
                }
            }
            .padding(theme.md)
        }
        .background(theme.background)
        .navigationTitle("BSChart")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - E-commerce Showcase

struct EcommerceShowcaseView: View {
    @State private var quantity = 1
    @Environment(\.theme) var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.xl) {
                ShowcaseSection(title: "Product Card") {
                    BSProductCard(
                        title: "iPhone 15 Pro",
                        price: 999.00,
                        originalPrice: 1099.00,
                        rating: 4.8,
                        reviewCount: 2340,
                        badge: "Sale"
                    )
                }

                ShowcaseSection(title: "Price Tags") {
                    VStack(spacing: theme.md) {
                        BSPriceTag(price: 49.99)
                        BSPriceTag(price: 79.99, originalPrice: 99.99, currency: "$")
                        BSPriceTag(price: 149.99, originalPrice: 199.99, size: .large)
                    }
                }

                ShowcaseSection(title: "Cart Badge") {
                    HStack(spacing: theme.xl) {
                        BSCartBadge(count: 0)
                        BSCartBadge(count: 3)
                        BSCartBadge(count: 12)
                        BSCartBadge(count: 99)
                    }
                }

                ShowcaseSection(title: "Quantity Selector") {
                    VStack(spacing: theme.md) {
                        BSQuantitySelector(quantity: $quantity)
                        BSText("Quantity: \(quantity)", style: .caption1, color: .secondary)
                    }
                }

                ShowcaseSection(title: "Cart Item") {
                    BSCartItemRow(
                        title: "MacBook Pro 14\"",
                        variant: "Space Gray / 16GB / 512GB",
                        price: 1999.00,
                        quantity: 1
                    )
                }

                ShowcaseSection(title: "Order Summary") {
                    BSOrderSummary(
                        subtotal: 2998.00,
                        shipping: 0,
                        tax: 249.83,
                        discount: 100.00
                    )
                }
            }
            .padding(theme.md)
        }
        .background(theme.background)
        .navigationTitle("E-commerce")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Social Showcase

struct SocialShowcaseView: View {
    @State private var isLiked = false
    @State private var selectedReaction: String?
    @Environment(\.theme) var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.xl) {
                ShowcaseSection(title: "Post Card") {
                    BSPostCard(
                        author: .init(name: "John Doe", initials: "JD"),
                        timeAgo: "2h ago",
                        content: "Just shipped a new feature! SwiftUI makes building UIs so much faster. Can't wait to see what you all build with it!",
                        likeCount: 42,
                        commentCount: 12,
                        shareCount: 5,
                        isLiked: isLiked
                    ) {
                        isLiked.toggle()
                    }
                }

                ShowcaseSection(title: "Comments") {
                    VStack(spacing: theme.sm) {
                        BSComment(
                            author: .init(name: "Jane Smith", initials: "JS"),
                            timeAgo: "1h ago",
                            content: "This is amazing! Great work!",
                            likeCount: 5
                        )

                        BSComment(
                            author: .init(name: "Bob Wilson", initials: "BW"),
                            timeAgo: "30m ago",
                            content: "Can't wait to try it out!",
                            likeCount: 2
                        )
                    }
                }

                ShowcaseSection(title: "Stories") {
                    BSStoriesRow(
                        stories: [
                            .init(id: "1", username: "john", hasUnread: true),
                            .init(id: "2", username: "jane", hasUnread: true),
                            .init(id: "3", username: "bob", hasUnread: false),
                            .init(id: "4", username: "alice", hasUnread: true),
                            .init(id: "5", username: "charlie", hasUnread: false),
                        ]
                    ) { story in
                        BSToastManager.shared.info("Viewing \(story.username)'s story")
                    }
                }

                ShowcaseSection(title: "Reaction Picker") {
                    VStack(spacing: theme.md) {
                        BSReactionPicker(selected: $selectedReaction)

                        if let reaction = selectedReaction {
                            BSText("Selected: \(reaction)", style: .caption1, color: .secondary)
                        }
                    }
                }
            }
            .padding(theme.md)
        }
        .background(theme.background)
        .navigationTitle("Social")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Chat Showcase

struct ChatShowcaseView: View {
    @State private var message = ""
    @Environment(\.theme) var theme

    var body: some View {
        VStack(spacing: 0) {
            // Chat header
            BSChatHeader(
                title: "John Doe",
                subtitle: "Online",
                onBack: {},
                onCall: {},
                onVideo: {}
            )

            ScrollView {
                VStack(spacing: theme.md) {
                    // Messages
                    BSChatBubble(
                        message: "Hey! How are you doing?",
                        isFromCurrentUser: false,
                        timestamp: "10:30 AM"
                    )

                    BSChatBubble(
                        message: "I'm doing great! Just working on the new BootstrapUI library.",
                        isFromCurrentUser: true,
                        timestamp: "10:31 AM",
                        status: .read
                    )

                    BSChatBubble(
                        message: "That sounds awesome! Can't wait to see it.",
                        isFromCurrentUser: false,
                        timestamp: "10:32 AM"
                    )

                    BSChatBubble(
                        message: "Thanks! It has tons of new components including this chat UI!",
                        isFromCurrentUser: true,
                        timestamp: "10:33 AM",
                        status: .delivered
                    )

                    // Typing indicator
                    HStack {
                        BSTypingIndicator()
                        Spacer()
                    }
                    .padding(.horizontal, theme.md)
                }
                .padding(theme.md)
            }
            .background(theme.background)

            // Message input
            BSMessageInput(text: $message) {
                if !message.isEmpty {
                    BSToastManager.shared.info("Message sent: \(message)")
                    message = ""
                }
            }
        }
        .navigationTitle("Chat")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Theme Showcase

struct ThemeShowcaseView: View {
    @State private var selectedTheme: Theme = .light
    @EnvironmentObject var appState: AppState
    @Environment(\.theme) var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.xl) {
                ShowcaseSection(title: "Theme Switcher") {
                    HStack {
                        Spacer()
                        BSThemeSwitcher()
                        Spacer()
                    }
                }

                ShowcaseSection(title: "Theme Picker Row") {
                    BSThemePickerRow(selectedTheme: $selectedTheme) { newTheme in
                        appState.themeManager.setTheme(newTheme)
                    }
                }

                ShowcaseSection(title: "Light Themes") {
                    BSThemePicker(
                        selectedTheme: $selectedTheme,
                        themes: Theme.lightThemes,
                        columns: 2
                    ) { newTheme in
                        appState.themeManager.setTheme(newTheme)
                    }
                }

                ShowcaseSection(title: "Dark Themes") {
                    BSThemePicker(
                        selectedTheme: $selectedTheme,
                        themes: Theme.darkThemes,
                        columns: 2
                    ) { newTheme in
                        appState.themeManager.setTheme(newTheme)
                    }
                }

                ShowcaseSection(title: "Color Palette") {
                    BSColorPalettePreview(theme: selectedTheme)
                }
            }
            .padding(theme.md)
        }
        .background(theme.background)
        .navigationTitle("Themes")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            selectedTheme = appState.themeManager.currentTheme
        }
    }
}

// MARK: - Onboarding Showcase

struct OnboardingShowcaseView: View {
    @State private var showOnboarding = false
    @State private var currentPage = 0
    @Environment(\.theme) var theme

    let pages: [BSOnboardingPage] = [
        BSOnboardingPage(
            icon: "star.fill",
            title: "Welcome",
            description: "Welcome to BootstrapUI - a comprehensive SwiftUI component library",
            iconColor: .yellow
        ),
        BSOnboardingPage(
            icon: "paintbrush.fill",
            title: "Customizable",
            description: "16+ beautiful themes and easy customization options",
            iconColor: .purple
        ),
        BSOnboardingPage(
            icon: "sparkles",
            title: "Modern",
            description: "Built with SwiftUI and following best practices",
            iconColor: .blue
        )
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: theme.xl) {
                ShowcaseSection(title: "Show Onboarding") {
                    BSButton("Launch Onboarding", style: .primary) {
                        showOnboarding = true
                    }
                }

                ShowcaseSection(title: "Page Indicator") {
                    VStack(spacing: theme.lg) {
                        BSPageIndicator(currentPage: currentPage, totalPages: 4)
                        BSAnimatedPageIndicator(currentPage: currentPage, totalPages: 4)

                        HStack {
                            BSButton("Previous", style: .outline, size: .small) {
                                if currentPage > 0 { currentPage -= 1 }
                            }
                            BSButton("Next", style: .outline, size: .small) {
                                if currentPage < 3 { currentPage += 1 }
                            }
                        }
                    }
                }

                ShowcaseSection(title: "Feature Highlight") {
                    VStack(spacing: theme.md) {
                        BSFeatureHighlight(
                            icon: "bolt.fill",
                            title: "Fast Performance",
                            description: "Optimized for speed and efficiency"
                        )
                        BSFeatureHighlight(
                            icon: "lock.fill",
                            title: "Secure",
                            description: "Built with security in mind"
                        )
                        BSFeatureHighlight(
                            icon: "paintpalette.fill",
                            title: "Beautiful",
                            description: "Stunning UI components"
                        )
                    }
                }
            }
            .padding(theme.md)
        }
        .background(theme.background)
        .navigationTitle("Onboarding")
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $showOnboarding) {
            BSOnboardingView(pages: pages) {
                showOnboarding = false
            }
        }
    }
}

// MARK: - Swipe Card Showcase

struct SwipeCardShowcaseView: View {
    @State private var cards: [SampleCard] = [
        SampleCard(id: "1", title: "Card 1", color: .blue),
        SampleCard(id: "2", title: "Card 2", color: .green),
        SampleCard(id: "3", title: "Card 3", color: .orange),
        SampleCard(id: "4", title: "Card 4", color: .purple),
        SampleCard(id: "5", title: "Card 5", color: .red)
    ]
    @State private var lastAction = "Swipe a card!"
    @Environment(\.theme) var theme

    var body: some View {
        VStack(spacing: theme.lg) {
            BSText(lastAction, style: .headline)
                .padding()

            BSSwipeCardStack(
                cards: cards,
                onSwipe: { card, direction in
                    switch direction {
                    case .left:
                        lastAction = "Swiped \(card.title) LEFT (Nope)"
                    case .right:
                        lastAction = "Swiped \(card.title) RIGHT (Like)"
                    case .up:
                        lastAction = "Swiped \(card.title) UP (Super Like)"
                    case .down:
                        lastAction = "Swiped \(card.title) DOWN (Skip)"
                    }
                    cards.removeAll { $0.id == card.id }
                }
            ) { card in
                RoundedRectangle(cornerRadius: theme.radiusLg)
                    .fill(card.color)
                    .overlay(
                        VStack {
                            BSText(card.title, style: .title1, weight: .bold)
                                .foregroundColor(.white)
                            BSText("Swipe me!", style: .body)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    )
            }
            .frame(height: 400)

            BSSwipeCardActions(
                onNope: {
                    lastAction = "Nope button tapped"
                },
                onSuperLike: {
                    lastAction = "Super Like button tapped"
                },
                onLike: {
                    lastAction = "Like button tapped"
                }
            )

            if cards.isEmpty {
                BSButton("Reset Cards", style: .primary) {
                    cards = [
                        SampleCard(id: "1", title: "Card 1", color: .blue),
                        SampleCard(id: "2", title: "Card 2", color: .green),
                        SampleCard(id: "3", title: "Card 3", color: .orange),
                        SampleCard(id: "4", title: "Card 4", color: .purple),
                        SampleCard(id: "5", title: "Card 5", color: .red)
                    ]
                    lastAction = "Cards reset!"
                }
            }

            Spacer()
        }
        .padding(theme.md)
        .background(theme.background)
        .navigationTitle("Swipe Cards")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SampleCard: BSSwipeCardData {
    let id: String
    let title: String
    let color: Color
}

#Preview {
    ExtrasShowcaseView()
        .environmentObject(AppState())
        .withTheme()
}
