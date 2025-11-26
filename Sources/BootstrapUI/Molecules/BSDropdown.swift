// BSDropdown.swift
// BootstrapUI
//
// Dropdown select components with search and multi-select support
// Provides native-feeling picker experience

import SwiftUI

// MARK: - BSDropdown

/// A dropdown select component
public struct BSDropdown<T: Hashable>: View {

    @Binding private var selection: T?
    private let options: [T]
    private let labelProvider: (T) -> String
    private let placeholder: String
    private let icon: String?
    private let isSearchable: Bool
    private let isDisabled: Bool

    @State private var isExpanded = false
    @State private var searchText = ""

    @Environment(\.theme) private var theme

    public init(
        selection: Binding<T?>,
        options: [T],
        labelProvider: @escaping (T) -> String,
        placeholder: String = "Select...",
        icon: String? = nil,
        isSearchable: Bool = false,
        isDisabled: Bool = false
    ) {
        self._selection = selection
        self.options = options
        self.labelProvider = labelProvider
        self.placeholder = placeholder
        self.icon = icon
        self.isSearchable = isSearchable
        self.isDisabled = isDisabled
    }

    private var filteredOptions: [T] {
        guard isSearchable, !searchText.isEmpty else { return options }
        return options.filter { labelProvider($0).localizedCaseInsensitiveContains(searchText) }
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Trigger button
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: theme.sm) {
                    if let icon = icon {
                        Image(systemName: icon)
                            .foregroundColor(theme.placeholder)
                    }

                    Text(selection.map(labelProvider) ?? placeholder)
                        .foregroundColor(selection == nil ? theme.placeholder : theme.onSurface)

                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(theme.placeholder)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .font(theme.body)
                .padding(theme.md)
                .background(theme.surface)
                .cornerRadius(theme.radiusMd)
                .overlay(
                    RoundedRectangle(cornerRadius: theme.radiusMd)
                        .stroke(isExpanded ? theme.primary : theme.border, lineWidth: 1)
                )
            }
            .disabled(isDisabled)
            .opacity(isDisabled ? 0.5 : 1)

            // Dropdown content
            if isExpanded {
                VStack(spacing: 0) {
                    // Search field
                    if isSearchable {
                        HStack(spacing: theme.sm) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(theme.placeholder)
                            TextField("Search...", text: $searchText)
                        }
                        .padding(theme.sm)
                        .background(theme.background)

                        BSDivider()
                    }

                    // Options
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(filteredOptions, id: \.self) { option in
                                optionRow(option)
                            }

                            if filteredOptions.isEmpty {
                                BSText("No results found", style: .subheadline, color: .secondary)
                                    .padding(theme.md)
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                }
                .background(theme.surface)
                .cornerRadius(theme.radiusMd)
                .shadow(color: theme.onSurface.opacity(0.1), radius: 8, x: 0, y: 4)
                .transition(.opacity.combined(with: .scale(scale: 0.95, anchor: .top)))
            }
        }
    }

    private func optionRow(_ option: T) -> some View {
        Button {
            selection = option
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                isExpanded = false
            }
            searchText = ""
        } label: {
            HStack {
                Text(labelProvider(option))
                    .foregroundColor(theme.onSurface)

                Spacer()

                if selection == option {
                    Image(systemName: "checkmark")
                        .foregroundColor(theme.primary)
                        .font(.system(size: 14, weight: .semibold))
                }
            }
            .padding(theme.md)
            .background(selection == option ? theme.primary.opacity(0.1) : Color.clear)
        }
    }
}

// MARK: - BSMultiDropdown

/// A multi-select dropdown component
public struct BSMultiDropdown<T: Hashable>: View {

    @Binding private var selection: Set<T>
    private let options: [T]
    private let labelProvider: (T) -> String
    private let placeholder: String
    private let maxDisplayedSelections: Int
    private let isSearchable: Bool

    @State private var isExpanded = false
    @State private var searchText = ""

    @Environment(\.theme) private var theme

    public init(
        selection: Binding<Set<T>>,
        options: [T],
        labelProvider: @escaping (T) -> String,
        placeholder: String = "Select...",
        maxDisplayedSelections: Int = 3,
        isSearchable: Bool = false
    ) {
        self._selection = selection
        self.options = options
        self.labelProvider = labelProvider
        self.placeholder = placeholder
        self.maxDisplayedSelections = maxDisplayedSelections
        self.isSearchable = isSearchable
    }

    private var filteredOptions: [T] {
        guard isSearchable, !searchText.isEmpty else { return options }
        return options.filter { labelProvider($0).localizedCaseInsensitiveContains(searchText) }
    }

    private var displayText: String {
        guard !selection.isEmpty else { return placeholder }

        let selectedLabels = selection.prefix(maxDisplayedSelections).map(labelProvider)
        var text = selectedLabels.joined(separator: ", ")

        if selection.count > maxDisplayedSelections {
            text += " +\(selection.count - maxDisplayedSelections) more"
        }

        return text
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Trigger button
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: theme.sm) {
                    Text(displayText)
                        .foregroundColor(selection.isEmpty ? theme.placeholder : theme.onSurface)
                        .lineLimit(1)

                    Spacer()

                    if !selection.isEmpty {
                        BSCountBadge(selection.count)
                    }

                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(theme.placeholder)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .font(theme.body)
                .padding(theme.md)
                .background(theme.surface)
                .cornerRadius(theme.radiusMd)
                .overlay(
                    RoundedRectangle(cornerRadius: theme.radiusMd)
                        .stroke(isExpanded ? theme.primary : theme.border, lineWidth: 1)
                )
            }

            // Dropdown content
            if isExpanded {
                VStack(spacing: 0) {
                    // Search field
                    if isSearchable {
                        HStack(spacing: theme.sm) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(theme.placeholder)
                            TextField("Search...", text: $searchText)
                        }
                        .padding(theme.sm)
                        .background(theme.background)

                        BSDivider()
                    }

                    // Clear all / Select all
                    HStack {
                        Button("Select All") {
                            selection = Set(options)
                        }
                        .font(theme.caption1)
                        .foregroundColor(theme.primary)

                        Spacer()

                        Button("Clear") {
                            selection.removeAll()
                        }
                        .font(theme.caption1)
                        .foregroundColor(theme.error)
                    }
                    .padding(.horizontal, theme.md)
                    .padding(.vertical, theme.sm)

                    BSDivider()

                    // Options
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(filteredOptions, id: \.self) { option in
                                optionRow(option)
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                }
                .background(theme.surface)
                .cornerRadius(theme.radiusMd)
                .shadow(color: theme.onSurface.opacity(0.1), radius: 8, x: 0, y: 4)
                .transition(.opacity.combined(with: .scale(scale: 0.95, anchor: .top)))
            }
        }
    }

    private func optionRow(_ option: T) -> some View {
        Button {
            if selection.contains(option) {
                selection.remove(option)
            } else {
                selection.insert(option)
            }
        } label: {
            HStack {
                Image(systemName: selection.contains(option) ? "checkmark.square.fill" : "square")
                    .foregroundColor(selection.contains(option) ? theme.primary : theme.border)

                Text(labelProvider(option))
                    .foregroundColor(theme.onSurface)

                Spacer()
            }
            .padding(theme.md)
            .background(selection.contains(option) ? theme.primary.opacity(0.05) : Color.clear)
        }
    }
}

// MARK: - BSPicker

/// A styled picker wrapper
public struct BSPicker<T: Hashable, Label: View>: View {

    @Binding private var selection: T
    private let options: [T]
    private let labelProvider: (T) -> String
    private let label: () -> Label

    @Environment(\.theme) private var theme

    public init(
        selection: Binding<T>,
        options: [T],
        labelProvider: @escaping (T) -> String,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self._selection = selection
        self.options = options
        self.labelProvider = labelProvider
        self.label = label
    }

    public var body: some View {
        HStack {
            label()

            Spacer()

            Picker("", selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(labelProvider(option)).tag(option)
                }
            }
            .pickerStyle(.menu)
            .tint(theme.primary)
        }
        .padding(theme.md)
        .background(theme.surface)
        .cornerRadius(theme.radiusMd)
    }
}

extension BSPicker where Label == Text {
    public init(
        _ title: String,
        selection: Binding<T>,
        options: [T],
        labelProvider: @escaping (T) -> String
    ) {
        self._selection = selection
        self.options = options
        self.labelProvider = labelProvider
        self.label = { Text(title) }
    }
}

// MARK: - Preview

#if DEBUG
struct BSDropdown_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 32) {
            BSDropdown(
                selection: .constant("Option 1"),
                options: ["Option 1", "Option 2", "Option 3"],
                labelProvider: { $0 },
                placeholder: "Select option",
                isSearchable: true
            )

            BSMultiDropdown(
                selection: .constant(Set(["A", "B"])),
                options: ["A", "B", "C", "D", "E"],
                labelProvider: { $0 }
            )
        }
        .padding()
        .withTheme()
    }
}
#endif
