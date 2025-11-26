// BSHeader.swift
// BootstrapUI
//
// Header components for page and section headers
// Follows Composition - combines atoms for header presentations

import SwiftUI

// MARK: - Page Header

/// A page header component with title, subtitle, and actions
public struct BSPageHeader: View {

    private let title: String
    private let subtitle: String?
    private let leadingAction: HeaderAction?
    private let trailingActions: [HeaderAction]

    @Environment(\.theme) private var theme

    public struct HeaderAction: Identifiable {
        public let id = UUID()
        public let icon: String
        public let badge: Int?
        public let action: () -> Void

        public init(icon: String, badge: Int? = nil, action: @escaping () -> Void) {
            self.icon = icon
            self.badge = badge
            self.action = action
        }
    }

    public init(
        title: String,
        subtitle: String? = nil,
        leadingAction: HeaderAction? = nil,
        trailingActions: [HeaderAction] = []
    ) {
        self.title = title
        self.subtitle = subtitle
        self.leadingAction = leadingAction
        self.trailingActions = trailingActions
    }

    public var body: some View {
        HStack(spacing: theme.md) {
            // Leading action
            if let action = leadingAction {
                actionButton(action)
            }

            // Title and subtitle
            VStack(alignment: leadingAction == nil ? .leading : .center, spacing: theme.xxs) {
                Text(title)
                    .font(theme.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(theme.onSurface)

                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(theme.subheadline)
                        .foregroundColor(theme.placeholder)
                }
            }

            if leadingAction == nil {
                Spacer()
            } else if trailingActions.isEmpty {
                Spacer()
            }

            // Trailing actions
            HStack(spacing: theme.sm) {
                ForEach(trailingActions) { action in
                    actionButton(action)
                }
            }
        }
        .padding(.horizontal, theme.md)
        .padding(.vertical, theme.sm)
        .background(theme.background)
    }

    @ViewBuilder
    private func actionButton(_ action: HeaderAction) -> some View {
        Button(action: action.action) {
            if let badge = action.badge, badge > 0 {
                BSIconWithBadge(action.icon, size: .md, badgeCount: badge)
            } else {
                Image(systemName: action.icon)
                    .font(.system(size: 20))
                    .foregroundColor(theme.primary)
            }
        }
        .frame(width: 44, height: 44)
    }
}

// MARK: - Large Title Header

/// A large title header similar to iOS navigation bar
public struct BSLargeTitleHeader: View {

    private let title: String
    private let subtitle: String?
    private let trailingContent: AnyView?

    @Environment(\.theme) private var theme

    public init(
        title: String,
        subtitle: String? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.trailingContent = nil
    }

    public init<Content: View>(
        title: String,
        subtitle: String? = nil,
        @ViewBuilder trailing: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.trailingContent = AnyView(trailing())
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: theme.sm) {
            HStack {
                VStack(alignment: .leading, spacing: theme.xxs) {
                    Text(title)
                        .font(theme.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(theme.onBackground)

                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(theme.subheadline)
                            .foregroundColor(theme.placeholder)
                    }
                }

                Spacer()

                if let trailing = trailingContent {
                    trailing
                }
            }
        }
        .padding(.horizontal, theme.md)
        .padding(.vertical, theme.sm)
        .background(theme.background)
    }
}

// MARK: - Section Header

/// A section header for dividing content
public struct BSSectionHeader: View {

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
            Text(title)
                .font(theme.title3)
                .fontWeight(.semibold)
                .foregroundColor(theme.onSurface)

            Spacer()

            if let action = action {
                Button(action.title, action: action.action)
                    .font(theme.subheadline)
                    .foregroundColor(theme.primary)
            }
        }
        .padding(.horizontal, theme.md)
        .padding(.vertical, theme.sm)
    }
}

// MARK: - Profile Header

/// A header component for profile pages
public struct BSProfileHeader: View {

    private let name: String
    private let subtitle: String?
    private let avatarURL: URL?
    private let avatarInitials: String?
    private let stats: [ProfileStat]
    private let onAvatarTap: (() -> Void)?

    @Environment(\.theme) private var theme

    public struct ProfileStat: Identifiable {
        public let id = UUID()
        public let value: String
        public let label: String

        public init(value: String, label: String) {
            self.value = value
            self.label = label
        }
    }

    public init(
        name: String,
        subtitle: String? = nil,
        avatarURL: URL? = nil,
        avatarInitials: String? = nil,
        stats: [ProfileStat] = [],
        onAvatarTap: (() -> Void)? = nil
    ) {
        self.name = name
        self.subtitle = subtitle
        self.avatarURL = avatarURL
        self.avatarInitials = avatarInitials
        self.stats = stats
        self.onAvatarTap = onAvatarTap
    }

    public var body: some View {
        VStack(spacing: theme.lg) {
            // Avatar
            Group {
                if let url = avatarURL {
                    BSAvatar(imageURL: url, size: .xxl, onTap: onAvatarTap)
                } else if let initials = avatarInitials {
                    BSAvatar(initials: initials, size: .xxl, onTap: onAvatarTap)
                } else {
                    BSAvatar(icon: "person.fill", size: .xxl, onTap: onAvatarTap)
                }
            }

            // Name and subtitle
            VStack(spacing: theme.xxs) {
                Text(name)
                    .font(theme.title2)
                    .fontWeight(.bold)
                    .foregroundColor(theme.onSurface)

                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(theme.subheadline)
                        .foregroundColor(theme.placeholder)
                }
            }

            // Stats
            if !stats.isEmpty {
                HStack(spacing: theme.xl) {
                    ForEach(stats) { stat in
                        VStack(spacing: theme.xxs) {
                            Text(stat.value)
                                .font(theme.title3)
                                .fontWeight(.bold)
                                .foregroundColor(theme.onSurface)

                            Text(stat.label)
                                .font(theme.caption1)
                                .foregroundColor(theme.placeholder)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, theme.lg)
        .background(theme.background)
    }
}

// MARK: - Preview

#if DEBUG
struct BSHeader_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 32) {
                BSPageHeader(
                    title: "Messages",
                    subtitle: "12 unread",
                    leadingAction: .init(icon: "arrow.left", action: {}),
                    trailingActions: [
                        .init(icon: "magnifyingglass", action: {}),
                        .init(icon: "bell.fill", badge: 3, action: {})
                    ]
                )

                BSDivider()

                BSLargeTitleHeader(
                    title: "Welcome Back",
                    subtitle: "What would you like to do today?"
                ) {
                    BSAvatar(initials: "JD", size: .md)
                }

                BSDivider()

                BSSectionHeader("Recent Items", action: ("See All", {}))

                BSDivider()

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
            }
        }
        .withTheme()
    }
}
#endif
