// OrganismsShowcaseView.swift
// ShowCaseApp
//
// Showcase for all Organism components

import SwiftUI
import BootstrapUI

struct OrganismsShowcaseView: View {
    @Environment(\.theme) var theme

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: theme.lg) {
                    ComponentLinkCard(
                        title: "BSForm",
                        description: "Form components with sections and field types",
                        icon: "doc.text"
                    ) {
                        FormShowcaseView()
                    }

                    ComponentLinkCard(
                        title: "BSHeader",
                        description: "Page headers, section headers, and profile headers",
                        icon: "text.alignleft"
                    ) {
                        HeaderShowcaseView()
                    }

                    ComponentLinkCard(
                        title: "BSNavigation",
                        description: "Navigation bars and tab bars",
                        icon: "sidebar.left"
                    ) {
                        NavigationShowcaseView()
                    }

                    ComponentLinkCard(
                        title: "BSModal",
                        description: "Modals, dialogs, and bottom sheets",
                        icon: "rectangle.center.inset.filled"
                    ) {
                        ModalShowcaseView()
                    }
                }
                .padding(theme.md)
            }
            .background(theme.background)
            .navigationTitle("Organisms")
        }
    }
}

// MARK: - Form Showcase

struct FormShowcaseView: View {
    @State private var firstName = "John"
    @State private var lastName = "Doe"
    @State private var email = "john@example.com"
    @State private var notifications = true
    @State private var newsletter = false
    @State private var language = "English"
    @State private var birthday = Date()
    @State private var quantity = 1
    @State private var isLoading = false

    @Environment(\.theme) var theme

    var body: some View {
        BSForm {
            BSFormSection(title: "Personal Information", footer: "Your name will be visible to others") {
                BSFormTextField(label: "First Name", text: $firstName, isRequired: true)
                BSFormTextField(label: "Last Name", text: $lastName)
                BSFormTextField(label: "Email", text: $email, keyboardType: .emailAddress)
            }

            BSFormSection(title: "Preferences") {
                BSFormToggle(label: "Push Notifications", isOn: $notifications)
                BSFormToggle(label: "Email Newsletter", isOn: $newsletter)
                BSFormPicker(
                    label: "Language",
                    selection: $language,
                    options: ["English", "Spanish", "French", "German"],
                    optionLabel: { $0 }
                )
            }

            BSFormSection(title: "Additional") {
                BSFormDatePicker(label: "Birthday", date: $birthday)
                BSFormStepper(label: "Quantity", value: $quantity, range: 1...10)
            }

            BSFormActions(
                primaryTitle: "Save Changes",
                primaryAction: {
                    isLoading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        isLoading = false
                        BSToastManager.shared.success("Changes saved!")
                    }
                },
                secondaryTitle: "Cancel",
                secondaryAction: {},
                isLoading: isLoading
            )
        }
        .navigationTitle("BSForm")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Header Showcase

struct HeaderShowcaseView: View {
    @Environment(\.theme) var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.xl) {
                ShowcaseSection(title: "Page Header") {
                    VStack(spacing: theme.md) {
                        BSPageHeader(
                            title: "Messages",
                            subtitle: "12 unread",
                            leadingAction: .init(icon: "arrow.left", action: {}),
                            trailingActions: [
                                .init(icon: "magnifyingglass", action: {}),
                                .init(icon: "bell.fill", badge: 3, action: {})
                            ]
                        )
                        .background(theme.surface)
                        .cornerRadius(theme.radiusMd)
                    }
                }

                ShowcaseSection(title: "Large Title Header") {
                    BSLargeTitleHeader(
                        title: "Welcome Back",
                        subtitle: "What would you like to do today?"
                    ) {
                        BSAvatar(initials: "JD", size: .md)
                    }
                    .background(theme.surface)
                    .cornerRadius(theme.radiusMd)
                }

                ShowcaseSection(title: "Section Header") {
                    VStack(spacing: theme.sm) {
                        BSSectionHeader("Recent Items", action: ("See All", {}))
                        BSSectionHeader("Popular")
                    }
                }

                ShowcaseSection(title: "Profile Header") {
                    BSProfileHeader(
                        name: "John Doe",
                        subtitle: "@johndoe",
                        avatarInitials: "JD",
                        stats: [
                            .init(value: "1.2K", label: "Followers"),
                            .init(value: "350", label: "Following"),
                            .init(value: "42", label: "Posts")
                        ]
                    )
                    .background(theme.surface)
                    .cornerRadius(theme.radiusMd)
                }
            }
            .padding(theme.md)
        }
        .background(theme.background)
        .navigationTitle("BSHeader")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Navigation Showcase

struct NavigationShowcaseView: View {
    @State private var selectedTab = 0

    @Environment(\.theme) var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.xl) {
                ShowcaseSection(title: "Navigation Bar - Inline") {
                    BSNavigationBar(
                        title: "Settings",
                        displayMode: .inline,
                        leadingItems: [.init(icon: "arrow.left", action: {})],
                        trailingItems: [.init(text: "Done", action: {})]
                    )
                    .background(theme.surface)
                    .cornerRadius(theme.radiusMd)
                }

                ShowcaseSection(title: "Navigation Bar - Large") {
                    BSNavigationBar(
                        title: "Home",
                        displayMode: .large,
                        leadingItems: [.init(icon: "line.3.horizontal", action: {})],
                        trailingActions: [
                            .init(icon: "magnifyingglass", action: {}),
                            .init(icon: "bell", action: {})
                        ]
                    )
                    .background(theme.surface)
                    .cornerRadius(theme.radiusMd)
                }

                ShowcaseSection(title: "Tab Bar - Standard") {
                    BSTabBar(
                        selection: $selectedTab,
                        items: [
                            .init(id: 0, icon: "house", selectedIcon: "house.fill", title: "Home"),
                            .init(id: 1, icon: "magnifyingglass", title: "Search"),
                            .init(id: 2, icon: "bell", selectedIcon: "bell.fill", title: "Alerts", badge: 5),
                            .init(id: 3, icon: "person", selectedIcon: "person.fill", title: "Profile")
                        ],
                        style: .standard
                    )
                    .background(theme.surface)
                    .cornerRadius(theme.radiusMd)
                }

                ShowcaseSection(title: "Tab Bar - Floating") {
                    BSTabBar(
                        selection: $selectedTab,
                        items: [
                            .init(id: 0, icon: "house", selectedIcon: "house.fill", title: "Home"),
                            .init(id: 1, icon: "magnifyingglass", title: "Search"),
                            .init(id: 2, icon: "bell", selectedIcon: "bell.fill", title: "Alerts"),
                            .init(id: 3, icon: "person", selectedIcon: "person.fill", title: "Profile")
                        ],
                        style: .floating
                    )
                }

                ShowcaseSection(title: "Tab Bar - Minimal") {
                    BSTabBar(
                        selection: $selectedTab,
                        items: [
                            .init(id: 0, icon: "house", selectedIcon: "house.fill", title: "Home"),
                            .init(id: 1, icon: "magnifyingglass", title: "Search"),
                            .init(id: 2, icon: "bell", selectedIcon: "bell.fill", title: "Alerts"),
                            .init(id: 3, icon: "person", selectedIcon: "person.fill", title: "Profile")
                        ],
                        style: .minimal
                    )
                    .background(theme.surface)
                    .cornerRadius(theme.radiusMd)
                }
            }
            .padding(theme.md)
        }
        .background(theme.background)
        .navigationTitle("BSNavigation")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Modal Showcase

struct ModalShowcaseView: View {
    @State private var showModal = false
    @State private var showAlertDialog = false
    @State private var showConfirmation = false
    @State private var showBottomSheet = false

    @Environment(\.theme) var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.xl) {
                ShowcaseSection(title: "Basic Modal") {
                    BSButton("Show Modal", style: .primary, isFullWidth: true) {
                        showModal = true
                    }
                }

                ShowcaseSection(title: "Alert Dialog") {
                    BSButton("Show Alert Dialog", style: .secondary, isFullWidth: true) {
                        showAlertDialog = true
                    }
                }

                ShowcaseSection(title: "Confirmation Dialog") {
                    BSButton("Show Confirmation", style: .destructive, isFullWidth: true) {
                        showConfirmation = true
                    }
                }

                ShowcaseSection(title: "Bottom Sheet") {
                    BSButton("Show Bottom Sheet", style: .outline, isFullWidth: true) {
                        showBottomSheet = true
                    }
                }
            }
            .padding(theme.md)
        }
        .background(theme.background)
        .navigationTitle("BSModal")
        .navigationBarTitleDisplayMode(.inline)
        .bsModal(isPresented: $showModal) {
            VStack(spacing: theme.lg) {
                BSText("Custom Modal", style: .title2, weight: .bold)
                BSText("This is a custom modal with any content you want.", style: .body, color: .secondary, alignment: .center)

                BSButton("Close", style: .primary, isFullWidth: true) {
                    showModal = false
                }
            }
        }
        .overlay {
            BSAlertDialog(
                isPresented: $showAlertDialog,
                title: "Save Changes?",
                message: "Do you want to save your changes before leaving?",
                primaryAction: .init(title: "Save", style: .primary) {
                    BSToastManager.shared.success("Changes saved!")
                },
                secondaryAction: .init(title: "Don't Save", style: .ghost) {}
            )
        }
        .overlay {
            BSConfirmationDialog(
                isPresented: $showConfirmation,
                title: "Delete Item?",
                message: "This action cannot be undone. Are you sure you want to delete this item?",
                confirmTitle: "Delete",
                cancelTitle: "Cancel",
                isDestructive: true,
                onConfirm: {
                    BSToastManager.shared.success("Item deleted")
                }
            )
        }
        .overlay {
            BSBottomSheet(isPresented: $showBottomSheet, detents: [.medium, .large]) {
                VStack(spacing: theme.lg) {
                    BSText("Bottom Sheet", style: .title2, weight: .bold)
                    BSText("Drag to resize or tap outside to dismiss", style: .body, color: .secondary)

                    ForEach(1...5, id: \.self) { index in
                        BSListItem(
                            title: "Option \(index)",
                            leadingIcon: "circle",
                            showsChevron: true,
                            showsDivider: index < 5
                        ) {
                            showBottomSheet = false
                            BSToastManager.shared.info("Selected option \(index)")
                        }
                    }

                    Spacer()
                }
                .padding(theme.md)
            }
        }
    }
}

#Preview {
    OrganismsShowcaseView()
        .withTheme()
        .withToasts()
}
