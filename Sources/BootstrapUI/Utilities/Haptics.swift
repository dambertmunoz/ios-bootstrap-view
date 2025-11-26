// Haptics.swift
// BootstrapUI
//
// Haptic feedback utilities for enhanced user experience

import SwiftUI
#if os(iOS)
import UIKit
#endif

// MARK: - Haptic Manager

/// Manager for providing haptic feedback
public final class BSHapticManager {

    public static let shared = BSHapticManager()

    private init() {}

    // MARK: - Impact Feedback

    /// Trigger impact feedback
    /// - Parameter style: The style of impact feedback
    public func impact(_ style: ImpactStyle) {
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: style.uiStyle)
        generator.prepare()
        generator.impactOccurred()
        #endif
    }

    public enum ImpactStyle {
        case light
        case medium
        case heavy
        case soft
        case rigid

        #if os(iOS)
        var uiStyle: UIImpactFeedbackGenerator.FeedbackStyle {
            switch self {
            case .light: return .light
            case .medium: return .medium
            case .heavy: return .heavy
            case .soft: return .soft
            case .rigid: return .rigid
            }
        }
        #endif
    }

    // MARK: - Notification Feedback

    /// Trigger notification feedback
    /// - Parameter type: The type of notification feedback
    public func notification(_ type: NotificationType) {
        #if os(iOS)
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type.uiType)
        #endif
    }

    public enum NotificationType {
        case success
        case warning
        case error

        #if os(iOS)
        var uiType: UINotificationFeedbackGenerator.FeedbackType {
            switch self {
            case .success: return .success
            case .warning: return .warning
            case .error: return .error
            }
        }
        #endif
    }

    // MARK: - Selection Feedback

    /// Trigger selection feedback
    public func selection() {
        #if os(iOS)
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
        #endif
    }
}

// MARK: - View Extension

extension View {

    /// Add haptic feedback to button taps
    /// - Parameter style: Impact style for the feedback
    /// - Returns: View with haptic feedback
    public func withHapticFeedback(_ style: BSHapticManager.ImpactStyle = .light) -> some View {
        self.simultaneousGesture(
            TapGesture()
                .onEnded { _ in
                    BSHapticManager.shared.impact(style)
                }
        )
    }

    /// Add selection haptic feedback
    /// - Returns: View with selection haptic feedback
    public func withSelectionFeedback() -> some View {
        self.simultaneousGesture(
            TapGesture()
                .onEnded { _ in
                    BSHapticManager.shared.selection()
                }
        )
    }
}
