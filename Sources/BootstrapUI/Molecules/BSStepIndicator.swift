// BSStepIndicator.swift
// BootstrapUI
//
// Step indicator / progress stepper component
// Perfect for checkout flows, wizards, and multi-step forms

import SwiftUI

// MARK: - Step Indicator Style

/// Available step indicator styles
public enum BSStepIndicatorStyle {
    case numbered
    case icon
    case dot
}

// MARK: - Step Status

/// Status of each step
public enum BSStepStatus {
    case completed
    case current
    case upcoming
}

// MARK: - Step Data

/// Data for a single step
public struct BSStep: Identifiable {
    public let id = UUID()
    public let title: String
    public let subtitle: String?
    public let icon: String?

    public init(
        title: String,
        subtitle: String? = nil,
        icon: String? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
    }
}

// MARK: - Step Indicator Component

/// A horizontal step indicator for multi-step flows
///
/// Example usage:
/// ```swift
/// BSStepIndicator(
///     currentStep: 2,
///     steps: [
///         BSStep(title: "Cart", icon: "cart"),
///         BSStep(title: "Shipping", icon: "shippingbox"),
///         BSStep(title: "Payment", icon: "creditcard"),
///         BSStep(title: "Done", icon: "checkmark.circle")
///     ]
/// )
/// ```
public struct BSStepIndicator: View {

    // MARK: - Properties

    private let steps: [BSStep]
    private let currentStep: Int
    private let style: BSStepIndicatorStyle
    private let showLabels: Bool
    private let onStepTap: ((Int) -> Void)?

    @Environment(\.theme) private var theme

    // MARK: - Initialization

    public init(
        currentStep: Int,
        steps: [BSStep],
        style: BSStepIndicatorStyle = .numbered,
        showLabels: Bool = true,
        onStepTap: ((Int) -> Void)? = nil
    ) {
        self.currentStep = max(0, min(currentStep, steps.count - 1))
        self.steps = steps
        self.style = style
        self.showLabels = showLabels
        self.onStepTap = onStepTap
    }

    /// Convenience initializer with string array
    public init(
        currentStep: Int,
        steps: [String],
        style: BSStepIndicatorStyle = .numbered,
        showLabels: Bool = true,
        onStepTap: ((Int) -> Void)? = nil
    ) {
        self.currentStep = max(0, min(currentStep, steps.count - 1))
        self.steps = steps.map { BSStep(title: $0) }
        self.style = style
        self.showLabels = showLabels
        self.onStepTap = onStepTap
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                stepView(for: step, at: index)

                if index < steps.count - 1 {
                    connector(after: index)
                }
            }
        }
    }

    // MARK: - Step View

    @ViewBuilder
    private func stepView(for step: BSStep, at index: Int) -> some View {
        let status = stepStatus(for: index)

        VStack(spacing: theme.xs) {
            // Step circle/indicator
            ZStack {
                Circle()
                    .fill(circleBackground(for: status))
                    .frame(width: 32, height: 32)

                Circle()
                    .stroke(circleBorder(for: status), lineWidth: 2)
                    .frame(width: 32, height: 32)

                stepContent(for: step, at: index, status: status)
            }
            .contentShape(Circle())
            .onTapGesture {
                if status == .completed {
                    onStepTap?(index)
                }
            }

            // Labels
            if showLabels {
                VStack(spacing: 2) {
                    Text(step.title)
                        .font(theme.caption1)
                        .fontWeight(status == .current ? .semibold : .regular)
                        .foregroundColor(labelColor(for: status))
                        .lineLimit(1)

                    if let subtitle = step.subtitle {
                        Text(subtitle)
                            .font(theme.caption2)
                            .foregroundColor(theme.placeholder)
                            .lineLimit(1)
                    }
                }
                .frame(width: 60)
            }
        }
    }

    @ViewBuilder
    private func stepContent(for step: BSStep, at index: Int, status: BSStepStatus) -> some View {
        switch style {
        case .numbered:
            if status == .completed {
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            } else {
                Text("\(index + 1)")
                    .font(theme.subheadline.weight(.semibold))
                    .foregroundColor(numberColor(for: status))
            }

        case .icon:
            if status == .completed {
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            } else if let icon = step.icon {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(iconColor(for: status))
            } else {
                Text("\(index + 1)")
                    .font(theme.subheadline.weight(.semibold))
                    .foregroundColor(numberColor(for: status))
            }

        case .dot:
            if status == .completed {
                Circle()
                    .fill(Color.white)
                    .frame(width: 8, height: 8)
            } else if status == .current {
                Circle()
                    .fill(theme.primary)
                    .frame(width: 10, height: 10)
            } else {
                Circle()
                    .fill(theme.border)
                    .frame(width: 8, height: 8)
            }
        }
    }

    // MARK: - Connector

    private func connector(after index: Int) -> some View {
        let isCompleted = index < currentStep

        return Rectangle()
            .fill(isCompleted ? theme.primary : theme.border)
            .frame(height: 2)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 4)
            .offset(y: showLabels ? -20 : 0)
    }

    // MARK: - Helper Methods

    private func stepStatus(for index: Int) -> BSStepStatus {
        if index < currentStep {
            return .completed
        } else if index == currentStep {
            return .current
        } else {
            return .upcoming
        }
    }

    private func circleBackground(for status: BSStepStatus) -> Color {
        switch status {
        case .completed:
            return theme.primary
        case .current:
            return theme.primary.opacity(0.1)
        case .upcoming:
            return .clear
        }
    }

    private func circleBorder(for status: BSStepStatus) -> Color {
        switch status {
        case .completed:
            return theme.primary
        case .current:
            return theme.primary
        case .upcoming:
            return theme.border
        }
    }

    private func numberColor(for status: BSStepStatus) -> Color {
        switch status {
        case .completed:
            return .white
        case .current:
            return theme.primary
        case .upcoming:
            return theme.placeholder
        }
    }

    private func iconColor(for status: BSStepStatus) -> Color {
        switch status {
        case .completed:
            return .white
        case .current:
            return theme.primary
        case .upcoming:
            return theme.placeholder
        }
    }

    private func labelColor(for status: BSStepStatus) -> Color {
        switch status {
        case .completed:
            return theme.onSurface
        case .current:
            return theme.primary
        case .upcoming:
            return theme.placeholder
        }
    }
}

// MARK: - Vertical Step Indicator

/// A vertical step indicator for detailed multi-step flows
public struct BSVerticalStepIndicator: View {

    private let steps: [BSStep]
    private let currentStep: Int
    private let onStepTap: ((Int) -> Void)?

    @Environment(\.theme) private var theme

    public init(
        currentStep: Int,
        steps: [BSStep],
        onStepTap: ((Int) -> Void)? = nil
    ) {
        self.currentStep = max(0, min(currentStep, steps.count - 1))
        self.steps = steps
        self.onStepTap = onStepTap
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                HStack(alignment: .top, spacing: theme.md) {
                    // Indicator column
                    VStack(spacing: 0) {
                        stepCircle(at: index)

                        if index < steps.count - 1 {
                            Rectangle()
                                .fill(index < currentStep ? theme.primary : theme.border)
                                .frame(width: 2)
                                .frame(height: 40)
                        }
                    }

                    // Content column
                    VStack(alignment: .leading, spacing: theme.xxs) {
                        Text(step.title)
                            .font(theme.subheadline)
                            .fontWeight(index == currentStep ? .semibold : .regular)
                            .foregroundColor(index <= currentStep ? theme.onSurface : theme.placeholder)

                        if let subtitle = step.subtitle {
                            Text(subtitle)
                                .font(theme.caption1)
                                .foregroundColor(theme.placeholder)
                        }
                    }
                    .padding(.bottom, index < steps.count - 1 ? theme.lg : 0)

                    Spacer()
                }
            }
        }
    }

    @ViewBuilder
    private func stepCircle(at index: Int) -> some View {
        let status = index < currentStep ? BSStepStatus.completed :
                     index == currentStep ? BSStepStatus.current : BSStepStatus.upcoming

        ZStack {
            Circle()
                .fill(status == .completed ? theme.primary : .clear)
                .frame(width: 28, height: 28)

            Circle()
                .stroke(status == .upcoming ? theme.border : theme.primary, lineWidth: 2)
                .frame(width: 28, height: 28)

            if status == .completed {
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
            } else {
                Text("\(index + 1)")
                    .font(theme.caption1.weight(.semibold))
                    .foregroundColor(status == .current ? theme.primary : theme.placeholder)
            }
        }
    }
}

// MARK: - Progress Step Bar

/// A simple progress bar for steps
public struct BSStepProgressBar: View {

    private let totalSteps: Int
    private let currentStep: Int
    private let showStepCount: Bool

    @Environment(\.theme) private var theme

    public init(
        currentStep: Int,
        totalSteps: Int,
        showStepCount: Bool = true
    ) {
        self.currentStep = max(0, min(currentStep, totalSteps))
        self.totalSteps = max(1, totalSteps)
        self.showStepCount = showStepCount
    }

    public var body: some View {
        VStack(spacing: theme.xs) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 4)
                        .fill(theme.border)
                        .frame(height: 8)

                    // Progress
                    RoundedRectangle(cornerRadius: 4)
                        .fill(theme.primary)
                        .frame(width: progressWidth(in: geometry), height: 8)
                        .animation(.easeInOut(duration: 0.3), value: currentStep)
                }
            }
            .frame(height: 8)

            if showStepCount {
                HStack {
                    Spacer()
                    Text("Step \(currentStep + 1) of \(totalSteps)")
                        .font(theme.caption1)
                        .foregroundColor(theme.placeholder)
                }
            }
        }
    }

    private func progressWidth(in geometry: GeometryProxy) -> CGFloat {
        let progress = CGFloat(currentStep + 1) / CGFloat(totalSteps)
        return geometry.size.width * progress
    }
}

// MARK: - Preview

#if DEBUG
struct BSStepIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Numbered
                Text("Numbered Steps").font(.headline)
                BSStepIndicator(
                    currentStep: 1,
                    steps: ["Cart", "Shipping", "Payment", "Done"]
                )

                // With icons
                Text("With Icons").font(.headline)
                BSStepIndicator(
                    currentStep: 2,
                    steps: [
                        BSStep(title: "Cart", icon: "cart"),
                        BSStep(title: "Shipping", icon: "shippingbox"),
                        BSStep(title: "Payment", icon: "creditcard"),
                        BSStep(title: "Done", icon: "checkmark.circle")
                    ],
                    style: .icon
                )

                // Dots
                Text("Dot Style").font(.headline)
                BSStepIndicator(
                    currentStep: 1,
                    steps: ["Step 1", "Step 2", "Step 3", "Step 4"],
                    style: .dot
                )

                // Progress bar
                Text("Progress Bar").font(.headline)
                BSStepProgressBar(currentStep: 2, totalSteps: 5)

                // Vertical
                Text("Vertical Steps").font(.headline)
                BSVerticalStepIndicator(
                    currentStep: 1,
                    steps: [
                        BSStep(title: "Order Placed", subtitle: "Nov 25, 2024"),
                        BSStep(title: "Processing", subtitle: "In progress"),
                        BSStep(title: "Shipped", subtitle: "Pending"),
                        BSStep(title: "Delivered", subtitle: "Pending")
                    ]
                )
            }
            .padding()
        }
        .withTheme()
    }
}
#endif
