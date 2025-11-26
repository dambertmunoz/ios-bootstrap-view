# Generate BootstrapUI E-commerce View

Generate a SwiftUI e-commerce view using BootstrapUI components for: $ARGUMENTS

## Instructions

Create e-commerce components like product cards, carts, and checkout:

```swift
import SwiftUI
import BootstrapUI

struct ProductListView: View {
    @State private var products: [Product] = []
    @State private var selectedCategory = "All"

    @Environment(\.theme) private var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.md) {
                // Category filter
                BSChipGroup(
                    options: ["All", "Electronics", "Clothing", "Home"],
                    selected: $selectedCategory
                )
                .padding(.horizontal)

                // Product grid
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: theme.md) {
                    ForEach(products) { product in
                        BSProductCard(
                            title: product.title,
                            price: product.price,
                            originalPrice: product.originalPrice,
                            rating: product.rating,
                            imageURL: product.imageURL,
                            badge: product.isNew ? "New" : nil
                        ) {
                            // Add to cart
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
```

## Available E-commerce Components

### BSProductCard
```swift
// Basic product card
BSProductCard(
    title: "iPhone 15 Pro",
    price: 999.00,
    imageURL: imageURL
)

// With discount
BSProductCard(
    title: "iPhone 15 Pro",
    price: 899.00,
    originalPrice: 999.00,
    rating: 4.8,
    reviewCount: 1234,
    badge: "Sale"
) {
    addToCart()
}

// Compact variant
BSProductCard(
    title: "AirPods Pro",
    price: 249.00,
    variant: .compact
)
```

### BSPriceTag
```swift
// Regular price
BSPriceTag(price: 49.99)

// With discount
BSPriceTag(price: 39.99, originalPrice: 49.99)

// With currency
BSPriceTag(price: 49.99, currency: "EUR")
```

### BSQuantitySelector
```swift
BSQuantitySelector(
    quantity: $quantity,
    minimum: 1,
    maximum: 10
)
```

### BSCartItemRow
```swift
BSCartItemRow(
    title: "Product Name",
    subtitle: "Size: M, Color: Blue",
    price: 99.00,
    quantity: 2,
    imageURL: imageURL,
    onRemove: { removeItem() },
    onQuantityChange: { newQty in updateQuantity(newQty) }
)
```

### BSOrderSummary
```swift
BSOrderSummary(
    subtotal: 199.00,
    shipping: 0.00,
    tax: 15.99,
    discount: 20.00,
    total: 194.99
)
```

### BSRating Components
```swift
// Interactive rating
BSRating(value: $rating)

// Display only
BSRatingDisplay(value: 4.5, reviewCount: 1234)

// Rating summary
BSRatingSummary(
    averageRating: 4.5,
    totalReviews: 200,
    distribution: [
        .init(stars: 5, count: 120),
        .init(stars: 4, count: 50),
        .init(stars: 3, count: 20),
        .init(stars: 2, count: 7),
        .init(stars: 1, count: 3)
    ]
)
```

## Cart View Pattern

```swift
struct CartView: View {
    @State private var cartItems: [CartItem] = []

    var body: some View {
        VStack {
            ScrollView {
                ForEach(cartItems) { item in
                    BSCartItemRow(
                        title: item.title,
                        price: item.price,
                        quantity: item.quantity,
                        onRemove: { removeItem(item) }
                    )
                }
            }

            Spacer()

            BSOrderSummary(
                subtotal: subtotal,
                shipping: shipping,
                tax: tax,
                total: total
            )

            BSButton("Checkout", style: .primary, isFullWidth: true) {
                checkout()
            }
            .padding()
        }
    }
}
```

## Checkout Flow

```swift
struct CheckoutView: View {
    var body: some View {
        BSStepIndicator(
            steps: ["Cart", "Shipping", "Payment", "Review"],
            currentStep: currentStep
        )

        // Step content based on currentStep
    }
}
```

Generate the e-commerce view based on the user's requirements using these patterns.
