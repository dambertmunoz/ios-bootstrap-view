// BSAlert.swift
// BootstrapUI
//
// Alert and notification components
// Follows Composition - combines atoms for alert presentations

import SwiftUI

// MARK: - Alert Type

/// Types of alerts with semantic meaning
public enum BSAlertType: String, CaseIterable, Sendable {
    case info
    case success
    case warning
    case error

    var icon: String {
        switch self {
        case .info: return "info.circle.fill"
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.circle.fill"
        }
    }
}

// MARK: - Alert Variant

/// Visual variants for alerts
public enum BSAlertVariant: String, CaseIterable, Sendable {
    case filled
    case outlined
    case subtle
}

// MARK: - Inline Alert Component

/// An inline alert component for contextual messages
///
/// Example usage:
/// ```swift
/// BSAlert(
///     type: .warning,
///     title: "Warning",
///     message: "Your session will expire soon"
/// )
/// ```
public struct BSAlert: View {

    // MARK: - Properties

    private let type: BSAlertType
    private let variant: BSAlertVariant
    private let title: String?
    private let message: String
    private let isDismissible: Bool
    private let action: (title: String, action: () -> Void)?
    private let onDismiss: (() -> Void)?

    @State private var isVisible = true
    @Environment(\.theme) private var theme

    // MARK: - Initialization

    /// Creates an inline alert
    /// - Parameters:
    ///   - type: Alert type (info, success, warning, error)
    ///   - variant: Visual variant
    ///   - title: Optional title
    ///   - message: Alert message
    ///   - isDismissible: Whether alert can be dismissed
    ///   - action: Optional action button
    ///   - onDismiss: Callback when dismissed
    public init(
        type: BSAlertType,
        variant: BSAlertVariant = .subtle,
        title: String? = nil,
        message: String,
        isDismissible: Bool = true,
        action: (title: String, action: () -> Void)? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        self.type = type
        self.variant = variant
        self.title = title
        self.message = message
        self.isDismissible = isDismissible
        self.action = action
        self.onDismiss = onDismiss
    }

    // MARK: - Body

    public var body: some View {
        if isVisible {
            HStack(alignment: .top, spacing: theme.sm) {
                // Icon
                Image(systemName: type.icon)
                    .font(.system(size: 20))
                    .foregroundColor(iconColor)

                // Content
                VStack(alignment: .leading, spacing: theme.xxs) {
                    if let title = title {
                        Text(title)
                            .font(theme.headline)
                            .foregroundColor(textColor)
                    }

                    Text(message)
                        .font(theme.body)
                        .foregroundColor(textColor.opacity(0.9))

                    if let action = action {
                        Button(action.title, action: action.action)
                            .font(theme.subheadline.weight(.semibold))
                            .foregroundColor(actionColor)
                            .padding(.top, theme.xs)
                    }
                }

                Spacer()

                // Dismiss button
                if isDismissible {
                    Button(action: dismiss) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(textColor.opacity(0.6))
                    }
                }
            }
            .padding(theme.md)
            .background(backgroundColor)
            .overlay(borderOverlay)
            .cornerRadius(theme.radiusMd)
            .transition(.opacity.combined(with: .move(edge: .top)))
        }
    }

    // MARK: - Actions

    private func dismiss() {
        withAnimation(.easeInOut(duration: theme.durationFast)) {
            isVisible = false
        }
        onDismiss?()
    }

    // MARK: - Computed Properties

    private var semanticColor: Color {
        switch type {
        case .info: return theme.info
        case .success: return theme.success
        case .warning: return theme.warning
        case .error: return theme.error
        }
    }

    private var backgroundColor: Color {
        switch variant {
        case .filled: return semanticColor
        case .outlined: return .clear
        case .subtle: return semanticColor.opacity(0.1)
        }
    }

    private var textColor: Color {
        switch variant {
        case .filled: return .white
        case .outlined, .subtle: return semanticColor
        }
    }

    private var iconColor: Color {
        switch variant {
        case .filled: return .white
        case .outlined, .subtle: return semanticColor
        }
    }

    private var actionColor: Color {
        switch variant {
        case .filled: return .white
        case .outlined, .subtle: return semanticColor
        }
    }

    @ViewBuilder
    private var borderOverlay: some View {
        if variant == .outlined {
            RoundedRectangle(cornerRadius: theme.radiusMd)
                .stroke(semanticColor, lineWidth: 1)
        }
    }
}

// MARK: - Banner Alert

/// A full-width banner alert typically shown at the top of a screen
public struct BSBanner: View {

    private let type: BSAlertType
    private let message: String
    private let action: (title: String, action: () -> Void)?
    private let onDismiss: (() -> Void)?

    @State private var isVisible = true
    @Environment(\.theme) private var theme

    public init(
        type: BSAlertType,
        message: String,
        action: (title: String, action: () -> Void)? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        self.type = type
        self.message = message
        self.action = action
        self.onDismiss = onDismiss
    }

    public var body: some View {
        if isVisible {
            HStack(spacing: theme.sm) {
                Image(systemName: type.icon)
                    .font(.system(size: 18))

                Text(message)
                    .font(theme.subheadline)
                    .lineLimit(2)

                Spacer()

                if let action = action {
                    Button(action.title, action: action.action)
                        .font(theme.subheadline.weight(.semibold))
                }

                Button(action: dismiss) {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .bold))
                }
            }
            .foregroundColor(.white)
            .padding(.horizontal, theme.md)
            .padding(.vertical, theme.sm)
            .background(backgroundColor)
            .transition(.move(edge: .top).combined(with: .opacity))
        }
    }

    private func dismiss() {
        withAnimation(.easeInOut(duration: theme.durationFast)) {
            isVisible = false
        }
        onDismiss?()
    }

    private var backgroundColor: Color {
        switch type {
        case .info: return theme.info
        case .success: return theme.success
        case .warning: return theme.warning
        case .error: return theme.error
        }
    }
}

// MARK: - Empty State

/// An empty state component for when there's no content
public struct BSEmptyState: View {

    private let icon: String
    private let title: String
    private let message: String
    private let action: (title: String, action: () -> Void)?

    @Environment(\.theme) private var theme

    public init(
        icon: String = "tray",
        title: String,
        message: String,
        action: (title: String, action: () -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.action = action
    }

    public var body: some View {
        VStack(spacing: theme.lg) {
            Image(systemName: icon)
                .font(.system(size: 64))
                .foregroundColor(theme.placeholder)

            VStack(spacing: theme.sm) {
                Text(title)
                    .font(theme.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(theme.onSurface)

                Text(message)
                    .font(theme.body)
                    .foregroundColor(theme.placeholder)
                    .multilineTextAlignment(.center)
            }

            if let action = action {
                BSButton(action.title, style: .primary, action: action.action)
            }
        }
        .padding(theme.xl)
    }
}

// MARK: - Preview

#if DEBUG
struct BSAlert_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 16) {
                BSAlert(
                    type: .info,
                    title: "Information",
                    message: "This is an informational message"
                )

                BSAlert(
                    type: .success,
                    message: "Your changes have been saved successfully"
                )

                BSAlert(
                    type: .warning,
                    variant: .outlined,
                    title: "Warning",
                    message: "Your subscription will expire in 3 days"
                )

                BSAlert(
                    type: .error,
                    variant: .filled,
                    title: "Error",
                    message: "Failed to save your changes",
                    action: ("Retry", {})
                )

                BSBanner(
                    type: .info,
                    message: "A new version is available",
                    action: ("Update", {})
                )

                BSEmptyState(
                    icon: "doc.text.magnifyingglass",
                    title: "No Results Found",
                    message: "Try adjusting your search or filters",
                    action: ("Clear Filters", {})
                )
            }
            .padding()
        }
        .withTheme()
    }
}
#endif
