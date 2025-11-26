// BSForm.swift
// BootstrapUI
//
// Form component for data collection
// Follows Composition - combines molecules for form handling

import SwiftUI

// MARK: - Form Section

/// A section within a form
public struct BSFormSection<Content: View>: View {

    private let title: String?
    private let footer: String?
    private let content: () -> Content

    @Environment(\.theme) private var theme

    public init(
        title: String? = nil,
        footer: String? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.footer = footer
        self.content = content
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: theme.sm) {
            if let title = title {
                Text(title.uppercased())
                    .font(theme.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(theme.placeholder)
                    .padding(.horizontal, theme.md)
            }

            VStack(spacing: 0) {
                content()
            }
            .background(theme.surface)
            .cornerRadius(theme.radiusMd)

            if let footer = footer {
                Text(footer)
                    .font(theme.footnote)
                    .foregroundColor(theme.placeholder)
                    .padding(.horizontal, theme.md)
            }
        }
    }
}

// MARK: - Form Row

/// A standard row within a form section
public struct BSFormRow<Content: View>: View {

    private let label: String
    private let isRequired: Bool
    private let showsDivider: Bool
    private let content: () -> Content

    @Environment(\.theme) private var theme

    public init(
        label: String,
        isRequired: Bool = false,
        showsDivider: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.label = label
        self.isRequired = isRequired
        self.showsDivider = showsDivider
        self.content = content
    }

    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                HStack(spacing: theme.xxs) {
                    Text(label)
                        .font(theme.body)
                        .foregroundColor(theme.onSurface)

                    if isRequired {
                        Text("*")
                            .foregroundColor(theme.error)
                    }
                }

                Spacer()

                content()
            }
            .padding(.horizontal, theme.md)
            .padding(.vertical, theme.sm + 4)

            if showsDivider {
                BSInsetDivider(leadingInset: theme.md)
            }
        }
    }
}

// MARK: - Form Component

/// A complete form component with sections
public struct BSForm<Content: View>: View {

    private let content: () -> Content

    @Environment(\.theme) private var theme

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: theme.lg) {
                content()
            }
            .padding(.vertical, theme.md)
        }
        .background(theme.background)
    }
}

// MARK: - Form Field Types

/// A text input row for forms
public struct BSFormTextField: View {

    private let label: String
    @Binding private var text: String
    private let placeholder: String
    private let isRequired: Bool
    private let keyboardType: UIKeyboardType

    @Environment(\.theme) private var theme

    public init(
        label: String,
        text: Binding<String>,
        placeholder: String = "",
        isRequired: Bool = false,
        keyboardType: UIKeyboardType = .default
    ) {
        self.label = label
        self._text = text
        self.placeholder = placeholder
        self.isRequired = isRequired
        self.keyboardType = keyboardType
    }

    public var body: some View {
        BSFormRow(label: label, isRequired: isRequired) {
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .multilineTextAlignment(.trailing)
                .foregroundColor(theme.onSurface)
        }
    }
}

/// A toggle row for forms
public struct BSFormToggle: View {

    private let label: String
    @Binding private var isOn: Bool

    @Environment(\.theme) private var theme

    public init(label: String, isOn: Binding<Bool>) {
        self.label = label
        self._isOn = isOn
    }

    public var body: some View {
        BSFormRow(label: label) {
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(theme.primary)
        }
    }
}

/// A picker row for forms
public struct BSFormPicker<T: Hashable>: View {

    private let label: String
    @Binding private var selection: T
    private let options: [T]
    private let optionLabel: (T) -> String

    @Environment(\.theme) private var theme

    public init(
        label: String,
        selection: Binding<T>,
        options: [T],
        optionLabel: @escaping (T) -> String
    ) {
        self.label = label
        self._selection = selection
        self.options = options
        self.optionLabel = optionLabel
    }

    public var body: some View {
        BSFormRow(label: label) {
            Picker("", selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(optionLabel(option)).tag(option)
                }
            }
            .pickerStyle(.menu)
            .tint(theme.onSurface)
        }
    }
}

/// A date picker row for forms
public struct BSFormDatePicker: View {

    private let label: String
    @Binding private var date: Date
    private let displayedComponents: DatePickerComponents

    @Environment(\.theme) private var theme

    public init(
        label: String,
        date: Binding<Date>,
        displayedComponents: DatePickerComponents = .date
    ) {
        self.label = label
        self._date = date
        self.displayedComponents = displayedComponents
    }

    public var body: some View {
        BSFormRow(label: label) {
            DatePicker("", selection: $date, displayedComponents: displayedComponents)
                .labelsHidden()
                .tint(theme.primary)
        }
    }
}

/// A stepper row for forms
public struct BSFormStepper: View {

    private let label: String
    @Binding private var value: Int
    private let range: ClosedRange<Int>

    @Environment(\.theme) private var theme

    public init(
        label: String,
        value: Binding<Int>,
        range: ClosedRange<Int> = 0...100
    ) {
        self.label = label
        self._value = value
        self.range = range
    }

    public var body: some View {
        BSFormRow(label: label) {
            HStack(spacing: theme.sm) {
                Text("\(value)")
                    .font(theme.body)
                    .foregroundColor(theme.onSurface)
                    .monospacedDigit()

                Stepper("", value: $value, in: range)
                    .labelsHidden()
            }
        }
    }
}

// MARK: - Form Actions

/// Action buttons for forms
public struct BSFormActions: View {

    private let primaryTitle: String
    private let primaryAction: () -> Void
    private let secondaryTitle: String?
    private let secondaryAction: (() -> Void)?
    private let isLoading: Bool
    private let isDisabled: Bool

    @Environment(\.theme) private var theme

    public init(
        primaryTitle: String,
        primaryAction: @escaping () -> Void,
        secondaryTitle: String? = nil,
        secondaryAction: (() -> Void)? = nil,
        isLoading: Bool = false,
        isDisabled: Bool = false
    ) {
        self.primaryTitle = primaryTitle
        self.primaryAction = primaryAction
        self.secondaryTitle = secondaryTitle
        self.secondaryAction = secondaryAction
        self.isLoading = isLoading
        self.isDisabled = isDisabled
    }

    public var body: some View {
        VStack(spacing: theme.sm) {
            BSButton(
                primaryTitle,
                style: .primary,
                isFullWidth: true,
                isLoading: isLoading,
                isDisabled: isDisabled,
                action: primaryAction
            )

            if let secondaryTitle = secondaryTitle,
               let secondaryAction = secondaryAction {
                BSButton(
                    secondaryTitle,
                    style: .ghost,
                    isFullWidth: true,
                    action: secondaryAction
                )
            }
        }
        .padding(.horizontal, theme.md)
        .padding(.vertical, theme.lg)
    }
}

// MARK: - Preview

#if DEBUG
struct BSForm_Previews: PreviewProvider {
    static var previews: some View {
        BSForm {
            BSFormSection(title: "Personal Information", footer: "Your name will be visible to others") {
                BSFormTextField(label: "First Name", text: .constant("John"), isRequired: true)
                BSFormTextField(label: "Last Name", text: .constant("Doe"))
                BSFormTextField(label: "Email", text: .constant("john@example.com"), keyboardType: .emailAddress)
            }

            BSFormSection(title: "Preferences") {
                BSFormToggle(label: "Email Notifications", isOn: .constant(true))
                BSFormToggle(label: "Push Notifications", isOn: .constant(false))
                BSFormPicker(
                    label: "Language",
                    selection: .constant("English"),
                    options: ["English", "Spanish", "French"],
                    optionLabel: { $0 }
                )
            }

            BSFormSection(title: "Account") {
                BSFormDatePicker(label: "Birthday", date: .constant(Date()))
                BSFormStepper(label: "Quantity", value: .constant(5), range: 1...10)
            }

            BSFormActions(
                primaryTitle: "Save Changes",
                primaryAction: {},
                secondaryTitle: "Cancel",
                secondaryAction: {}
            )
        }
        .withTheme()
    }
}
#endif
