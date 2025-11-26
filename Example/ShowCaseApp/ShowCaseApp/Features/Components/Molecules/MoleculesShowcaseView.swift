// MoleculesShowcaseView.swift
// ShowCaseApp
//
// Showcase for all Molecule components

import SwiftUI
import BootstrapUI

struct MoleculesShowcaseView: View {
    @Environment(\.theme) var theme

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: theme.lg) {
                    ComponentLinkCard(
                        title: "BSInputField",
                        description: "Enhanced input fields with validation and helper text",
                        icon: "rectangle.and.pencil.and.ellipsis"
                    ) {
                        InputFieldShowcaseView()
                    }

                    ComponentLinkCard(
                        title: "BSSearchBar",
                        description: "Search bars with scope and suggestions",
                        icon: "magnifyingglass"
                    ) {
                        SearchBarShowcaseView()
                    }

                    ComponentLinkCard(
                        title: "BSCard",
                        description: "Card containers with various styles",
                        icon: "rectangle.portrait.on.rectangle.portrait"
                    ) {
                        CardShowcaseView()
                    }

                    ComponentLinkCard(
                        title: "BSListItem",
                        description: "List items with icons, badges, and actions",
                        icon: "list.bullet"
                    ) {
                        ListItemShowcaseView()
                    }

                    ComponentLinkCard(
                        title: "BSAlert",
                        description: "Inline alerts, banners, and empty states",
                        icon: "exclamationmark.triangle"
                    ) {
                        AlertShowcaseView()
                    }

                    ComponentLinkCard(
                        title: "BSToast",
                        description: "Toast notifications with different types",
                        icon: "bell.badge"
                    ) {
                        ToastShowcaseView()
                    }
                }
                .padding(theme.md)
            }
            .background(theme.background)
            .navigationTitle("Molecules")
        }
    }
}

// MARK: - Input Field Showcase

struct InputFieldShowcaseView: View {
    @State private var email = ""
    @State private var emailValidation: BSInputValidation = .none
    @State private var password = ""
    @State private var bio = ""

    @Environment(\.theme) var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.xl) {
                ShowcaseSection(title: "Basic Input Field") {
                    BSInputField(
                        label: "Email Address",
                        text: $email,
                        placeholder: "you@example.com",
                        helperText: "We'll never share your email",
                        icon: "envelope",
                        isRequired: true
                    )
                }

                ShowcaseSection(title: "Validation States") {
                    VStack(spacing: theme.md) {
                        BSInputField(
                            label: "Valid Input",
                            text: .constant("john@example.com"),
                            validation: .valid,
                            icon: "envelope"
                        )

                        BSInputField(
                            label: "Invalid Input",
                            text: .constant("invalid"),
                            validation: .invalid("Please enter a valid email address"),
                            icon: "envelope"
                        )
                    }
                }

                ShowcaseSection(title: "With Character Limit") {
                    BSInputField(
                        label: "Username",
                        text: $bio,
                        placeholder: "Enter username",
                        helperText: "Choose a unique username",
                        characterLimit: 20
                    )
                }

                ShowcaseSection(title: "Password Field") {
                    BSPasswordField(
                        text: $password,
                        showStrengthIndicator: true
                    )
                }
            }
            .padding(theme.md)
        }
        .background(theme.background)
        .navigationTitle("BSInputField")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Search Bar Showcase

struct SearchBarShowcaseView: View {
    @State private var searchText = ""
    @State private var searchText2 = ""
    @State private var selectedScope = "All"

    @Environment(\.theme) var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.xl) {
                ShowcaseSection(title: "Basic Search Bar") {
                    BSSearchBar(text: $searchText, placeholder: "Search...")
                }

                ShowcaseSection(title: "With Filter Button") {
                    BSSearchBar(
                        text: $searchText,
                        placeholder: "Search products...",
                        showsFilterButton: true
                    ) {
                        BSToastManager.shared.info("Filter tapped")
                    }
                }

                ShowcaseSection(title: "Loading State") {
                    BSSearchBar(
                        text: .constant("Searching..."),
                        isLoading: true
                    )
                }

                ShowcaseSection(title: "Scoped Search") {
                    BSScopedSearchBar(
                        text: $searchText2,
                        selectedScope: $selectedScope,
                        scopes: ["All", "Images", "Videos", "Documents"],
                        scopeTitle: { $0 }
                    )
                }
            }
            .padding(theme.md)
        }
        .background(theme.background)
        .navigationTitle("BSSearchBar")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Card Showcase

struct CardShowcaseView: View {
    @Environment(\.theme) var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.xl) {
                ShowcaseSection(title: "Card Variants") {
                    VStack(spacing: theme.md) {
                        BSCard {
                            VStack(alignment: .leading, spacing: theme.xs) {
                                BSText("Elevated Card", style: .headline)
                                BSText("This is the default card style with shadow.", style: .body, color: .secondary)
                            }
                        }

                        BSCard(variant: .outlined) {
                            VStack(alignment: .leading, spacing: theme.xs) {
                                BSText("Outlined Card", style: .headline)
                                BSText("Card with border outline.", style: .body, color: .secondary)
                            }
                        }

                        BSCard(variant: .filled) {
                            VStack(alignment: .leading, spacing: theme.xs) {
                                BSText("Filled Card", style: .headline)
                                BSText("Card with filled background.", style: .body, color: .secondary)
                            }
                        }
                    }
                }

                ShowcaseSection(title: "Interactive Card") {
                    BSCard(isInteractive: true) {
                        HStack {
                            BSText("Tap me!", style: .headline)
                            Spacer()
                            BSIcon("chevron.right", size: .sm, color: .gray)
                        }
                    } onTap: {
                        BSToastManager.shared.info("Card tapped!")
                    }
                }

                ShowcaseSection(title: "Action Card") {
                    BSActionCard(
                        title: "Premium Plan",
                        subtitle: "Unlock all features",
                        icon: "crown.fill",
                        primaryAction: ("Upgrade", {
                            BSToastManager.shared.success("Upgraded!")
                        }),
                        secondaryAction: ("Learn More", {})
                    )
                }
            }
            .padding(theme.md)
        }
        .background(theme.background)
        .navigationTitle("BSCard")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - List Item Showcase

struct ListItemShowcaseView: View {
    @State private var notificationsEnabled = true
    @State private var darkMode = false

    @Environment(\.theme) var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.xl) {
                ShowcaseSection(title: "Basic List Items") {
                    VStack(spacing: 0) {
                        BSListItem(
                            title: "Profile",
                            subtitle: "View and edit your profile",
                            leadingIcon: "person.circle.fill",
                            showsChevron: true
                        )

                        BSListItem(
                            title: "Notifications",
                            leadingIcon: "bell.fill",
                            badge: "3",
                            showsChevron: true
                        )

                        BSListItem(
                            title: "Storage",
                            leadingIcon: "externaldrive.fill",
                            trailingText: "2.5 GB",
                            showsChevron: true,
                            showsDivider: false
                        )
                    }
                    .background(theme.surface)
                    .cornerRadius(theme.radiusMd)
                }

                ShowcaseSection(title: "Toggle List Items") {
                    VStack(spacing: 0) {
                        BSToggleListItem(
                            title: "Notifications",
                            subtitle: "Receive push notifications",
                            icon: "bell.fill",
                            isOn: $notificationsEnabled
                        )
                        BSDivider()
                        BSToggleListItem(
                            title: "Dark Mode",
                            icon: "moon.fill",
                            isOn: $darkMode
                        )
                    }
                    .background(theme.surface)
                    .cornerRadius(theme.radiusMd)
                }

                ShowcaseSection(title: "Destructive Item") {
                    BSListItem(
                        title: "Delete Account",
                        leadingIcon: "trash.fill",
                        isDestructive: true,
                        showsDivider: false
                    ) {
                        BSToastManager.shared.error("This would delete your account")
                    }
                    .background(theme.surface)
                    .cornerRadius(theme.radiusMd)
                }

                ShowcaseSection(title: "Section Header") {
                    VStack(spacing: 0) {
                        BSListSectionHeader("Account Settings", action: ("Edit", {}))

                        BSListItem(title: "Email", trailingText: "john@example.com", showsDivider: true)
                        BSListItem(title: "Phone", trailingText: "+1 234 567 890", showsDivider: false)
                    }
                }
            }
            .padding(theme.md)
        }
        .background(theme.background)
        .navigationTitle("BSListItem")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Alert Showcase

struct AlertShowcaseView: View {
    @Environment(\.theme) var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.xl) {
                ShowcaseSection(title: "Alert Types") {
                    VStack(spacing: theme.md) {
                        BSAlert(type: .info, title: "Information", message: "This is an informational message.")
                        BSAlert(type: .success, message: "Your changes have been saved successfully!")
                        BSAlert(type: .warning, title: "Warning", message: "Your subscription will expire in 3 days.")
                        BSAlert(type: .error, title: "Error", message: "Failed to save your changes.")
                    }
                }

                ShowcaseSection(title: "Alert Variants") {
                    VStack(spacing: theme.md) {
                        BSAlert(type: .info, variant: .filled, message: "Filled variant alert")
                        BSAlert(type: .info, variant: .outlined, message: "Outlined variant alert")
                        BSAlert(type: .info, variant: .subtle, message: "Subtle variant alert")
                    }
                }

                ShowcaseSection(title: "Alert with Action") {
                    BSAlert(
                        type: .error,
                        title: "Connection Error",
                        message: "Unable to connect to the server.",
                        action: ("Retry", {
                            BSToastManager.shared.info("Retrying...")
                        })
                    )
                }

                ShowcaseSection(title: "Banner") {
                    BSBanner(
                        type: .info,
                        message: "A new version is available!",
                        action: ("Update", {
                            BSToastManager.shared.success("Updating...")
                        })
                    )
                }

                ShowcaseSection(title: "Empty State") {
                    BSEmptyState(
                        icon: "doc.text.magnifyingglass",
                        title: "No Results Found",
                        message: "Try adjusting your search or filters to find what you're looking for.",
                        action: ("Clear Filters", {})
                    )
                }
            }
            .padding(theme.md)
        }
        .background(theme.background)
        .navigationTitle("BSAlert")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Toast Showcase

struct ToastShowcaseView: View {
    @Environment(\.theme) var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.xl) {
                ShowcaseSection(title: "Toast Types") {
                    VStack(spacing: theme.md) {
                        BSButton("Show Info Toast", style: .outline, isFullWidth: true) {
                            BSToastManager.shared.info("This is an info toast")
                        }

                        BSButton("Show Success Toast", style: .outline, isFullWidth: true) {
                            BSToastManager.shared.success("Operation completed successfully!")
                        }

                        BSButton("Show Warning Toast", style: .outline, isFullWidth: true) {
                            BSToastManager.shared.warning("Please review your input")
                        }

                        BSButton("Show Error Toast", style: .outline, isFullWidth: true) {
                            BSToastManager.shared.error("Something went wrong!")
                        }
                    }
                }

                ShowcaseSection(title: "Toast with Action") {
                    BSButton("Show Toast with Action", style: .primary, isFullWidth: true) {
                        BSToastManager.shared.show(BSToastData(
                            type: .error,
                            message: "Failed to save changes",
                            action: .init(title: "Retry") {
                                BSToastManager.shared.success("Retried successfully!")
                            }
                        ))
                    }
                }

                ShowcaseSection(title: "Multiple Toasts") {
                    BSButton("Show Multiple Toasts", style: .secondary, isFullWidth: true) {
                        BSToastManager.shared.info("First toast")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            BSToastManager.shared.success("Second toast")
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            BSToastManager.shared.warning("Third toast")
                        }
                    }
                }

                ShowcaseSection(title: "Toast Preview") {
                    VStack(spacing: theme.md) {
                        BSToast(data: BSToastData(type: .info, message: "Info toast preview"), onDismiss: {})
                        BSToast(data: BSToastData(type: .success, message: "Success toast preview"), onDismiss: {})
                        BSToast(data: BSToastData(type: .warning, message: "Warning toast preview"), onDismiss: {})
                        BSToast(data: BSToastData(type: .error, message: "Error toast preview"), onDismiss: {})
                    }
                }
            }
            .padding(theme.md)
        }
        .background(theme.background)
        .navigationTitle("BSToast")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MoleculesShowcaseView()
        .withTheme()
        .withToasts()
}
