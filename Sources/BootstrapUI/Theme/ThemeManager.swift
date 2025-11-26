// ThemeManager.swift
// BootstrapUI
//
// Centralized theme management using Singleton pattern
// Follows Single Responsibility Principle - only manages theme state

import SwiftUI
import Combine

// MARK: - Theme Manager

/// Central manager for theme state throughout the application
/// Uses Singleton pattern for global access while maintaining testability through protocol
@MainActor
public final class ThemeManager: ObservableObject {

    // MARK: - Singleton

    /// Shared instance for global access
    public static let shared = ThemeManager()

    // MARK: - Published Properties

    /// Current active theme
    @Published public private(set) var currentTheme: Theme

    /// Whether to follow system appearance automatically
    @Published public var followSystemAppearance: Bool = false {
        didSet {
            if followSystemAppearance {
                updateThemeForSystemAppearance()
            }
        }
    }

    // MARK: - Private Properties

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    private init() {
        self.currentTheme = .light
        setupSystemAppearanceObserver()
    }

    /// Initialize with a specific theme (useful for testing)
    public init(theme: Theme) {
        self.currentTheme = theme
        setupSystemAppearanceObserver()
    }

    // MARK: - Public Methods

    /// Set a new theme
    /// - Parameter theme: The theme to apply
    public func setTheme(_ theme: Theme) {
        withAnimation(.easeInOut(duration: currentTheme.durationNormal)) {
            currentTheme = theme
        }
    }

    /// Toggle between light and dark themes
    public func toggleTheme() {
        setTheme(currentTheme.isDark ? .light : .dark)
    }

    /// Reset to the default light theme
    public func resetToDefault() {
        setTheme(.light)
    }

    // MARK: - Private Methods

    private func setupSystemAppearanceObserver() {
        #if os(iOS)
        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .sink { [weak self] _ in
                if self?.followSystemAppearance == true {
                    self?.updateThemeForSystemAppearance()
                }
            }
            .store(in: &cancellables)
        #endif
    }

    private func updateThemeForSystemAppearance() {
        setTheme(.system)
    }
}

// MARK: - Theme Environment Key

/// Environment key for accessing the current theme
public struct ThemeEnvironmentKey: EnvironmentKey {
    public static let defaultValue: Theme = .light
}

extension EnvironmentValues {
    /// The current theme from the environment
    public var theme: Theme {
        get { self[ThemeEnvironmentKey.self] }
        set { self[ThemeEnvironmentKey.self] = newValue }
    }
}

// MARK: - Theme View Modifier

/// View modifier to inject theme into the environment
public struct ThemeModifier: ViewModifier {
    @ObservedObject private var themeManager: ThemeManager

    public init(themeManager: ThemeManager = .shared) {
        self.themeManager = themeManager
    }

    public func body(content: Content) -> some View {
        content
            .environment(\.theme, themeManager.currentTheme)
            .preferredColorScheme(themeManager.currentTheme.isDark ? .dark : .light)
    }
}

// MARK: - View Extension

extension View {
    /// Apply the theme to this view and its descendants
    /// - Parameter themeManager: The theme manager to use (defaults to shared instance)
    /// - Returns: A view with the theme applied
    public func withTheme(_ themeManager: ThemeManager = .shared) -> some View {
        modifier(ThemeModifier(themeManager: themeManager))
    }

    /// Apply a specific theme to this view
    /// - Parameter theme: The theme to apply
    /// - Returns: A view with the theme applied
    public func theme(_ theme: Theme) -> some View {
        environment(\.theme, theme)
    }
}

// MARK: - Theme Provider View

/// A container view that provides theme to all child views
public struct ThemeProvider<Content: View>: View {
    @ObservedObject private var themeManager: ThemeManager
    private let content: () -> Content

    public init(
        themeManager: ThemeManager = .shared,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.themeManager = themeManager
        self.content = content
    }

    public var body: some View {
        content()
            .withTheme(themeManager)
    }
}
