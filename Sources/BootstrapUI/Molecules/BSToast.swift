// BSToast.swift
// BootstrapUI
//
// Toast notification component
// Follows Single Responsibility - handles toast presentation

import SwiftUI

// MARK: - Toast Position

/// Position where toast appears
public enum BSToastPosition: String, CaseIterable, Sendable {
    case top
    case bottom
}

// MARK: - Toast Data

/// Data model for toast notifications
public struct BSToastData: Identifiable, Equatable {
    public let id: UUID
    public let type: BSAlertType
    public let message: String
    public let duration: TimeInterval
    public let action: ToastAction?

    public struct ToastAction: Equatable {
        public let title: String
        public let action: () -> Void

        public init(title: String, action: @escaping () -> Void) {
            self.title = title
            self.action = action
        }

        public static func == (lhs: ToastAction, rhs: ToastAction) -> Bool {
            lhs.title == rhs.title
        }
    }

    public init(
        id: UUID = UUID(),
        type: BSAlertType = .info,
        message: String,
        duration: TimeInterval = 3.0,
        action: ToastAction? = nil
    ) {
        self.id = id
        self.type = type
        self.message = message
        self.duration = duration
        self.action = action
    }
}

// MARK: - Toast View

/// A toast notification view
public struct BSToast: View {

    private let data: BSToastData
    private let onDismiss: () -> Void

    @Environment(\.theme) private var theme
    @State private var offset: CGFloat = 0

    public init(data: BSToastData, onDismiss: @escaping () -> Void) {
        self.data = data
        self.onDismiss = onDismiss
    }

    public var body: some View {
        HStack(spacing: theme.sm) {
            Image(systemName: data.type.icon)
                .font(.system(size: 18))
                .foregroundColor(iconColor)

            Text(data.message)
                .font(theme.subheadline)
                .foregroundColor(theme.onSurface)
                .lineLimit(2)

            Spacer()

            if let action = data.action {
                Button(action.title) {
                    action.action()
                    onDismiss()
                }
                .font(theme.subheadline.weight(.semibold))
                .foregroundColor(theme.primary)
            }

            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(theme.placeholder)
            }
        }
        .padding(.horizontal, theme.md)
        .padding(.vertical, theme.sm + 2)
        .background(theme.surface)
        .cornerRadius(theme.radiusMd)
        .shadow(
            color: theme.shadowLg.color,
            radius: theme.shadowLg.radius,
            x: theme.shadowLg.x,
            y: theme.shadowLg.y
        )
        .offset(x: offset)
        .gesture(
            DragGesture()
                .onChanged { value in
                    offset = value.translation.width
                }
                .onEnded { value in
                    if abs(value.translation.width) > 100 {
                        withAnimation {
                            offset = value.translation.width > 0 ? 500 : -500
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            onDismiss()
                        }
                    } else {
                        withAnimation {
                            offset = 0
                        }
                    }
                }
        )
    }

    private var iconColor: Color {
        switch data.type {
        case .info: return theme.info
        case .success: return theme.success
        case .warning: return theme.warning
        case .error: return theme.error
        }
    }
}

// MARK: - Toast Manager

/// Manager for displaying toast notifications
@MainActor
public final class BSToastManager: ObservableObject {

    public static let shared = BSToastManager()

    @Published public private(set) var toasts: [BSToastData] = []

    private init() {}

    /// Show a toast notification
    /// - Parameter toast: Toast data to display
    public func show(_ toast: BSToastData) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            toasts.append(toast)
        }

        // Auto dismiss after duration
        DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration) { [weak self] in
            self?.dismiss(toast.id)
        }
    }

    /// Show a simple toast message
    /// - Parameters:
    ///   - message: Message to display
    ///   - type: Toast type
    ///   - duration: Display duration
    public func show(
        _ message: String,
        type: BSAlertType = .info,
        duration: TimeInterval = 3.0
    ) {
        show(BSToastData(type: type, message: message, duration: duration))
    }

    /// Dismiss a specific toast
    /// - Parameter id: Toast ID to dismiss
    public func dismiss(_ id: UUID) {
        withAnimation(.easeInOut(duration: 0.2)) {
            toasts.removeAll { $0.id == id }
        }
    }

    /// Dismiss all toasts
    public func dismissAll() {
        withAnimation(.easeInOut(duration: 0.2)) {
            toasts.removeAll()
        }
    }
}

// MARK: - Toast Container

/// Container view for displaying toasts
public struct BSToastContainer<Content: View>: View {

    @ObservedObject private var toastManager: BSToastManager
    private let position: BSToastPosition
    private let content: () -> Content

    @Environment(\.theme) private var theme

    public init(
        toastManager: BSToastManager = .shared,
        position: BSToastPosition = .bottom,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.toastManager = toastManager
        self.position = position
        self.content = content
    }

    public var body: some View {
        ZStack {
            content()

            VStack {
                if position == .bottom {
                    Spacer()
                }

                VStack(spacing: theme.sm) {
                    ForEach(toastManager.toasts) { toast in
                        BSToast(data: toast) {
                            toastManager.dismiss(toast.id)
                        }
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: position == .top ? .top : .bottom)
                                    .combined(with: .opacity),
                                removal: .opacity
                            )
                        )
                    }
                }
                .padding(.horizontal, theme.md)
                .padding(.vertical, theme.lg)

                if position == .top {
                    Spacer()
                }
            }
        }
    }
}

// MARK: - View Extension

extension View {
    /// Add toast container to this view
    /// - Parameters:
    ///   - toastManager: Toast manager instance
    ///   - position: Position for toasts
    /// - Returns: View with toast container
    public func withToasts(
        _ toastManager: BSToastManager = .shared,
        position: BSToastPosition = .bottom
    ) -> some View {
        BSToastContainer(toastManager: toastManager, position: position) {
            self
        }
    }
}

// MARK: - Convenience Methods

extension BSToastManager {

    /// Show success toast
    public func success(_ message: String, duration: TimeInterval = 3.0) {
        show(message, type: .success, duration: duration)
    }

    /// Show error toast
    public func error(_ message: String, duration: TimeInterval = 4.0) {
        show(message, type: .error, duration: duration)
    }

    /// Show warning toast
    public func warning(_ message: String, duration: TimeInterval = 3.5) {
        show(message, type: .warning, duration: duration)
    }

    /// Show info toast
    public func info(_ message: String, duration: TimeInterval = 3.0) {
        show(message, type: .info, duration: duration)
    }
}

// MARK: - Preview

#if DEBUG
struct BSToast_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            BSToast(
                data: BSToastData(type: .info, message: "This is an info toast"),
                onDismiss: {}
            )

            BSToast(
                data: BSToastData(type: .success, message: "Operation completed successfully"),
                onDismiss: {}
            )

            BSToast(
                data: BSToastData(type: .warning, message: "Please review your settings"),
                onDismiss: {}
            )

            BSToast(
                data: BSToastData(
                    type: .error,
                    message: "Something went wrong",
                    action: .init(title: "Retry", action: {})
                ),
                onDismiss: {}
            )
        }
        .padding()
        .withTheme()
    }
}
#endif
