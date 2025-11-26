// BSBadge.swift
// BootstrapUI
//
// Badge and chip components for labels and status indicators
// Follows Single Responsibility Principle - handles badge presentation

import SwiftUI

// MARK: - Badge Variant

/// Available badge variants
public enum BSBadgeVariant: String, CaseIterable, Sendable {
    case filled
    case outlined
    case subtle
}

// MARK: - Badge Color

/// Semantic colors for badges
public enum BSBadgeColor: String, CaseIterable, Sendable {
    case primary
    case secondary
    case success
    case warning
    case error
    case info
    case neutral
}

// MARK: - Badge Size

/// Available badge sizes
public enum BSBadgeSize: String, CaseIterable, Sendable {
    case small
    case medium
    case large

    var verticalPadding: CGFloat {
        switch self {
        case .small: return 2
        case .medium: return 4
        case .large: return 6
        }
    }

    var horizontalPadding: CGFloat {
        switch self {
        case .small: return 6
        case .medium: return 8
        case .large: return 12
        }
    }

    var font: Font {
        switch self {
        case .small: return .caption2.weight(.semibold)
        case .medium: return .caption.weight(.semibold)
        case .large: return .footnote.weight(.semibold)
        }
    }
}

// MARK: - Badge Component

/// A badge component for status indicators and labels
///
/// Example usage:
/// ```swift
/// BSBadge("New")
/// BSBadge("Success", color: .success)
/// BSBadge("Outlined", variant: .outlined, color: .primary)
/// BSBadge("With Icon", icon: "star.fill")
/// ```
public struct BSBadge: View {

    // MARK: - Properties

    private let text: String
    private let variant: BSBadgeVariant
    private let color: BSBadgeColor
    private let size: BSBadgeSize
    private let icon: String?
    private let isDismissible: Bool
    private let onDismiss: (() -> Void)?

    @Environment(\.theme) private var theme

    // MARK: - Initialization

    /// Creates a badge
    /// - Parameters:
    ///   - text: Badge text
    ///   - variant: Visual variant (default: .filled)
    ///   - color: Semantic color (default: .primary)
    ///   - size: Badge size (default: .medium)
    ///   - icon: Optional SF Symbol icon
    ///   - isDismissible: Whether badge can be dismissed (default: false)
    ///   - onDismiss: Callback when dismissed
    public init(
        _ text: String,
        variant: BSBadgeVariant = .filled,
        color: BSBadgeColor = .primary,
        size: BSBadgeSize = .medium,
        icon: String? = nil,
        isDismissible: Bool = false,
        onDismiss: (() -> Void)? = nil
    ) {
        self.text = text
        self.variant = variant
        self.color = color
        self.size = size
        self.icon = icon
        self.isDismissible = isDismissible
        self.onDismiss = onDismiss
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: 4) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: iconSize))
            }

            Text(text)
                .font(size.font)

            if isDismissible {
                Button(action: { onDismiss?() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: iconSize, weight: .bold))
                }
            }
        }
        .foregroundColor(foregroundColor)
        .padding(.vertical, size.verticalPadding)
        .padding(.horizontal, size.horizontalPadding)
        .background(backgroundColor)
        .overlay(borderOverlay)
        .clipShape(Capsule())
    }

    // MARK: - Computed Properties

    private var iconSize: CGFloat {
        switch size {
        case .small: return 8
        case .medium: return 10
        case .large: return 12
        }
    }

    private var foregroundColor: Color {
        switch variant {
        case .filled:
            return .white
        case .outlined, .subtle:
            return semanticColor
        }
    }

    private var backgroundColor: Color {
        switch variant {
        case .filled:
            return semanticColor
        case .outlined:
            return .clear
        case .subtle:
            return semanticColor.opacity(0.15)
        }
    }

    @ViewBuilder
    private var borderOverlay: some View {
        if variant == .outlined {
            Capsule()
                .stroke(semanticColor, lineWidth: 1)
        } else {
            EmptyView()
        }
    }

    private var semanticColor: Color {
        switch color {
        case .primary: return theme.primary
        case .secondary: return theme.secondary
        case .success: return theme.success
        case .warning: return theme.warning
        case .error: return theme.error
        case .info: return theme.info
        case .neutral: return theme.onSurface.opacity(0.6)
        }
    }
}

// MARK: - Dot Badge

/// A simple dot indicator
public struct BSDotBadge: View {

    private let color: BSBadgeColor
    private let size: CGFloat
    private let isPulsing: Bool

    @State private var isAnimating = false
    @Environment(\.theme) private var theme

    public init(
        color: BSBadgeColor = .error,
        size: CGFloat = 8,
        isPulsing: Bool = false
    ) {
        self.color = color
        self.size = size
        self.isPulsing = isPulsing
    }

    public var body: some View {
        Circle()
            .fill(semanticColor)
            .frame(width: size, height: size)
            .scaleEffect(isPulsing && isAnimating ? 1.2 : 1.0)
            .opacity(isPulsing && isAnimating ? 0.7 : 1.0)
            .onAppear {
                if isPulsing {
                    withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                        isAnimating = true
                    }
                }
            }
    }

    private var semanticColor: Color {
        switch color {
        case .primary: return theme.primary
        case .secondary: return theme.secondary
        case .success: return theme.success
        case .warning: return theme.warning
        case .error: return theme.error
        case .info: return theme.info
        case .neutral: return theme.onSurface.opacity(0.6)
        }
    }
}

// MARK: - Count Badge

/// A badge showing a count number
public struct BSCountBadge: View {

    private let count: Int
    private let maxCount: Int
    private let color: BSBadgeColor
    private let size: BSBadgeSize

    @Environment(\.theme) private var theme

    public init(
        _ count: Int,
        maxCount: Int = 99,
        color: BSBadgeColor = .error,
        size: BSBadgeSize = .small
    ) {
        self.count = count
        self.maxCount = maxCount
        self.color = color
        self.size = size
    }

    public var body: some View {
        if count > 0 {
            BSBadge(
                displayText,
                variant: .filled,
                color: color,
                size: size
            )
        }
    }

    private var displayText: String {
        count > maxCount ? "\(maxCount)+" : "\(count)"
    }
}

// MARK: - Status Badge

/// A badge with predefined status styles
public struct BSStatusBadge: View {

    public enum Status: String, CaseIterable {
        case active
        case inactive
        case pending
        case completed
        case failed
        case cancelled

        var color: BSBadgeColor {
            switch self {
            case .active: return .success
            case .inactive: return .neutral
            case .pending: return .warning
            case .completed: return .success
            case .failed: return .error
            case .cancelled: return .neutral
            }
        }

        var icon: String {
            switch self {
            case .active: return "checkmark.circle.fill"
            case .inactive: return "minus.circle.fill"
            case .pending: return "clock.fill"
            case .completed: return "checkmark.seal.fill"
            case .failed: return "xmark.circle.fill"
            case .cancelled: return "slash.circle.fill"
            }
        }
    }

    private let status: Status
    private let showIcon: Bool
    private let customText: String?

    public init(
        _ status: Status,
        showIcon: Bool = true,
        customText: String? = nil
    ) {
        self.status = status
        self.showIcon = showIcon
        self.customText = customText
    }

    public var body: some View {
        BSBadge(
            customText ?? status.rawValue.capitalized,
            variant: .subtle,
            color: status.color,
            icon: showIcon ? status.icon : nil
        )
    }
}

// MARK: - Preview

#if DEBUG
struct BSBadge_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            HStack {
                BSBadge("Primary")
                BSBadge("Success", color: .success)
                BSBadge("Error", color: .error)
            }

            HStack {
                BSBadge("Outlined", variant: .outlined)
                BSBadge("Subtle", variant: .subtle)
            }

            HStack {
                BSBadge("Small", size: .small)
                BSBadge("Medium", size: .medium)
                BSBadge("Large", size: .large)
            }

            HStack {
                BSBadge("With Icon", icon: "star.fill")
                BSBadge("Dismissible", isDismissible: true) {}
            }

            HStack {
                BSDotBadge()
                BSDotBadge(color: .success)
                BSDotBadge(color: .warning, isPulsing: true)
            }

            HStack {
                BSCountBadge(5)
                BSCountBadge(99)
                BSCountBadge(150)
            }

            HStack {
                BSStatusBadge(.active)
                BSStatusBadge(.pending)
                BSStatusBadge(.failed)
            }
        }
        .padding()
        .withTheme()
    }
}
#endif
