// View+Extensions.swift
// BootstrapUI
//
// SwiftUI View extensions for common modifiers and utilities

import SwiftUI

// MARK: - Conditional Modifiers

extension View {

    /// Apply a modifier conditionally
    /// - Parameters:
    ///   - condition: The condition to evaluate
    ///   - transform: The modifier to apply if condition is true
    /// - Returns: Modified or original view
    @ViewBuilder
    public func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    /// Apply one of two modifiers based on a condition
    /// - Parameters:
    ///   - condition: The condition to evaluate
    ///   - ifTrue: Modifier to apply if true
    ///   - ifFalse: Modifier to apply if false
    /// - Returns: Modified view
    @ViewBuilder
    public func `if`<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        ifTrue: (Self) -> TrueContent,
        ifFalse: (Self) -> FalseContent
    ) -> some View {
        if condition {
            ifTrue(self)
        } else {
            ifFalse(self)
        }
    }

    /// Apply a modifier if the value is not nil
    /// - Parameters:
    ///   - value: Optional value to check
    ///   - transform: Modifier to apply with the unwrapped value
    /// - Returns: Modified or original view
    @ViewBuilder
    public func ifLet<T, Content: View>(
        _ value: T?,
        transform: (Self, T) -> Content
    ) -> some View {
        if let value = value {
            transform(self, value)
        } else {
            self
        }
    }
}

// MARK: - Frame Extensions

extension View {

    /// Apply a square frame
    /// - Parameter size: The size for both width and height
    /// - Returns: View with square frame
    public func frame(square size: CGFloat) -> some View {
        self.frame(width: size, height: size)
    }

    /// Fill the maximum available space
    /// - Returns: View filling max space
    public func fillMaxSize() -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    /// Fill the maximum width
    /// - Parameter alignment: Alignment within the frame
    /// - Returns: View filling max width
    public func fillMaxWidth(alignment: Alignment = .center) -> some View {
        self.frame(maxWidth: .infinity, alignment: alignment)
    }

    /// Fill the maximum height
    /// - Parameter alignment: Alignment within the frame
    /// - Returns: View filling max height
    public func fillMaxHeight(alignment: Alignment = .center) -> some View {
        self.frame(maxHeight: .infinity, alignment: alignment)
    }
}

// MARK: - Background Extensions

extension View {

    /// Add a themed card background
    /// - Parameters:
    ///   - theme: The theme to use
    ///   - cornerRadius: Corner radius
    /// - Returns: View with card background
    public func cardBackground(theme: Theme, cornerRadius: CGFloat? = nil) -> some View {
        self
            .background(theme.surface)
            .cornerRadius(cornerRadius ?? theme.radiusLg)
            .shadow(
                color: theme.shadowMd.color,
                radius: theme.shadowMd.radius,
                x: theme.shadowMd.x,
                y: theme.shadowMd.y
            )
    }
}

// MARK: - Loading Overlay

extension View {

    /// Add a loading overlay to the view
    /// - Parameters:
    ///   - isLoading: Whether to show loading state
    ///   - message: Optional message to display
    /// - Returns: View with loading overlay
    public func loadingOverlay(isLoading: Bool, message: String? = nil) -> some View {
        ZStack {
            self
                .disabled(isLoading)
                .blur(radius: isLoading ? 2 : 0)

            if isLoading {
                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.5)

                    if let message = message {
                        Text(message)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.3))
            }
        }
        .animation(.easeInOut, value: isLoading)
    }
}

// MARK: - Keyboard Extensions

extension View {

    /// Hide keyboard when tapping outside
    /// - Returns: View with tap-to-dismiss keyboard
    public func hideKeyboardOnTap() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil,
                from: nil,
                for: nil
            )
        }
    }
}

// MARK: - Accessibility Extensions

extension View {

    /// Add common accessibility modifiers
    /// - Parameters:
    ///   - label: Accessibility label
    ///   - hint: Accessibility hint
    ///   - traits: Accessibility traits
    /// - Returns: View with accessibility modifiers
    public func accessible(
        label: String,
        hint: String? = nil,
        traits: AccessibilityTraits = []
    ) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
            .accessibilityAddTraits(traits)
    }
}

// MARK: - Animation Extensions

extension View {

    /// Apply spring animation on appear
    /// - Parameters:
    ///   - delay: Delay before animation starts
    ///   - animation: The animation to use
    /// - Returns: View with appear animation
    public func animateOnAppear(
        delay: Double = 0,
        animation: Animation = .spring(response: 0.5, dampingFraction: 0.7)
    ) -> some View {
        modifier(AppearAnimationModifier(delay: delay, animation: animation))
    }
}

struct AppearAnimationModifier: ViewModifier {
    let delay: Double
    let animation: Animation

    @State private var isVisible = false

    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .scaleEffect(isVisible ? 1 : 0.95)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    withAnimation(animation) {
                        isVisible = true
                    }
                }
            }
    }
}

// MARK: - Debug Extensions

#if DEBUG
extension View {

    /// Add debug border with random color
    /// - Returns: View with debug border
    public func debugBorder() -> some View {
        self.border(Color.random, width: 1)
    }

    /// Print and return the view (for debugging)
    /// - Parameter message: Message to print
    /// - Returns: Unchanged view
    public func debug(_ message: String) -> some View {
        print("DEBUG: \(message)")
        return self
    }
}

extension Color {
    static var random: Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
#endif

// MARK: - Safe Area Extensions

extension View {

    /// Read safe area insets
    /// - Parameter action: Callback with safe area insets
    /// - Returns: View that reports safe area insets
    public func readSafeArea(_ action: @escaping (EdgeInsets) -> Void) -> some View {
        self.background(
            GeometryReader { proxy in
                Color.clear
                    .onAppear {
                        action(proxy.safeAreaInsets)
                    }
            }
        )
    }
}

// MARK: - Navigation Extensions

extension View {

    /// Embed in a navigation stack
    /// - Returns: View wrapped in NavigationStack
    public func embedInNavigation() -> some View {
        NavigationStack {
            self
        }
    }
}
