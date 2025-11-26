// BSAccessibility.swift
// BootstrapUI
//
// Accessibility utilities and modifiers for better VoiceOver support
// Implements WCAG guidelines for iOS applications

import SwiftUI

// MARK: - Accessibility Modifiers

extension View {

    /// Adds comprehensive accessibility to a view
    /// - Parameters:
    ///   - label: The accessibility label (what VoiceOver reads)
    ///   - hint: The accessibility hint (additional context)
    ///   - traits: The accessibility traits
    ///   - value: The current value (for controls)
    /// - Returns: A view with accessibility applied
    public func bsAccessible(
        label: String,
        hint: String? = nil,
        traits: AccessibilityTraits = [],
        value: String? = nil
    ) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
            .accessibilityAddTraits(traits)
            .accessibilityValue(value ?? "")
    }

    /// Makes a view accessible as a button
    /// - Parameters:
    ///   - label: What the button does
    ///   - hint: Additional context
    /// - Returns: A view with button accessibility
    public func bsAccessibleButton(
        _ label: String,
        hint: String? = nil
    ) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
            .accessibilityAddTraits(.isButton)
    }

    /// Makes a view accessible as a header
    /// - Parameter label: The header text
    /// - Returns: A view with header accessibility
    public func bsAccessibleHeader(_ label: String) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityAddTraits(.isHeader)
    }

    /// Makes a view accessible as an image
    /// - Parameters:
    ///   - label: Description of the image
    ///   - isDecorative: Whether the image is purely decorative
    /// - Returns: A view with image accessibility
    public func bsAccessibleImage(
        _ label: String,
        isDecorative: Bool = false
    ) -> some View {
        Group {
            if isDecorative {
                self.accessibilityHidden(true)
            } else {
                self
                    .accessibilityLabel(label)
                    .accessibilityAddTraits(.isImage)
            }
        }
    }

    /// Makes a view accessible as a link
    /// - Parameters:
    ///   - label: Description of the link
    ///   - hint: Additional context
    /// - Returns: A view with link accessibility
    public func bsAccessibleLink(
        _ label: String,
        hint: String? = nil
    ) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "Double tap to open")
            .accessibilityAddTraits(.isLink)
    }

    /// Marks a view as selected
    /// - Parameter isSelected: Whether the view is selected
    /// - Returns: A view with selection state
    public func bsAccessibleSelected(_ isSelected: Bool) -> some View {
        self.accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    /// Groups multiple views for accessibility
    /// - Parameter label: The combined accessibility label
    /// - Returns: A grouped accessible view
    public func bsAccessibilityGroup(_ label: String) -> some View {
        self
            .accessibilityElement(children: .combine)
            .accessibilityLabel(label)
    }

    /// Hides a view from accessibility
    /// - Returns: A view hidden from VoiceOver
    public func bsAccessibilityHidden() -> some View {
        self.accessibilityHidden(true)
    }

    /// Adds sort priority for accessibility focus order
    /// - Parameter priority: Higher values are focused first
    /// - Returns: A view with focus priority
    public func bsAccessibilityPriority(_ priority: Double) -> some View {
        self.accessibilitySortPriority(priority)
    }

    /// Announces a message to VoiceOver
    /// - Parameter message: The message to announce
    /// - Returns: A view that posts an announcement
    public func bsAnnounce(_ message: String) -> some View {
        self.onAppear {
            BSAccessibilityManager.announce(message)
        }
    }
}

// MARK: - Accessibility Manager

/// Manager for programmatic accessibility actions
public enum BSAccessibilityManager {

    /// Posts an announcement to VoiceOver
    /// - Parameters:
    ///   - message: The message to announce
    ///   - delay: Optional delay before announcement
    public static func announce(_ message: String, delay: TimeInterval = 0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            #if os(iOS)
            UIAccessibility.post(notification: .announcement, argument: message)
            #endif
        }
    }

    /// Posts a screen changed notification
    /// - Parameter element: Optional element to focus
    public static func screenChanged(focusOn element: Any? = nil) {
        #if os(iOS)
        UIAccessibility.post(notification: .screenChanged, argument: element)
        #endif
    }

    /// Posts a layout changed notification
    /// - Parameter element: Optional element to focus
    public static func layoutChanged(focusOn element: Any? = nil) {
        #if os(iOS)
        UIAccessibility.post(notification: .layoutChanged, argument: element)
        #endif
    }

    /// Checks if VoiceOver is running
    public static var isVoiceOverRunning: Bool {
        #if os(iOS)
        return UIAccessibility.isVoiceOverRunning
        #else
        return false
        #endif
    }

    /// Checks if reduce motion is enabled
    public static var isReduceMotionEnabled: Bool {
        #if os(iOS)
        return UIAccessibility.isReduceMotionEnabled
        #else
        return false
        #endif
    }

    /// Checks if bold text is enabled
    public static var isBoldTextEnabled: Bool {
        #if os(iOS)
        return UIAccessibility.isBoldTextEnabled
        #else
        return false
        #endif
    }

    /// Checks if increase contrast is enabled
    public static var isIncreaseContrastEnabled: Bool {
        #if os(iOS)
        return UIAccessibility.isDarkerSystemColorsEnabled
        #else
        return false
        #endif
    }
}

// MARK: - Reduce Motion Support

extension View {

    /// Applies animation with reduced motion support
    /// - Parameters:
    ///   - animation: The animation to use
    ///   - value: The value that triggers the animation
    /// - Returns: A view with accessible animation
    public func bsAnimation<V: Equatable>(
        _ animation: Animation?,
        value: V
    ) -> some View {
        self.animation(
            BSAccessibilityManager.isReduceMotionEnabled ? nil : animation,
            value: value
        )
    }

    /// Conditionally applies an animation based on reduce motion settings
    /// - Parameters:
    ///   - normalAnimation: Animation when reduce motion is off
    ///   - reducedAnimation: Animation when reduce motion is on (defaults to nil)
    /// - Returns: A view with the appropriate animation
    public func bsConditionalAnimation(
        normal normalAnimation: Animation?,
        reduced reducedAnimation: Animation? = nil
    ) -> some View {
        self.animation(
            BSAccessibilityManager.isReduceMotionEnabled ? reducedAnimation : normalAnimation
        )
    }
}

// MARK: - Dynamic Type Support

extension View {

    /// Applies a scaled font that respects Dynamic Type
    /// - Parameters:
    ///   - style: The text style to base scaling on
    ///   - maxSize: Optional maximum font size
    /// - Returns: A view with a scaled font
    public func bsScaledFont(
        _ style: Font.TextStyle,
        maxSize: CGFloat? = nil
    ) -> some View {
        self.font(.system(style).leading(.loose))
            .dynamicTypeSize(maxSize != nil ? ...DynamicTypeSize.accessibility3 : DynamicTypeSize.large...DynamicTypeSize.accessibility5)
    }

    /// Limits dynamic type scaling to prevent layout issues
    /// - Parameter maxCategory: The maximum text size category
    /// - Returns: A view with limited scaling
    public func bsLimitDynamicType(to maxSize: DynamicTypeSize = .accessibility3) -> some View {
        self.dynamicTypeSize(...maxSize)
    }
}

// MARK: - Focus State Support

/// Environment key for tracking focus
public struct BSFocusedKey: EnvironmentKey {
    public static let defaultValue: Bool = false
}

extension EnvironmentValues {
    public var bsFocused: Bool {
        get { self[BSFocusedKey.self] }
        set { self[BSFocusedKey.self] = newValue }
    }
}

// MARK: - Accessibility Preview Wrapper

/// A wrapper view that shows how the view looks with various accessibility settings
public struct BSAccessibilityPreview<Content: View>: View {

    private let content: () -> Content
    @State private var simulatedSettings = SimulatedSettings()

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        VStack(spacing: 16) {
            // Settings toggles
            VStack(alignment: .leading, spacing: 8) {
                Toggle("Larger Text", isOn: $simulatedSettings.largerText)
                Toggle("Bold Text", isOn: $simulatedSettings.boldText)
                Toggle("Reduce Motion", isOn: $simulatedSettings.reduceMotion)
                Toggle("High Contrast", isOn: $simulatedSettings.highContrast)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)

            Divider()

            // Content preview
            content()
                .dynamicTypeSize(simulatedSettings.largerText ? .accessibility3 : .large)
                .environment(\.legibilityWeight, simulatedSettings.boldText ? .bold : .regular)
        }
    }

    private struct SimulatedSettings {
        var largerText = false
        var boldText = false
        var reduceMotion = false
        var highContrast = false
    }
}

// MARK: - Accessible Container

/// A container that provides proper accessibility grouping
public struct BSAccessibleContainer<Content: View>: View {

    private let label: String
    private let hint: String?
    private let content: () -> Content

    public init(
        label: String,
        hint: String? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.label = label
        self.hint = hint
        self.content = content
    }

    public var body: some View {
        content()
            .accessibilityElement(children: .combine)
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
    }
}

// MARK: - Skip to Content Button

/// A button that allows users to skip to main content (WCAG 2.4.1)
public struct BSSkipToContent: View {

    private let action: () -> Void

    @State private var isFocused = false
    @Environment(\.theme) private var theme

    public init(action: @escaping () -> Void) {
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text("Skip to main content")
                .font(theme.body)
                .foregroundColor(theme.onPrimary)
                .padding(theme.sm)
                .background(theme.primary)
                .cornerRadius(theme.radiusSm)
        }
        .opacity(isFocused ? 1 : 0)
        .accessibilityLabel("Skip to main content")
        .accessibilityHint("Activating this will skip navigation and jump to the main content")
        .accessibilityAddTraits(.isButton)
        .onAccessibilityFocus { focused in
            withAnimation {
                isFocused = focused
            }
        }
    }
}

// MARK: - Accessibility Focus Ring

/// A focus ring that appears when a view has accessibility focus
public struct BSFocusRing: ViewModifier {

    @AccessibilityFocusState private var isFocused: Bool
    let color: Color
    let width: CGFloat

    public init(color: Color = .blue, width: CGFloat = 2) {
        self.color = color
        self.width = width
    }

    public func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(color, lineWidth: isFocused ? width : 0)
            )
            .accessibilityFocused($isFocused)
    }
}

extension View {
    /// Adds a focus ring for accessibility
    public func bsFocusRing(color: Color = .blue, width: CGFloat = 2) -> some View {
        self.modifier(BSFocusRing(color: color, width: width))
    }
}

// MARK: - Semantic Colors

extension Color {

    /// Returns a semantically accessible color based on content type
    public static func bsSemanticColor(for type: BSSemanticColorType, in theme: Theme) -> Color {
        switch type {
        case .interactive:
            return theme.primary
        case .success:
            return theme.success
        case .warning:
            return theme.warning
        case .error:
            return theme.error
        case .info:
            return theme.info
        case .disabled:
            return theme.disabled
        case .text:
            return theme.onBackground
        case .secondaryText:
            return theme.placeholder
        }
    }
}

/// Types of semantic colors
public enum BSSemanticColorType {
    case interactive
    case success
    case warning
    case error
    case info
    case disabled
    case text
    case secondaryText
}

// MARK: - Haptic Feedback

/// Provides haptic feedback for accessibility
public enum BSHaptics {

    /// Light impact feedback
    public static func light() {
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        #endif
    }

    /// Medium impact feedback
    public static func medium() {
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        #endif
    }

    /// Heavy impact feedback
    public static func heavy() {
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        #endif
    }

    /// Success notification feedback
    public static func success() {
        #if os(iOS)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        #endif
    }

    /// Warning notification feedback
    public static func warning() {
        #if os(iOS)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
        #endif
    }

    /// Error notification feedback
    public static func error() {
        #if os(iOS)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
        #endif
    }

    /// Selection feedback
    public static func selection() {
        #if os(iOS)
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        #endif
    }
}

// MARK: - Preview

#if DEBUG
struct BSAccessibility_Previews: PreviewProvider {
    static var previews: some View {
        BSAccessibilityPreview {
            VStack(spacing: 16) {
                Text("Sample Text")
                    .bsAccessibleHeader("Sample Header")

                Button("Action") {}
                    .bsAccessibleButton("Perform action", hint: "Does something important")

                Image(systemName: "star.fill")
                    .bsAccessibleImage("Favorite star")
            }
        }
        .padding()
    }
}
#endif
