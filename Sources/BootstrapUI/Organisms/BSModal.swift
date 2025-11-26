// BSModal.swift
// BootstrapUI
//
// Modal and dialog components
// Follows Composition - provides flexible modal presentations

import SwiftUI

// MARK: - Modal Size

/// Available modal sizes
public enum BSModalSize {
    case small
    case medium
    case large
    case fullScreen

    var maxWidth: CGFloat {
        switch self {
        case .small: return 300
        case .medium: return 400
        case .large: return 500
        case .fullScreen: return .infinity
        }
    }

    var maxHeight: CGFloat {
        switch self {
        case .small: return 200
        case .medium: return 400
        case .large: return 600
        case .fullScreen: return .infinity
        }
    }
}

// MARK: - Modal Component

/// A customizable modal/dialog component
public struct BSModal<Content: View>: View {

    @Binding private var isPresented: Bool
    private let size: BSModalSize
    private let showsCloseButton: Bool
    private let dismissOnBackgroundTap: Bool
    private let content: () -> Content

    @Environment(\.theme) private var theme

    public init(
        isPresented: Binding<Bool>,
        size: BSModalSize = .medium,
        showsCloseButton: Bool = true,
        dismissOnBackgroundTap: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isPresented = isPresented
        self.size = size
        self.showsCloseButton = showsCloseButton
        self.dismissOnBackgroundTap = dismissOnBackgroundTap
        self.content = content
    }

    public var body: some View {
        ZStack {
            // Background overlay
            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        if dismissOnBackgroundTap {
                            dismiss()
                        }
                    }
                    .transition(.opacity)
            }

            // Modal content
            if isPresented {
                VStack(spacing: 0) {
                    // Close button
                    if showsCloseButton {
                        HStack {
                            Spacer()
                            Button(action: dismiss) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(theme.placeholder)
                                    .frame(width: 32, height: 32)
                                    .background(theme.surface)
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.horizontal, theme.md)
                        .padding(.top, theme.md)
                    }

                    // Content
                    content()
                        .padding(showsCloseButton ? [.horizontal, .bottom] : .all, theme.lg)
                }
                .frame(maxWidth: size.maxWidth)
                .background(theme.background)
                .cornerRadius(size == .fullScreen ? 0 : theme.radiusLg)
                .shadow(
                    color: theme.shadowXl.color,
                    radius: theme.shadowXl.radius,
                    x: theme.shadowXl.x,
                    y: theme.shadowXl.y
                )
                .padding(size == .fullScreen ? 0 : theme.lg)
                .transition(.scale(scale: 0.9).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPresented)
    }

    private func dismiss() {
        isPresented = false
    }
}

// MARK: - Alert Dialog

/// A standard alert dialog with title, message, and actions
public struct BSAlertDialog: View {

    @Binding private var isPresented: Bool
    private let title: String
    private let message: String
    private let primaryAction: DialogAction
    private let secondaryAction: DialogAction?

    @Environment(\.theme) private var theme

    public struct DialogAction {
        public let title: String
        public let style: BSButtonStyle
        public let action: () -> Void

        public init(
            title: String,
            style: BSButtonStyle = .primary,
            action: @escaping () -> Void
        ) {
            self.title = title
            self.style = style
            self.action = action
        }
    }

    public init(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        primaryAction: DialogAction,
        secondaryAction: DialogAction? = nil
    ) {
        self._isPresented = isPresented
        self.title = title
        self.message = message
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }

    public var body: some View {
        BSModal(isPresented: $isPresented, size: .small, showsCloseButton: false) {
            VStack(spacing: theme.lg) {
                VStack(spacing: theme.sm) {
                    Text(title)
                        .font(theme.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(theme.onSurface)
                        .multilineTextAlignment(.center)

                    Text(message)
                        .font(theme.body)
                        .foregroundColor(theme.placeholder)
                        .multilineTextAlignment(.center)
                }

                HStack(spacing: theme.sm) {
                    if let secondary = secondaryAction {
                        BSButton(secondary.title, style: secondary.style, isFullWidth: true) {
                            secondary.action()
                            isPresented = false
                        }
                    }

                    BSButton(primaryAction.title, style: primaryAction.style, isFullWidth: true) {
                        primaryAction.action()
                        isPresented = false
                    }
                }
            }
        }
    }
}

// MARK: - Confirmation Dialog

/// A confirmation dialog for destructive actions
public struct BSConfirmationDialog: View {

    @Binding private var isPresented: Bool
    private let title: String
    private let message: String
    private let confirmTitle: String
    private let cancelTitle: String
    private let isDestructive: Bool
    private let onConfirm: () -> Void
    private let onCancel: (() -> Void)?

    @Environment(\.theme) private var theme

    public init(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        confirmTitle: String = "Confirm",
        cancelTitle: String = "Cancel",
        isDestructive: Bool = false,
        onConfirm: @escaping () -> Void,
        onCancel: (() -> Void)? = nil
    ) {
        self._isPresented = isPresented
        self.title = title
        self.message = message
        self.confirmTitle = confirmTitle
        self.cancelTitle = cancelTitle
        self.isDestructive = isDestructive
        self.onConfirm = onConfirm
        self.onCancel = onCancel
    }

    public var body: some View {
        BSAlertDialog(
            isPresented: $isPresented,
            title: title,
            message: message,
            primaryAction: .init(
                title: confirmTitle,
                style: isDestructive ? .destructive : .primary,
                action: onConfirm
            ),
            secondaryAction: .init(
                title: cancelTitle,
                style: .ghost,
                action: { onCancel?() }
            )
        )
    }
}

// MARK: - Bottom Sheet

/// A bottom sheet modal component
public struct BSBottomSheet<Content: View>: View {

    @Binding private var isPresented: Bool
    private let detents: [Detent]
    private let showsDragIndicator: Bool
    private let content: () -> Content

    @State private var currentDetent: Detent = .medium
    @State private var dragOffset: CGFloat = 0
    @GestureState private var isDragging = false

    @Environment(\.theme) private var theme

    public enum Detent: CaseIterable {
        case small
        case medium
        case large

        var heightRatio: CGFloat {
            switch self {
            case .small: return 0.25
            case .medium: return 0.5
            case .large: return 0.9
            }
        }
    }

    public init(
        isPresented: Binding<Bool>,
        detents: [Detent] = [.medium],
        showsDragIndicator: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isPresented = isPresented
        self.detents = detents
        self.showsDragIndicator = showsDragIndicator
        self.content = content
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // Background
                if isPresented {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            dismiss()
                        }
                        .transition(.opacity)
                }

                // Sheet
                if isPresented {
                    VStack(spacing: 0) {
                        // Drag indicator
                        if showsDragIndicator {
                            Capsule()
                                .fill(theme.border)
                                .frame(width: 36, height: 5)
                                .padding(.top, theme.sm)
                                .padding(.bottom, theme.sm)
                        }

                        content()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: sheetHeight(in: geometry))
                    .background(theme.background)
                    .cornerRadius(theme.radiusLg, corners: [.topLeft, .topRight])
                    .offset(y: max(0, dragOffset))
                    .gesture(dragGesture(in: geometry))
                    .transition(.move(edge: .bottom))
                }
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPresented)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: dragOffset)
    }

    private func sheetHeight(in geometry: GeometryProxy) -> CGFloat {
        geometry.size.height * currentDetent.heightRatio
    }

    private func dragGesture(in geometry: GeometryProxy) -> some Gesture {
        DragGesture()
            .updating($isDragging) { _, state, _ in
                state = true
            }
            .onChanged { value in
                dragOffset = value.translation.height
            }
            .onEnded { value in
                let threshold = geometry.size.height * 0.1

                if value.translation.height > threshold {
                    // Dismiss or go to smaller detent
                    if let currentIndex = detents.firstIndex(of: currentDetent),
                       currentIndex > 0 {
                        currentDetent = detents[currentIndex - 1]
                    } else {
                        dismiss()
                    }
                } else if value.translation.height < -threshold {
                    // Go to larger detent
                    if let currentIndex = detents.firstIndex(of: currentDetent),
                       currentIndex < detents.count - 1 {
                        currentDetent = detents[currentIndex + 1]
                    }
                }

                dragOffset = 0
            }
    }

    private func dismiss() {
        isPresented = false
    }
}

// MARK: - Corner Radius Extension

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - View Modifier

public struct BSModalModifier<ModalContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let size: BSModalSize
    let modalContent: () -> ModalContent

    public func body(content: Content) -> some View {
        ZStack {
            content
            BSModal(isPresented: $isPresented, size: size, content: modalContent)
        }
    }
}

extension View {
    /// Present a modal over this view
    public func bsModal<Content: View>(
        isPresented: Binding<Bool>,
        size: BSModalSize = .medium,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(BSModalModifier(isPresented: isPresented, size: size, modalContent: content))
    }
}

// MARK: - Preview

#if DEBUG
struct BSModal_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray.opacity(0.1).ignoresSafeArea()

            BSModal(isPresented: .constant(true), size: .medium) {
                VStack(spacing: 16) {
                    Text("Modal Title")
                        .font(.headline)
                    Text("This is the modal content. It can contain any SwiftUI views.")
                        .multilineTextAlignment(.center)

                    BSButton("Close", style: .primary, isFullWidth: true) {}
                }
            }
        }
        .withTheme()
    }
}
#endif
