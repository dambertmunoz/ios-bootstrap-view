# BootstrapUI

A comprehensive SwiftUI component library following Atomic Design principles. Build beautiful, consistent iOS applications with ease.

## Features

- **Atomic Design Architecture** - Components organized as Atoms, Molecules, Organisms, and Templates
- **Comprehensive Theming** - Full theme system with light/dark modes and custom theme support
- **100% SwiftUI** - Pure SwiftUI implementation, no UIKit dependencies in components
- **Type-Safe** - Leverages Swift's type system for compile-time safety
- **Accessible** - Built with accessibility in mind
- **Well Documented** - Extensive documentation and code examples
- **Unit Tested** - Comprehensive test coverage

## Requirements

- iOS 15.0+
- macOS 12.0+
- tvOS 15.0+
- watchOS 8.0+
- Swift 5.9+

## Installation

### Swift Package Manager

Add BootstrapUI to your project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/your-org/ios-bootstrap-view.git", from: "1.0.0")
]
```

Or in Xcode:
1. File > Add Packages...
2. Enter the repository URL
3. Select the version and add to your project

## Quick Start

### Basic Setup

```swift
import SwiftUI
import BootstrapUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .withTheme() // Apply the theme system
        }
    }
}
```

### Using Components

```swift
import SwiftUI
import BootstrapUI

struct ContentView: View {
    @State private var email = ""
    @State private var isEnabled = false

    var body: some View {
        VStack(spacing: 16) {
            BSText("Welcome", style: .largeTitle, weight: .bold)

            BSInputField(
                label: "Email",
                text: $email,
                placeholder: "Enter your email",
                icon: "envelope"
            )

            BSToggle("Enable notifications", isOn: $isEnabled)

            BSButton("Continue", style: .primary, isFullWidth: true) {
                // Action
            }
        }
        .padding()
    }
}
```

## Architecture

BootstrapUI follows the Atomic Design methodology:

```
BootstrapUI/
├── Theme/           # Theming system
├── Atoms/           # Basic building blocks
├── Molecules/       # Combinations of atoms
├── Organisms/       # Complex UI components
├── Templates/       # Page-level layouts
├── Extensions/      # SwiftUI extensions
└── Utilities/       # Helper utilities
```

## Components

### Theme System

Configure your app's visual appearance:

```swift
// Use default themes
ThemeManager.shared.setTheme(.light)
ThemeManager.shared.setTheme(.dark)

// Create custom theme
let customTheme = ThemeBuilder()
    .name("Brand")
    .primary(Color(hex: "#FF5722"))
    .secondary(Color(hex: "#03A9F4"))
    .build()

BootstrapUI.configure(with: customTheme)
```

### Atoms

Basic UI building blocks:

#### BSButton
```swift
BSButton("Primary", style: .primary) { }
BSButton("With Icon", style: .secondary, icon: "star.fill") { }
BSButton("Loading", style: .primary, isLoading: true) { }
BSButton("Full Width", style: .primary, isFullWidth: true) { }
```

#### BSText
```swift
BSText("Headline", style: .headline)
BSText("Body text", style: .body, color: .secondary)
BSText("Bold text", style: .body, weight: .bold)
```

#### BSTextField
```swift
BSTextField("Email", text: $email, placeholder: "you@example.com", icon: "envelope")
BSTextField("Password", text: $password, isSecure: true)
```

#### BSIcon
```swift
BSIcon("star.fill", size: .lg, color: .yellow)
BSCircularIcon("person.fill", size: .md)
BSIconWithBadge("bell.fill", badgeCount: 5)
```

#### BSToggle
```swift
BSToggle("Switch", isOn: $isOn)
BSToggle("Checkbox", isOn: $checked, style: .checkbox)
BSToggle("Radio", isOn: $selected, style: .radio)
```

#### BSAvatar
```swift
BSAvatar(initials: "JD", size: .lg)
BSAvatar(imageURL: url, size: .md, status: .online)
BSAvatarGroup(avatars: avatarData)
```

#### BSBadge
```swift
BSBadge("New", color: .primary)
BSBadge("Error", variant: .filled, color: .error)
BSStatusBadge(.active)
```

### Molecules

Combinations of atoms:

#### BSInputField
```swift
BSInputField(
    label: "Email",
    text: $email,
    placeholder: "Enter email",
    helperText: "We'll never share your email",
    validation: .valid,
    icon: "envelope"
)
```

#### BSSearchBar
```swift
BSSearchBar(text: $searchText, placeholder: "Search...")
BSScopedSearchBar(text: $text, selectedScope: $scope, scopes: scopes)
```

#### BSCard
```swift
BSCard {
    VStack {
        BSText("Card Title", style: .headline)
        BSText("Card content", style: .body)
    }
}

BSActionCard(
    title: "Action Card",
    subtitle: "With actions",
    primaryAction: ("Confirm", { }),
    secondaryAction: ("Cancel", { })
)
```

#### BSListItem
```swift
BSListItem(
    title: "Settings",
    subtitle: "App preferences",
    leadingIcon: "gear",
    showsChevron: true
) { }
```

#### BSAlert
```swift
BSAlert(type: .warning, title: "Warning", message: "Check your input")
BSBanner(type: .info, message: "New update available")
```

#### BSToast
```swift
// Using the toast manager
BSToastManager.shared.success("Operation completed")
BSToastManager.shared.error("Something went wrong")

// In your view
ContentView()
    .withToasts()
```

### Organisms

Complex UI components:

#### BSForm
```swift
BSForm {
    BSFormSection(title: "Personal Info") {
        BSFormTextField(label: "Name", text: $name)
        BSFormTextField(label: "Email", text: $email)
    }

    BSFormSection(title: "Preferences") {
        BSFormToggle(label: "Notifications", isOn: $notifications)
        BSFormPicker(label: "Language", selection: $language, options: languages)
    }

    BSFormActions(
        primaryTitle: "Save",
        primaryAction: save,
        secondaryTitle: "Cancel",
        secondaryAction: cancel
    )
}
```

#### BSNavigationBar
```swift
BSNavigationBar(
    title: "Home",
    displayMode: .large,
    leadingItems: [.init(icon: "line.3.horizontal", action: { })],
    trailingItems: [.init(icon: "bell", action: { })]
)
```

#### BSTabBar
```swift
BSTabBar(selection: $selectedTab, items: [
    .init(id: 0, icon: "house", title: "Home"),
    .init(id: 1, icon: "magnifyingglass", title: "Search"),
    .init(id: 2, icon: "person", title: "Profile")
])
```

#### BSModal
```swift
BSModal(isPresented: $showModal) {
    VStack {
        BSText("Modal Content", style: .headline)
        BSButton("Close", style: .primary) {
            showModal = false
        }
    }
}

BSBottomSheet(isPresented: $showSheet, detents: [.medium, .large]) {
    // Sheet content
}
```

### Templates

Page-level layouts:

#### BSPageTemplate
```swift
BSPageTemplate {
    BSNavigationBar(title: "Home")
} content: {
    // Page content
}
```

#### BSListTemplate
```swift
BSListTemplate(
    items: items,
    emptyState: .init(title: "No Items", message: "Add your first item")
) { item in
    BSListItem(title: item.title)
}
```

#### BSDetailTemplate
```swift
BSDetailTemplate(navigationTitle: "Details") {
    // Header
} content: {
    // Content
} footer: {
    BSButton("Action", style: .primary) { }
}
```

## Validation

Built-in validation system:

```swift
// Single rule
let emailRule = BSEmailRule()
let result = emailRule.validate(email)

// Multiple rules
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

Available rules:
- `BSRequiredRule` - Non-empty validation
- `BSEmailRule` - Email format validation
- `BSMinLengthRule` - Minimum length validation
- `BSMaxLengthRule` - Maximum length validation
- `BSPhoneRule` - Phone number format
- `BSURLRule` - URL format validation
- `BSPasswordRule` - Password strength validation
- `BSMatchRule` - Field matching validation
- `BSRegexRule` - Custom regex validation

## Haptic Feedback

```swift
// Impact feedback
BSHapticManager.shared.impact(.medium)

// Notification feedback
BSHapticManager.shared.notification(.success)

// Selection feedback
BSHapticManager.shared.selection()

// View modifier
Button("Tap") { }
    .withHapticFeedback(.light)
```

## View Extensions

Useful SwiftUI extensions:

```swift
// Conditional modifiers
view.if(condition) { $0.padding() }

// Frame helpers
view.frame(square: 44)
view.fillMaxWidth()

// Loading overlay
view.loadingOverlay(isLoading: isLoading)

// Keyboard dismissal
view.hideKeyboardOnTap()
```

## Design Principles

This library follows:

- **SOLID Principles**
  - Single Responsibility: Each component has one job
  - Open/Closed: Extensible without modification
  - Liskov Substitution: Components are interchangeable
  - Interface Segregation: Small, focused protocols
  - Dependency Inversion: Depend on abstractions

- **Design Patterns**
  - Builder Pattern: ThemeBuilder for fluent configuration
  - Singleton Pattern: ThemeManager for global state
  - Strategy Pattern: Validation rules
  - Factory Pattern: Component creation
  - Template Method: Page templates

## Contributing

Contributions are welcome! Please read our contributing guidelines before submitting PRs.

## License

MIT License - see LICENSE file for details.

## Credits

Built with SwiftUI by the BootstrapUI Team.
