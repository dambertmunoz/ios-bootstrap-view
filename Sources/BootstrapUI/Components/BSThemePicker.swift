// BSThemePicker.swift
// BootstrapUI
//
// Theme selection components for switching between themes
// Provides UI for browsing and selecting from predefined themes

import SwiftUI

// MARK: - Theme Picker

/// A grid-based theme picker for selecting from predefined themes
public struct BSThemePicker: View {

    @Binding private var selectedTheme: Theme
    private let themes: [Theme]
    private let columns: Int
    private let showLabels: Bool
    private let onThemeSelected: ((Theme) -> Void)?

    @Environment(\.theme) private var theme

    public init(
        selectedTheme: Binding<Theme>,
        themes: [Theme] = Theme.allThemes,
        columns: Int = 2,
        showLabels: Bool = true,
        onThemeSelected: ((Theme) -> Void)? = nil
    ) {
        self._selectedTheme = selectedTheme
        self.themes = themes
        self.columns = columns
        self.showLabels = showLabels
        self.onThemeSelected = onThemeSelected
    }

    public var body: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: theme.md), count: columns),
            spacing: theme.md
        ) {
            ForEach(themes, id: \.name) { themeOption in
                ThemeCard(
                    theme: themeOption,
                    isSelected: themeOption.name == selectedTheme.name,
                    showLabel: showLabels
                ) {
                    selectedTheme = themeOption
                    onThemeSelected?(themeOption)
                }
            }
        }
    }
}

// MARK: - Theme Card

/// Individual theme preview card
private struct ThemeCard: View {

    let theme: Theme
    let isSelected: Bool
    let showLabel: Bool
    let onTap: () -> Void

    @Environment(\.theme) private var currentTheme

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: currentTheme.sm) {
                // Theme preview
                ZStack {
                    RoundedRectangle(cornerRadius: currentTheme.radiusMd)
                        .fill(theme.background)
                        .frame(height: 80)

                    VStack(spacing: currentTheme.xs) {
                        // Header simulation
                        HStack {
                            Circle()
                                .fill(theme.primary)
                                .frame(width: 12, height: 12)
                            RoundedRectangle(cornerRadius: 2)
                                .fill(theme.onBackground.opacity(0.3))
                                .frame(width: 40, height: 8)
                            Spacer()
                        }

                        // Content simulation
                        HStack(spacing: currentTheme.xs) {
                            RoundedRectangle(cornerRadius: currentTheme.radiusSm)
                                .fill(theme.surface)
                                .frame(width: 30, height: 30)

                            VStack(alignment: .leading, spacing: 4) {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(theme.onSurface.opacity(0.7))
                                    .frame(width: 50, height: 6)
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(theme.onSurface.opacity(0.4))
                                    .frame(width: 35, height: 4)
                            }

                            Spacer()

                            Circle()
                                .fill(theme.secondary)
                                .frame(width: 16, height: 16)
                        }

                        // Button simulation
                        RoundedRectangle(cornerRadius: currentTheme.radiusSm)
                            .fill(theme.primary)
                            .frame(height: 14)
                    }
                    .padding(currentTheme.sm)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: currentTheme.radiusMd)
                        .stroke(isSelected ? currentTheme.primary : currentTheme.border, lineWidth: isSelected ? 2 : 1)
                )

                if showLabel {
                    HStack {
                        if isSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(currentTheme.primary)
                                .font(.caption)
                        }

                        Text(theme.name)
                            .font(currentTheme.caption1)
                            .foregroundColor(currentTheme.onSurface)

                        if theme.isDark {
                            Image(systemName: "moon.fill")
                                .font(.caption2)
                                .foregroundColor(currentTheme.placeholder)
                        }
                    }
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(theme.name) theme")
        .accessibilityHint(isSelected ? "Currently selected" : "Double tap to select")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

// MARK: - Theme Picker Row

/// Horizontal scrollable theme picker
public struct BSThemePickerRow: View {

    @Binding private var selectedTheme: Theme
    private let themes: [Theme]
    private let onThemeSelected: ((Theme) -> Void)?

    @Environment(\.theme) private var theme

    public init(
        selectedTheme: Binding<Theme>,
        themes: [Theme] = Theme.allThemes,
        onThemeSelected: ((Theme) -> Void)? = nil
    ) {
        self._selectedTheme = selectedTheme
        self.themes = themes
        self.onThemeSelected = onThemeSelected
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: theme.md) {
                ForEach(themes, id: \.name) { themeOption in
                    ThemeChip(
                        theme: themeOption,
                        isSelected: themeOption.name == selectedTheme.name
                    ) {
                        selectedTheme = themeOption
                        onThemeSelected?(themeOption)
                    }
                }
            }
            .padding(.horizontal, theme.md)
        }
    }
}

// MARK: - Theme Chip

/// Compact theme chip for horizontal picker
private struct ThemeChip: View {

    let theme: Theme
    let isSelected: Bool
    let onTap: () -> Void

    @Environment(\.theme) private var currentTheme

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: currentTheme.sm) {
                // Color dots
                HStack(spacing: 2) {
                    Circle()
                        .fill(theme.primary)
                        .frame(width: 10, height: 10)
                    Circle()
                        .fill(theme.secondary)
                        .frame(width: 10, height: 10)
                    Circle()
                        .fill(theme.background)
                        .frame(width: 10, height: 10)
                        .overlay(
                            Circle()
                                .stroke(currentTheme.border, lineWidth: 1)
                        )
                }

                Text(theme.name)
                    .font(currentTheme.caption1)
                    .foregroundColor(isSelected ? currentTheme.primary : currentTheme.onSurface)
            }
            .padding(.horizontal, currentTheme.sm)
            .padding(.vertical, currentTheme.xs)
            .background(
                RoundedRectangle(cornerRadius: currentTheme.radiusFull)
                    .fill(isSelected ? currentTheme.primary.opacity(0.1) : currentTheme.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: currentTheme.radiusFull)
                    .stroke(isSelected ? currentTheme.primary : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(theme.name) theme")
        .accessibilityHint(isSelected ? "Currently selected" : "Double tap to select")
    }
}

// MARK: - Theme Switcher

/// Simple light/dark mode toggle
public struct BSThemeSwitcher: View {

    @ObservedObject private var themeManager: ThemeManager

    @Environment(\.theme) private var theme

    public init(themeManager: ThemeManager = .shared) {
        self.themeManager = themeManager
    }

    public var body: some View {
        Button {
            themeManager.toggleTheme()
        } label: {
            Image(systemName: themeManager.currentTheme.isDark ? "sun.max.fill" : "moon.fill")
                .font(.title2)
                .foregroundColor(theme.primary)
                .frame(width: 44, height: 44)
                .background(theme.surface)
                .clipShape(Circle())
        }
        .accessibilityLabel(themeManager.currentTheme.isDark ? "Switch to light mode" : "Switch to dark mode")
    }
}

// MARK: - Theme Settings View

/// Full theme settings view with all options
public struct BSThemeSettings: View {

    @ObservedObject private var themeManager: ThemeManager
    @State private var selectedTheme: Theme

    @Environment(\.theme) private var theme

    public init(themeManager: ThemeManager = .shared) {
        self.themeManager = themeManager
        self._selectedTheme = State(initialValue: themeManager.currentTheme)
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: theme.lg) {
            // Auto mode toggle
            BSToggle(
                isOn: Binding(
                    get: { themeManager.followSystemAppearance },
                    set: { themeManager.followSystemAppearance = $0 }
                ),
                label: "Follow System",
                style: .labeled
            )

            if !themeManager.followSystemAppearance {
                // Light themes section
                VStack(alignment: .leading, spacing: theme.sm) {
                    BSText("Light Themes", style: .headline)

                    BSThemePickerRow(
                        selectedTheme: $selectedTheme,
                        themes: Theme.lightThemes
                    ) { newTheme in
                        themeManager.setTheme(newTheme)
                    }
                }

                // Dark themes section
                VStack(alignment: .leading, spacing: theme.sm) {
                    BSText("Dark Themes", style: .headline)

                    BSThemePickerRow(
                        selectedTheme: $selectedTheme,
                        themes: Theme.darkThemes
                    ) { newTheme in
                        themeManager.setTheme(newTheme)
                    }
                }
            }
        }
        .padding(theme.md)
        .background(theme.background)
        .onChange(of: themeManager.currentTheme) { _, newTheme in
            selectedTheme = newTheme
        }
    }
}

// MARK: - Color Palette Preview

/// Shows all colors from a theme
public struct BSColorPalettePreview: View {

    let previewTheme: Theme

    @Environment(\.theme) private var theme

    public init(theme: Theme) {
        self.previewTheme = theme
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: theme.md) {
            BSText(previewTheme.name, style: .headline)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: theme.sm) {
                ColorSwatch(name: "Primary", color: previewTheme.primary)
                ColorSwatch(name: "Secondary", color: previewTheme.secondary)
                ColorSwatch(name: "Background", color: previewTheme.background)
                ColorSwatch(name: "Surface", color: previewTheme.surface)
                ColorSwatch(name: "Error", color: previewTheme.error)
                ColorSwatch(name: "Success", color: previewTheme.success)
                ColorSwatch(name: "Warning", color: previewTheme.warning)
                ColorSwatch(name: "Info", color: previewTheme.info)
            }
        }
        .padding(theme.md)
        .background(theme.surface)
        .cornerRadius(theme.radiusMd)
    }
}

private struct ColorSwatch: View {

    let name: String
    let color: Color

    @Environment(\.theme) private var theme

    var body: some View {
        VStack(spacing: theme.xs) {
            RoundedRectangle(cornerRadius: theme.radiusSm)
                .fill(color)
                .frame(height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: theme.radiusSm)
                        .stroke(theme.border, lineWidth: 0.5)
                )

            Text(name)
                .font(theme.caption2)
                .foregroundColor(theme.placeholder)
        }
    }
}

// MARK: - Preview

#if DEBUG
struct BSThemePicker_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 32) {
                BSThemePicker(
                    selectedTheme: .constant(.light)
                )

                BSDivider()

                BSThemePickerRow(
                    selectedTheme: .constant(.dracula)
                )

                BSDivider()

                BSThemeSwitcher()

                BSDivider()

                BSColorPalettePreview(theme: .dracula)
            }
            .padding()
        }
        .withTheme()
    }
}
#endif
