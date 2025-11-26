// BSSearchBar.swift
// BootstrapUI
//
// Search bar component with filtering capabilities
// Follows Composition - combines atoms for search functionality

import SwiftUI

// MARK: - Search Bar Component

/// A customizable search bar component
///
/// Example usage:
/// ```swift
/// @State private var searchText = ""
///
/// BSSearchBar(
///     text: $searchText,
///     placeholder: "Search products...",
///     showsCancelButton: true
/// )
/// ```
public struct BSSearchBar: View {

    // MARK: - Properties

    @Binding private var text: String
    private let placeholder: String
    private let showsCancelButton: Bool
    private let showsFilterButton: Bool
    private let isLoading: Bool
    private let onSubmit: (() -> Void)?
    private let onCancel: (() -> Void)?
    private let onFilter: (() -> Void)?

    @Environment(\.theme) private var theme
    @FocusState private var isFocused: Bool

    // MARK: - Initialization

    /// Creates a search bar
    /// - Parameters:
    ///   - text: Binding to search text
    ///   - placeholder: Placeholder text
    ///   - showsCancelButton: Whether to show cancel button when focused
    ///   - showsFilterButton: Whether to show filter button
    ///   - isLoading: Whether to show loading indicator
    ///   - onSubmit: Action when search is submitted
    ///   - onCancel: Action when cancelled
    ///   - onFilter: Action when filter button is tapped
    public init(
        text: Binding<String>,
        placeholder: String = "Search...",
        showsCancelButton: Bool = true,
        showsFilterButton: Bool = false,
        isLoading: Bool = false,
        onSubmit: (() -> Void)? = nil,
        onCancel: (() -> Void)? = nil,
        onFilter: (() -> Void)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.showsCancelButton = showsCancelButton
        self.showsFilterButton = showsFilterButton
        self.isLoading = isLoading
        self.onSubmit = onSubmit
        self.onCancel = onCancel
        self.onFilter = onFilter
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: theme.sm) {
            // Search field
            HStack(spacing: theme.sm) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(theme.placeholder)
                    .font(.system(size: 16))

                TextField(placeholder, text: $text)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .submitLabel(.search)
                    .focused($isFocused)
                    .onSubmit {
                        onSubmit?()
                    }

                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                } else if !text.isEmpty {
                    Button(action: clearText) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(theme.placeholder)
                            .font(.system(size: 16))
                    }
                }

                if showsFilterButton {
                    Button(action: { onFilter?() }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundColor(theme.primary)
                            .font(.system(size: 18))
                    }
                }
            }
            .padding(.horizontal, theme.md)
            .padding(.vertical, theme.sm + 2)
            .background(theme.surface)
            .cornerRadius(theme.radiusMd)

            // Cancel button
            if showsCancelButton && isFocused {
                Button("Cancel") {
                    cancelSearch()
                }
                .foregroundColor(theme.primary)
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: theme.durationFast), value: isFocused)
    }

    // MARK: - Actions

    private func clearText() {
        text = ""
    }

    private func cancelSearch() {
        text = ""
        isFocused = false
        onCancel?()
    }
}

// MARK: - Search Bar with Scope

/// A search bar with scope buttons for filtering categories
public struct BSScopedSearchBar<Scope: Hashable>: View {

    @Binding private var text: String
    @Binding private var selectedScope: Scope
    private let scopes: [Scope]
    private let scopeTitle: (Scope) -> String
    private let placeholder: String
    private let onSubmit: (() -> Void)?

    @Environment(\.theme) private var theme

    public init(
        text: Binding<String>,
        selectedScope: Binding<Scope>,
        scopes: [Scope],
        scopeTitle: @escaping (Scope) -> String,
        placeholder: String = "Search...",
        onSubmit: (() -> Void)? = nil
    ) {
        self._text = text
        self._selectedScope = selectedScope
        self.scopes = scopes
        self.scopeTitle = scopeTitle
        self.placeholder = placeholder
        self.onSubmit = onSubmit
    }

    public var body: some View {
        VStack(spacing: theme.sm) {
            BSSearchBar(
                text: $text,
                placeholder: placeholder,
                onSubmit: onSubmit
            )

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: theme.sm) {
                    ForEach(scopes, id: \.self) { scope in
                        Button(action: { selectedScope = scope }) {
                            Text(scopeTitle(scope))
                                .font(theme.subheadline)
                                .fontWeight(selectedScope == scope ? .semibold : .regular)
                                .padding(.horizontal, theme.md)
                                .padding(.vertical, theme.xs)
                                .background(
                                    selectedScope == scope ? theme.primary : theme.surface
                                )
                                .foregroundColor(
                                    selectedScope == scope ? theme.onPrimary : theme.onSurface
                                )
                                .cornerRadius(theme.radiusFull)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Search Suggestions

/// A search bar with suggestions dropdown
public struct BSSearchBarWithSuggestions: View {

    @Binding private var text: String
    private let suggestions: [String]
    private let placeholder: String
    private let onSelect: (String) -> Void
    private let onSubmit: (() -> Void)?

    @State private var showSuggestions = false
    @FocusState private var isFocused: Bool
    @Environment(\.theme) private var theme

    public init(
        text: Binding<String>,
        suggestions: [String],
        placeholder: String = "Search...",
        onSelect: @escaping (String) -> Void,
        onSubmit: (() -> Void)? = nil
    ) {
        self._text = text
        self.suggestions = suggestions
        self.placeholder = placeholder
        self.onSelect = onSelect
        self.onSubmit = onSubmit
    }

    public var body: some View {
        VStack(spacing: 0) {
            BSSearchBar(
                text: $text,
                placeholder: placeholder,
                onSubmit: {
                    showSuggestions = false
                    onSubmit?()
                }
            )

            if showSuggestions && !filteredSuggestions.isEmpty {
                VStack(spacing: 0) {
                    ForEach(filteredSuggestions.prefix(5), id: \.self) { suggestion in
                        Button(action: {
                            text = suggestion
                            showSuggestions = false
                            onSelect(suggestion)
                        }) {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(theme.placeholder)
                                Text(suggestion)
                                    .foregroundColor(theme.onSurface)
                                Spacer()
                            }
                            .padding(.horizontal, theme.md)
                            .padding(.vertical, theme.sm)
                        }

                        if suggestion != filteredSuggestions.prefix(5).last {
                            BSInsetDivider(leadingInset: theme.md)
                        }
                    }
                }
                .background(theme.surface)
                .cornerRadius(theme.radiusMd)
                .shadow(color: theme.shadowMd.color, radius: theme.shadowMd.radius)
                .padding(.top, theme.xs)
            }
        }
        .onChange(of: text) { _, newValue in
            showSuggestions = !newValue.isEmpty
        }
    }

    private var filteredSuggestions: [String] {
        guard !text.isEmpty else { return [] }
        return suggestions.filter { $0.localizedCaseInsensitiveContains(text) }
    }
}

// MARK: - Preview

#if DEBUG
struct BSSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 32) {
            BSSearchBar(text: .constant(""))

            BSSearchBar(
                text: .constant("Swift"),
                showsFilterButton: true
            )

            BSSearchBar(
                text: .constant(""),
                isLoading: true
            )

            BSScopedSearchBar(
                text: .constant(""),
                selectedScope: .constant("All"),
                scopes: ["All", "Images", "Videos", "Documents"],
                scopeTitle: { $0 }
            )
        }
        .padding()
        .withTheme()
    }
}
#endif
