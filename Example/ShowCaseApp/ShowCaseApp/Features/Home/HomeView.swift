// HomeView.swift
// ShowCaseApp
//
// Home screen with library overview

import SwiftUI
import BootstrapUI

struct HomeView: View {
    @EnvironmentObject var navigation: NavigationState
    @EnvironmentObject var appState: AppState
    @Environment(\.theme) var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.lg) {
                // Header
                headerSection

                // Quick Stats
                statsSection

                // Categories
                categoriesSection

                // Quick Actions
                quickActionsSection
            }
            .padding(theme.md)
        }
        .background(theme.background)
    }

    // MARK: - Header Section

    private var headerSection: some View {
        VStack(spacing: theme.md) {
            HStack {
                VStack(alignment: .leading, spacing: theme.xs) {
                    BSText("BootstrapUI", style: .largeTitle, weight: .bold)
                    BSText("SwiftUI Component Library", style: .subheadline, color: .secondary)
                }

                Spacer()

                BSIconButton(icon: "gear", style: .ghost, size: .large) {
                    navigation.showSettings = true
                }
            }

            // Version badge
            HStack {
                BSBadge("v\(BootstrapUI.version)", variant: .subtle, color: .primary)
                BSBadge("SwiftUI", variant: .subtle, color: .info)
                BSBadge("iOS 15+", variant: .subtle, color: .success)
                Spacer()
            }
        }
    }

    // MARK: - Stats Section

    private var statsSection: some View {
        BSCard(variant: .filled) {
            HStack(spacing: theme.md) {
                StatItem(value: "11", label: "Atoms", icon: "atom")
                Divider().frame(height: 40)
                StatItem(value: "10", label: "Molecules", icon: "diamond")
                Divider().frame(height: 40)
                StatItem(value: "6", label: "Organisms", icon: "square.stack.3d.up")
                Divider().frame(height: 40)
                StatItem(value: "5", label: "Templates", icon: "rectangle.3.group")
                Divider().frame(height: 40)
                StatItem(value: "16", label: "Themes", icon: "paintpalette")
            }
            .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Categories Section

    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: theme.md) {
            BSSectionHeader("Component Categories")

            VStack(spacing: theme.sm) {
                CategoryCard(
                    title: "Atoms",
                    description: "Basic building blocks: buttons, text, icons, chips, ratings",
                    icon: "atom",
                    color: .blue,
                    count: 11
                ) {
                    navigation.selectedTab = .atoms
                }

                CategoryCard(
                    title: "Molecules",
                    description: "Combinations: cards, inputs, charts, FAB, steps",
                    icon: "diamond.fill",
                    color: .purple,
                    count: 10
                ) {
                    navigation.selectedTab = .molecules
                }

                CategoryCard(
                    title: "Organisms",
                    description: "Complex: forms, navigation, swipe cards",
                    icon: "square.stack.3d.up.fill",
                    color: .orange,
                    count: 6
                ) {
                    navigation.selectedTab = .organisms
                }

                CategoryCard(
                    title: "Templates",
                    description: "Page layouts, onboarding, and structures",
                    icon: "rectangle.3.group.fill",
                    color: .green,
                    count: 5
                ) {
                    navigation.selectedTab = .templates
                }

                CategoryCard(
                    title: "Extras",
                    description: "E-commerce, social, chat, themes & more",
                    icon: "sparkles",
                    color: .pink,
                    count: 12
                ) {
                    navigation.selectedTab = .extras
                }
            }
        }
    }

    // MARK: - Quick Actions Section

    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: theme.md) {
            BSSectionHeader("Quick Actions")

            HStack(spacing: theme.md) {
                BSButton("Show Toast", style: .outline, icon: "bell.fill") {
                    BSToastManager.shared.success("This is a toast notification!")
                }

                BSButton("Toggle Theme", style: .outline, icon: "moon.fill") {
                    appState.isDarkMode.toggle()
                }
            }
        }
    }
}

// MARK: - Supporting Views

struct StatItem: View {
    let value: String
    let label: String
    let icon: String

    @Environment(\.theme) var theme

    var body: some View {
        VStack(spacing: theme.xs) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(theme.primary)

            BSText(value, style: .title2, weight: .bold)
            BSText(label, style: .caption1, color: .secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct CategoryCard: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let count: Int
    let action: () -> Void

    @Environment(\.theme) var theme

    var body: some View {
        BSCard(isInteractive: true, onTap: action) {
            HStack(spacing: theme.md) {
                // Icon
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                    .frame(width: 50, height: 50)
                    .background(color.opacity(0.1))
                    .cornerRadius(theme.radiusMd)

                // Content
                VStack(alignment: .leading, spacing: theme.xxs) {
                    HStack {
                        BSText(title, style: .headline)
                        BSBadge("\(count)", size: .small, color: .neutral)
                    }
                    BSText(description, style: .caption1, color: .secondary, lineLimit: 2)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(theme.placeholder)
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AppState())
        .environmentObject(NavigationState())
        .withTheme()
}
