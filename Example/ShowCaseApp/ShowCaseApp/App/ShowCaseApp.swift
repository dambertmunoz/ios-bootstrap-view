// ShowCaseApp.swift
// ShowCaseApp
//
// Main entry point for the BootstrapUI ShowCase application

import SwiftUI
import BootstrapUI

@main
struct ShowCaseApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var navigation = NavigationState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .environmentObject(navigation)
                .withTheme(appState.themeManager)
                .withToasts()
        }
    }
}

// MARK: - App State

/// Global application state
final class AppState: ObservableObject {
    @Published var themeManager = ThemeManager.shared
    @Published var isDarkMode: Bool = false {
        didSet {
            themeManager.setTheme(isDarkMode ? .dark : .light)
        }
    }

    init() {
        // Initialize with system preference if needed
    }
}

// MARK: - Navigation State

/// Navigation state for the app
final class NavigationState: ObservableObject {
    @Published var selectedTab: Tab = .home
    @Published var showSettings: Bool = false

    enum Tab: String, CaseIterable, Identifiable {
        case home = "Home"
        case atoms = "Atoms"
        case molecules = "Molecules"
        case organisms = "Organisms"
        case templates = "Templates"

        var id: String { rawValue }

        var icon: String {
            switch self {
            case .home: return "house"
            case .atoms: return "atom"
            case .molecules: return "diamond"
            case .organisms: return "square.stack.3d.up"
            case .templates: return "rectangle.3.group"
            }
        }

        var selectedIcon: String {
            switch self {
            case .home: return "house.fill"
            case .atoms: return "atom"
            case .molecules: return "diamond.fill"
            case .organisms: return "square.stack.3d.up.fill"
            case .templates: return "rectangle.3.group.fill"
            }
        }
    }
}
