// BSToggle.swift
// BootstrapUI
//
// Toggle and checkbox components
// Follows Single Responsibility Principle - handles toggle presentation

import SwiftUI

// MARK: - Toggle Style

/// Available toggle styles
public enum BSToggleStyle: String, CaseIterable, Sendable {
    case `switch`
    case checkbox
    case radio
}

// MARK: - Toggle Component

/// A customizable toggle component
///
/// Example usage:
/// ```swift
/// @State private var isEnabled = false
///
/// BSToggle("Enable notifications", isOn: $isEnabled)
/// BSToggle("Accept terms", isOn: $accepted, style: .checkbox)
/// ```
public struct BSToggle: View {

    // MARK: - Properties

    private let label: String
    @Binding private var isOn: Bool
    private let style: BSToggleStyle
    private let isDisabled: Bool
    private let onColor: Color?
    private let onChange: ((Bool) -> Void)?

    @Environment(\.theme) private var theme

    // MARK: - Initialization

    /// Creates a toggle component
    /// - Parameters:
    ///   - label: Toggle label text
    ///   - isOn: Binding to the toggle state
    ///   - style: Toggle visual style (default: .switch)
    ///   - isDisabled: Whether toggle is disabled (default: false)
    ///   - onColor: Custom color when on (nil uses theme primary)
    ///   - onChange: Callback when value changes
    public init(
        _ label: String,
        isOn: Binding<Bool>,
        style: BSToggleStyle = .switch,
        isDisabled: Bool = false,
        onColor: Color? = nil,
        onChange: ((Bool) -> Void)? = nil
    ) {
        self.label = label
        self._isOn = isOn
        self.style = style
        self.isDisabled = isDisabled
        self.onColor = onColor
        self.onChange = onChange
    }

    // MARK: - Body

    public var body: some View {
        Button(action: toggle) {
            HStack(spacing: theme.sm) {
                toggleView

                if !label.isEmpty {
                    Text(label)
                        .font(theme.body)
                        .foregroundColor(isDisabled ? theme.disabled : theme.onSurface)
                }

                Spacer()
            }
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
    }

    // MARK: - Private Views

    @ViewBuilder
    private var toggleView: some View {
        switch style {
        case .switch:
            switchView
        case .checkbox:
            checkboxView
        case .radio:
            radioView
        }
    }

    private var switchView: some View {
        ZStack {
            Capsule()
                .fill(isOn ? (onColor ?? theme.primary) : theme.border)
                .frame(width: 50, height: 30)

            Circle()
                .fill(Color.white)
                .frame(width: 26, height: 26)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                .offset(x: isOn ? 10 : -10)
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isOn)
    }

    private var checkboxView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: theme.radiusSm)
                .stroke(isOn ? (onColor ?? theme.primary) : theme.border, lineWidth: 2)
                .frame(width: 24, height: 24)

            if isOn {
                RoundedRectangle(cornerRadius: theme.radiusSm - 2)
                    .fill(onColor ?? theme.primary)
                    .frame(width: 24, height: 24)

                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .animation(.easeInOut(duration: theme.durationFast), value: isOn)
    }

    private var radioView: some View {
        ZStack {
            Circle()
                .stroke(isOn ? (onColor ?? theme.primary) : theme.border, lineWidth: 2)
                .frame(width: 24, height: 24)

            if isOn {
                Circle()
                    .fill(onColor ?? theme.primary)
                    .frame(width: 14, height: 14)
            }
        }
        .animation(.easeInOut(duration: theme.durationFast), value: isOn)
    }

    // MARK: - Actions

    private func toggle() {
        isOn.toggle()
        onChange?(isOn)
    }
}

// MARK: - Toggle Group

/// A group of radio toggles where only one can be selected
public struct BSToggleGroup<T: Hashable>: View {

    private let options: [T]
    @Binding private var selected: T
    private let labelProvider: (T) -> String
    private let isDisabled: Bool

    @Environment(\.theme) private var theme

    public init(
        options: [T],
        selected: Binding<T>,
        isDisabled: Bool = false,
        labelProvider: @escaping (T) -> String
    ) {
        self.options = options
        self._selected = selected
        self.isDisabled = isDisabled
        self.labelProvider = labelProvider
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: theme.sm) {
            ForEach(options, id: \.self) { option in
                BSToggle(
                    labelProvider(option),
                    isOn: Binding(
                        get: { selected == option },
                        set: { if $0 { selected = option } }
                    ),
                    style: .radio,
                    isDisabled: isDisabled
                )
            }
        }
    }
}

// MARK: - Checkbox List

/// A list of checkboxes for multiple selection
public struct BSCheckboxList<T: Hashable>: View {

    private let options: [T]
    @Binding private var selected: Set<T>
    private let labelProvider: (T) -> String
    private let isDisabled: Bool

    @Environment(\.theme) private var theme

    public init(
        options: [T],
        selected: Binding<Set<T>>,
        isDisabled: Bool = false,
        labelProvider: @escaping (T) -> String
    ) {
        self.options = options
        self._selected = selected
        self.isDisabled = isDisabled
        self.labelProvider = labelProvider
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: theme.sm) {
            ForEach(options, id: \.self) { option in
                BSToggle(
                    labelProvider(option),
                    isOn: Binding(
                        get: { selected.contains(option) },
                        set: { isSelected in
                            if isSelected {
                                selected.insert(option)
                            } else {
                                selected.remove(option)
                            }
                        }
                    ),
                    style: .checkbox,
                    isDisabled: isDisabled
                )
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct BSToggle_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 24) {
            BSToggle("Switch Toggle", isOn: .constant(true))
            BSToggle("Switch Off", isOn: .constant(false))
            BSToggle("Checkbox", isOn: .constant(true), style: .checkbox)
            BSToggle("Radio", isOn: .constant(true), style: .radio)
            BSToggle("Disabled", isOn: .constant(true), isDisabled: true)
            BSToggle("Custom Color", isOn: .constant(true), onColor: .green)
        }
        .padding()
        .withTheme()
    }
}
#endif
