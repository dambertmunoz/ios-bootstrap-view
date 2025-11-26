// BootstrapUITests.swift
// BootstrapUITests
//
// Main test file for BootstrapUI library

import XCTest
@testable import BootstrapUI

final class BootstrapUITests: XCTestCase {

    // MARK: - Library Version Tests

    func testLibraryVersion() {
        XCTAssertEqual(BootstrapUI.version, "1.0.0")
    }

    // MARK: - Toast Manager Tests

    @MainActor
    func testToastManagerSharedInstance() {
        let manager1 = BSToastManager.shared
        let manager2 = BSToastManager.shared

        XCTAssertTrue(manager1 === manager2)
    }

    @MainActor
    func testToastManagerShow() {
        let manager = BSToastManager.shared
        let initialCount = manager.toasts.count

        manager.show("Test message")

        XCTAssertEqual(manager.toasts.count, initialCount + 1)

        // Clean up
        manager.dismissAll()
    }

    @MainActor
    func testToastManagerDismiss() {
        let manager = BSToastManager.shared
        manager.dismissAll()

        let toast = BSToastData(message: "Test")
        manager.show(toast)
        XCTAssertEqual(manager.toasts.count, 1)

        manager.dismiss(toast.id)
        XCTAssertEqual(manager.toasts.count, 0)
    }

    @MainActor
    func testToastManagerDismissAll() {
        let manager = BSToastManager.shared
        manager.dismissAll()

        manager.show("Toast 1")
        manager.show("Toast 2")
        manager.show("Toast 3")
        XCTAssertEqual(manager.toasts.count, 3)

        manager.dismissAll()
        XCTAssertEqual(manager.toasts.count, 0)
    }

    @MainActor
    func testToastManagerConvenienceMethods() {
        let manager = BSToastManager.shared
        manager.dismissAll()

        manager.success("Success message")
        XCTAssertEqual(manager.toasts.last?.type, .success)

        manager.error("Error message")
        XCTAssertEqual(manager.toasts.last?.type, .error)

        manager.warning("Warning message")
        XCTAssertEqual(manager.toasts.last?.type, .warning)

        manager.info("Info message")
        XCTAssertEqual(manager.toasts.last?.type, .info)

        manager.dismissAll()
    }

    // MARK: - Toast Data Tests

    func testToastDataInitialization() {
        let toast = BSToastData(
            type: .success,
            message: "Test message",
            duration: 5.0
        )

        XCTAssertEqual(toast.type, .success)
        XCTAssertEqual(toast.message, "Test message")
        XCTAssertEqual(toast.duration, 5.0)
        XCTAssertNil(toast.action)
    }

    func testToastDataWithAction() {
        var actionCalled = false
        let action = BSToastData.ToastAction(title: "Retry") {
            actionCalled = true
        }

        let toast = BSToastData(
            type: .error,
            message: "Error occurred",
            action: action
        )

        XCTAssertNotNil(toast.action)
        XCTAssertEqual(toast.action?.title, "Retry")

        toast.action?.action()
        XCTAssertTrue(actionCalled)
    }

    func testToastDataEquality() {
        let toast1 = BSToastData(id: UUID(), message: "Test")
        let toast2 = toast1

        XCTAssertEqual(toast1, toast2)
    }

    // MARK: - Haptic Manager Tests

    func testHapticManagerSharedInstance() {
        let manager1 = BSHapticManager.shared
        let manager2 = BSHapticManager.shared

        XCTAssertTrue(manager1 === manager2)
    }

    func testHapticImpactStyles() {
        // Just verify all styles exist
        XCTAssertNotNil(BSHapticManager.ImpactStyle.light)
        XCTAssertNotNil(BSHapticManager.ImpactStyle.medium)
        XCTAssertNotNil(BSHapticManager.ImpactStyle.heavy)
        XCTAssertNotNil(BSHapticManager.ImpactStyle.soft)
        XCTAssertNotNil(BSHapticManager.ImpactStyle.rigid)
    }

    func testHapticNotificationTypes() {
        XCTAssertNotNil(BSHapticManager.NotificationType.success)
        XCTAssertNotNil(BSHapticManager.NotificationType.warning)
        XCTAssertNotNil(BSHapticManager.NotificationType.error)
    }

    // MARK: - Text Field State Tests

    func testTextFieldStateEquality() {
        XCTAssertEqual(BSTextFieldState.normal, BSTextFieldState.normal)
        XCTAssertEqual(BSTextFieldState.focused, BSTextFieldState.focused)
        XCTAssertEqual(BSTextFieldState.success, BSTextFieldState.success)
        XCTAssertEqual(BSTextFieldState.disabled, BSTextFieldState.disabled)
        XCTAssertEqual(BSTextFieldState.error("Error"), BSTextFieldState.error("Error"))
        XCTAssertNotEqual(BSTextFieldState.error("Error 1"), BSTextFieldState.error("Error 2"))
    }

    // MARK: - Toggle Style Tests

    func testToggleStyleCases() {
        XCTAssertEqual(BSToggleStyle.allCases.count, 3)
        XCTAssertTrue(BSToggleStyle.allCases.contains(.switch))
        XCTAssertTrue(BSToggleStyle.allCases.contains(.checkbox))
        XCTAssertTrue(BSToggleStyle.allCases.contains(.radio))
    }

    // MARK: - Modal Size Tests

    func testModalSizeMaxWidth() {
        XCTAssertEqual(BSModalSize.small.maxWidth, 300)
        XCTAssertEqual(BSModalSize.medium.maxWidth, 400)
        XCTAssertEqual(BSModalSize.large.maxWidth, 500)
        XCTAssertEqual(BSModalSize.fullScreen.maxWidth, .infinity)
    }

    func testModalSizeMaxHeight() {
        XCTAssertEqual(BSModalSize.small.maxHeight, 200)
        XCTAssertEqual(BSModalSize.medium.maxHeight, 400)
        XCTAssertEqual(BSModalSize.large.maxHeight, 600)
        XCTAssertEqual(BSModalSize.fullScreen.maxHeight, .infinity)
    }

    // MARK: - Avatar Status Tests

    func testAvatarStatusColors() {
        XCTAssertEqual(BSAvatar.Status.online.color, .green)
        XCTAssertEqual(BSAvatar.Status.offline.color, .gray)
        XCTAssertEqual(BSAvatar.Status.busy.color, .red)
        XCTAssertEqual(BSAvatar.Status.away.color, .orange)
    }

    // MARK: - Divider Style Tests

    func testDividerStyleCases() {
        XCTAssertEqual(BSDividerStyle.allCases.count, 3)
        XCTAssertTrue(BSDividerStyle.allCases.contains(.solid))
        XCTAssertTrue(BSDividerStyle.allCases.contains(.dashed))
        XCTAssertTrue(BSDividerStyle.allCases.contains(.dotted))
    }

    // MARK: - Tab Bar Style Tests

    func testBottomSheetDetents() {
        XCTAssertEqual(BSBottomSheet<EmptyView>.Detent.small.heightRatio, 0.25)
        XCTAssertEqual(BSBottomSheet<EmptyView>.Detent.medium.heightRatio, 0.5)
        XCTAssertEqual(BSBottomSheet<EmptyView>.Detent.large.heightRatio, 0.9)
    }
}
