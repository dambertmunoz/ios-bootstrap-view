// BSEmptyState.swift
// BootstrapUI
//
// Empty state views for various scenarios
// Provides consistent placeholder content when data is unavailable

import SwiftUI

// MARK: - BSEmptyState

/// A customizable empty state view
public struct BSEmptyState: View {

    private let icon: String
    private let title: String
    private let message: String?
    private let actionTitle: String?
    private let secondaryActionTitle: String?
    private let style: Style
    private let action: (() -> Void)?
    private let secondaryAction: (() -> Void)?

    @Environment(\.theme) private var theme

    public enum Style {
        case standard
        case compact
        case fullScreen
        case card
    }

    public init(
        icon: String,
        title: String,
        message: String? = nil,
        actionTitle: String? = nil,
        secondaryActionTitle: String? = nil,
        style: Style = .standard,
        action: (() -> Void)? = nil,
        secondaryAction: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.secondaryActionTitle = secondaryActionTitle
        self.style = style
        self.action = action
        self.secondaryAction = secondaryAction
    }

    public var body: some View {
        Group {
            switch style {
            case .standard:
                standardView
            case .compact:
                compactView
            case .fullScreen:
                fullScreenView
            case .card:
                cardView
            }
        }
    }

    private var standardView: some View {
        VStack(spacing: theme.lg) {
            iconView
            textContent
            actionButtons
        }
        .padding(theme.xl)
    }

    private var compactView: some View {
        HStack(spacing: theme.md) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(theme.placeholder)

            VStack(alignment: .leading, spacing: theme.xxs) {
                BSText(title, style: .headline)
                if let message = message {
                    BSText(message, style: .caption1, color: .secondary)
                }
            }

            Spacer()

            if let actionTitle = actionTitle, let action = action {
                BSButton(actionTitle, style: .primary, size: .small, action: action)
            }
        }
        .padding(theme.md)
    }

    private var fullScreenView: some View {
        GeometryReader { geometry in
            VStack(spacing: theme.xl) {
                Spacer()
                iconView
                    .scaleEffect(1.5)
                textContent
                actionButtons
                Spacer()
            }
            .frame(width: geometry.size.width)
            .padding(theme.xl)
        }
    }

    private var cardView: some View {
        BSCard(variant: .outlined) {
            VStack(spacing: theme.md) {
                Image(systemName: icon)
                    .font(.system(size: 40))
                    .foregroundColor(theme.primary.opacity(0.6))

                BSText(title, style: .headline)

                if let message = message {
                    BSText(message, style: .subheadline, color: .secondary)
                        .multilineTextAlignment(.center)
                }

                if let actionTitle = actionTitle, let action = action {
                    BSButton(actionTitle, style: .outline, size: .small, action: action)
                }
            }
            .padding(theme.md)
        }
    }

    private var iconView: some View {
        ZStack {
            Circle()
                .fill(theme.primary.opacity(0.1))
                .frame(width: 80, height: 80)

            Image(systemName: icon)
                .font(.system(size: 36))
                .foregroundColor(theme.primary)
        }
    }

    private var textContent: some View {
        VStack(spacing: theme.sm) {
            BSText(title, style: .title3, weight: .semibold)
                .multilineTextAlignment(.center)

            if let message = message {
                BSText(message, style: .body, color: .secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }

    @ViewBuilder
    private var actionButtons: some View {
        if actionTitle != nil || secondaryActionTitle != nil {
            VStack(spacing: theme.sm) {
                if let actionTitle = actionTitle, let action = action {
                    BSButton(actionTitle, style: .primary, action: action)
                }

                if let secondaryActionTitle = secondaryActionTitle, let secondaryAction = secondaryAction {
                    BSButton(secondaryActionTitle, style: .ghost, action: secondaryAction)
                }
            }
        }
    }
}

// MARK: - Predefined Empty States

extension BSEmptyState {

    /// Empty state for no search results
    public static func noResults(
        searchTerm: String? = nil,
        onClear: (() -> Void)? = nil
    ) -> BSEmptyState {
        BSEmptyState(
            icon: "magnifyingglass",
            title: "No Results Found",
            message: searchTerm.map { "No results for \"\($0)\". Try a different search." } ?? "We couldn't find what you're looking for.",
            actionTitle: onClear != nil ? "Clear Search" : nil,
            action: onClear
        )
    }

    /// Empty state for no data
    public static func noData(
        title: String = "No Data",
        message: String = "There's nothing here yet.",
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) -> BSEmptyState {
        BSEmptyState(
            icon: "tray",
            title: title,
            message: message,
            actionTitle: actionTitle,
            action: action
        )
    }

    /// Empty state for no internet connection
    public static func noConnection(
        onRetry: (() -> Void)? = nil
    ) -> BSEmptyState {
        BSEmptyState(
            icon: "wifi.slash",
            title: "No Connection",
            message: "Please check your internet connection and try again.",
            actionTitle: "Retry",
            action: onRetry
        )
    }

    /// Empty state for error
    public static func error(
        title: String = "Something Went Wrong",
        message: String = "An error occurred. Please try again.",
        onRetry: (() -> Void)? = nil
    ) -> BSEmptyState {
        BSEmptyState(
            icon: "exclamationmark.triangle",
            title: title,
            message: message,
            actionTitle: "Try Again",
            action: onRetry
        )
    }

    /// Empty state for empty cart
    public static func emptyCart(
        onBrowse: (() -> Void)? = nil
    ) -> BSEmptyState {
        BSEmptyState(
            icon: "cart",
            title: "Your Cart is Empty",
            message: "Looks like you haven't added anything to your cart yet.",
            actionTitle: "Browse Products",
            action: onBrowse
        )
    }

    /// Empty state for no favorites
    public static func noFavorites(
        onExplore: (() -> Void)? = nil
    ) -> BSEmptyState {
        BSEmptyState(
            icon: "heart",
            title: "No Favorites Yet",
            message: "Items you favorite will appear here.",
            actionTitle: "Explore",
            action: onExplore
        )
    }

    /// Empty state for no notifications
    public static func noNotifications() -> BSEmptyState {
        BSEmptyState(
            icon: "bell",
            title: "No Notifications",
            message: "You're all caught up! Check back later for updates."
        )
    }

    /// Empty state for no messages
    public static func noMessages(
        onStartChat: (() -> Void)? = nil
    ) -> BSEmptyState {
        BSEmptyState(
            icon: "bubble.left.and.bubble.right",
            title: "No Messages",
            message: "Start a conversation to see your messages here.",
            actionTitle: "Start Chat",
            action: onStartChat
        )
    }

    /// Empty state for permission required
    public static func permissionRequired(
        permission: String,
        onOpenSettings: (() -> Void)? = nil
    ) -> BSEmptyState {
        BSEmptyState(
            icon: "lock.shield",
            title: "\(permission) Access Required",
            message: "Please grant access to \(permission.lowercased()) in Settings to use this feature.",
            actionTitle: "Open Settings",
            action: onOpenSettings
        )
    }

    /// Empty state for coming soon
    public static func comingSoon(
        feature: String = "This feature"
    ) -> BSEmptyState {
        BSEmptyState(
            icon: "sparkles",
            title: "Coming Soon",
            message: "\(feature) is under construction. Stay tuned!"
        )
    }
}

// MARK: - BSErrorView

/// A view to display errors with retry option
public struct BSErrorView: View {

    private let error: Error?
    private let title: String
    private let onRetry: (() -> Void)?

    @Environment(\.theme) private var theme

    public init(
        error: Error? = nil,
        title: String = "Something Went Wrong",
        onRetry: (() -> Void)? = nil
    ) {
        self.error = error
        self.title = title
        self.onRetry = onRetry
    }

    public var body: some View {
        VStack(spacing: theme.lg) {
            Image(systemName: "exclamationmark.circle")
                .font(.system(size: 48))
                .foregroundColor(theme.error)

            VStack(spacing: theme.sm) {
                BSText(title, style: .headline)

                if let error = error {
                    BSText(error.localizedDescription, style: .subheadline, color: .secondary)
                        .multilineTextAlignment(.center)
                }
            }

            if let onRetry = onRetry {
                BSButton("Retry", style: .primary, icon: "arrow.clockwise", action: onRetry)
            }
        }
        .padding(theme.xl)
    }
}

// MARK: - BSPlaceholder

/// A simple placeholder view
public struct BSPlaceholder: View {

    private let text: String
    private let icon: String?

    @Environment(\.theme) private var theme

    public init(_ text: String, icon: String? = nil) {
        self.text = text
        self.icon = icon
    }

    public var body: some View {
        VStack(spacing: theme.sm) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(theme.placeholder)
            }

            BSText(text, style: .subheadline, color: .secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.surface.opacity(0.5))
    }
}

// MARK: - Preview

#if DEBUG
struct BSEmptyState_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 32) {
                BSEmptyState.noResults(searchTerm: "Swift")

                BSEmptyState.noConnection {}

                BSEmptyState.emptyCart {}

                BSEmptyState.noNotifications()
            }
            .padding()
        }
        .withTheme()
    }
}
#endif
