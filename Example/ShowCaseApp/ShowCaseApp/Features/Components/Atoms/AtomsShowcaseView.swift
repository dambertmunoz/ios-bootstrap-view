// AtomsShowcaseView.swift
// ShowCaseApp
//
// Showcase for all Atom components

import SwiftUI
import BootstrapUI

struct AtomsShowcaseView: View {
    @Environment(\.theme) var theme

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: theme.lg) {
                    // Navigation links to individual atom showcases
                    ComponentLinkCard(
                        title: "BSButton",
                        description: "Customizable buttons with multiple styles, sizes, and states",
                        icon: "hand.tap.fill"
                    ) {
                        ButtonShowcaseView()
                    }

                    ComponentLinkCard(
                        title: "BSText",
                        description: "Typography components with all text styles",
                        icon: "textformat"
                    ) {
                        TextShowcaseView()
                    }

                    ComponentLinkCard(
                        title: "BSTextField",
                        description: "Input fields with validation and different styles",
                        icon: "character.cursor.ibeam"
                    ) {
                        TextFieldShowcaseView()
                    }

                    ComponentLinkCard(
                        title: "BSIcon",
                        description: "SF Symbols icons with various sizes and styles",
                        icon: "star.fill"
                    ) {
                        IconShowcaseView()
                    }

                    ComponentLinkCard(
                        title: "BSToggle",
                        description: "Switch, checkbox, and radio button toggles",
                        icon: "switch.2"
                    ) {
                        ToggleShowcaseView()
                    }

                    ComponentLinkCard(
                        title: "BSDivider",
                        description: "Dividers and separators with different styles",
                        icon: "minus"
                    ) {
                        DividerShowcaseView()
                    }

                    ComponentLinkCard(
                        title: "BSBadge",
                        description: "Badges, tags, and status indicators",
                        icon: "tag.fill"
                    ) {
                        BadgeShowcaseView()
                    }

                    ComponentLinkCard(
                        title: "BSAvatar",
                        description: "User avatars with images, initials, and status",
                        icon: "person.circle.fill"
                    ) {
                        AvatarShowcaseView()
                    }
                }
                .padding(theme.md)
            }
            .background(theme.background)
            .navigationTitle("Atoms")
        }
    }
}

// MARK: - Component Link Card

struct ComponentLinkCard<Destination: View>: View {
    let title: String
    let description: String
    let icon: String
    @ViewBuilder let destination: () -> Destination

    @Environment(\.theme) var theme

    var body: some View {
        NavigationLink {
            destination()
        } label: {
            BSCard {
                HStack(spacing: theme.md) {
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(theme.primary)
                        .frame(width: 44, height: 44)
                        .background(theme.primary.opacity(0.1))
                        .cornerRadius(theme.radiusMd)

                    VStack(alignment: .leading, spacing: theme.xxs) {
                        BSText(title, style: .headline)
                        BSText(description, style: .caption1, color: .secondary, lineLimit: 2)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(theme.placeholder)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Button Showcase

struct ButtonShowcaseView: View {
    @State private var isLoading = false
    @Environment(\.theme) var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.xl) {
                ShowcaseSection(title: "Button Styles") {
                    VStack(spacing: theme.md) {
                        BSButton("Primary", style: .primary) {}
                        BSButton("Secondary", style: .secondary) {}
                        BSButton("Outline", style: .outline) {}
                        BSButton("Ghost", style: .ghost) {}
                        BSButton("Destructive", style: .destructive) {}
                        BSButton("Success", style: .success) {}
                        BSButton("Link Style", style: .link) {}
                    }
                }

                ShowcaseSection(title: "Button Sizes") {
                    VStack(spacing: theme.md) {
                        BSButton("Small", style: .primary, size: .small) {}
                        BSButton("Medium", style: .primary, size: .medium) {}
                        BSButton("Large", style: .primary, size: .large) {}
                    }
                }

                ShowcaseSection(title: "With Icons") {
                    VStack(spacing: theme.md) {
                        BSButton("Leading Icon", style: .primary, icon: "star.fill", iconPosition: .leading) {}
                        BSButton("Trailing Icon", style: .primary, icon: "arrow.right", iconPosition: .trailing) {}
                    }
                }

                ShowcaseSection(title: "States") {
                    VStack(spacing: theme.md) {
                        BSButton("Loading", style: .primary, isLoading: isLoading) {}
                        BSButton("Disabled", style: .primary, isDisabled: true) {}
                        BSButton("Full Width", style: .primary, isFullWidth: true) {}

                        BSButton("Toggle Loading", style: .outline) {
                            isLoading.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                isLoading = false
                            }
                        }
                    }
                }

                ShowcaseSection(title: "Icon Buttons") {
                    HStack(spacing: theme.md) {
                        BSIconButton(icon: "heart.fill", style: .primary) {}
                        BSIconButton(icon: "star.fill", style: .secondary) {}
                        BSIconButton(icon: "trash", style: .destructive) {}
                        BSIconButton(icon: "gear", style: .ghost) {}
                    }
                }
            }
            .padding(theme.md)
        }
        .background(theme.background)
        .navigationTitle("BSButton")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Text Showcase

struct TextShowcaseView: View {
    @Environment(\.theme) var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.xl) {
                ShowcaseSection(title: "Text Styles") {
                    VStack(alignment: .leading, spacing: theme.sm) {
                        BSText("Large Title", style: .largeTitle)
                        BSText("Title 1", style: .title1)
                        BSText("Title 2", style: .title2)
                        BSText("Title 3", style: .title3)
                        BSText("Headline", style: .headline)
                        BSText("Body", style: .body)
                        BSText("Callout", style: .callout)
                        BSText("Subheadline", style: .subheadline)
                        BSText("Footnote", style: .footnote)
                        BSText("Caption 1", style: .caption1)
                        BSText("Caption 2", style: .caption2)
                    }
                }

                ShowcaseSection(title: "Text Colors") {
                    VStack(alignment: .leading, spacing: theme.sm) {
                        BSText("Primary Color", style: .body, color: .primary)
                        BSText("Secondary Color", style: .body, color: .secondary)
                        BSText("Tertiary Color", style: .body, color: .tertiary)
                        BSText("Error Color", style: .body, color: .error)
                        BSText("Success Color", style: .body, color: .success)
                        BSText("Warning Color", style: .body, color: .warning)
                    }
                }

                ShowcaseSection(title: "Text Weights") {
                    VStack(alignment: .leading, spacing: theme.sm) {
                        BSText("Regular Weight", style: .body, weight: .regular)
                        BSText("Medium Weight", style: .body, weight: .medium)
                        BSText("Semibold Weight", style: .body, weight: .semibold)
                        BSText("Bold Weight", style: .body, weight: .bold)
                    }
                }

                ShowcaseSection(title: "Label with Icon") {
                    VStack(alignment: .leading, spacing: theme.sm) {
                        BSLabel("Star Label", icon: "star.fill")
                        BSLabel("Heart Label", icon: "heart.fill", color: .error)
                        BSLabel("Check Label", icon: "checkmark.circle.fill", color: .success)
                    }
                }
            }
            .padding(theme.md)
        }
        .background(theme.background)
        .navigationTitle("BSText")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - TextField Showcase

struct TextFieldShowcaseView: View {
    @State private var text1 = ""
    @State private var text2 = "Valid input"
    @State private var text3 = "Invalid"
    @State private var password = ""
    @State private var textArea = ""

    @Environment(\.theme) var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.xl) {
                ShowcaseSection(title: "Basic TextField") {
                    VStack(spacing: theme.md) {
                        BSTextField("Email", text: $text1, placeholder: "Enter your email", icon: "envelope")
                    }
                }

                ShowcaseSection(title: "TextField States") {
                    VStack(spacing: theme.md) {
                        BSTextField("Success", text: $text2, state: .success, placeholder: "Valid input")
                        BSTextField("Error", text: $text3, state: .error("This field has an error"), placeholder: "Invalid input")
                        BSTextField("Disabled", text: .constant("Disabled"), state: .disabled, placeholder: "Cannot edit")
                    }
                }

                ShowcaseSection(title: "TextField Styles") {
                    VStack(spacing: theme.md) {
                        BSTextField("Outlined", text: $text1, placeholder: "Outlined style", style: .outlined)
                        BSTextField("Filled", text: $text1, placeholder: "Filled style", style: .filled)
                        BSTextField("Underlined", text: $text1, placeholder: "Underlined style", style: .underlined)
                    }
                }

                ShowcaseSection(title: "Password Field") {
                    VStack(spacing: theme.md) {
                        BSTextField("Password", text: $password, placeholder: "Enter password", icon: "lock", trailingIcon: "eye.slash", isSecure: true)
                    }
                }

                ShowcaseSection(title: "Text Area") {
                    BSTextArea("Description", text: $textArea, placeholder: "Enter a longer description...")
                }
            }
            .padding(theme.md)
        }
        .background(theme.background)
        .navigationTitle("BSTextField")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Icon Showcase

struct IconShowcaseView: View {
    @Environment(\.theme) var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.xl) {
                ShowcaseSection(title: "Icon Sizes") {
                    HStack(spacing: theme.lg) {
                        VStack {
                            BSIcon("star.fill", size: .xs)
                            BSText("XS", style: .caption2)
                        }
                        VStack {
                            BSIcon("star.fill", size: .sm)
                            BSText("SM", style: .caption2)
                        }
                        VStack {
                            BSIcon("star.fill", size: .md)
                            BSText("MD", style: .caption2)
                        }
                        VStack {
                            BSIcon("star.fill", size: .lg)
                            BSText("LG", style: .caption2)
                        }
                        VStack {
                            BSIcon("star.fill", size: .xl)
                            BSText("XL", style: .caption2)
                        }
                        VStack {
                            BSIcon("star.fill", size: .xxl)
                            BSText("XXL", style: .caption2)
                        }
                    }
                }

                ShowcaseSection(title: "Icon Colors") {
                    HStack(spacing: theme.lg) {
                        BSIcon("heart.fill", size: .lg, color: .red)
                        BSIcon("star.fill", size: .lg, color: .yellow)
                        BSIcon("leaf.fill", size: .lg, color: .green)
                        BSIcon("drop.fill", size: .lg, color: .blue)
                        BSIcon("flame.fill", size: .lg, color: .orange)
                    }
                }

                ShowcaseSection(title: "Circular Icons") {
                    HStack(spacing: theme.lg) {
                        BSCircularIcon("person.fill", size: .sm)
                        BSCircularIcon("heart.fill", size: .md, iconColor: .red)
                        BSCircularIcon("star.fill", size: .lg, backgroundColor: .yellow.opacity(0.2), iconColor: .yellow)
                    }
                }

                ShowcaseSection(title: "Icons with Badge") {
                    HStack(spacing: theme.xl) {
                        BSIconWithBadge("bell.fill", size: .lg, badgeCount: 3)
                        BSIconWithBadge("envelope.fill", size: .lg, badgeCount: 12)
                        BSIconWithBadge("cart.fill", size: .lg, badgeCount: 99)
                        BSIconWithBadge("message.fill", size: .lg, badgeCount: 150)
                    }
                }
            }
            .padding(theme.md)
        }
        .background(theme.background)
        .navigationTitle("BSIcon")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Toggle Showcase

struct ToggleShowcaseView: View {
    @State private var switch1 = true
    @State private var switch2 = false
    @State private var checkbox1 = true
    @State private var checkbox2 = false
    @State private var radio = true
    @State private var selectedOption = "Option A"

    @Environment(\.theme) var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.xl) {
                ShowcaseSection(title: "Switch Toggle") {
                    VStack(spacing: theme.md) {
                        BSToggle("Enabled Switch", isOn: $switch1)
                        BSToggle("Disabled Switch", isOn: $switch2)
                        BSToggle("Custom Color", isOn: $switch1, onColor: .green)
                        BSToggle("Disabled", isOn: $switch1, isDisabled: true)
                    }
                }

                ShowcaseSection(title: "Checkbox") {
                    VStack(spacing: theme.md) {
                        BSToggle("Checked Checkbox", isOn: $checkbox1, style: .checkbox)
                        BSToggle("Unchecked Checkbox", isOn: $checkbox2, style: .checkbox)
                    }
                }

                ShowcaseSection(title: "Radio") {
                    VStack(spacing: theme.md) {
                        BSToggle("Selected Radio", isOn: $radio, style: .radio)
                        BSToggle("Unselected Radio", isOn: .constant(false), style: .radio)
                    }
                }

                ShowcaseSection(title: "Toggle Group") {
                    BSToggleGroup(
                        options: ["Option A", "Option B", "Option C"],
                        selected: $selectedOption,
                        labelProvider: { $0 }
                    )
                }
            }
            .padding(theme.md)
        }
        .background(theme.background)
        .navigationTitle("BSToggle")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Divider Showcase

struct DividerShowcaseView: View {
    @Environment(\.theme) var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.xl) {
                ShowcaseSection(title: "Divider Styles") {
                    VStack(spacing: theme.lg) {
                        VStack(spacing: theme.sm) {
                            BSText("Solid Divider", style: .subheadline)
                            BSDivider()
                        }

                        VStack(spacing: theme.sm) {
                            BSText("Dashed Divider", style: .subheadline)
                            BSDivider(style: .dashed)
                        }

                        VStack(spacing: theme.sm) {
                            BSText("Dotted Divider", style: .subheadline)
                            BSDivider(style: .dotted)
                        }
                    }
                }

                ShowcaseSection(title: "Divider with Text") {
                    VStack(spacing: theme.lg) {
                        BSDivider(text: "OR")
                        BSDivider(text: "Section")
                    }
                }

                ShowcaseSection(title: "Inset Divider") {
                    VStack(spacing: 0) {
                        BSText("Item 1", style: .body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(theme.md)
                        BSInsetDivider(leadingInset: theme.md)
                        BSText("Item 2", style: .body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(theme.md)
                        BSInsetDivider(leadingInset: theme.md)
                        BSText("Item 3", style: .body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(theme.md)
                    }
                    .background(theme.surface)
                    .cornerRadius(theme.radiusMd)
                }

                ShowcaseSection(title: "Spacer Divider") {
                    BSSpacerDivider(height: 32, showLine: true)
                }
            }
            .padding(theme.md)
        }
        .background(theme.background)
        .navigationTitle("BSDivider")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Badge Showcase

struct BadgeShowcaseView: View {
    @Environment(\.theme) var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.xl) {
                ShowcaseSection(title: "Badge Variants") {
                    HStack(spacing: theme.md) {
                        BSBadge("Filled", variant: .filled)
                        BSBadge("Outlined", variant: .outlined)
                        BSBadge("Subtle", variant: .subtle)
                    }
                }

                ShowcaseSection(title: "Badge Colors") {
                    VStack(spacing: theme.md) {
                        HStack(spacing: theme.sm) {
                            BSBadge("Primary", color: .primary)
                            BSBadge("Secondary", color: .secondary)
                            BSBadge("Success", color: .success)
                            BSBadge("Warning", color: .warning)
                        }
                        HStack(spacing: theme.sm) {
                            BSBadge("Error", color: .error)
                            BSBadge("Info", color: .info)
                            BSBadge("Neutral", color: .neutral)
                        }
                    }
                }

                ShowcaseSection(title: "Badge Sizes") {
                    HStack(spacing: theme.md) {
                        BSBadge("Small", size: .small)
                        BSBadge("Medium", size: .medium)
                        BSBadge("Large", size: .large)
                    }
                }

                ShowcaseSection(title: "Badge with Icon") {
                    HStack(spacing: theme.md) {
                        BSBadge("New", icon: "sparkles")
                        BSBadge("Premium", icon: "star.fill", color: .warning)
                        BSBadge("Verified", icon: "checkmark.seal.fill", color: .success)
                    }
                }

                ShowcaseSection(title: "Dot Badge") {
                    HStack(spacing: theme.xl) {
                        VStack {
                            BSDotBadge(color: .success)
                            BSText("Online", style: .caption2)
                        }
                        VStack {
                            BSDotBadge(color: .error)
                            BSText("Offline", style: .caption2)
                        }
                        VStack {
                            BSDotBadge(color: .warning, isPulsing: true)
                            BSText("Busy", style: .caption2)
                        }
                    }
                }

                ShowcaseSection(title: "Count Badge") {
                    HStack(spacing: theme.xl) {
                        BSCountBadge(5)
                        BSCountBadge(42)
                        BSCountBadge(99)
                        BSCountBadge(150)
                    }
                }

                ShowcaseSection(title: "Status Badge") {
                    VStack(spacing: theme.md) {
                        HStack(spacing: theme.md) {
                            BSStatusBadge(.active)
                            BSStatusBadge(.inactive)
                            BSStatusBadge(.pending)
                        }
                        HStack(spacing: theme.md) {
                            BSStatusBadge(.completed)
                            BSStatusBadge(.failed)
                            BSStatusBadge(.cancelled)
                        }
                    }
                }
            }
            .padding(theme.md)
        }
        .background(theme.background)
        .navigationTitle("BSBadge")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Avatar Showcase

struct AvatarShowcaseView: View {
    @Environment(\.theme) var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.xl) {
                ShowcaseSection(title: "Avatar Sizes") {
                    HStack(spacing: theme.md) {
                        VStack {
                            BSAvatar(initials: "XS", size: .xs)
                            BSText("XS", style: .caption2)
                        }
                        VStack {
                            BSAvatar(initials: "SM", size: .sm)
                            BSText("SM", style: .caption2)
                        }
                        VStack {
                            BSAvatar(initials: "MD", size: .md)
                            BSText("MD", style: .caption2)
                        }
                        VStack {
                            BSAvatar(initials: "LG", size: .lg)
                            BSText("LG", style: .caption2)
                        }
                        VStack {
                            BSAvatar(initials: "XL", size: .xl)
                            BSText("XL", style: .caption2)
                        }
                    }
                }

                ShowcaseSection(title: "Avatar Types") {
                    HStack(spacing: theme.lg) {
                        VStack {
                            BSAvatar(initials: "JD", size: .lg)
                            BSText("Initials", style: .caption2)
                        }
                        VStack {
                            BSAvatar(icon: "person.fill", size: .lg)
                            BSText("Icon", style: .caption2)
                        }
                        VStack {
                            BSAvatar(icon: "star.fill", size: .lg, backgroundColor: .yellow, foregroundColor: .white)
                            BSText("Custom", style: .caption2)
                        }
                    }
                }

                ShowcaseSection(title: "Avatar Shapes") {
                    HStack(spacing: theme.lg) {
                        VStack {
                            BSAvatar(initials: "C", size: .lg, shape: .circle)
                            BSText("Circle", style: .caption2)
                        }
                        VStack {
                            BSAvatar(initials: "R", size: .lg, shape: .rounded)
                            BSText("Rounded", style: .caption2)
                        }
                        VStack {
                            BSAvatar(initials: "S", size: .lg, shape: .square)
                            BSText("Square", style: .caption2)
                        }
                    }
                }

                ShowcaseSection(title: "Avatar with Status") {
                    HStack(spacing: theme.lg) {
                        VStack {
                            BSAvatar(initials: "ON", size: .lg, status: .online)
                            BSText("Online", style: .caption2)
                        }
                        VStack {
                            BSAvatar(initials: "OF", size: .lg, status: .offline)
                            BSText("Offline", style: .caption2)
                        }
                        VStack {
                            BSAvatar(initials: "BU", size: .lg, status: .busy)
                            BSText("Busy", style: .caption2)
                        }
                        VStack {
                            BSAvatar(initials: "AW", size: .lg, status: .away)
                            BSText("Away", style: .caption2)
                        }
                    }
                }

                ShowcaseSection(title: "Avatar Group") {
                    BSAvatarGroup(
                        avatars: [
                            .init(initials: "AB"),
                            .init(initials: "CD"),
                            .init(initials: "EF"),
                            .init(initials: "GH"),
                            .init(initials: "IJ"),
                            .init(initials: "KL"),
                        ],
                        size: .md
                    )
                }
            }
            .padding(theme.md)
        }
        .background(theme.background)
        .navigationTitle("BSAvatar")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Showcase Section

struct ShowcaseSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    @Environment(\.theme) var theme

    var body: some View {
        VStack(alignment: .leading, spacing: theme.md) {
            BSText(title, style: .headline)

            BSCard(variant: .outlined) {
                content()
            }
        }
    }
}

#Preview {
    AtomsShowcaseView()
        .withTheme()
}
