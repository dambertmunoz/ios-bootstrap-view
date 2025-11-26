// BSBottomSheet.swift
// BootstrapUI
//
// Bottom sheet modal components with drag-to-dismiss
// Supports multiple detents and customizable appearance

import SwiftUI

// MARK: - BSBottomSheet

/// A draggable bottom sheet modal
public struct BSBottomSheet<Content: View>: View {

    @Binding private var isPresented: Bool
    private let detents: [Detent]
    private let showDragIndicator: Bool
    private let showCloseButton: Bool
    private let title: String?
    private let content: () -> Content

    @State private var currentDetent: Detent
    @State private var dragOffset: CGFloat = 0
    @GestureState private var isDragging = false

    @Environment(\.theme) private var theme

    public enum Detent: Equatable, CaseIterable {
        case small   // 25% of screen
        case medium  // 50% of screen
        case large   // 90% of screen

        var heightRatio: CGFloat {
            switch self {
            case .small: return 0.25
            case .medium: return 0.5
            case .large: return 0.9
            }
        }

        public static var allCases: [Detent] = [.small, .medium, .large]
    }

    public init(
        isPresented: Binding<Bool>,
        detents: [Detent] = [.medium, .large],
        showDragIndicator: Bool = true,
        showCloseButton: Bool = false,
        title: String? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isPresented = isPresented
        self.detents = detents.isEmpty ? [.medium] : detents
        self.showDragIndicator = showDragIndicator
        self.showCloseButton = showCloseButton
        self.title = title
        self.content = content
        self._currentDetent = State(initialValue: detents.first ?? .medium)
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // Backdrop
                if isPresented {
                    Color.black
                        .opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            dismiss()
                        }
                        .transition(.opacity)
                }

                // Sheet
                if isPresented {
                    VStack(spacing: 0) {
                        // Header
                        sheetHeader

                        // Content
                        content()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(height: sheetHeight(for: geometry))
                    .frame(maxWidth: .infinity)
                    .background(theme.surface)
                    .clipShape(RoundedCorner(radius: theme.radiusLg, corners: [.topLeft, .topRight]))
                    .shadow(color: theme.onSurface.opacity(0.15), radius: 10, x: 0, y: -5)
                    .offset(y: max(0, dragOffset))
                    .gesture(dragGesture(geometry: geometry))
                    .transition(.move(edge: .bottom))
                }
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: isPresented)
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: currentDetent)
        }
    }

    private var sheetHeader: some View {
        VStack(spacing: theme.sm) {
            if showDragIndicator {
                RoundedRectangle(cornerRadius: 2.5)
                    .fill(theme.border)
                    .frame(width: 36, height: 5)
                    .padding(.top, theme.sm)
            }

            if title != nil || showCloseButton {
                HStack {
                    if let title = title {
                        BSText(title, style: .headline)
                    }

                    Spacer()

                    if showCloseButton {
                        BSIconButton(icon: "xmark", style: .ghost, size: .small) {
                            dismiss()
                        }
                    }
                }
                .padding(.horizontal, theme.md)
                .padding(.bottom, theme.sm)
            }
        }
    }

    private func sheetHeight(for geometry: GeometryProxy) -> CGFloat {
        geometry.size.height * currentDetent.heightRatio
    }

    private func dragGesture(geometry: GeometryProxy) -> some Gesture {
        DragGesture()
            .updating($isDragging) { _, state, _ in
                state = true
            }
            .onChanged { value in
                dragOffset = value.translation.height
            }
            .onEnded { value in
                handleDragEnd(value: value, geometry: geometry)
            }
    }

    private func handleDragEnd(value: DragGesture.Value, geometry: GeometryProxy) {
        let velocity = value.predictedEndTranslation.height - value.translation.height
        let threshold = geometry.size.height * 0.15

        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            dragOffset = 0

            // Dismiss if dragged down enough or with high velocity
            if value.translation.height > threshold || velocity > 500 {
                // Try to go to smaller detent or dismiss
                if let currentIndex = detents.firstIndex(of: currentDetent),
                   currentIndex > 0 {
                    currentDetent = detents[currentIndex - 1]
                } else {
                    dismiss()
                }
            }
            // Expand if dragged up
            else if value.translation.height < -threshold || velocity < -500 {
                if let currentIndex = detents.firstIndex(of: currentDetent),
                   currentIndex < detents.count - 1 {
                    currentDetent = detents[currentIndex + 1]
                }
            }
        }
    }

    private func dismiss() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            isPresented = false
        }
    }
}

// MARK: - BSActionSheet

/// An action sheet style bottom sheet
public struct BSActionSheet: View {

    @Binding private var isPresented: Bool
    private let title: String?
    private let message: String?
    private let actions: [Action]
    private let cancelAction: Action?

    @Environment(\.theme) private var theme

    public struct Action: Identifiable {
        public let id = UUID()
        public let title: String
        public let icon: String?
        public let style: ActionStyle
        public let action: () -> Void

        public enum ActionStyle {
            case `default`
            case destructive
            case cancel
        }

        public init(
            title: String,
            icon: String? = nil,
            style: ActionStyle = .default,
            action: @escaping () -> Void
        ) {
            self.title = title
            self.icon = icon
            self.style = style
            self.action = action
        }
    }

    public init(
        isPresented: Binding<Bool>,
        title: String? = nil,
        message: String? = nil,
        actions: [Action],
        cancelAction: Action? = nil
    ) {
        self._isPresented = isPresented
        self.title = title
        self.message = message
        self.actions = actions
        self.cancelAction = cancelAction
    }

    public var body: some View {
        BSBottomSheet(
            isPresented: $isPresented,
            detents: [.medium],
            showDragIndicator: true
        ) {
            VStack(spacing: theme.md) {
                // Header
                if title != nil || message != nil {
                    VStack(spacing: theme.xs) {
                        if let title = title {
                            BSText(title, style: .headline)
                        }
                        if let message = message {
                            BSText(message, style: .subheadline, color: .secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal, theme.md)

                    BSDivider()
                }

                // Actions
                VStack(spacing: theme.xs) {
                    ForEach(actions) { action in
                        actionButton(action)
                    }
                }
                .padding(.horizontal, theme.md)

                // Cancel
                if let cancel = cancelAction {
                    BSDivider()
                    actionButton(cancel)
                        .padding(.horizontal, theme.md)
                }

                Spacer()
            }
            .padding(.top, theme.md)
        }
    }

    private func actionButton(_ action: Action) -> some View {
        Button {
            isPresented = false
            action.action()
        } label: {
            HStack(spacing: theme.sm) {
                if let icon = action.icon {
                    Image(systemName: icon)
                        .font(.system(size: 20))
                }

                Text(action.title)
                    .font(theme.body)
                    .fontWeight(action.style == .cancel ? .semibold : .regular)

                Spacer()
            }
            .foregroundColor(actionColor(for: action.style))
            .padding(theme.md)
            .background(theme.background)
            .cornerRadius(theme.radiusMd)
        }
    }

    private func actionColor(for style: Action.ActionStyle) -> Color {
        switch style {
        case .default: return theme.onSurface
        case .destructive: return theme.error
        case .cancel: return theme.primary
        }
    }
}

// MARK: - BSConfirmationSheet

/// A confirmation bottom sheet with confirm/cancel buttons
public struct BSConfirmationSheet: View {

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
        BSBottomSheet(
            isPresented: $isPresented,
            detents: [.small],
            showDragIndicator: true
        ) {
            VStack(spacing: theme.lg) {
                VStack(spacing: theme.sm) {
                    BSText(title, style: .title3, weight: .semibold)
                    BSText(message, style: .body, color: .secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, theme.md)

                HStack(spacing: theme.md) {
                    BSButton(cancelTitle, style: .outline, isFullWidth: true) {
                        isPresented = false
                        onCancel?()
                    }

                    BSButton(
                        confirmTitle,
                        style: isDestructive ? .destructive : .primary,
                        isFullWidth: true
                    ) {
                        isPresented = false
                        onConfirm()
                    }
                }
                .padding(.horizontal, theme.md)

                Spacer()
            }
            .padding(.top, theme.md)
        }
    }
}

// MARK: - View Extension

extension View {
    /// Presents a bottom sheet
    public func bsBottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        detents: [BSBottomSheet<Content>.Detent] = [.medium, .large],
        title: String? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        ZStack {
            self
            BSBottomSheet(
                isPresented: isPresented,
                detents: detents,
                title: title,
                content: content
            )
        }
    }

    /// Presents an action sheet
    public func bsActionSheet(
        isPresented: Binding<Bool>,
        title: String? = nil,
        message: String? = nil,
        actions: [BSActionSheet.Action],
        cancelAction: BSActionSheet.Action? = nil
    ) -> some View {
        ZStack {
            self
            BSActionSheet(
                isPresented: isPresented,
                title: title,
                message: message,
                actions: actions,
                cancelAction: cancelAction
            )
        }
    }

    /// Presents a confirmation sheet
    public func bsConfirmationSheet(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        confirmTitle: String = "Confirm",
        cancelTitle: String = "Cancel",
        isDestructive: Bool = false,
        onConfirm: @escaping () -> Void
    ) -> some View {
        ZStack {
            self
            BSConfirmationSheet(
                isPresented: isPresented,
                title: title,
                message: message,
                confirmTitle: confirmTitle,
                cancelTitle: cancelTitle,
                isDestructive: isDestructive,
                onConfirm: onConfirm
            )
        }
    }
}

// MARK: - Rounded Corner Shape

private struct RoundedCorner: Shape {
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

// MARK: - Preview

#if DEBUG
struct BSBottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        BSBottomSheet(isPresented: .constant(true), title: "Select Option") {
            VStack(spacing: 16) {
                Text("Bottom Sheet Content")
                BSButton("Action") {}
            }
            .padding()
        }
        .withTheme()
    }
}
#endif
