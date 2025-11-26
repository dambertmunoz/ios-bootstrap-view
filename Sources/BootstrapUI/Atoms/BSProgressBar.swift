// BSProgressBar.swift
// BootstrapUI
//
// Linear progress bar components with various styles
// Supports determinate and indeterminate progress

import SwiftUI

// MARK: - BSProgressBar

/// A linear progress bar
public struct BSProgressBar: View {

    private let progress: Double
    private let style: Style
    private let color: Color?
    private let height: CGFloat
    private let showLabel: Bool
    private let labelFormatter: (Double) -> String

    @Environment(\.theme) private var theme

    public enum Style {
        case solid
        case gradient([Color])
        case striped
        case rounded
    }

    public init(
        progress: Double,
        style: Style = .solid,
        color: Color? = nil,
        height: CGFloat = 8,
        showLabel: Bool = false,
        labelFormatter: @escaping (Double) -> String = { "\(Int($0 * 100))%" }
    ) {
        self.progress = min(max(progress, 0), 1)
        self.style = style
        self.color = color
        self.height = height
        self.showLabel = showLabel
        self.labelFormatter = labelFormatter
    }

    public var body: some View {
        VStack(alignment: .trailing, spacing: theme.xs) {
            if showLabel {
                BSText(labelFormatter(progress), style: .caption1, weight: .medium)
                    .foregroundColor(color ?? theme.primary)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    backgroundTrack

                    // Progress fill
                    progressFill(width: geometry.size.width)
                }
            }
            .frame(height: height)
        }
    }

    private var backgroundTrack: some View {
        RoundedRectangle(cornerRadius: height / 2)
            .fill(theme.border.opacity(0.3))
    }

    @ViewBuilder
    private func progressFill(width: CGFloat) -> some View {
        let fillWidth = width * CGFloat(progress)

        switch style {
        case .solid:
            RoundedRectangle(cornerRadius: height / 2)
                .fill(color ?? theme.primary)
                .frame(width: fillWidth)
                .animation(.easeInOut(duration: 0.3), value: progress)

        case .gradient(let colors):
            LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing)
                .frame(width: fillWidth)
                .clipShape(RoundedRectangle(cornerRadius: height / 2))
                .animation(.easeInOut(duration: 0.3), value: progress)

        case .striped:
            StripedProgressFill(color: color ?? theme.primary, height: height)
                .frame(width: fillWidth)
                .clipShape(RoundedRectangle(cornerRadius: height / 2))
                .animation(.easeInOut(duration: 0.3), value: progress)

        case .rounded:
            RoundedRectangle(cornerRadius: height / 2)
                .fill(color ?? theme.primary)
                .frame(width: fillWidth)
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: progress)
        }
    }
}

// MARK: - Striped Progress Fill

private struct StripedProgressFill: View {
    let color: Color
    let height: CGFloat

    @State private var animationOffset: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                color

                StripedPattern(stripeWidth: height)
                    .fill(Color.white.opacity(0.2))
                    .offset(x: animationOffset)
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                animationOffset = height * 2
            }
        }
    }
}

private struct StripedPattern: Shape {
    let stripeWidth: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let stripeCount = Int(rect.width / stripeWidth) + 4

        for i in stride(from: -2, to: stripeCount, by: 2) {
            let x = CGFloat(i) * stripeWidth
            path.move(to: CGPoint(x: x, y: rect.height))
            path.addLine(to: CGPoint(x: x + stripeWidth, y: 0))
            path.addLine(to: CGPoint(x: x + stripeWidth * 2, y: 0))
            path.addLine(to: CGPoint(x: x + stripeWidth, y: rect.height))
            path.closeSubpath()
        }

        return path
    }
}

// MARK: - BSIndeterminateProgress

/// An indeterminate progress indicator
public struct BSIndeterminateProgress: View {

    private let style: Style
    private let color: Color?
    private let height: CGFloat

    @State private var animating = false

    @Environment(\.theme) private var theme

    public enum Style {
        case sliding
        case pulsing
        case bouncing
    }

    public init(
        style: Style = .sliding,
        color: Color? = nil,
        height: CGFloat = 4
    ) {
        self.style = style
        self.color = color
        self.height = height
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(theme.border.opacity(0.3))

                // Animated fill
                switch style {
                case .sliding:
                    slidingIndicator(width: geometry.size.width)
                case .pulsing:
                    pulsingIndicator(width: geometry.size.width)
                case .bouncing:
                    bouncingIndicator(width: geometry.size.width)
                }
            }
        }
        .frame(height: height)
        .onAppear {
            animating = true
        }
    }

    private func slidingIndicator(width: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: height / 2)
            .fill(color ?? theme.primary)
            .frame(width: width * 0.3)
            .offset(x: animating ? width * 0.7 : -width * 0.3)
            .animation(
                .linear(duration: 1)
                .repeatForever(autoreverses: false),
                value: animating
            )
    }

    private func pulsingIndicator(width: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: height / 2)
            .fill(color ?? theme.primary)
            .opacity(animating ? 0.3 : 1)
            .animation(
                .easeInOut(duration: 0.8)
                .repeatForever(autoreverses: true),
                value: animating
            )
    }

    private func bouncingIndicator(width: CGFloat) -> some View {
        HStack(spacing: width * 0.02) {
            ForEach(0..<3) { index in
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(color ?? theme.primary)
                    .frame(width: width * 0.2)
                    .scaleEffect(y: animating ? 1.5 : 0.5)
                    .animation(
                        .easeInOut(duration: 0.4)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.15),
                        value: animating
                    )
            }
        }
        .frame(width: width * 0.66)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - BSStepProgress

/// A step-based progress bar
public struct BSStepProgress: View {

    private let totalSteps: Int
    private let completedSteps: Int
    private let color: Color?

    @Environment(\.theme) private var theme

    public init(
        completedSteps: Int,
        totalSteps: Int,
        color: Color? = nil
    ) {
        self.totalSteps = max(1, totalSteps)
        self.completedSteps = min(max(0, completedSteps), totalSteps)
        self.color = color
    }

    public var body: some View {
        VStack(spacing: theme.sm) {
            HStack(spacing: theme.xs) {
                ForEach(0..<totalSteps, id: \.self) { step in
                    stepSegment(isCompleted: step < completedSteps)
                }
            }

            HStack {
                BSText("\(completedSteps) of \(totalSteps)", style: .caption1, color: .secondary)
                Spacer()
                BSText("\(Int(Double(completedSteps) / Double(totalSteps) * 100))%", style: .caption1, weight: .medium)
                    .foregroundColor(color ?? theme.primary)
            }
        }
    }

    private func stepSegment(isCompleted: Bool) -> some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(isCompleted ? (color ?? theme.primary) : theme.border.opacity(0.3))
            .frame(height: 6)
    }
}

// MARK: - BSCircularProgress

/// A circular progress indicator
public struct BSCircularProgress: View {

    private let progress: Double
    private let lineWidth: CGFloat
    private let color: Color?
    private let showLabel: Bool

    @Environment(\.theme) private var theme

    public init(
        progress: Double,
        lineWidth: CGFloat = 8,
        color: Color? = nil,
        showLabel: Bool = true
    ) {
        self.progress = min(max(progress, 0), 1)
        self.lineWidth = lineWidth
        self.color = color
        self.showLabel = showLabel
    }

    public var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(theme.border.opacity(0.3), lineWidth: lineWidth)

            // Progress circle
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    color ?? theme.primary,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.3), value: progress)

            // Label
            if showLabel {
                BSText("\(Int(progress * 100))%", style: .headline, weight: .bold)
                    .foregroundColor(color ?? theme.primary)
            }
        }
    }
}

// MARK: - BSLoadingSpinner

/// A loading spinner with various styles
public struct BSLoadingSpinner: View {

    private let style: Style
    private let color: Color?
    private let size: CGFloat

    @State private var isAnimating = false

    @Environment(\.theme) private var theme

    public enum Style {
        case circular
        case dots
        case pulse
        case bars
    }

    public init(
        style: Style = .circular,
        color: Color? = nil,
        size: CGFloat = 40
    ) {
        self.style = style
        self.color = color
        self.size = size
    }

    public var body: some View {
        Group {
            switch style {
            case .circular:
                circularSpinner
            case .dots:
                dotsSpinner
            case .pulse:
                pulseSpinner
            case .bars:
                barsSpinner
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            isAnimating = true
        }
    }

    private var circularSpinner: some View {
        Circle()
            .trim(from: 0.2, to: 1)
            .stroke(
                color ?? theme.primary,
                style: StrokeStyle(lineWidth: size / 10, lineCap: .round)
            )
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .animation(
                .linear(duration: 1)
                .repeatForever(autoreverses: false),
                value: isAnimating
            )
    }

    private var dotsSpinner: some View {
        HStack(spacing: size / 8) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(color ?? theme.primary)
                    .frame(width: size / 4, height: size / 4)
                    .scaleEffect(isAnimating ? 1 : 0.5)
                    .animation(
                        .easeInOut(duration: 0.6)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.2),
                        value: isAnimating
                    )
            }
        }
    }

    private var pulseSpinner: some View {
        Circle()
            .fill(color ?? theme.primary)
            .scaleEffect(isAnimating ? 1 : 0.5)
            .opacity(isAnimating ? 0 : 1)
            .animation(
                .easeOut(duration: 1)
                .repeatForever(autoreverses: false),
                value: isAnimating
            )
    }

    private var barsSpinner: some View {
        HStack(spacing: size / 10) {
            ForEach(0..<4) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(color ?? theme.primary)
                    .frame(width: size / 8)
                    .scaleEffect(y: isAnimating ? 1 : 0.4)
                    .animation(
                        .easeInOut(duration: 0.5)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.1),
                        value: isAnimating
                    )
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct BSProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 32) {
                BSProgressBar(progress: 0.7, showLabel: true)

                BSProgressBar(progress: 0.5, style: .striped)

                BSProgressBar(
                    progress: 0.8,
                    style: .gradient([.blue, .purple])
                )

                BSIndeterminateProgress()

                BSStepProgress(completedSteps: 3, totalSteps: 5)

                BSCircularProgress(progress: 0.75)
                    .frame(width: 100, height: 100)

                HStack(spacing: 32) {
                    BSLoadingSpinner(style: .circular)
                    BSLoadingSpinner(style: .dots)
                    BSLoadingSpinner(style: .pulse)
                    BSLoadingSpinner(style: .bars)
                }
            }
            .padding()
        }
        .withTheme()
    }
}
#endif
