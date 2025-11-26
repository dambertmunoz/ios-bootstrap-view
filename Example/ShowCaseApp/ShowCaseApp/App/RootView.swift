// RootView.swift
// ShowCaseApp
//
// Root view with tab navigation

import SwiftUI
import BootstrapUI

struct RootView: View {
    @EnvironmentObject var navigation: NavigationState
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 0) {
            // Content
            TabView(selection: $navigation.selectedTab) {
                HomeView()
                    .tag(NavigationState.Tab.home)

                AtomsShowcaseView()
                    .tag(NavigationState.Tab.atoms)

                MoleculesShowcaseView()
                    .tag(NavigationState.Tab.molecules)

                OrganismsShowcaseView()
                    .tag(NavigationState.Tab.organisms)

                TemplatesShowcaseView()
                    .tag(NavigationState.Tab.templates)

                ExtrasShowcaseView()
                    .tag(NavigationState.Tab.extras)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            // Custom Tab Bar
            BSTabBar(
                selection: $navigation.selectedTab,
                items: NavigationState.Tab.allCases.map { tab in
                    BSTabBar.TabBarItem(
                        id: tab,
                        icon: tab.icon,
                        selectedIcon: tab.selectedIcon,
                        title: tab.rawValue
                    )
                }
            )
        }
        .sheet(isPresented: $navigation.showSettings) {
            SettingsView()
        }
    }
}

// MARK: - Settings View

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @Environment(\.theme) var theme

    var body: some View {
        NavigationStack {
            BSForm {
                BSFormSection(title: "Appearance") {
                    BSToggleListItem(
                        title: "Dark Mode",
                        subtitle: "Toggle dark appearance",
                        icon: "moon.fill",
                        isOn: $appState.isDarkMode
                    )
                }

                BSFormSection(title: "About") {
                    BSListItem(
                        title: "Version",
                        trailingText: BootstrapUI.version,
                        showsDivider: true
                    )

                    BSListItem(
                        title: "Documentation",
                        leadingIcon: "book.fill",
                        showsChevron: true
                    ) {
                        // Open docs
                    }

                    BSListItem(
                        title: "GitHub Repository",
                        leadingIcon: "link",
                        showsChevron: true,
                        showsDivider: false
                    ) {
                        // Open GitHub
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AppState())
        .environmentObject(NavigationState())
        .withTheme()
}
