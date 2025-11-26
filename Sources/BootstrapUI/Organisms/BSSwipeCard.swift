// BSSwipeCard.swift
// BootstrapUI
//
// Swipeable card stack component (Tinder-style)
// Perfect for matching, selection, and discovery interfaces

import SwiftUI

// MARK: - Swipe Direction

/// Direction of swipe
public enum BSSwipeDirection {
    case left
    case right
    case up
    case down

    var icon: String {
        switch self {
        case .left: return "xmark"
        case .right: return "heart.fill"
        case .up: return "star.fill"
        case .down: return "arrow.down"
        }
    }

    var color: Color {
        switch self {
        case .left: return .red
        case .right: return .green
        case .up: return .blue
        case .down: return .gray
        }
    }
}

// MARK: - Swipe Card Data

/// Protocol for swipeable card data
public protocol BSSwipeCardData: Identifiable {
    var id: UUID { get }
}

// MARK: - Swipe Card Stack

/// A stack of swipeable cards
///
/// Example usage:
/// ```swift
/// BSSwipeCardStack(cards: profiles) { profile, direction in
///     handleSwipe(profile, direction)
/// } cardContent: { profile in
///     ProfileCardView(profile: profile)
/// }
/// ```
public struct BSSwipeCardStack<Item: BSSwipeCardData, CardContent: View>: View {

    // MARK: - Properties

    @Binding private var cards: [Item]
    private let onSwipe: (Item, BSSwipeDirection) -> Void
    private let cardContent: (Item) -> CardContent
    private let allowedDirections: Set<BSSwipeDirection>
    private let showOverlay: Bool

    @Environment(\.theme) private var theme

    // MARK: - Initialization

    public init(
        cards: Binding<[Item]>,
        allowedDirections: Set<BSSwipeDirection> = [.left, .right],
        showOverlay: Bool = true,
        onSwipe: @escaping (Item, BSSwipeDirection) -> Void,
        @ViewBuilder cardContent: @escaping (Item) -> CardContent
    ) {
        self._cards = cards
        self.allowedDirections = allowedDirections
        self.showOverlay = showOverlay
        self.onSwipe = onSwipe
        self.cardContent = cardContent
    }

    // MARK: - Body

    public var body: some View {
        ZStack {
            // Background cards
            ForEach(Array(cards.prefix(3).enumerated().reversed()), id: \.element.id) { index, card in
                if index > 0 {
                    cardView(for: card, at: index)
                }
            }

            // Top card (swipeable)
            if let topCard = cards.first {
                BSSwipeableCard(
                    allowedDirections: allowedDirections,
                    showOverlay: showOverlay,
                    onSwipe: { direction in
                        handleSwipe(topCard, direction)
                    }
                ) {
                    cardContent(topCard)
                }
            } else {
                emptyStateView
            }
        }
    }

    // MARK: - Card View

    private func cardView(for card: Item, at index: Int) -> some View {
        cardContent(card)
            .scaleEffect(1 - CGFloat(index) * 0.05)
            .offset(y: CGFloat(index) * 10)
            .allowsHitTesting(false)
    }

    // MARK: - Empty State

    private var emptyStateView: some View {
        VStack(spacing: theme.md) {
            Image(systemName: "rectangle.stack")
                .font(.system(size: 60))
                .foregroundColor(theme.placeholder)

            Text("No more cards")
                .font(theme.headline)
                .foregroundColor(theme.placeholder)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.surface)
        .cornerRadius(theme.radiusLg)
    }

    // MARK: - Handle Swipe

    private func handleSwipe(_ card: Item, _ direction: BSSwipeDirection) {
        onSwipe(card, direction)

        withAnimation(.spring()) {
            if let index = cards.firstIndex(where: { $0.id == card.id }) {
                cards.remove(at: index)
            }
        }
    }
}

// MARK: - Swipeable Card

/// A single swipeable card with gesture handling
public struct BSSwipeableCard<Content: View>: View {

    // MARK: - Properties

    private let content: () -> Content
    private let onSwipe: (BSSwipeDirection) -> Void
    private let allowedDirections: Set<BSSwipeDirection>
    private let showOverlay: Bool

    @State private var offset: CGSize = .zero
    @State private var rotation: Double = 0
    @GestureState private var isDragging = false

    @Environment(\.theme) private var theme

    private let swipeThreshold: CGFloat = 100

    // MARK: - Initialization

    public init(
        allowedDirections: Set<BSSwipeDirection> = [.left, .right],
        showOverlay: Bool = true,
        onSwipe: @escaping (BSSwipeDirection) -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.allowedDirections = allowedDirections
        self.showOverlay = showOverlay
        self.onSwipe = onSwipe
        self.content = content
    }

    // MARK: - Body

    public var body: some View {
        content()
            .overlay(overlayView)
            .rotationEffect(.degrees(rotation))
            .offset(offset)
            .gesture(dragGesture)
            .animation(.spring(response: 0.3), value: offset)
    }

    // MARK: - Overlay

    @ViewBuilder
    private var overlayView: some View {
        if showOverlay {
            ZStack {
                // Left overlay (reject)
                if allowedDirections.contains(.left) && offset.width < 0 {
                    swipeIndicator(direction: .left, opacity: min(1, -offset.width / swipeThreshold))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .padding()
                }

                // Right overlay (accept)
                if allowedDirections.contains(.right) && offset.width > 0 {
                    swipeIndicator(direction: .right, opacity: min(1, offset.width / swipeThreshold))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .padding()
                }

                // Up overlay (super like)
                if allowedDirections.contains(.up) && offset.height < -30 {
                    swipeIndicator(direction: .up, opacity: min(1, -offset.height / swipeThreshold))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                        .padding()
                }
            }
        }
    }

    private func swipeIndicator(direction: BSSwipeDirection, opacity: Double) -> some View {
        Image(systemName: direction.icon)
            .font(.system(size: 48, weight: .bold))
            .foregroundColor(direction.color)
            .padding()
            .background(
                Circle()
                    .stroke(direction.color, lineWidth: 4)
            )
            .opacity(opacity)
    }

    // MARK: - Drag Gesture

    private var dragGesture: some Gesture {
        DragGesture()
            .updating($isDragging) { _, state, _ in
                state = true
            }
            .onChanged { gesture in
                offset = gesture.translation
                rotation = Double(offset.width / 20)
            }
            .onEnded { gesture in
                let direction = determineSwipeDirection(gesture.translation)

                if let direction = direction, allowedDirections.contains(direction) {
                    // Animate off screen
                    let offScreenOffset = calculateOffScreenOffset(for: direction)
                    withAnimation(.easeOut(duration: 0.3)) {
                        offset = offScreenOffset
                    }

                    // Trigger swipe action
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        onSwipe(direction)
                    }
                } else {
                    // Reset position
                    withAnimation(.spring()) {
                        offset = .zero
                        rotation = 0
                    }
                }
            }
    }

    // MARK: - Helpers

    private func determineSwipeDirection(_ translation: CGSize) -> BSSwipeDirection? {
        let horizontalAmount = translation.width
        let verticalAmount = translation.height

        // Check horizontal swipe
        if abs(horizontalAmount) > swipeThreshold && abs(horizontalAmount) > abs(verticalAmount) {
            return horizontalAmount > 0 ? .right : .left
        }

        // Check vertical swipe
        if abs(verticalAmount) > swipeThreshold && abs(verticalAmount) > abs(horizontalAmount) {
            return verticalAmount > 0 ? .down : .up
        }

        return nil
    }

    private func calculateOffScreenOffset(for direction: BSSwipeDirection) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        switch direction {
        case .left:
            return CGSize(width: -screenWidth * 1.5, height: offset.height)
        case .right:
            return CGSize(width: screenWidth * 1.5, height: offset.height)
        case .up:
            return CGSize(width: offset.width, height: -screenHeight * 1.5)
        case .down:
            return CGSize(width: offset.width, height: screenHeight * 1.5)
        }
    }
}

// MARK: - Swipe Card Actions

/// Action buttons for manual swipe control
public struct BSSwipeCardActions: View {

    private let onLeft: () -> Void
    private let onRight: () -> Void
    private let onUp: (() -> Void)?
    private let leftIcon: String
    private let rightIcon: String
    private let upIcon: String

    @Environment(\.theme) private var theme

    public init(
        leftIcon: String = "xmark",
        rightIcon: String = "heart.fill",
        upIcon: String = "star.fill",
        onLeft: @escaping () -> Void,
        onRight: @escaping () -> Void,
        onUp: (() -> Void)? = nil
    ) {
        self.leftIcon = leftIcon
        self.rightIcon = rightIcon
        self.upIcon = upIcon
        self.onLeft = onLeft
        self.onRight = onRight
        self.onUp = onUp
    }

    public var body: some View {
        HStack(spacing: theme.xl) {
            // Reject button
            actionButton(icon: leftIcon, color: .red, size: 60, action: onLeft)

            // Super like button (optional)
            if let onUp = onUp {
                actionButton(icon: upIcon, color: .blue, size: 50, action: onUp)
            }

            // Accept button
            actionButton(icon: rightIcon, color: .green, size: 60, action: onRight)
        }
    }

    private func actionButton(
        icon: String,
        color: Color,
        size: CGFloat,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size * 0.4, weight: .bold))
                .foregroundColor(color)
                .frame(width: size, height: size)
                .background(
                    Circle()
                        .stroke(color, lineWidth: 2)
                )
        }
    }
}

// MARK: - Simple Card Data

/// A simple implementation of BSSwipeCardData
public struct BSSimpleCardData: BSSwipeCardData {
    public let id = UUID()
    public let title: String
    public let subtitle: String?
    public let imageURL: URL?
    public let color: Color?

    public init(
        title: String,
        subtitle: String? = nil,
        imageURL: URL? = nil,
        color: Color? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
        self.color = color
    }
}

// MARK: - Preview

#if DEBUG
struct BSSwipeCard_Previews: PreviewProvider {
    struct PreviewCard: BSSwipeCardData {
        let id = UUID()
        let name: String
        let age: Int
        let color: Color
    }

    struct PreviewView: View {
        @State private var cards: [PreviewCard] = [
            PreviewCard(name: "Alice", age: 25, color: .red),
            PreviewCard(name: "Bob", age: 28, color: .blue),
            PreviewCard(name: "Charlie", age: 24, color: .green),
            PreviewCard(name: "Diana", age: 27, color: .purple),
            PreviewCard(name: "Eve", age: 26, color: .orange)
        ]

        var body: some View {
            VStack(spacing: 20) {
                BSSwipeCardStack(cards: $cards) { card, direction in
                    print("\(card.name) swiped \(direction)")
                } cardContent: { card in
                    VStack {
                        Spacer()
                        Text(card.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("\(card.age) years old")
                            .foregroundColor(.white.opacity(0.8))
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(card.color)
                    .cornerRadius(16)
                }
                .frame(height: 400)
                .padding()

                BSSwipeCardActions(
                    onLeft: { swipeTop(.left) },
                    onRight: { swipeTop(.right) },
                    onUp: { swipeTop(.up) }
                )
            }
            .withTheme()
        }

        private func swipeTop(_ direction: BSSwipeDirection) {
            guard let first = cards.first else { return }
            withAnimation {
                cards.removeFirst()
            }
        }
    }

    static var previews: some View {
        PreviewView()
    }
}
#endif
