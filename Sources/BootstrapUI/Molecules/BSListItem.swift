// BSListItem.swift
// BootstrapUI
//
// List item component for consistent list presentations
// Follows Composition - combines atoms for list items

import SwiftUI

// MARK: - List Item Style

/// Available list item styles
public enum BSListItemStyle: String, CaseIterable, Sendable {
    case standard
    case inset
    case grouped
}

// MARK: - List Item Component

/// A customizable list item component
///
/// Example usage:
/// ```swift
/// BSListItem(
///     title: "Profile",
///     subtitle: "View your profile",
///     leadingIcon: "person.circle.fill",
///     showsChevron: true
/// ) {
///     navigateToProfile()
/// }
/// ```
public struct BSListItem: View {

    // MARK: - Properties

    private let title: String
    private let subtitle: String?
    private let leadingIcon: String?
    private let leadingImage: URL?
    private let trailingText: String?
    private let trailingIcon: String?
    private let showsChevron: Bool
    private let showsDivider: Bool
    private let isDestructive: Bool
    private let isDisabled: Bool
    private let badge: String?
    private let style: BSListItemStyle
    private let onTap: (() -> Void)?

    @Environment(\.theme) private var theme
    @State private var isPressed = false

    // MARK: - Initialization

    /// Creates a list item
    /// - Parameters:
    ///   - title: Main title text
    ///   - subtitle: Optional subtitle text
    ///   - leadingIcon: SF Symbol for leading icon
    ///   - leadingImage: URL for leading image
    ///   - trailingText: Optional trailing text
    ///   - trailingIcon: SF Symbol for trailing icon
    ///   - showsChevron: Whether to show chevron indicator
    ///   - showsDivider: Whether to show bottom divider
    ///   - isDestructive: Whether item is destructive (red styling)
    ///   - isDisabled: Whether item is disabled
    ///   - badge: Optional badge text
    ///   - style: Visual style
    ///   - onTap: Action when tapped
    public init(
        title: String,
        subtitle: String? = nil,
        leadingIcon: String? = nil,
        leadingImage: URL? = nil,
        trailingText: String? = nil,
        trailingIcon: String? = nil,
        showsChevron: Bool = false,
        showsDivider: Bool = true,
        isDestructive: Bool = false,
        isDisabled: Bool = false,
        badge: String? = nil,
        style: BSListItemStyle = .standard,
        onTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.leadingIcon = leadingIcon
        self.leadingImage = leadingImage
        self.trailingText = trailingText
        self.trailingIcon = trailingIcon
        self.showsChevron = showsChevron
        self.showsDivider = showsDivider
        self.isDestructive = isDestructive
        self.isDisabled = isDisabled
        self.badge = badge
        self.style = style
        self.onTap = onTap
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 0) {
            Button(action: { onTap?() }) {
                HStack(spacing: theme.md) {
                    // Leading content
                    leadingContent

                    // Text content
                    VStack(alignment: .leading, spacing: theme.xxs) {
                        HStack {
                            Text(title)
                                .font(theme.body)
                                .foregroundColor(titleColor)

                            if let badge = badge {
                                BSBadge(badge, size: .small)
                            }
                        }

                        if let subtitle = subtitle {
                            Text(subtitle)
                                .font(theme.subheadline)
                                .foregroundColor(theme.placeholder)
                                .lineLimit(2)
                        }
                    }

                    Spacer()

                    // Trailing content
                    trailingContent
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, theme.md)
                .background(isPressed ? theme.surface.opacity(0.5) : Color.clear)
            }
            .buttonStyle(.plain)
            .disabled(isDisabled)

            // Divider
            if showsDivider {
                BSInsetDivider(leadingInset: dividerInset)
            }
        }
        .opacity(isDisabled ? 0.5 : 1.0)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }

    // MARK: - Private Views

    @ViewBuilder
    private var leadingContent: some View {
        if let leadingImage = leadingImage {
            BSAvatar(imageURL: leadingImage, size: .md)
        } else if let leadingIcon = leadingIcon {
            Image(systemName: leadingIcon)
                .font(.system(size: 22))
                .foregroundColor(isDestructive ? theme.error : theme.primary)
                .frame(width: 28)
        }
    }

    @ViewBuilder
    private var trailingContent: some View {
        HStack(spacing: theme.sm) {
            if let trailingText = trailingText {
                Text(trailingText)
                    .font(theme.subheadline)
                    .foregroundColor(theme.placeholder)
            }

            if let trailingIcon = trailingIcon {
                Image(systemName: trailingIcon)
                    .font(.system(size: 16))
                    .foregroundColor(theme.placeholder)
            } else if showsChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(theme.placeholder)
            }
        }
    }

    // MARK: - Computed Properties

    private var titleColor: Color {
        isDestructive ? theme.error : theme.onSurface
    }

    private var horizontalPadding: CGFloat {
        switch style {
        case .standard: return theme.md
        case .inset: return theme.lg
        case .grouped: return theme.md
        }
    }

    private var dividerInset: CGFloat {
        var inset = horizontalPadding
        if leadingIcon != nil || leadingImage != nil {
            inset += 28 + theme.md
        }
        return inset
    }
}

// MARK: - List Item with Toggle

/// A list item with a toggle switch
public struct BSToggleListItem: View {

    private let title: String
    private let subtitle: String?
    private let icon: String?
    @Binding private var isOn: Bool
    private let onChange: ((Bool) -> Void)?

    @Environment(\.theme) private var theme

    public init(
        title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        isOn: Binding<Bool>,
        onChange: ((Bool) -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self._isOn = isOn
        self.onChange = onChange
    }

    public var body: some View {
        HStack(spacing: theme.md) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(theme.primary)
                    .frame(width: 28)
            }

            VStack(alignment: .leading, spacing: theme.xxs) {
                Text(title)
                    .font(theme.body)
                    .foregroundColor(theme.onSurface)

                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(theme.subheadline)
                        .foregroundColor(theme.placeholder)
                }
            }

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(theme.primary)
                .onChange(of: isOn) { _, newValue in
                    onChange?(newValue)
                }
        }
        .padding(.horizontal, theme.md)
        .padding(.vertical, theme.md)
    }
}

// MARK: - Section Header

/// A section header for grouped lists
public struct BSListSectionHeader: View {

    private let title: String
    private let action: (title: String, action: () -> Void)?

    @Environment(\.theme) private var theme

    public init(
        _ title: String,
        action: (title: String, action: () -> Void)? = nil
    ) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        HStack {
            Text(title.uppercased())
                .font(theme.footnote)
                .fontWeight(.semibold)
                .foregroundColor(theme.placeholder)

            Spacer()

            if let action = action {
                Button(action.title, action: action.action)
                    .font(theme.footnote)
                    .foregroundColor(theme.primary)
            }
        }
        .padding(.horizontal, theme.md)
        .padding(.vertical, theme.sm)
    }
}

// MARK: - Preview

#if DEBUG
struct BSListItem_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 0) {
                BSListSectionHeader("General")

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
                    showsChevron: true
                )

                BSToggleListItem(
                    title: "Dark Mode",
                    subtitle: "Enable dark appearance",
                    icon: "moon.fill",
                    isOn: .constant(true)
                )

                BSListSectionHeader("Danger Zone")

                BSListItem(
                    title: "Delete Account",
                    leadingIcon: "trash.fill",
                    isDestructive: true,
                    showsDivider: false
                )
            }
        }
        .withTheme()
    }
}
#endif
