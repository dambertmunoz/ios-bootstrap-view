# BootstrapUI Components Reference

Quick reference for all BootstrapUI components. Use this when building: $ARGUMENTS

## Quick Reference Table

| Category | Components |
|----------|------------|
| **Atoms** | BSButton, BSText, BSTextField, BSIcon, BSToggle, BSDivider, BSBadge, BSAvatar, BSSkeleton, BSChip, BSRating, BSSlider, BSProgressBar, BSSegmentedControl |
| **Molecules** | BSInputField, BSSearchBar, BSCard, BSListItem, BSAlert, BSToast, BSStepIndicator, BSFAB, BSChart, BSDropdown |
| **Organisms** | BSForm, BSHeader, BSNavigation, BSModal, BSSwipeCard, BSBottomSheet, BSTimeline, BSAccordion, BSCarousel |
| **Templates** | BSPageTemplate, BSListTemplate, BSDetailTemplate, BSOnboarding, BSEmptyState |
| **Domain** | BSEcommerce, BSSocial, BSChat, BSThemePicker |

---

## ATOMS

### BSButton
```swift
BSButton("Save", style: .primary) { }
BSButton("Delete", style: .destructive, isLoading: true) { }
BSButton("Settings", style: .outline, icon: "gear") { }
BSIconButton(icon: "heart.fill", style: .primary) { }
// Styles: .primary, .secondary, .outline, .ghost, .destructive, .success, .link
```

### BSTextField
```swift
BSTextField("Email", text: $email, placeholder: "you@example.com", icon: "envelope")
BSTextField("Password", text: $password, isSecure: true)
BSTextField("Error", text: $text, state: .error("Invalid"))
BSTextArea("Description", text: $text, placeholder: "Enter description...")
```

### BSBadge
```swift
BSBadge("New", color: .primary)
BSBadge("5", size: .small, color: .error)
BSCountBadge(99)
```

### BSAvatar
```swift
BSAvatar(name: "John Doe", size: .md)
BSAvatar(imageURL: url, size: .lg)
BSAvatarGroup(names: ["A", "B", "C"], maxDisplay: 3)
```

### BSSkeleton
```swift
BSSkeletonText(lines: 3)
BSSkeletonAvatar(size: .lg)
BSSkeletonCard()
BSSkeletonListItem()
```

### BSChip
```swift
BSChip("Swift", variant: .filled)
BSChipGroup(options: ["iOS", "Android"], selected: $selected)
BSMultiChipGroup(options: tags, selected: $selectedTags)
```

### BSRating
```swift
BSRating(value: $rating)  // Interactive
BSRatingDisplay(value: 4.5, reviewCount: 1234)  // Read-only
```

### BSSlider
```swift
BSSlider(value: $value, showValue: true)
BSRangeSlider(lowerValue: $min, upperValue: $max)
BSDiscreteSlider(selection: $size, options: ["S", "M", "L"])
```

### BSProgressBar
```swift
BSProgressBar(progress: 0.75, showLabel: true)
BSCircularProgress(progress: 0.8)
BSIndeterminateProgress()
BSLoadingSpinner(style: .dots)  // .circular, .dots, .pulse, .bars
```

### BSSegmentedControl
```swift
BSSegmentedControl(selection: $tab, options: ["A", "B", "C"])
BSSegmentedControl(selection: $tab, options: tabs, style: .underlined)
BSIconSegmentedControl(selection: $view, options: [(0, "list.bullet", "List")])
```

---

## MOLECULES

### BSCard
```swift
BSCard { content }
BSCard(variant: .outlined, isInteractive: true) { content }
BSActionCard(title: "Premium", icon: "crown.fill", primaryAction: ("Upgrade", { }))
```

### BSSearchBar
```swift
BSSearchBar(text: $searchText, placeholder: "Search...")
```

### BSAlert
```swift
BSAlert("Success!", message: "Operation completed", type: .success)
BSAlert("Error", message: "Something went wrong", type: .error, isDismissible: true)
```

### BSToast
```swift
BSToastManager.shared.success("Saved!")
BSToastManager.shared.error("Failed")
BSToastManager.shared.info("Loading...")
```

### BSStepIndicator
```swift
BSStepIndicator(steps: ["Account", "Profile", "Review"], currentStep: 1)
BSVerticalStepIndicator(steps: steps, currentStep: currentStep)
```

### BSFAB
```swift
BSFAB(icon: "plus") { }
BSSpeedDialFAB(icon: "plus", actions: [
    .init(icon: "camera.fill", label: "Camera") { }
])
```

### BSChart
```swift
BSBarChart(data: [.init(label: "Jan", value: 120)])
BSLineChart(data: [.init(x: 0, y: 10)])
BSPieChart(slices: [.init(value: 35, label: "iOS", color: .blue)])
```

### BSDropdown
```swift
BSDropdown(selection: $selected, options: items, isSearchable: true)
BSMultiDropdown(selection: $selected, options: items)
```

---

## ORGANISMS

### BSForm
```swift
BSForm {
    BSFormSection(title: "Info") {
        BSFormTextField(label: "Name", text: $name, isRequired: true)
    }
    BSFormActions(primaryTitle: "Save", primaryAction: save)
}
```

### BSBottomSheet
```swift
.bsBottomSheet(isPresented: $show) { content }
.bsActionSheet(isPresented: $show, actions: [...])
.bsConfirmationSheet(isPresented: $show, title: "Delete?", onConfirm: { })
```

### BSTimeline
```swift
BSOrderTimeline(steps: [
    .init(title: "Placed", status: .completed),
    .init(title: "Shipped", status: .current)
])
BSActivityTimeline(activities: [...])
```

### BSAccordion
```swift
BSExpandableSection(title: "FAQ", icon: "questionmark.circle") { content }
BSFAQAccordion(faqs: [.init(question: "Q?", answer: "A")])
BSCollapsibleCard(title: "Details", badge: "3") { content }
```

### BSCarousel
```swift
BSBannerCarousel(banners: [
    .init(title: "Sale", subtitle: "50% off", buttonTitle: "Shop")
])
BSImageCarousel(images: [.init(url: imageURL, caption: "Photo 1")])
```

### BSSwipeCard
```swift
BSSwipeCardStack(cards: cards, onSwipe: { card, direction in }) { card in
    // Card content
}
```

---

## TEMPLATES

### BSEmptyState
```swift
BSEmptyState.noResults(searchTerm: "query")
BSEmptyState.noConnection(onRetry: { })
BSEmptyState.emptyCart(onBrowse: { })
BSEmptyState.error(onRetry: { })
```

### BSOnboarding
```swift
BSOnboardingView(pages: [
    BSOnboardingPage(icon: "star.fill", title: "Welcome", description: "...")
]) { onComplete() }
```

---

## DOMAIN

### E-commerce
```swift
BSProductCard(title: "iPhone", price: 999, rating: 4.8)
BSCartItemRow(title: "Product", price: 99, quantity: 1)
BSOrderSummary(subtotal: 199, shipping: 0, tax: 15.99)
```

### Social
```swift
BSPostCard(author: .init(name: "John"), content: "Hello!", likeCount: 42)
BSComment(author: .init(name: "Jane"), content: "Great!", likeCount: 5)
BSStoriesRow(stories: stories, onTap: { })
```

### Chat
```swift
BSChatBubble(message: "Hello!", isFromCurrentUser: true, timestamp: "10:30")
BSTypingIndicator()
BSMessageInput(text: $message, onSend: { })
```

---

## THEMES

```swift
ThemeManager.shared.setTheme(.dark)
ThemeManager.shared.setTheme(.dracula)

// Available: light, dark, materialLight, materialDark, nordLight, nordDark,
// dracula, solarizedLight, solarizedDark, ocean, forest, sunset, midnight,
// roseLight, monokai, cyberpunk

BSThemePicker(selectedTheme: $theme)
BSThemeSwitcher()  // Light/dark toggle
```

---

## MODIFIERS

```swift
.withTheme()    // Apply theme system
.withToasts()   // Enable toast notifications
.bsPullToRefresh { await refresh() }
```

Use these components to build the requested interface.
