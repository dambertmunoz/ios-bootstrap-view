// BSOnboarding.swift
// BootstrapUI
//
// Onboarding/Walkthrough components for app introduction
// Perfect for first-time user experience

import SwiftUI

// MARK: - Onboarding Page Data

/// Data for a single onboarding page
public struct BSOnboardingPage: Identifiable {
    public let id = UUID()
    public let image: OnboardingImage
    public let title: String
    public let subtitle: String
    public let accentColor: Color?

    public enum OnboardingImage {
        case systemIcon(String)
        case assetImage(String)
        case view(AnyView)
    }

    public init(
        image: OnboardingImage,
        title: String,
        subtitle: String,
        accentColor: Color? = nil
    ) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.accentColor = accentColor
    }

    /// Convenience initializer with SF Symbol
    public init(
        icon: String,
        title: String,
        subtitle: String,
        accentColor: Color? = nil
    ) {
        self.image = .systemIcon(icon)
        self.title = title
        self.subtitle = subtitle
        self.accentColor = accentColor
    }
}

// MARK: - Onboarding View

/// A complete onboarding/walkthrough view
///
/// Example usage:
/// ```swift
/// BSOnboardingView(
///     pages: [
///         BSOnboardingPage(icon: "star.fill", title: "Welcome", subtitle: "Discover amazing features"),
///         BSOnboardingPage(icon: "heart.fill", title: "Personalize", subtitle: "Make it yours"),
///         BSOnboardingPage(icon: "checkmark.circle.fill", title: "Get Started", subtitle: "You're all set!")
///     ],
///     onComplete: { handleOnboardingComplete() }
/// )
/// ```
public struct BSOnboardingView: View {

    // MARK: - Properties

    private let pages: [BSOnboardingPage]
    private let primaryButtonTitle: String
    private let skipButtonTitle: String?
    private let showSkipButton: Bool
    private let showPageIndicator: Bool
    private let onComplete: () -> Void
    private let onSkip: (() -> Void)?

    @State private var currentPage = 0
    @Environment(\.theme) private var theme

    // MARK: - Initialization

    public init(
        pages: [BSOnboardingPage],
        primaryButtonTitle: String = "Continue",
        skipButtonTitle: String? = "Skip",
        showSkipButton: Bool = true,
        showPageIndicator: Bool = true,
        onComplete: @escaping () -> Void,
        onSkip: (() -> Void)? = nil
    ) {
        self.pages = pages
        self.primaryButtonTitle = primaryButtonTitle
        self.skipButtonTitle = skipButtonTitle
        self.showSkipButton = showSkipButton
        self.showPageIndicator = showPageIndicator
        self.onComplete = onComplete
        self.onSkip = onSkip
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 0) {
            // Skip button
            if showSkipButton && currentPage < pages.count - 1 {
                HStack {
                    Spacer()
                    Button(skipButtonTitle ?? "Skip") {
                        onSkip?() ?? onComplete()
                    }
                    .font(theme.subheadline)
                    .foregroundColor(theme.placeholder)
                }
                .padding()
            } else {
                Spacer()
                    .frame(height: 60)
            }

            // Page content
            TabView(selection: $currentPage) {
                ForEach(Array(pages.enumerated()), id: \.element.id) { index, page in
                    pageView(for: page)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentPage)

            // Page indicator
            if showPageIndicator {
                BSPageIndicator(
                    currentPage: currentPage,
                    totalPages: pages.count,
                    activeColor: pages[currentPage].accentColor ?? theme.primary
                )
                .padding(.vertical, theme.lg)
            }

            // Action button
            BSButton(
                isLastPage ? "Get Started" : primaryButtonTitle,
                style: .primary,
                isFullWidth: true
            ) {
                if isLastPage {
                    onComplete()
                } else {
                    withAnimation {
                        currentPage += 1
                    }
                }
            }
            .padding(.horizontal, theme.lg)
            .padding(.bottom, theme.xl)
        }
        .background(theme.background)
    }

    // MARK: - Page View

    private func pageView(for page: BSOnboardingPage) -> some View {
        VStack(spacing: theme.xl) {
            Spacer()

            // Image
            Group {
                switch page.image {
                case .systemIcon(let name):
                    Image(systemName: name)
                        .font(.system(size: 100))
                        .foregroundColor(page.accentColor ?? theme.primary)

                case .assetImage(let name):
                    Image(name)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 250)

                case .view(let view):
                    view
                        .frame(maxHeight: 250)
                }
            }
            .frame(height: 200)

            // Text
            VStack(spacing: theme.md) {
                Text(page.title)
                    .font(theme.title1)
                    .fontWeight(.bold)
                    .foregroundColor(theme.onBackground)
                    .multilineTextAlignment(.center)

                Text(page.subtitle)
                    .font(theme.body)
                    .foregroundColor(theme.placeholder)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, theme.lg)
            }

            Spacer()
        }
        .padding(.horizontal, theme.lg)
    }

    // MARK: - Helpers

    private var isLastPage: Bool {
        currentPage == pages.count - 1
    }
}

// MARK: - Page Indicator

/// A custom page indicator
public struct BSPageIndicator: View {

    private let currentPage: Int
    private let totalPages: Int
    private let activeColor: Color
    private let inactiveColor: Color
    private let dotSize: CGFloat
    private let spacing: CGFloat

    public init(
        currentPage: Int,
        totalPages: Int,
        activeColor: Color = .blue,
        inactiveColor: Color = .gray.opacity(0.3),
        dotSize: CGFloat = 8,
        spacing: CGFloat = 8
    ) {
        self.currentPage = currentPage
        self.totalPages = totalPages
        self.activeColor = activeColor
        self.inactiveColor = inactiveColor
        self.dotSize = dotSize
        self.spacing = spacing
    }

    public var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<totalPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? activeColor : inactiveColor)
                    .frame(width: dotSize, height: dotSize)
                    .scaleEffect(index == currentPage ? 1.2 : 1)
                    .animation(.spring(response: 0.3), value: currentPage)
            }
        }
    }
}

// MARK: - Animated Page Indicator

/// An animated page indicator with different styles
public struct BSAnimatedPageIndicator: View {

    public enum Style {
        case dots
        case worm
        case expanding
        case sliding
    }

    private let currentPage: Int
    private let totalPages: Int
    private let style: Style
    private let activeColor: Color
    private let inactiveColor: Color

    @Environment(\.theme) private var theme

    public init(
        currentPage: Int,
        totalPages: Int,
        style: Style = .worm,
        activeColor: Color? = nil,
        inactiveColor: Color? = nil
    ) {
        self.currentPage = currentPage
        self.totalPages = totalPages
        self.style = style
        self.activeColor = activeColor ?? .blue
        self.inactiveColor = inactiveColor ?? .gray.opacity(0.3)
    }

    public var body: some View {
        switch style {
        case .dots:
            dotsIndicator
        case .worm:
            wormIndicator
        case .expanding:
            expandingIndicator
        case .sliding:
            slidingIndicator
        }
    }

    private var dotsIndicator: some View {
        BSPageIndicator(
            currentPage: currentPage,
            totalPages: totalPages,
            activeColor: activeColor,
            inactiveColor: inactiveColor
        )
    }

    private var wormIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) { index in
                Capsule()
                    .fill(index == currentPage ? activeColor : inactiveColor)
                    .frame(width: index == currentPage ? 24 : 8, height: 8)
                    .animation(.spring(response: 0.3), value: currentPage)
            }
        }
    }

    private var expandingIndicator: some View {
        HStack(spacing: 6) {
            ForEach(0..<totalPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? activeColor : inactiveColor)
                    .frame(width: index == currentPage ? 12 : 6, height: index == currentPage ? 12 : 6)
                    .animation(.spring(response: 0.3), value: currentPage)
            }
        }
    }

    private var slidingIndicator: some View {
        ZStack(alignment: .leading) {
            HStack(spacing: 8) {
                ForEach(0..<totalPages, id: \.self) { _ in
                    Circle()
                        .fill(inactiveColor)
                        .frame(width: 8, height: 8)
                }
            }

            Circle()
                .fill(activeColor)
                .frame(width: 8, height: 8)
                .offset(x: CGFloat(currentPage) * 16)
                .animation(.spring(response: 0.3), value: currentPage)
        }
    }
}

// MARK: - Feature Highlight

/// A feature highlight card for onboarding
public struct BSFeatureHighlight: View {

    private let icon: String
    private let title: String
    private let description: String
    private let color: Color?

    @Environment(\.theme) private var theme

    public init(
        icon: String,
        title: String,
        description: String,
        color: Color? = nil
    ) {
        self.icon = icon
        self.title = title
        self.description = description
        self.color = color
    }

    public var body: some View {
        HStack(alignment: .top, spacing: theme.md) {
            BSCircularIcon(icon, size: .lg, backgroundColor: (color ?? theme.primary).opacity(0.1))
                .foregroundColor(color ?? theme.primary)

            VStack(alignment: .leading, spacing: theme.xxs) {
                Text(title)
                    .font(theme.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(theme.onSurface)

                Text(description)
                    .font(theme.subheadline)
                    .foregroundColor(theme.placeholder)
            }

            Spacer()
        }
        .padding(theme.md)
        .background(theme.surface)
        .cornerRadius(theme.radiusMd)
    }
}

// MARK: - Onboarding Carousel

/// A horizontal carousel for onboarding features
public struct BSOnboardingCarousel: View {

    private let features: [BSOnboardingPage]
    @State private var currentIndex = 0

    @Environment(\.theme) private var theme

    public init(features: [BSOnboardingPage]) {
        self.features = features
    }

    public var body: some View {
        VStack(spacing: theme.md) {
            TabView(selection: $currentIndex) {
                ForEach(Array(features.enumerated()), id: \.element.id) { index, feature in
                    featureCard(feature)
                        .tag(index)
                        .padding(.horizontal, theme.md)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 200)

            BSAnimatedPageIndicator(
                currentPage: currentIndex,
                totalPages: features.count,
                style: .worm
            )
        }
    }

    private func featureCard(_ feature: BSOnboardingPage) -> some View {
        BSCard {
            VStack(spacing: theme.md) {
                if case .systemIcon(let name) = feature.image {
                    Image(systemName: name)
                        .font(.system(size: 40))
                        .foregroundColor(feature.accentColor ?? theme.primary)
                }

                VStack(spacing: theme.xs) {
                    Text(feature.title)
                        .font(theme.headline)
                        .fontWeight(.semibold)

                    Text(feature.subtitle)
                        .font(theme.subheadline)
                        .foregroundColor(theme.placeholder)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(theme.md)
        }
    }
}

// MARK: - Preview

#if DEBUG
struct BSOnboarding_Previews: PreviewProvider {
    static var previews: some View {
        BSOnboardingView(
            pages: [
                BSOnboardingPage(
                    icon: "star.fill",
                    title: "Welcome to BootstrapUI",
                    subtitle: "A comprehensive SwiftUI component library for building beautiful iOS apps",
                    accentColor: .blue
                ),
                BSOnboardingPage(
                    icon: "paintbrush.fill",
                    title: "Customizable Themes",
                    subtitle: "Easily customize colors, typography, and spacing to match your brand",
                    accentColor: .purple
                ),
                BSOnboardingPage(
                    icon: "cube.fill",
                    title: "Ready-to-Use Components",
                    subtitle: "40+ components following Atomic Design principles",
                    accentColor: .orange
                ),
                BSOnboardingPage(
                    icon: "checkmark.circle.fill",
                    title: "You're All Set!",
                    subtitle: "Start building amazing apps with BootstrapUI",
                    accentColor: .green
                )
            ],
            onComplete: {}
        )
        .withTheme()
    }
}
#endif
