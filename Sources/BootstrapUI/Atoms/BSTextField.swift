// BSTextField.swift
// BootstrapUI
//
// Customizable text field component with validation support
// Follows Single Responsibility Principle - handles text input presentation

import SwiftUI

// MARK: - TextField State

/// Visual state of the text field
public enum BSTextFieldState: Equatable, Sendable {
    case normal
    case focused
    case error(String)
    case success
    case disabled
}

// MARK: - TextField Style

/// Available text field styles
public enum BSTextFieldStyle: String, CaseIterable, Sendable {
    case outlined
    case filled
    case underlined
}

// MARK: - TextField Component

/// A customizable text field component with validation support
///
/// Example usage:
/// ```swift
/// @State private var email = ""
/// @State private var emailState: BSTextFieldState = .normal
///
/// BSTextField(
///     "Email",
///     text: $email,
///     state: emailState,
///     placeholder: "Enter your email",
///     icon: "envelope"
/// )
/// ```
public struct BSTextField: View {

    // MARK: - Properties

    private let label: String
    @Binding private var text: String
    private let state: BSTextFieldState
    private let placeholder: String
    private let style: BSTextFieldStyle
    private let icon: String?
    private let trailingIcon: String?
    private let isSecure: Bool
    private let keyboardType: UIKeyboardType
    private let autocapitalization: TextInputAutocapitalization
    private let submitLabel: SubmitLabel
    private let onSubmit: (() -> Void)?
    private let onTrailingIconTap: (() -> Void)?

    @Environment(\.theme) private var theme
    @FocusState private var isFocused: Bool

    // MARK: - Initialization

    /// Creates a new text field
    /// - Parameters:
    ///   - label: Label text shown above the field
    ///   - text: Binding to the text value
    ///   - state: Current state of the field (default: .normal)
    ///   - placeholder: Placeholder text
    ///   - style: Visual style (default: .outlined)
    ///   - icon: Leading SF Symbol icon name
    ///   - trailingIcon: Trailing SF Symbol icon name
    ///   - isSecure: Whether to mask input (default: false)
    ///   - keyboardType: Keyboard type (default: .default)
    ///   - autocapitalization: Autocapitalization behavior
    ///   - submitLabel: Submit button label
    ///   - onSubmit: Action when submit is pressed
    ///   - onTrailingIconTap: Action when trailing icon is tapped
    public init(
        _ label: String,
        text: Binding<String>,
        state: BSTextFieldState = .normal,
        placeholder: String = "",
        style: BSTextFieldStyle = .outlined,
        icon: String? = nil,
        trailingIcon: String? = nil,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default,
        autocapitalization: TextInputAutocapitalization = .sentences,
        submitLabel: SubmitLabel = .done,
        onSubmit: (() -> Void)? = nil,
        onTrailingIconTap: (() -> Void)? = nil
    ) {
        self.label = label
        self._text = text
        self.state = state
        self.placeholder = placeholder
        self.style = style
        self.icon = icon
        self.trailingIcon = trailingIcon
        self.isSecure = isSecure
        self.keyboardType = keyboardType
        self.autocapitalization = autocapitalization
        self.submitLabel = submitLabel
        self.onSubmit = onSubmit
        self.onTrailingIconTap = onTrailingIconTap
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: theme.xs) {
            // Label
            if !label.isEmpty {
                Text(label)
                    .font(theme.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(labelColor)
            }

            // Input field
            HStack(spacing: theme.sm) {
                // Leading icon
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(iconColor)
                        .font(.system(size: 16))
                }

                // Text field
                Group {
                    if isSecure {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                    }
                }
                .textInputAutocapitalization(autocapitalization)
                .keyboardType(keyboardType)
                .submitLabel(submitLabel)
                .focused($isFocused)
                .onSubmit {
                    onSubmit?()
                }

                // Trailing icon or state icon
                if let trailingIcon = trailingIcon {
                    Button(action: { onTrailingIconTap?() }) {
                        Image(systemName: trailingIcon)
                            .foregroundColor(iconColor)
                            .font(.system(size: 16))
                    }
                } else if case .success = state {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(theme.success)
                        .font(.system(size: 16))
                } else if case .error = state {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(theme.error)
                        .font(.system(size: 16))
                }
            }
            .padding(.horizontal, theme.md)
            .padding(.vertical, theme.sm + 4)
            .background(backgroundColor)
            .overlay(borderOverlay)
            .cornerRadius(cornerRadius)

            // Error message
            if case .error(let message) = state {
                Text(message)
                    .font(theme.caption1)
                    .foregroundColor(theme.error)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeInOut(duration: theme.durationFast), value: state)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.6 : 1.0)
    }

    // MARK: - Computed Properties

    private var isDisabled: Bool {
        if case .disabled = state { return true }
        return false
    }

    private var labelColor: Color {
        switch state {
        case .error: return theme.error
        case .focused: return theme.primary
        default: return theme.onSurface.opacity(0.7)
        }
    }

    private var iconColor: Color {
        switch state {
        case .error: return theme.error
        case .focused: return theme.primary
        default: return theme.placeholder
        }
    }

    private var backgroundColor: Color {
        switch style {
        case .outlined: return .clear
        case .filled: return theme.surface
        case .underlined: return .clear
        }
    }

    private var borderColor: Color {
        switch state {
        case .error: return theme.error
        case .success: return theme.success
        case .focused: return theme.primary
        default:
            return isFocused ? theme.primary : theme.border
        }
    }

    @ViewBuilder
    private var borderOverlay: some View {
        switch style {
        case .outlined:
            RoundedRectangle(cornerRadius: theme.radiusMd)
                .stroke(borderColor, lineWidth: isFocused ? 2 : 1)
        case .filled:
            RoundedRectangle(cornerRadius: theme.radiusMd)
                .stroke(borderColor, lineWidth: isFocused ? 2 : 0)
        case .underlined:
            VStack {
                Spacer()
                Rectangle()
                    .fill(borderColor)
                    .frame(height: isFocused ? 2 : 1)
            }
        }
    }

    private var cornerRadius: CGFloat {
        style == .underlined ? 0 : theme.radiusMd
    }
}

// MARK: - Text Area Component

/// A multi-line text input component
public struct BSTextArea: View {

    private let label: String
    @Binding private var text: String
    private let placeholder: String
    private let minHeight: CGFloat
    private let maxHeight: CGFloat
    private let state: BSTextFieldState

    @Environment(\.theme) private var theme
    @FocusState private var isFocused: Bool

    public init(
        _ label: String,
        text: Binding<String>,
        placeholder: String = "",
        minHeight: CGFloat = 100,
        maxHeight: CGFloat = 200,
        state: BSTextFieldState = .normal
    ) {
        self.label = label
        self._text = text
        self.placeholder = placeholder
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.state = state
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: theme.xs) {
            if !label.isEmpty {
                Text(label)
                    .font(theme.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(theme.onSurface.opacity(0.7))
            }

            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(theme.placeholder)
                        .padding(.horizontal, theme.xs)
                        .padding(.vertical, theme.sm)
                }

                TextEditor(text: $text)
                    .focused($isFocused)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: minHeight, maxHeight: maxHeight)
            }
            .padding(theme.sm)
            .background(theme.surface)
            .overlay(
                RoundedRectangle(cornerRadius: theme.radiusMd)
                    .stroke(borderColor, lineWidth: isFocused ? 2 : 1)
            )
            .cornerRadius(theme.radiusMd)

            if case .error(let message) = state {
                Text(message)
                    .font(theme.caption1)
                    .foregroundColor(theme.error)
            }
        }
    }

    private var borderColor: Color {
        switch state {
        case .error: return theme.error
        case .success: return theme.success
        default: return isFocused ? theme.primary : theme.border
        }
    }
}

// MARK: - Preview

#if DEBUG
struct BSTextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 24) {
            BSTextField(
                "Email",
                text: .constant(""),
                placeholder: "Enter your email",
                icon: "envelope"
            )

            BSTextField(
                "Password",
                text: .constant("password123"),
                placeholder: "Enter password",
                icon: "lock",
                trailingIcon: "eye.slash",
                isSecure: true
            )

            BSTextField(
                "Error State",
                text: .constant("invalid"),
                state: .error("This field is required"),
                placeholder: "Enter value"
            )

            BSTextField(
                "Success State",
                text: .constant("valid@email.com"),
                state: .success,
                placeholder: "Enter email"
            )

            BSTextField(
                "Filled Style",
                text: .constant(""),
                placeholder: "Filled input",
                style: .filled
            )

            BSTextArea(
                "Description",
                text: .constant(""),
                placeholder: "Enter description..."
            )
        }
        .padding()
        .withTheme()
    }
}
#endif
