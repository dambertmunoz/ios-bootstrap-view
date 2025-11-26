// BSButton.swift
// BootstrapUI
//
// Customizable button component with multiple styles and sizes
// Follows Single Responsibility Principle - handles button presentation only

import SwiftUI

// MARK: - Button Style Enum

/// Available button styles
public enum BSButtonStyle: String, CaseIterable, Sendable {
    case primary
    case secondary
    case outline
    case ghost
    case destructive
    case success
    case link
}

// MARK: - Button Size Enum

/// Available button sizes
public enum BSButtonSize: String, CaseIterable, Sendable {
    case small
    case medium
    case large

    var verticalPadding: CGFloat {
        switch self {
        case .small: return 8
        case .medium: return 12
        case .large: return 16
        }
    }

    var horizontalPadding: CGFloat {
        switch self {
        case .small: return 16
        case .medium: return 24
        case .large: return 32
        }
    }

    var font: Font {
        switch self {
        case .small: return .footnote.weight(.semibold)
        case .medium: return .body.weight(.semibold)
        case .large: return .title3.weight(.semibold)
        }
    }

    var iconSize: CGFloat {
        switch self {
        case .small: return 14
        case .medium: return 18
        case .large: return 22
        }
    }
}

// MARK: - Button Component

/// A customizable button component following design system guidelines
///
/// Example usage:
/// ```swift
/// BSButton("Click Me", style: .primary, size: .medium) {
///     print("Button tapped")
/// }
///
/// BSButton("Delete", style: .destructive, icon: "trash") {
///     deleteItem()
/// }
/// ```
public struct BSButton: View {

    // MARK: - Properties

    private let title: String
    private let style: BSButtonStyle
    private let size: BSButtonSize
    private let icon: String?
    private let iconPosition: IconPosition
    private let isFullWidth: Bool
    private let isLoading: Bool
    private let isDisabled: Bool
    private let action: () -> Void

    @Environment(\.theme) private var theme

    // MARK: - Icon Position

    public enum IconPosition {
        case leading
        case trailing
    }

    // MARK: - Initialization

    /// Creates a new button
    /// - Parameters:
    ///   - title: Button title text
    ///   - style: Button style (default: .primary)
    ///   - size: Button size (default: .medium)
    ///   - icon: Optional SF Symbol name
    ///   - iconPosition: Position of the icon (default: .leading)
    ///   - isFullWidth: Whether button should fill available width (default: false)
    ///   - isLoading: Whether to show loading state (default: false)
    ///   - isDisabled: Whether button is disabled (default: false)
    ///   - action: Action to perform when tapped
    public init(
        _ title: String,
        style: BSButtonStyle = .primary,
        size: BSButtonSize = .medium,
        icon: String? = nil,
        iconPosition: IconPosition = .leading,
        isFullWidth: Bool = false,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.size = size
        self.icon = icon
        self.iconPosition = iconPosition
        self.isFullWidth = isFullWidth
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        Button(action: {
            if !isLoading && !isDisabled {
                action()
            }
        }) {
            HStack(spacing: theme.sm) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: foregroundColor))
                        .scaleEffect(0.8)
                } else {
                    if iconPosition == .leading, let icon = icon {
                        iconView(icon)
                    }

                    Text(title)
                        .font(size.font)

                    if iconPosition == .trailing, let icon = icon {
                        iconView(icon)
                    }
                }
            }
            .padding(.vertical, size.verticalPadding)
            .padding(.horizontal, size.horizontalPadding)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .cornerRadius(theme.radiusMd)
            .overlay(
                RoundedRectangle(cornerRadius: theme.radiusMd)
                    .stroke(borderColor, lineWidth: style == .outline ? theme.widthThin : 0)
            )
        }
        .disabled(isDisabled || isLoading)
        .opacity(isDisabled ? 0.5 : 1.0)
        .animation(.easeInOut(duration: theme.durationFast), value: isLoading)
        .animation(.easeInOut(duration: theme.durationFast), value: isDisabled)
    }

    // MARK: - Private Views

    @ViewBuilder
    private func iconView(_ name: String) -> some View {
        Image(systemName: name)
            .font(.system(size: size.iconSize, weight: .semibold))
    }

    // MARK: - Computed Properties

    private var foregroundColor: Color {
        switch style {
        case .primary:
            return theme.onPrimary
        case .secondary:
            return theme.onSecondary
        case .outline, .ghost:
            return theme.primary
        case .destructive:
            return theme.onError
        case .success:
            return .white
        case .link:
            return theme.primary
        }
    }

    private var backgroundColor: Color {
        switch style {
        case .primary:
            return theme.primary
        case .secondary:
            return theme.secondary
        case .outline, .ghost, .link:
            return .clear
        case .destructive:
            return theme.error
        case .success:
            return theme.success
        }
    }

    private var borderColor: Color {
        switch style {
        case .outline:
            return theme.primary
        default:
            return .clear
        }
    }
}

// MARK: - Button Style Modifier (Strategy Pattern)

/// Custom button style for BSButton
public struct BSButtonStyleModifier: ButtonStyle {
    let theme: Theme
    let style: BSButtonStyle

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: theme.durationFast), value: configuration.isPressed)
    }
}

// MARK: - Icon Only Button

/// An icon-only button variant
public struct BSIconButton: View {
    private let icon: String
    private let style: BSButtonStyle
    private let size: BSButtonSize
    private let isDisabled: Bool
    private let action: () -> Void

    @Environment(\.theme) private var theme

    public init(
        icon: String,
        style: BSButtonStyle = .ghost,
        size: BSButtonSize = .medium,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.style = style
        self.size = size
        self.isDisabled = isDisabled
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size.iconSize, weight: .semibold))
                .foregroundColor(foregroundColor)
                .frame(width: buttonSize, height: buttonSize)
                .background(backgroundColor)
                .cornerRadius(theme.radiusMd)
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1.0)
    }

    private var buttonSize: CGFloat {
        switch size {
        case .small: return 32
        case .medium: return 44
        case .large: return 56
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .primary: return theme.onPrimary
        case .secondary: return theme.onSecondary
        case .outline, .ghost, .link: return theme.primary
        case .destructive: return theme.onError
        case .success: return .white
        }
    }

    private var backgroundColor: Color {
        switch style {
        case .primary: return theme.primary
        case .secondary: return theme.secondary
        case .outline, .ghost, .link: return .clear
        case .destructive: return theme.error
        case .success: return theme.success
        }
    }
}

// MARK: - Preview

#if DEBUG
struct BSButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            BSButton("Primary Button", style: .primary) {}
            BSButton("Secondary", style: .secondary) {}
            BSButton("Outline", style: .outline) {}
            BSButton("Ghost", style: .ghost) {}
            BSButton("Destructive", style: .destructive, icon: "trash") {}
            BSButton("Loading", style: .primary, isLoading: true) {}
            BSButton("Disabled", style: .primary, isDisabled: true) {}
            BSButton("Full Width", style: .primary, isFullWidth: true) {}
        }
        .padding()
        .withTheme()
    }
}
#endif
