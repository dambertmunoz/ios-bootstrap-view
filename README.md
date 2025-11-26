# BootstrapUI

<p align="center">
  <img src="docs/images/logo.png" alt="BootstrapUI Logo" width="200"/>
</p>

<p align="center">
  <strong>A comprehensive SwiftUI component library following Atomic Design principles</strong>
</p>

<p align="center">
  <a href="#installation">Installation</a> •
  <a href="#quick-start">Quick Start</a> •
  <a href="#components">Components</a> •
  <a href="#documentation">Documentation</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Swift-5.9+-orange.svg" alt="Swift 5.9+"/>
  <img src="https://img.shields.io/badge/iOS-15.0+-blue.svg" alt="iOS 15.0+"/>
  <img src="https://img.shields.io/badge/SwiftUI-100%25-green.svg" alt="SwiftUI"/>
  <img src="https://img.shields.io/badge/License-MIT-lightgrey.svg" alt="MIT License"/>
</p>

---

## Overview

Build beautiful, consistent iOS applications with ease using BootstrapUI - a comprehensive SwiftUI component library following Atomic Design principles.

<!-- TODO: Add hero image showcasing the library -->
<!-- ![BootstrapUI Showcase](docs/images/showcase.png) -->

### Features

- 🎨 **Atomic Design Architecture** - Components organized as Atoms, Molecules, Organisms, and Templates
- 🌓 **Comprehensive Theming** - Full theme system with light/dark modes and custom theme support
- 📱 **100% SwiftUI** - Pure SwiftUI implementation
- ✅ **Type-Safe** - Leverages Swift's type system for compile-time safety
- ♿ **Accessible** - Built with accessibility in mind
- 📚 **Well Documented** - Extensive documentation and code examples
- 🧪 **Unit Tested** - Comprehensive test coverage

---

## Screenshots

### Theme System

| Light Mode | Dark Mode |
|:----------:|:---------:|
| ![Light Theme](docs/images/theme-light.png) | ![Dark Theme](docs/images/theme-dark.png) |

### Atoms

| Component | Preview |
|-----------|---------|
| **BSButton** - Multiple styles and sizes | ![Buttons](docs/images/atoms/buttons.png) |
| **BSText** - Typography system | ![Text](docs/images/atoms/text.png) |
| **BSTextField** - Input fields with validation | ![TextField](docs/images/atoms/textfield.png) |
| **BSIcon** - SF Symbols with various sizes | ![Icons](docs/images/atoms/icons.png) |
| **BSToggle** - Switch, checkbox, radio | ![Toggles](docs/images/atoms/toggles.png) |
| **BSDivider** - Separators and dividers | ![Dividers](docs/images/atoms/dividers.png) |
| **BSBadge** - Badges and status indicators | ![Badges](docs/images/atoms/badges.png) |
| **BSAvatar** - User avatars with status | ![Avatars](docs/images/atoms/avatars.png) |

### Molecules

| Component | Preview |
|-----------|---------|
| **BSInputField** - Enhanced input with validation | ![InputField](docs/images/molecules/inputfield.png) |
| **BSSearchBar** - Search with scopes | ![SearchBar](docs/images/molecules/searchbar.png) |
| **BSCard** - Card containers | ![Cards](docs/images/molecules/cards.png) |
| **BSListItem** - List items with actions | ![ListItems](docs/images/molecules/listitems.png) |
| **BSAlert** - Alerts and banners | ![Alerts](docs/images/molecules/alerts.png) |
| **BSToast** - Toast notifications | ![Toasts](docs/images/molecules/toasts.png) |

### Organisms

| Component | Preview |
|-----------|---------|
| **BSForm** - Complete form system | ![Form](docs/images/organisms/form.png) |
| **BSHeader** - Page and section headers | ![Headers](docs/images/organisms/headers.png) |
| **BSNavigation** - Nav bars and tab bars | ![Navigation](docs/images/organisms/navigation.png) |
| **BSModal** - Modals and bottom sheets | ![Modals](docs/images/organisms/modals.png) |

### Templates

| Template | Preview |
|----------|---------|
| **BSPageTemplate** - Basic page layouts | ![Page](docs/images/templates/page.png) |
| **BSListTemplate** - List page layouts | ![List](docs/images/templates/list.png) |
| **BSDetailTemplate** - Detail page layouts | ![Detail](docs/images/templates/detail.png) |

---

## Requirements

- iOS 15.0+ / macOS 12.0+ / tvOS 15.0+ / watchOS 8.0+
- Swift 5.9+
- Xcode 15.0+

---

## Installation

### Swift Package Manager

Add BootstrapUI to your project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/dambertmunoz/ios-bootstrap-view.git", from: "1.0.0")
]
```

**Or in Xcode:**

1. Go to **File > Add Package Dependencies...**
2. Enter the repository URL: `https://github.com/dambertmunoz/ios-bootstrap-view.git`
3. Select version and add to your project

---

## Quick Start

### 1. Setup Theme

```swift
import SwiftUI
import BootstrapUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .withTheme() // Apply the theme system
                .withToasts() // Enable toast notifications
        }
    }
}
```

### 2. Use Components

```swift
import SwiftUI
import BootstrapUI

struct ContentView: View {
    @State private var email = ""
    @State private var isEnabled = false
    @Environment(\.theme) var theme

    var body: some View {
        VStack(spacing: theme.md) {
            BSText("Welcome", style: .largeTitle, weight: .bold)

            BSInputField(
                label: "Email",
                text: $email,
                placeholder: "Enter your email",
                icon: "envelope",
                isRequired: true
            )

            BSToggle("Enable notifications", isOn: $isEnabled)

            BSButton("Continue", style: .primary, isFullWidth: true) {
                BSToastManager.shared.success("Welcome!")
            }
        }
        .padding(theme.md)
    }
}
```

---

## Architecture

BootstrapUI follows the **Atomic Design** methodology:

```
BootstrapUI/
├── Theme/           # 🎨 Theming system (colors, typography, spacing)
├── Atoms/           # ⚛️  Basic building blocks
├── Molecules/       # 🔬 Combinations of atoms
├── Organisms/       # 🦠 Complex UI components
├── Templates/       # 📄 Page-level layouts
├── Extensions/      # 🔧 SwiftUI extensions
└── Utilities/       # 🛠️  Helper utilities
```

---

## Components Reference

### Theme System

Configure your app's visual appearance:

```swift
// Use default themes
ThemeManager.shared.setTheme(.light)
ThemeManager.shared.setTheme(.dark)

// Toggle theme
ThemeManager.shared.toggleTheme()

// Create custom theme using Builder pattern
let customTheme = ThemeBuilder()
    .name("Brand")
    .primary(Color(hex: "#FF5722"))
    .secondary(Color(hex: "#03A9F4"))
    .background(.white)
    .build()

BootstrapUI.configure(with: customTheme)
```

#### Design Tokens

| Token Type | Examples |
|------------|----------|
| **Colors** | `primary`, `secondary`, `background`, `surface`, `error`, `success`, `warning` |
| **Typography** | `largeTitle`, `title1`, `headline`, `body`, `caption1` |
| **Spacing** | `xxs (2)`, `xs (4)`, `sm (8)`, `md (16)`, `lg (24)`, `xl (32)` |
| **Border Radius** | `radiusSm (4)`, `radiusMd (8)`, `radiusLg (12)`, `radiusFull (9999)` |
| **Shadows** | `shadowSm`, `shadowMd`, `shadowLg`, `shadowXl` |

---

### Atoms

#### BSButton

<!-- ![BSButton Variants](docs/images/atoms/button-variants.png) -->

```swift
// Styles
BSButton("Primary", style: .primary) { }
BSButton("Secondary", style: .secondary) { }
BSButton("Outline", style: .outline) { }
BSButton("Ghost", style: .ghost) { }
BSButton("Destructive", style: .destructive) { }
BSButton("Success", style: .success) { }
BSButton("Link", style: .link) { }

// Sizes
BSButton("Small", style: .primary, size: .small) { }
BSButton("Medium", style: .primary, size: .medium) { }
BSButton("Large", style: .primary, size: .large) { }

// With icon
BSButton("Save", style: .primary, icon: "checkmark") { }
BSButton("Next", style: .primary, icon: "arrow.right", iconPosition: .trailing) { }

// States
BSButton("Loading", style: .primary, isLoading: true) { }
BSButton("Disabled", style: .primary, isDisabled: true) { }
BSButton("Full Width", style: .primary, isFullWidth: true) { }

// Icon button
BSIconButton(icon: "heart.fill", style: .primary) { }
```

#### BSText

<!-- ![BSText Styles](docs/images/atoms/text-styles.png) -->

```swift
// Typography styles
BSText("Large Title", style: .largeTitle)
BSText("Title 1", style: .title1)
BSText("Headline", style: .headline)
BSText("Body", style: .body)
BSText("Caption", style: .caption1)

// Colors
BSText("Primary", style: .body, color: .primary)
BSText("Secondary", style: .body, color: .secondary)
BSText("Error", style: .body, color: .error)
BSText("Success", style: .body, color: .success)

// Weights
BSText("Bold", style: .body, weight: .bold)
BSText("Semibold", style: .body, weight: .semibold)

// Label with icon
BSLabel("Settings", icon: "gear")
```

#### BSTextField

<!-- ![BSTextField States](docs/images/atoms/textfield-states.png) -->

```swift
// Basic
BSTextField("Email", text: $email, placeholder: "you@example.com", icon: "envelope")

// Styles
BSTextField("Outlined", text: $text, style: .outlined)
BSTextField("Filled", text: $text, style: .filled)
BSTextField("Underlined", text: $text, style: .underlined)

// States
BSTextField("Success", text: $text, state: .success)
BSTextField("Error", text: $text, state: .error("Invalid input"))
BSTextField("Disabled", text: $text, state: .disabled)

// Password
BSTextField("Password", text: $password, isSecure: true)

// Text area
BSTextArea("Description", text: $description, placeholder: "Enter description...")
```

#### BSIcon

<!-- ![BSIcon Sizes](docs/images/atoms/icon-sizes.png) -->

```swift
// Sizes
BSIcon("star.fill", size: .xs)  // 12pt
BSIcon("star.fill", size: .sm)  // 16pt
BSIcon("star.fill", size: .md)  // 20pt
BSIcon("star.fill", size: .lg)  // 24pt
BSIcon("star.fill", size: .xl)  // 32pt
BSIcon("star.fill", size: .xxl) // 48pt

// Colors
BSIcon("heart.fill", size: .lg, color: .red)

// Circular icon
BSCircularIcon("person.fill", size: .md)

// Icon with badge
BSIconWithBadge("bell.fill", badgeCount: 5)
```

#### BSToggle

<!-- ![BSToggle Types](docs/images/atoms/toggle-types.png) -->

```swift
// Switch
BSToggle("Enable feature", isOn: $isEnabled)

// Checkbox
BSToggle("Accept terms", isOn: $accepted, style: .checkbox)

// Radio
BSToggle("Option A", isOn: $selected, style: .radio)

// Custom color
BSToggle("Custom", isOn: $isOn, onColor: .green)

// Toggle group (radio buttons)
BSToggleGroup(
    options: ["Option A", "Option B", "Option C"],
    selected: $selectedOption,
    labelProvider: { $0 }
)

// Checkbox list (multiple selection)
BSCheckboxList(
    options: features,
    selected: $selectedFeatures,
    labelProvider: { $0.name }
)
```

#### BSBadge

<!-- ![BSBadge Variants](docs/images/atoms/badge-variants.png) -->

```swift
// Variants
BSBadge("Filled", variant: .filled)
BSBadge("Outlined", variant: .outlined)
BSBadge("Subtle", variant: .subtle)

// Colors
BSBadge("Primary", color: .primary)
BSBadge("Success", color: .success)
BSBadge("Error", color: .error)
BSBadge("Warning", color: .warning)

// With icon
BSBadge("New", icon: "sparkles")

// Dot badge
BSDotBadge(color: .success)
BSDotBadge(color: .error, isPulsing: true)

// Count badge
BSCountBadge(5)
BSCountBadge(99)
BSCountBadge(150) // Shows "99+"

// Status badge
BSStatusBadge(.active)
BSStatusBadge(.pending)
BSStatusBadge(.failed)
```

#### BSAvatar

<!-- ![BSAvatar Variants](docs/images/atoms/avatar-variants.png) -->

```swift
// Sizes
BSAvatar(initials: "JD", size: .sm)
BSAvatar(initials: "JD", size: .md)
BSAvatar(initials: "JD", size: .lg)
BSAvatar(initials: "JD", size: .xl)

// Types
BSAvatar(initials: "JD", size: .lg)
BSAvatar(imageURL: url, size: .lg)
BSAvatar(icon: "person.fill", size: .lg)

// Shapes
BSAvatar(initials: "JD", size: .lg, shape: .circle)
BSAvatar(initials: "JD", size: .lg, shape: .rounded)
BSAvatar(initials: "JD", size: .lg, shape: .square)

// With status
BSAvatar(initials: "JD", size: .lg, status: .online)
BSAvatar(initials: "JD", size: .lg, status: .offline)
BSAvatar(initials: "JD", size: .lg, status: .busy)
BSAvatar(initials: "JD", size: .lg, status: .away)

// Avatar group
BSAvatarGroup(avatars: avatarData, size: .md, maxVisible: 4)
```

---

### Molecules

#### BSInputField

<!-- ![BSInputField](docs/images/molecules/inputfield-example.png) -->

```swift
BSInputField(
    label: "Email Address",
    text: $email,
    placeholder: "you@example.com",
    helperText: "We'll never share your email",
    validation: emailValidation,
    icon: "envelope",
    isRequired: true,
    characterLimit: 50
)

// Password field with strength indicator
BSPasswordField(
    text: $password,
    showStrengthIndicator: true
)
```

#### BSSearchBar

<!-- ![BSSearchBar](docs/images/molecules/searchbar-example.png) -->

```swift
// Basic
BSSearchBar(text: $searchText, placeholder: "Search...")

// With filter button
BSSearchBar(text: $searchText, showsFilterButton: true) {
    // Filter action
}

// Scoped search
BSScopedSearchBar(
    text: $searchText,
    selectedScope: $selectedScope,
    scopes: ["All", "Images", "Videos", "Documents"],
    scopeTitle: { $0 }
)
```

#### BSCard

<!-- ![BSCard Variants](docs/images/molecules/card-variants.png) -->

```swift
// Variants
BSCard { content }                    // Elevated (default)
BSCard(variant: .outlined) { content }
BSCard(variant: .filled) { content }

// Interactive
BSCard(isInteractive: true, onTap: { }) {
    // Content
}

// Action card
BSActionCard(
    title: "Premium Plan",
    subtitle: "Unlock all features",
    icon: "crown.fill",
    primaryAction: ("Upgrade", { }),
    secondaryAction: ("Learn More", { })
)

// Image card
BSImageCard(imageURL: url, imageHeight: 200) {
    BSText("Card Title", style: .headline)
}
```

#### BSListItem

<!-- ![BSListItem](docs/images/molecules/listitem-example.png) -->

```swift
// Basic
BSListItem(
    title: "Profile",
    subtitle: "View and edit your profile",
    leadingIcon: "person.circle.fill",
    showsChevron: true
) { }

// With badge
BSListItem(
    title: "Notifications",
    leadingIcon: "bell.fill",
    badge: "3",
    showsChevron: true
)

// With trailing text
BSListItem(
    title: "Storage",
    leadingIcon: "externaldrive.fill",
    trailingText: "2.5 GB"
)

// Toggle list item
BSToggleListItem(
    title: "Dark Mode",
    icon: "moon.fill",
    isOn: $isDarkMode
)

// Destructive
BSListItem(
    title: "Delete Account",
    leadingIcon: "trash.fill",
    isDestructive: true
)
```

#### BSAlert

<!-- ![BSAlert Types](docs/images/molecules/alert-types.png) -->

```swift
// Types
BSAlert(type: .info, message: "Informational message")
BSAlert(type: .success, message: "Success message")
BSAlert(type: .warning, message: "Warning message")
BSAlert(type: .error, message: "Error message")

// With title
BSAlert(type: .warning, title: "Warning", message: "Check your input")

// With action
BSAlert(
    type: .error,
    title: "Connection Error",
    message: "Unable to connect",
    action: ("Retry", { })
)

// Banner
BSBanner(type: .info, message: "New version available!", action: ("Update", { }))

// Empty state
BSEmptyState(
    icon: "tray",
    title: "No Items",
    message: "Add your first item",
    action: ("Add Item", { })
)
```

#### BSToast

<!-- ![BSToast](docs/images/molecules/toast-example.png) -->

```swift
// Show toasts
BSToastManager.shared.info("Info message")
BSToastManager.shared.success("Success!")
BSToastManager.shared.warning("Warning!")
BSToastManager.shared.error("Error occurred")

// With action
BSToastManager.shared.show(BSToastData(
    type: .error,
    message: "Failed to save",
    action: .init(title: "Retry") { }
))

// Enable in your app
ContentView()
    .withToasts()
    .withToasts(position: .top) // or .bottom
```

---

### Organisms

#### BSForm

<!-- ![BSForm](docs/images/organisms/form-example.png) -->

```swift
BSForm {
    BSFormSection(title: "Personal Information", footer: "Your name will be visible") {
        BSFormTextField(label: "First Name", text: $firstName, isRequired: true)
        BSFormTextField(label: "Last Name", text: $lastName)
        BSFormTextField(label: "Email", text: $email, keyboardType: .emailAddress)
    }

    BSFormSection(title: "Preferences") {
        BSFormToggle(label: "Notifications", isOn: $notifications)
        BSFormPicker(
            label: "Language",
            selection: $language,
            options: ["English", "Spanish", "French"],
            optionLabel: { $0 }
        )
        BSFormDatePicker(label: "Birthday", date: $birthday)
        BSFormStepper(label: "Quantity", value: $quantity, range: 1...10)
    }

    BSFormActions(
        primaryTitle: "Save",
        primaryAction: { },
        secondaryTitle: "Cancel",
        secondaryAction: { },
        isLoading: isSaving
    )
}
```

#### BSNavigation

<!-- ![BSNavigation](docs/images/organisms/navigation-example.png) -->

```swift
// Navigation bar
BSNavigationBar(
    title: "Home",
    displayMode: .large, // or .inline
    leadingItems: [.init(icon: "line.3.horizontal", action: { })],
    trailingItems: [
        .init(icon: "magnifyingglass", action: { }),
        .init(icon: "bell", badge: 3, action: { })
    ]
)

// Tab bar
BSTabBar(selection: $selectedTab, items: [
    .init(id: 0, icon: "house", selectedIcon: "house.fill", title: "Home"),
    .init(id: 1, icon: "magnifyingglass", title: "Search"),
    .init(id: 2, icon: "bell", selectedIcon: "bell.fill", title: "Alerts", badge: 5),
    .init(id: 3, icon: "person", selectedIcon: "person.fill", title: "Profile")
], style: .standard) // .standard, .floating, .minimal
```

#### BSModal

<!-- ![BSModal](docs/images/organisms/modal-example.png) -->

```swift
// Basic modal
BSModal(isPresented: $showModal, size: .medium) {
    VStack {
        BSText("Modal Title", style: .headline)
        BSButton("Close", style: .primary) { showModal = false }
    }
}

// Alert dialog
BSAlertDialog(
    isPresented: $showAlert,
    title: "Save Changes?",
    message: "Do you want to save before leaving?",
    primaryAction: .init(title: "Save") { },
    secondaryAction: .init(title: "Don't Save", style: .ghost) { }
)

// Confirmation dialog
BSConfirmationDialog(
    isPresented: $showConfirm,
    title: "Delete Item?",
    message: "This cannot be undone.",
    confirmTitle: "Delete",
    isDestructive: true,
    onConfirm: { }
)

// Bottom sheet
BSBottomSheet(isPresented: $showSheet, detents: [.medium, .large]) {
    // Sheet content
}
```

---

### Templates

#### BSPageTemplate

<!-- ![BSPageTemplate](docs/images/templates/page-example.png) -->

```swift
// Basic page
BSPageTemplate(hasRefresh: true) {
    BSNavigationBar(title: "Home")
} content: {
    // Page content
} onRefresh: {
    await loadData()
}

// Stateful page (loading/error/empty states)
BSStatefulPageTemplate(state: loadingState, onRetry: { }) {
    // Content when loaded
}

// Sticky header page
BSStickyHeaderPage(headerHeight: 60) {
    BSPageHeader(title: "Sticky")
} content: {
    // Scrollable content
}
```

#### BSListTemplate

<!-- ![BSListTemplate](docs/images/templates/list-example.png) -->

```swift
// Basic list
BSListTemplate(
    items: items,
    emptyState: .init(title: "No Items", message: "Add your first item")
) { item in
    BSListItem(title: item.title)
}

// Search list
BSSearchListTemplate(
    searchText: $searchText,
    items: items,
    filterPredicate: { item, query in
        item.title.contains(query)
    }
) { item in
    BSListItem(title: item.title)
}

// Grid list
BSGridListTemplate(items: items, columns: 2) { item in
    BSCard { BSText(item.title) }
}
```

#### BSDetailTemplate

<!-- ![BSDetailTemplate](docs/images/templates/detail-example.png) -->

```swift
// Basic detail
BSDetailTemplate(navigationTitle: "Details") {
    // Header
} content: {
    // Content
} footer: {
    BSButton("Action", style: .primary, isFullWidth: true) { }
}

// Profile detail
BSProfileDetailTemplate(
    name: "John Doe",
    subtitle: "@johndoe",
    avatarInitials: "JD",
    stats: [.init(value: "1.2K", label: "Followers")]
) {
    // Content
} actions: {
    BSButton("Follow", style: .primary) { }
}

// Product detail
BSProductDetailTemplate(title: "Product", price: "$99") {
    // Gallery
} info: {
    // Info
} actions: {
    BSButton("Add to Cart", style: .primary) { }
}
```

---

## Validation

Built-in validation system using Strategy Pattern:

```swift
// Single rule
let emailRule = BSEmailRule()
let result = emailRule.validate(email) // .valid, .invalid("message"), or .none

// Combine multiple rules
let validator = BSValidator(rules: [
    BSRequiredRule(),
    BSEmailRule(),
    BSMinLengthRule(minLength: 5)
])

let validation = validator.validate(input)
if validation.isInvalid {
    print(validation.errorMessage ?? "Invalid")
}
```

### Available Rules

| Rule | Description |
|------|-------------|
| `BSRequiredRule` | Field must not be empty |
| `BSEmailRule` | Valid email format |
| `BSMinLengthRule` | Minimum character length |
| `BSMaxLengthRule` | Maximum character length |
| `BSPhoneRule` | Valid phone number format |
| `BSURLRule` | Valid URL format |
| `BSPasswordRule` | Password strength (configurable) |
| `BSMatchRule` | Two fields must match |
| `BSRegexRule` | Custom regex pattern |

---

## Utilities

### Haptic Feedback

```swift
BSHapticManager.shared.impact(.light)      // Light tap
BSHapticManager.shared.impact(.medium)     // Medium tap
BSHapticManager.shared.impact(.heavy)      // Heavy tap
BSHapticManager.shared.notification(.success)
BSHapticManager.shared.notification(.error)
BSHapticManager.shared.selection()

// View modifier
Button("Tap") { }
    .withHapticFeedback(.light)
```

### View Extensions

```swift
// Conditional modifiers
view.if(condition) { $0.padding() }
view.ifLet(optionalValue) { view, value in view.overlay(Text(value)) }

// Frame helpers
view.frame(square: 44)
view.fillMaxWidth()
view.fillMaxSize()

// Loading overlay
view.loadingOverlay(isLoading: isLoading, message: "Loading...")

// Keyboard
view.hideKeyboardOnTap()

// Accessibility
view.accessible(label: "Button", hint: "Tap to submit")

// Animation
view.animateOnAppear(delay: 0.2)
```

---

## Example App

Check out the complete ShowCase app in the `Example/` directory:

```
Example/ShowCaseApp/
├── App/                    # App entry and root view
├── Features/
│   ├── Home/              # Home screen
│   └── Components/
│       ├── Atoms/         # Atom showcases
│       ├── Molecules/     # Molecule showcases
│       ├── Organisms/     # Organism showcases
│       └── Templates/     # Template showcases
└── README.md
```

---

## Design Principles

### SOLID Principles

- **S**ingle Responsibility: Each component has one job
- **O**pen/Closed: Extensible without modification
- **L**iskov Substitution: Components are interchangeable
- **I**nterface Segregation: Small, focused protocols
- **D**ependency Inversion: Depend on abstractions

### Design Patterns

| Pattern | Usage |
|---------|-------|
| **Builder** | `ThemeBuilder` for fluent theme configuration |
| **Singleton** | `ThemeManager`, `BSToastManager` for global state |
| **Strategy** | Validation rules |
| **Factory** | Component creation |
| **Template Method** | Page templates |

---

## Adding Screenshots

To add screenshots to this README:

1. Create a `docs/images/` directory in the repository
2. Take screenshots of each component using the ShowCase app
3. Name them according to the structure above
4. Commit the images to the repository

Recommended screenshot sizes:
- Component previews: 400x300 pixels
- Full page screenshots: 390x844 pixels (iPhone 14 Pro)

---

## Contributing

Contributions are welcome! Please read our contributing guidelines before submitting PRs.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## License

MIT License - see [LICENSE](LICENSE) file for details.

---

## Credits

Built with ❤️ using SwiftUI.

**BootstrapUI Team**
