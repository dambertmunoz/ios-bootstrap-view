# BootstrapUI

<p align="center">
  <strong>A comprehensive SwiftUI component library following Atomic Design principles</strong>
</p>

<p align="center">
  <a href="#installation">Installation</a> •
  <a href="#quick-start">Quick Start</a> •
  <a href="#components">Components</a> •
  <a href="#ai-agent-usage">AI/Agent Usage</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Swift-5.9+-orange.svg" alt="Swift 5.9+"/>
  <img src="https://img.shields.io/badge/iOS-15.0+-blue.svg" alt="iOS 15.0+"/>
  <img src="https://img.shields.io/badge/SwiftUI-100%25-green.svg" alt="SwiftUI"/>
  <img src="https://img.shields.io/badge/Components-50+-purple.svg" alt="50+ Components"/>
  <img src="https://img.shields.io/badge/Themes-16-green.svg" alt="16 Themes"/>
</p>

---

## Overview

Build beautiful, consistent iOS applications with BootstrapUI - **50+ production-ready SwiftUI components** following Atomic Design principles.

### Key Features

- 🎨 **50+ Components** - Buttons, forms, charts, carousels, chat UI, and more
- 🌈 **16 Predefined Themes** - Material, Nord, Dracula, Solarized, Cyberpunk...
- 📱 **100% SwiftUI** - Pure SwiftUI, no UIKit dependencies
- ♿ **Accessible** - VoiceOver, Dynamic Type, Reduce Motion support
- 🧪 **Well Tested** - Comprehensive test coverage
- 📚 **Documented** - Extensive docs with examples

---

## Requirements

- iOS 15.0+ / macOS 12.0+
- Swift 5.9+
- Xcode 15.0+

---

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/dambertmunoz/ios-bootstrap-view.git", from: "1.0.0")
]
```

**Or in Xcode:** File > Add Package Dependencies > Enter URL

---

## Quick Start

```swift
import SwiftUI
import BootstrapUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .withTheme()   // Apply theme system
                .withToasts()  // Enable toast notifications
        }
    }
}

struct ContentView: View {
    @State private var email = ""
    @Environment(\.theme) var theme

    var body: some View {
        VStack(spacing: theme.md) {
            BSText("Welcome", style: .largeTitle, weight: .bold)

            BSTextField("Email", text: $email, placeholder: "you@example.com", icon: "envelope")

            BSButton("Continue", style: .primary, isFullWidth: true) {
                BSToastManager.shared.success("Welcome!")
            }
        }
        .padding(theme.md)
    }
}
```

---

## Components Reference

### Quick Reference Table

| Category | Components |
|----------|------------|
| **Atoms** | BSButton, BSText, BSTextField, BSIcon, BSToggle, BSDivider, BSBadge, BSAvatar, BSSkeleton, BSChip, BSRating, BSSlider, BSProgressBar, BSSegmentedControl |
| **Molecules** | BSInputField, BSSearchBar, BSCard, BSListItem, BSAlert, BSToast, BSStepIndicator, BSFAB, BSChart, BSDropdown |
| **Organisms** | BSForm, BSHeader, BSNavigation, BSModal, BSSwipeCard, BSBottomSheet, BSTimeline, BSAccordion, BSCarousel |
| **Templates** | BSPageTemplate, BSListTemplate, BSDetailTemplate, BSOnboarding, BSEmptyState |
| **Domain** | BSEcommerce, BSSocial, BSChat, BSThemePicker |
| **Themes** | Light, Dark, Material, Nord, Dracula, Solarized, Ocean, Forest, Sunset, Midnight, Rose, Monokai, Cyberpunk (16 total) |

---

### Atoms (Basic Building Blocks)

#### BSButton
```swift
// Styles: primary, secondary, outline, ghost, destructive, success, link
BSButton("Save", style: .primary, icon: "checkmark") { }
BSButton("Delete", style: .destructive, isLoading: isLoading) { }
BSIconButton(icon: "heart.fill", style: .primary) { }
```

#### BSTextField
```swift
BSTextField("Email", text: $email, placeholder: "you@example.com", icon: "envelope")
BSTextField("Error", text: $text, state: .error("Invalid input"))
BSTextArea("Description", text: $text, placeholder: "Enter description...")
```

#### BSSkeleton (Loading Placeholders)
```swift
BSSkeletonText(lines: 3)
BSSkeletonAvatar(size: .lg)
BSSkeletonCard()
BSSkeletonListItem()
```

#### BSChip (Tags & Filters)
```swift
BSChip("Swift", variant: .filled)
BSChipGroup(options: ["iOS", "Android", "Web"], selected: $selected)
BSMultiChipGroup(options: tags, selected: $selectedTags)
BSInputChip(chips: $chips, placeholder: "Add tag...")
```

#### BSRating (Star Ratings)
```swift
BSRating(value: $rating)  // Interactive
BSRatingDisplay(value: 4.5, reviewCount: 1234)  // Read-only
BSRatingSummary(averageRating: 4.5, totalReviews: 200, distribution: [...])
```

#### BSSlider
```swift
BSSlider(value: $value, showValue: true)
BSRangeSlider(lowerValue: $min, upperValue: $max)
BSDiscreteSlider(selection: $size, options: ["S", "M", "L", "XL"], labelProvider: { $0 })
```

#### BSProgressBar
```swift
BSProgressBar(progress: 0.75, showLabel: true)
BSProgressBar(progress: 0.5, style: .gradient([.blue, .purple]))
BSIndeterminateProgress()
BSCircularProgress(progress: 0.8)
BSLoadingSpinner(style: .dots)  // .circular, .dots, .pulse, .bars
```

#### BSSegmentedControl
```swift
BSSegmentedControl(selection: $tab, options: ["Tab 1", "Tab 2", "Tab 3"])
BSSegmentedControl(selection: $tab, options: tabs, style: .underlined)  // .filled, .outlined, .underlined, .pill
BSIconSegmentedControl(selection: $view, options: [(0, "list.bullet", "List"), (1, "square.grid.2x2", "Grid")])
```

---

### Molecules (Combinations)

#### BSCard
```swift
BSCard { content }
BSCard(variant: .outlined, isInteractive: true, onTap: { }) { content }
BSActionCard(title: "Premium", icon: "crown.fill", primaryAction: ("Upgrade", { }))
```

#### BSStepIndicator
```swift
BSStepIndicator(steps: ["Account", "Profile", "Review"], currentStep: 1)
BSVerticalStepIndicator(steps: steps, currentStep: currentStep)
BSStepProgressBar(currentStep: 2, totalSteps: 5)
```

#### BSFAB (Floating Action Button)
```swift
BSFAB(icon: "plus") { }
BSFAB(icon: "plus", label: "Create") { }
BSSpeedDialFAB(icon: "plus", actions: [
    .init(icon: "camera.fill", label: "Camera") { },
    .init(icon: "photo.fill", label: "Photos") { }
])
```

#### BSChart
```swift
BSBarChart(data: [.init(label: "Jan", value: 120), ...])
BSLineChart(data: [.init(x: 0, y: 10), ...])
BSPieChart(slices: [.init(value: 35, label: "iOS", color: .blue), ...])
BSProgressRing(progress: 0.75, label: "75%")
```

#### BSDropdown
```swift
BSDropdown(selection: $selected, options: languages, labelProvider: { $0 }, isSearchable: true)
BSMultiDropdown(selection: $selected, options: options, labelProvider: { $0 })
```

---

### Organisms (Complex Components)

#### BSBottomSheet
```swift
BSBottomSheet(isPresented: $show, detents: [.medium, .large], title: "Options") {
    // Content
}

// Or use modifiers:
.bsBottomSheet(isPresented: $show) { content }
.bsActionSheet(isPresented: $show, actions: [...])
.bsConfirmationSheet(isPresented: $show, title: "Delete?", onConfirm: { })
```

#### BSSwipeCard (Tinder-style)
```swift
BSSwipeCardStack(cards: cards, onSwipe: { card, direction in }) { card in
    // Card content
}
BSSwipeCardActions(onNope: { }, onSuperLike: { }, onLike: { })
```

#### BSTimeline
```swift
BSOrderTimeline(steps: [
    .init(title: "Order Placed", status: .completed),
    .init(title: "Shipped", status: .current),
    .init(title: "Delivered", status: .pending)
])

BSActivityTimeline(activities: [
    .init(title: "John commented", time: "2m ago", icon: "bubble.left.fill", iconColor: .blue)
])
```

#### BSAccordion
```swift
BSExpandableSection(title: "FAQ", icon: "questionmark.circle") {
    // Expandable content
}

BSFAQAccordion(faqs: [
    .init(question: "What is BootstrapUI?", answer: "A SwiftUI component library...")
])

BSCollapsibleCard(title: "Details", badge: "3") { content }
```

#### BSCarousel
```swift
BSBannerCarousel(banners: [
    .init(title: "Summer Sale", subtitle: "50% off", buttonTitle: "Shop", backgroundColor: .blue)
])

BSImageCarousel(images: [.init(url: imageURL, caption: "Photo 1")])
```

---

### Templates

#### BSOnboarding
```swift
BSOnboardingView(pages: [
    BSOnboardingPage(icon: "star.fill", title: "Welcome", description: "..."),
    BSOnboardingPage(icon: "heart.fill", title: "Features", description: "...")
]) {
    // On completion
}
```

#### BSEmptyState
```swift
BSEmptyState.noResults(searchTerm: "query")
BSEmptyState.noConnection(onRetry: { })
BSEmptyState.emptyCart(onBrowse: { })
BSEmptyState.error(onRetry: { })
BSEmptyState.comingSoon(feature: "This feature")
```

---

### Domain Components

#### E-commerce
```swift
BSProductCard(title: "iPhone 15", price: 999, originalPrice: 1099, rating: 4.8)
BSPriceTag(price: 49.99, originalPrice: 79.99)
BSQuantitySelector(quantity: $qty)
BSCartItemRow(title: "Product", price: 99, quantity: 1)
BSOrderSummary(subtotal: 199, shipping: 0, tax: 15.99)
```

#### Social
```swift
BSPostCard(author: .init(name: "John"), content: "Hello!", likeCount: 42, onLike: { })
BSComment(author: .init(name: "Jane"), content: "Great!", likeCount: 5)
BSStoriesRow(stories: stories, onTap: { })
BSReactionPicker(selected: $reaction)
```

#### Chat
```swift
BSChatBubble(message: "Hello!", isFromCurrentUser: true, timestamp: "10:30 AM")
BSTypingIndicator()
BSMessageInput(text: $message, onSend: { })
BSChatHeader(title: "John", subtitle: "Online")
```

---

### Themes

```swift
// Use predefined themes
ThemeManager.shared.setTheme(.dark)
ThemeManager.shared.setTheme(.dracula)
ThemeManager.shared.setTheme(.nordDark)

// Available themes:
Theme.light, Theme.dark
Theme.materialLight, Theme.materialDark
Theme.nordLight, Theme.nordDark
Theme.dracula
Theme.solarizedLight, Theme.solarizedDark
Theme.ocean, Theme.forest, Theme.sunset, Theme.midnight
Theme.roseLight, Theme.monokai, Theme.cyberpunk

// Access all themes
Theme.allThemes      // All 16 themes
Theme.lightThemes    // Light themes only
Theme.darkThemes     // Dark themes only

// Theme picker UI
BSThemePicker(selectedTheme: $theme)
BSThemePickerRow(selectedTheme: $theme)
BSThemeSwitcher()  // Light/dark toggle
```

---

## AI/Agent Usage

### For Claude Code / AI Agents

This library is optimized for AI-assisted development. Here's how to use it:

#### Quick Prompts for Agents

```
"Create a login form using BootstrapUI with email, password, and submit button"

"Build a product listing page with BSProductCard, search, and filters using BootstrapUI"

"Create a chat interface using BSChat components from BootstrapUI"

"Add a bottom sheet with action items using BSBottomSheet"

"Implement onboarding screens using BSOnboarding"
```

#### Component Patterns

**Form Pattern:**
```swift
BSForm {
    BSFormSection(title: "Info") {
        BSFormTextField(label: "Name", text: $name, isRequired: true)
        BSFormTextField(label: "Email", text: $email, keyboardType: .emailAddress)
    }
    BSFormActions(primaryTitle: "Save", primaryAction: save)
}
```

**List Pattern:**
```swift
BSListTemplate(items: items, emptyState: .noData()) { item in
    BSListItem(title: item.title, leadingIcon: "star", showsChevron: true)
}
```

**Loading Pattern:**
```swift
if isLoading {
    BSSkeletonCard()
    BSSkeletonListItem()
} else {
    // Actual content
}
```

---

## ShowCase App

Complete demo app in `Example/ShowCaseApp/` with interactive examples of all components.

```
Example/ShowCaseApp/
├── Features/
│   ├── Home/              # Overview
│   └── Components/
│       ├── Atoms/         # All atoms
│       ├── Molecules/     # All molecules
│       ├── Organisms/     # All organisms
│       ├── Templates/     # All templates
│       └── Extras/        # New components
```

---

## Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing`)
5. Open Pull Request

---

## License

MIT License - see [LICENSE](LICENSE) file.

---

Built with ❤️ using SwiftUI
