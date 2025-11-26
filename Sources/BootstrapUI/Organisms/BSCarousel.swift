// BSCarousel.swift
// BootstrapUI
//
// Carousel/slider components for images and content
// Supports auto-play, indicators, and various styles

import SwiftUI

// MARK: - BSCarousel

/// A carousel/slider component
public struct BSCarousel<Item: Identifiable, Content: View>: View {

    private let items: [Item]
    private let spacing: CGFloat
    private let showIndicators: Bool
    private let autoPlay: Bool
    private let autoPlayInterval: TimeInterval
    private let content: (Item) -> Content

    @State private var currentIndex = 0
    @State private var timer: Timer?

    @Environment(\.theme) private var theme

    public init(
        items: [Item],
        spacing: CGFloat = 16,
        showIndicators: Bool = true,
        autoPlay: Bool = false,
        autoPlayInterval: TimeInterval = 3,
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.items = items
        self.spacing = spacing
        self.showIndicators = showIndicators
        self.autoPlay = autoPlay
        self.autoPlayInterval = autoPlayInterval
        self.content = content
    }

    public var body: some View {
        VStack(spacing: theme.md) {
            // Carousel content
            TabView(selection: $currentIndex) {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    content(item)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            // Indicators
            if showIndicators && items.count > 1 {
                indicators
            }
        }
        .onAppear {
            if autoPlay {
                startAutoPlay()
            }
        }
        .onDisappear {
            stopAutoPlay()
        }
    }

    private var indicators: some View {
        HStack(spacing: theme.xs) {
            ForEach(0..<items.count, id: \.self) { index in
                Circle()
                    .fill(index == currentIndex ? theme.primary : theme.border)
                    .frame(width: 8, height: 8)
                    .scaleEffect(index == currentIndex ? 1.2 : 1)
                    .animation(.spring(response: 0.3), value: currentIndex)
                    .onTapGesture {
                        withAnimation {
                            currentIndex = index
                        }
                    }
            }
        }
    }

    private func startAutoPlay() {
        timer = Timer.scheduledTimer(withTimeInterval: autoPlayInterval, repeats: true) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % items.count
            }
        }
    }

    private func stopAutoPlay() {
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - BSImageCarousel

/// A carousel specifically for images
public struct BSImageCarousel: View {

    private let images: [ImageItem]
    private let aspectRatio: CGFloat
    private let cornerRadius: CGFloat
    private let showIndicators: Bool
    private let autoPlay: Bool

    @State private var currentIndex = 0

    @Environment(\.theme) private var theme

    public struct ImageItem: Identifiable {
        public let id = UUID()
        public let url: URL?
        public let systemImage: String?
        public let caption: String?

        public init(url: URL?, caption: String? = nil) {
            self.url = url
            self.systemImage = nil
            self.caption = caption
        }

        public init(systemImage: String, caption: String? = nil) {
            self.url = nil
            self.systemImage = systemImage
            self.caption = caption
        }
    }

    public init(
        images: [ImageItem],
        aspectRatio: CGFloat = 16/9,
        cornerRadius: CGFloat = 12,
        showIndicators: Bool = true,
        autoPlay: Bool = false
    ) {
        self.images = images
        self.aspectRatio = aspectRatio
        self.cornerRadius = cornerRadius
        self.showIndicators = showIndicators
        self.autoPlay = autoPlay
    }

    public var body: some View {
        BSCarousel(
            items: images,
            showIndicators: showIndicators,
            autoPlay: autoPlay
        ) { item in
            ZStack(alignment: .bottom) {
                // Image
                if let systemImage = item.systemImage {
                    Image(systemName: systemImage)
                        .font(.system(size: 60))
                        .foregroundColor(theme.placeholder)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .aspectRatio(aspectRatio, contentMode: .fit)
                        .background(theme.surface)
                } else {
                    AsyncImage(url: item.url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        case .failure:
                            Image(systemName: "photo")
                                .font(.system(size: 40))
                                .foregroundColor(theme.placeholder)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .aspectRatio(aspectRatio, contentMode: .fit)
                    .background(theme.surface)
                }

                // Caption overlay
                if let caption = item.caption {
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.7)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 60)

                    BSText(caption, style: .subheadline, weight: .medium)
                        .foregroundColor(.white)
                        .padding(theme.md)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
    }
}

// MARK: - BSCardCarousel

/// A carousel with cards that peek from sides
public struct BSCardCarousel<Item: Identifiable, Content: View>: View {

    private let items: [Item]
    private let cardWidth: CGFloat
    private let spacing: CGFloat
    private let content: (Item) -> Content

    @State private var currentIndex = 0
    @GestureState private var dragOffset: CGFloat = 0

    @Environment(\.theme) private var theme

    public init(
        items: [Item],
        cardWidth: CGFloat = 280,
        spacing: CGFloat = 16,
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.items = items
        self.cardWidth = cardWidth
        self.spacing = spacing
        self.content = content
    }

    public var body: some View {
        GeometryReader { geometry in
            let totalWidth = cardWidth + spacing
            let offset = CGFloat(currentIndex) * -totalWidth + dragOffset
            let sideInset = (geometry.size.width - cardWidth) / 2

            HStack(spacing: spacing) {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    content(item)
                        .frame(width: cardWidth)
                        .scaleEffect(index == currentIndex ? 1 : 0.9)
                        .opacity(index == currentIndex ? 1 : 0.7)
                        .animation(.spring(response: 0.3), value: currentIndex)
                }
            }
            .padding(.horizontal, sideInset)
            .offset(x: offset)
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation.width
                    }
                    .onEnded { value in
                        let threshold = cardWidth / 3
                        var newIndex = currentIndex

                        if value.translation.width < -threshold {
                            newIndex = min(currentIndex + 1, items.count - 1)
                        } else if value.translation.width > threshold {
                            newIndex = max(currentIndex - 1, 0)
                        }

                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            currentIndex = newIndex
                        }
                    }
            )
        }
    }
}

// MARK: - BSBannerCarousel

/// A full-width banner carousel
public struct BSBannerCarousel: View {

    private let banners: [Banner]
    private let height: CGFloat
    private let autoPlay: Bool
    private let autoPlayInterval: TimeInterval

    @State private var currentIndex = 0
    @State private var timer: Timer?

    @Environment(\.theme) private var theme

    public struct Banner: Identifiable {
        public let id = UUID()
        public let title: String
        public let subtitle: String?
        public let buttonTitle: String?
        public let backgroundColor: Color
        public let textColor: Color
        public let action: (() -> Void)?

        public init(
            title: String,
            subtitle: String? = nil,
            buttonTitle: String? = nil,
            backgroundColor: Color = .blue,
            textColor: Color = .white,
            action: (() -> Void)? = nil
        ) {
            self.title = title
            self.subtitle = subtitle
            self.buttonTitle = buttonTitle
            self.backgroundColor = backgroundColor
            self.textColor = textColor
            self.action = action
        }
    }

    public init(
        banners: [Banner],
        height: CGFloat = 160,
        autoPlay: Bool = true,
        autoPlayInterval: TimeInterval = 4
    ) {
        self.banners = banners
        self.height = height
        self.autoPlay = autoPlay
        self.autoPlayInterval = autoPlayInterval
    }

    public var body: some View {
        VStack(spacing: theme.sm) {
            TabView(selection: $currentIndex) {
                ForEach(Array(banners.enumerated()), id: \.element.id) { index, banner in
                    bannerView(banner)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: height)

            // Indicators
            if banners.count > 1 {
                HStack(spacing: theme.xs) {
                    ForEach(0..<banners.count, id: \.self) { index in
                        Capsule()
                            .fill(index == currentIndex ? theme.primary : theme.border)
                            .frame(width: index == currentIndex ? 20 : 8, height: 8)
                            .animation(.spring(response: 0.3), value: currentIndex)
                    }
                }
            }
        }
        .onAppear {
            if autoPlay {
                startAutoPlay()
            }
        }
        .onDisappear {
            stopAutoPlay()
        }
    }

    private func bannerView(_ banner: Banner) -> some View {
        ZStack {
            banner.backgroundColor

            HStack {
                VStack(alignment: .leading, spacing: theme.xs) {
                    Text(banner.title)
                        .font(theme.title2)
                        .fontWeight(.bold)
                        .foregroundColor(banner.textColor)

                    if let subtitle = banner.subtitle {
                        Text(subtitle)
                            .font(theme.subheadline)
                            .foregroundColor(banner.textColor.opacity(0.9))
                    }

                    if let buttonTitle = banner.buttonTitle {
                        Button {
                            banner.action?()
                        } label: {
                            Text(buttonTitle)
                                .font(theme.caption1)
                                .fontWeight(.semibold)
                                .foregroundColor(banner.backgroundColor)
                                .padding(.horizontal, theme.md)
                                .padding(.vertical, theme.xs)
                                .background(banner.textColor)
                                .cornerRadius(theme.radiusFull)
                        }
                        .padding(.top, theme.xs)
                    }
                }
                .padding(theme.lg)

                Spacer()
            }
        }
        .cornerRadius(theme.radiusMd)
        .padding(.horizontal, theme.md)
    }

    private func startAutoPlay() {
        timer = Timer.scheduledTimer(withTimeInterval: autoPlayInterval, repeats: true) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % banners.count
            }
        }
    }

    private func stopAutoPlay() {
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - Preview

#if DEBUG
struct BSCarousel_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 32) {
                BSBannerCarousel(banners: [
                    .init(title: "Summer Sale", subtitle: "Up to 50% off", buttonTitle: "Shop Now", backgroundColor: .blue),
                    .init(title: "New Arrivals", subtitle: "Check out the latest", buttonTitle: "Explore", backgroundColor: .purple),
                    .init(title: "Free Shipping", subtitle: "On orders over $50", backgroundColor: .green)
                ])

                BSImageCarousel(images: [
                    .init(systemImage: "photo.fill", caption: "Image 1"),
                    .init(systemImage: "photo.fill.on.rectangle.fill", caption: "Image 2"),
                    .init(systemImage: "person.crop.rectangle.fill", caption: "Image 3")
                ])
                .frame(height: 200)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .withTheme()
    }
}
#endif
