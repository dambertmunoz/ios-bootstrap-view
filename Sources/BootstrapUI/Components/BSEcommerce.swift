// BSEcommerce.swift
// BootstrapUI
//
// E-commerce specific components
// Product cards, price tags, cart badges, quantity selectors

import SwiftUI

// MARK: - Product Card

/// A product card for e-commerce listings
public struct BSProductCard: View {

    private let imageURL: URL?
    private let title: String
    private let subtitle: String?
    private let price: String
    private let originalPrice: String?
    private let rating: Double?
    private let reviewCount: Int?
    private let badge: String?
    private let isFavorite: Bool
    private let onFavoriteTap: (() -> Void)?
    private let onTap: (() -> Void)?

    @Environment(\.theme) private var theme

    public init(
        imageURL: URL? = nil,
        title: String,
        subtitle: String? = nil,
        price: String,
        originalPrice: String? = nil,
        rating: Double? = nil,
        reviewCount: Int? = nil,
        badge: String? = nil,
        isFavorite: Bool = false,
        onFavoriteTap: (() -> Void)? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.imageURL = imageURL
        self.title = title
        self.subtitle = subtitle
        self.price = price
        self.originalPrice = originalPrice
        self.rating = rating
        self.reviewCount = reviewCount
        self.badge = badge
        self.isFavorite = isFavorite
        self.onFavoriteTap = onFavoriteTap
        self.onTap = onTap
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image
            ZStack(alignment: .topTrailing) {
                productImage
                    .frame(height: 160)

                // Favorite button
                if onFavoriteTap != nil {
                    Button(action: { onFavoriteTap?() }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 16))
                            .foregroundColor(isFavorite ? .red : .white)
                            .padding(theme.sm)
                            .background(Color.black.opacity(0.3))
                            .clipShape(Circle())
                    }
                    .padding(theme.sm)
                }

                // Badge
                if let badge = badge {
                    Text(badge)
                        .font(theme.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, theme.sm)
                        .padding(.vertical, theme.xxs)
                        .background(theme.error)
                        .cornerRadius(theme.radiusSm)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .padding(theme.sm)
                }
            }

            // Content
            VStack(alignment: .leading, spacing: theme.xs) {
                Text(title)
                    .font(theme.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(theme.onSurface)
                    .lineLimit(2)

                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(theme.caption1)
                        .foregroundColor(theme.placeholder)
                        .lineLimit(1)
                }

                // Price
                priceView

                // Rating
                if let rating = rating {
                    BSRatingDisplay(rating: rating, reviewCount: reviewCount, size: .small)
                }
            }
            .padding(theme.sm)
        }
        .background(theme.background)
        .cornerRadius(theme.radiusMd)
        .shadow(color: theme.shadowSm.color, radius: theme.shadowSm.radius)
        .onTapGesture { onTap?() }
    }

    @ViewBuilder
    private var productImage: some View {
        if let url = imageURL {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    imagePlaceholder
                case .empty:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(theme.surface)
                @unknown default:
                    imagePlaceholder
                }
            }
            .clipped()
        } else {
            imagePlaceholder
        }
    }

    private var imagePlaceholder: some View {
        Rectangle()
            .fill(theme.surface)
            .overlay(
                Image(systemName: "photo")
                    .font(.largeTitle)
                    .foregroundColor(theme.placeholder)
            )
    }

    private var priceView: some View {
        HStack(spacing: theme.xs) {
            Text(price)
                .font(theme.headline)
                .fontWeight(.bold)
                .foregroundColor(theme.primary)

            if let original = originalPrice {
                Text(original)
                    .font(theme.caption1)
                    .foregroundColor(theme.placeholder)
                    .strikethrough()
            }
        }
    }
}

// MARK: - Price Tag

/// A price display component with optional discount
public struct BSPriceTag: View {

    private let price: Double
    private let originalPrice: Double?
    private let currencySymbol: String
    private let size: Size

    @Environment(\.theme) private var theme

    public enum Size {
        case small, medium, large

        var priceFont: Font {
            switch self {
            case .small: return .subheadline
            case .medium: return .title3
            case .large: return .title
            }
        }

        var originalFont: Font {
            switch self {
            case .small: return .caption2
            case .medium: return .caption1
            case .large: return .subheadline
            }
        }
    }

    public init(
        price: Double,
        originalPrice: Double? = nil,
        currencySymbol: String = "$",
        size: Size = .medium
    ) {
        self.price = price
        self.originalPrice = originalPrice
        self.currencySymbol = currencySymbol
        self.size = size
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(currencySymbol)
                    .font(size.priceFont.weight(.medium))
                    .foregroundColor(hasDiscount ? theme.error : theme.onSurface)

                Text(formatPrice(price))
                    .font(size.priceFont.weight(.bold))
                    .foregroundColor(hasDiscount ? theme.error : theme.onSurface)

                if let original = originalPrice, original > price {
                    Text(currencySymbol + formatPrice(original))
                        .font(size.originalFont)
                        .foregroundColor(theme.placeholder)
                        .strikethrough()
                }
            }

            if let savings = discountPercentage {
                Text("Save \(Int(savings))%")
                    .font(theme.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(theme.error)
            }
        }
    }

    private var hasDiscount: Bool {
        if let original = originalPrice {
            return original > price
        }
        return false
    }

    private var discountPercentage: Double? {
        guard let original = originalPrice, original > price else { return nil }
        return ((original - price) / original) * 100
    }

    private func formatPrice(_ value: Double) -> String {
        return String(format: "%.2f", value)
    }
}

// MARK: - Cart Badge

/// A cart icon with item count badge
public struct BSCartBadge: View {

    private let count: Int
    private let size: CGFloat
    private let onTap: (() -> Void)?

    @Environment(\.theme) private var theme

    public init(
        count: Int,
        size: CGFloat = 24,
        onTap: (() -> Void)? = nil
    ) {
        self.count = count
        self.size = size
        self.onTap = onTap
    }

    public var body: some View {
        Button(action: { onTap?() }) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "cart")
                    .font(.system(size: size))
                    .foregroundColor(theme.onSurface)

                if count > 0 {
                    Text(count > 99 ? "99+" : "\(count)")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                        .background(theme.error)
                        .clipShape(Capsule())
                        .offset(x: 8, y: -8)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Quantity Selector

/// A quantity selector for cart items
public struct BSQuantitySelector: View {

    @Binding private var quantity: Int
    private let minValue: Int
    private let maxValue: Int
    private let size: Size
    private let onChange: ((Int) -> Void)?

    @Environment(\.theme) private var theme

    public enum Size {
        case small, medium, large

        var buttonSize: CGFloat {
            switch self {
            case .small: return 28
            case .medium: return 36
            case .large: return 44
            }
        }

        var font: Font {
            switch self {
            case .small: return .caption1
            case .medium: return .subheadline
            case .large: return .body
            }
        }
    }

    public init(
        quantity: Binding<Int>,
        minValue: Int = 1,
        maxValue: Int = 99,
        size: Size = .medium,
        onChange: ((Int) -> Void)? = nil
    ) {
        self._quantity = quantity
        self.minValue = minValue
        self.maxValue = maxValue
        self.size = size
        self.onChange = onChange
    }

    public var body: some View {
        HStack(spacing: 0) {
            // Decrease button
            Button(action: decrease) {
                Image(systemName: "minus")
                    .font(.system(size: size.buttonSize * 0.4, weight: .semibold))
                    .foregroundColor(quantity <= minValue ? theme.placeholder : theme.onSurface)
            }
            .frame(width: size.buttonSize, height: size.buttonSize)
            .disabled(quantity <= minValue)

            // Quantity
            Text("\(quantity)")
                .font(size.font.weight(.semibold))
                .foregroundColor(theme.onSurface)
                .frame(minWidth: size.buttonSize)

            // Increase button
            Button(action: increase) {
                Image(systemName: "plus")
                    .font(.system(size: size.buttonSize * 0.4, weight: .semibold))
                    .foregroundColor(quantity >= maxValue ? theme.placeholder : theme.onSurface)
            }
            .frame(width: size.buttonSize, height: size.buttonSize)
            .disabled(quantity >= maxValue)
        }
        .background(theme.surface)
        .cornerRadius(theme.radiusMd)
        .overlay(
            RoundedRectangle(cornerRadius: theme.radiusMd)
                .stroke(theme.border, lineWidth: 1)
        )
    }

    private func decrease() {
        let newValue = max(minValue, quantity - 1)
        quantity = newValue
        onChange?(newValue)
    }

    private func increase() {
        let newValue = min(maxValue, quantity + 1)
        quantity = newValue
        onChange?(newValue)
    }
}

// MARK: - Cart Item Row

/// A row for displaying cart items
public struct BSCartItemRow: View {

    private let imageURL: URL?
    private let title: String
    private let subtitle: String?
    private let price: String
    @Binding private var quantity: Int
    private let onRemove: (() -> Void)?

    @Environment(\.theme) private var theme

    public init(
        imageURL: URL? = nil,
        title: String,
        subtitle: String? = nil,
        price: String,
        quantity: Binding<Int>,
        onRemove: (() -> Void)? = nil
    ) {
        self.imageURL = imageURL
        self.title = title
        self.subtitle = subtitle
        self.price = price
        self._quantity = quantity
        self.onRemove = onRemove
    }

    public var body: some View {
        HStack(spacing: theme.md) {
            // Image
            Group {
                if let url = imageURL {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(theme.surface)
                    }
                } else {
                    Rectangle()
                        .fill(theme.surface)
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(theme.placeholder)
                        )
                }
            }
            .frame(width: 80, height: 80)
            .cornerRadius(theme.radiusSm)

            // Details
            VStack(alignment: .leading, spacing: theme.xs) {
                Text(title)
                    .font(theme.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(theme.onSurface)
                    .lineLimit(2)

                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(theme.caption1)
                        .foregroundColor(theme.placeholder)
                }

                Text(price)
                    .font(theme.headline)
                    .fontWeight(.bold)
                    .foregroundColor(theme.primary)
            }

            Spacer()

            // Quantity
            VStack(alignment: .trailing, spacing: theme.sm) {
                if let onRemove = onRemove {
                    Button(action: onRemove) {
                        Image(systemName: "trash")
                            .font(.system(size: 14))
                            .foregroundColor(theme.error)
                    }
                }

                BSQuantitySelector(quantity: $quantity, size: .small)
            }
        }
        .padding(theme.md)
        .background(theme.background)
        .cornerRadius(theme.radiusMd)
    }
}

// MARK: - Order Summary

/// An order summary view for checkout
public struct BSOrderSummary: View {

    public struct SummaryLine: Identifiable {
        public let id = UUID()
        public let label: String
        public let value: String
        public let isTotal: Bool

        public init(label: String, value: String, isTotal: Bool = false) {
            self.label = label
            self.value = value
            self.isTotal = isTotal
        }
    }

    private let lines: [SummaryLine]
    private let ctaTitle: String?
    private let ctaAction: (() -> Void)?

    @Environment(\.theme) private var theme

    public init(
        lines: [SummaryLine],
        ctaTitle: String? = nil,
        ctaAction: (() -> Void)? = nil
    ) {
        self.lines = lines
        self.ctaTitle = ctaTitle
        self.ctaAction = ctaAction
    }

    public var body: some View {
        VStack(spacing: theme.md) {
            ForEach(lines) { line in
                if line.isTotal {
                    BSDivider()
                }

                HStack {
                    Text(line.label)
                        .font(line.isTotal ? theme.headline : theme.body)
                        .fontWeight(line.isTotal ? .bold : .regular)
                        .foregroundColor(theme.onSurface)

                    Spacer()

                    Text(line.value)
                        .font(line.isTotal ? theme.headline : theme.body)
                        .fontWeight(line.isTotal ? .bold : .medium)
                        .foregroundColor(line.isTotal ? theme.primary : theme.onSurface)
                }
            }

            if let title = ctaTitle, let action = ctaAction {
                BSButton(title, style: .primary, isFullWidth: true, action: action)
            }
        }
        .padding(theme.md)
        .background(theme.surface)
        .cornerRadius(theme.radiusMd)
    }
}

// MARK: - Preview

#if DEBUG
struct BSEcommerce_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Product Cards
                Text("Product Cards").font(.headline)
                HStack(spacing: 12) {
                    BSProductCard(
                        title: "Wireless Headphones",
                        subtitle: "Premium Sound",
                        price: "$99.99",
                        originalPrice: "$149.99",
                        rating: 4.5,
                        reviewCount: 128,
                        badge: "SALE",
                        isFavorite: true
                    )
                    .frame(width: 170)

                    BSProductCard(
                        title: "Smart Watch",
                        price: "$299.00",
                        rating: 4.8
                    )
                    .frame(width: 170)
                }

                // Price Tags
                Text("Price Tags").font(.headline)
                HStack(spacing: 24) {
                    BSPriceTag(price: 29.99, size: .small)
                    BSPriceTag(price: 79.99, originalPrice: 99.99, size: .medium)
                    BSPriceTag(price: 199.00, originalPrice: 299.00, size: .large)
                }

                // Cart Badge
                Text("Cart Badge").font(.headline)
                HStack(spacing: 24) {
                    BSCartBadge(count: 0)
                    BSCartBadge(count: 3)
                    BSCartBadge(count: 99)
                    BSCartBadge(count: 150)
                }

                // Quantity Selector
                Text("Quantity Selector").font(.headline)
                HStack(spacing: 20) {
                    BSQuantitySelector(quantity: .constant(1), size: .small)
                    BSQuantitySelector(quantity: .constant(5), size: .medium)
                    BSQuantitySelector(quantity: .constant(10), size: .large)
                }

                // Order Summary
                Text("Order Summary").font(.headline)
                BSOrderSummary(
                    lines: [
                        .init(label: "Subtotal", value: "$299.97"),
                        .init(label: "Shipping", value: "$9.99"),
                        .init(label: "Tax", value: "$24.00"),
                        .init(label: "Total", value: "$333.96", isTotal: true)
                    ],
                    ctaTitle: "Checkout",
                    ctaAction: {}
                )
            }
            .padding()
        }
        .withTheme()
    }
}
#endif
