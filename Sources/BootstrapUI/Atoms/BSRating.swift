// BSRating.swift
// BootstrapUI
//
// Star rating component for reviews and feedback
// Supports both display and interactive modes

import SwiftUI

// MARK: - Rating Style

/// Available rating styles
public enum BSRatingStyle {
    case stars
    case hearts
    case circles
    case custom(filled: String, empty: String)

    var filledIcon: String {
        switch self {
        case .stars: return "star.fill"
        case .hearts: return "heart.fill"
        case .circles: return "circle.fill"
        case .custom(let filled, _): return filled
        }
    }

    var emptyIcon: String {
        switch self {
        case .stars: return "star"
        case .hearts: return "heart"
        case .circles: return "circle"
        case .custom(_, let empty): return empty
        }
    }

    var halfIcon: String {
        switch self {
        case .stars: return "star.leadinghalf.filled"
        case .hearts: return "heart.fill" // No half heart in SF Symbols
        case .circles: return "circle.lefthalf.filled"
        case .custom(let filled, _): return filled
        }
    }
}

// MARK: - Rating Size

/// Available rating sizes
public enum BSRatingSize {
    case small
    case medium
    case large
    case custom(CGFloat)

    var iconSize: CGFloat {
        switch self {
        case .small: return 14
        case .medium: return 20
        case .large: return 28
        case .custom(let size): return size
        }
    }

    var spacing: CGFloat {
        switch self {
        case .small: return 2
        case .medium: return 4
        case .large: return 6
        case .custom: return 4
        }
    }
}

// MARK: - Rating Component

/// A customizable rating component
///
/// Example usage:
/// ```swift
/// // Display only
/// BSRating(value: 4.5, maxValue: 5)
///
/// // Interactive
/// BSRating(value: $rating, maxValue: 5)
///
/// // Custom style
/// BSRating(value: $rating, style: .hearts, color: .red)
/// ```
public struct BSRating: View {

    // MARK: - Properties

    @Binding private var value: Double
    private let maxValue: Int
    private let style: BSRatingStyle
    private let size: BSRatingSize
    private let color: Color?
    private let emptyColor: Color?
    private let allowHalfStars: Bool
    private let isReadOnly: Bool
    private let showValue: Bool
    private let onRatingChanged: ((Double) -> Void)?

    @Environment(\.theme) private var theme
    @GestureState private var isDragging = false

    // MARK: - Initialization (Interactive)

    public init(
        value: Binding<Double>,
        maxValue: Int = 5,
        style: BSRatingStyle = .stars,
        size: BSRatingSize = .medium,
        color: Color? = nil,
        emptyColor: Color? = nil,
        allowHalfStars: Bool = true,
        showValue: Bool = false,
        onRatingChanged: ((Double) -> Void)? = nil
    ) {
        self._value = value
        self.maxValue = maxValue
        self.style = style
        self.size = size
        self.color = color
        self.emptyColor = emptyColor
        self.allowHalfStars = allowHalfStars
        self.isReadOnly = false
        self.showValue = showValue
        self.onRatingChanged = onRatingChanged
    }

    // MARK: - Initialization (Read-only)

    public init(
        value: Double,
        maxValue: Int = 5,
        style: BSRatingStyle = .stars,
        size: BSRatingSize = .medium,
        color: Color? = nil,
        emptyColor: Color? = nil,
        allowHalfStars: Bool = true,
        showValue: Bool = false
    ) {
        self._value = .constant(value)
        self.maxValue = maxValue
        self.style = style
        self.size = size
        self.color = color
        self.emptyColor = emptyColor
        self.allowHalfStars = allowHalfStars
        self.isReadOnly = true
        self.showValue = showValue
        self.onRatingChanged = nil
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: size.spacing) {
            starsView

            if showValue {
                Text(String(format: "%.1f", value))
                    .font(valueFont)
                    .foregroundColor(theme.onSurface)
            }
        }
    }

    private var starsView: some View {
        HStack(spacing: size.spacing) {
            ForEach(1...maxValue, id: \.self) { index in
                starImage(for: index)
                    .font(.system(size: size.iconSize))
                    .foregroundColor(starColor(for: index))
                    .onTapGesture {
                        if !isReadOnly {
                            setRating(Double(index))
                        }
                    }
            }
        }
        .gesture(isReadOnly ? nil : dragGesture)
    }

    // MARK: - Star Image

    @ViewBuilder
    private func starImage(for index: Int) -> some View {
        let threshold = Double(index)

        if value >= threshold {
            // Full star
            Image(systemName: style.filledIcon)
        } else if allowHalfStars && value >= threshold - 0.5 {
            // Half star
            Image(systemName: style.halfIcon)
        } else {
            // Empty star
            Image(systemName: style.emptyIcon)
        }
    }

    // MARK: - Star Color

    private func starColor(for index: Int) -> Color {
        let threshold = Double(index)

        if value >= threshold - 0.5 {
            return color ?? theme.warning
        } else {
            return emptyColor ?? theme.border
        }
    }

    // MARK: - Drag Gesture

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .updating($isDragging) { _, state, _ in
                state = true
            }
            .onChanged { gesture in
                let starWidth = size.iconSize + size.spacing
                let totalWidth = starWidth * CGFloat(maxValue)
                let percentage = gesture.location.x / totalWidth
                var newValue = Double(maxValue) * Double(percentage)

                if allowHalfStars {
                    newValue = (newValue * 2).rounded() / 2
                } else {
                    newValue = newValue.rounded()
                }

                newValue = max(0, min(Double(maxValue), newValue))

                if newValue != value {
                    setRating(newValue)
                }
            }
    }

    // MARK: - Set Rating

    private func setRating(_ newValue: Double) {
        withAnimation(.easeInOut(duration: 0.15)) {
            value = newValue
        }
        onRatingChanged?(newValue)
    }

    // MARK: - Font

    private var valueFont: Font {
        switch size {
        case .small: return theme.caption2
        case .medium: return theme.subheadline
        case .large: return theme.body
        case .custom: return theme.subheadline
        }
    }
}

// MARK: - Rating Display

/// A compact rating display with count
public struct BSRatingDisplay: View {

    private let rating: Double
    private let reviewCount: Int?
    private let size: BSRatingSize
    private let color: Color?

    @Environment(\.theme) private var theme

    public init(
        rating: Double,
        reviewCount: Int? = nil,
        size: BSRatingSize = .small,
        color: Color? = nil
    ) {
        self.rating = rating
        self.reviewCount = reviewCount
        self.size = size
        self.color = color
    }

    public var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .font(.system(size: size.iconSize))
                .foregroundColor(color ?? theme.warning)

            Text(String(format: "%.1f", rating))
                .font(textFont)
                .fontWeight(.medium)
                .foregroundColor(theme.onSurface)

            if let count = reviewCount {
                Text("(\(count))")
                    .font(textFont)
                    .foregroundColor(theme.placeholder)
            }
        }
    }

    private var textFont: Font {
        switch size {
        case .small: return theme.caption1
        case .medium: return theme.subheadline
        case .large: return theme.body
        case .custom: return theme.subheadline
        }
    }
}

// MARK: - Rating Bar (for breakdowns)

/// A rating breakdown bar
public struct BSRatingBar: View {

    private let stars: Int
    private let count: Int
    private let total: Int
    private let color: Color?

    @Environment(\.theme) private var theme

    public init(
        stars: Int,
        count: Int,
        total: Int,
        color: Color? = nil
    ) {
        self.stars = stars
        self.count = count
        self.total = max(1, total)
        self.color = color
    }

    public var body: some View {
        HStack(spacing: theme.sm) {
            Text("\(stars)")
                .font(theme.caption1)
                .foregroundColor(theme.placeholder)
                .frame(width: 16)

            Image(systemName: "star.fill")
                .font(.system(size: 10))
                .foregroundColor(theme.warning)

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(theme.border)
                        .frame(height: 6)

                    RoundedRectangle(cornerRadius: 2)
                        .fill(color ?? theme.primary)
                        .frame(width: barWidth(in: geometry), height: 6)
                }
            }
            .frame(height: 6)

            Text("\(count)")
                .font(theme.caption1)
                .foregroundColor(theme.placeholder)
                .frame(width: 30, alignment: .trailing)
        }
    }

    private func barWidth(in geometry: GeometryProxy) -> CGFloat {
        let percentage = CGFloat(count) / CGFloat(total)
        return geometry.size.width * percentage
    }
}

// MARK: - Rating Summary

/// A complete rating summary view
public struct BSRatingSummary: View {

    private let averageRating: Double
    private let totalReviews: Int
    private let distribution: [Int: Int] // stars -> count

    @Environment(\.theme) private var theme

    public init(
        averageRating: Double,
        totalReviews: Int,
        distribution: [Int: Int]
    ) {
        self.averageRating = averageRating
        self.totalReviews = totalReviews
        self.distribution = distribution
    }

    public var body: some View {
        HStack(alignment: .top, spacing: theme.lg) {
            // Average rating
            VStack(spacing: theme.xs) {
                Text(String(format: "%.1f", averageRating))
                    .font(theme.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(theme.onSurface)

                BSRating(value: averageRating, size: .small, showValue: false)

                Text("\(totalReviews) reviews")
                    .font(theme.caption1)
                    .foregroundColor(theme.placeholder)
            }

            // Distribution
            VStack(spacing: 4) {
                ForEach((1...5).reversed(), id: \.self) { stars in
                    BSRatingBar(
                        stars: stars,
                        count: distribution[stars] ?? 0,
                        total: totalReviews
                    )
                }
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct BSRating_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Basic
                Text("Basic Rating").font(.headline)
                BSRating(value: .constant(3.5))

                // Sizes
                Text("Sizes").font(.headline)
                VStack(spacing: 12) {
                    BSRating(value: 4, size: .small)
                    BSRating(value: 4, size: .medium)
                    BSRating(value: 4, size: .large)
                }

                // Styles
                Text("Styles").font(.headline)
                VStack(spacing: 12) {
                    BSRating(value: 4, style: .stars)
                    BSRating(value: 4, style: .hearts, color: .red)
                    BSRating(value: 4, style: .circles, color: .blue)
                }

                // With value
                Text("With Value").font(.headline)
                BSRating(value: 4.5, showValue: true)

                // Display
                Text("Compact Display").font(.headline)
                HStack {
                    BSRatingDisplay(rating: 4.5, reviewCount: 128)
                    Spacer()
                    BSRatingDisplay(rating: 3.8, reviewCount: 45, color: .orange)
                }

                // Summary
                Text("Rating Summary").font(.headline)
                BSRatingSummary(
                    averageRating: 4.3,
                    totalReviews: 1250,
                    distribution: [5: 800, 4: 300, 3: 100, 2: 30, 1: 20]
                )
            }
            .padding()
        }
        .withTheme()
    }
}
#endif
