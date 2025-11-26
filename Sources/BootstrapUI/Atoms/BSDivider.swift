// BSDivider.swift
// BootstrapUI
//
// Divider and separator components
// Follows Single Responsibility Principle - handles visual separation

import SwiftUI

// MARK: - Divider Orientation

/// Orientation of the divider
public enum BSDividerOrientation: String, Sendable {
    case horizontal
    case vertical
}

// MARK: - Divider Style

/// Available divider styles
public enum BSDividerStyle: String, CaseIterable, Sendable {
    case solid
    case dashed
    case dotted
}

// MARK: - Divider Component

/// A customizable divider component
///
/// Example usage:
/// ```swift
/// BSDivider()
/// BSDivider(style: .dashed, color: .gray)
/// BSDivider(orientation: .vertical)
/// BSDivider(text: "OR")
/// ```
public struct BSDivider: View {

    // MARK: - Properties

    private let orientation: BSDividerOrientation
    private let style: BSDividerStyle
    private let color: Color?
    private let thickness: CGFloat
    private let text: String?
    private let spacing: CGFloat

    @Environment(\.theme) private var theme

    // MARK: - Initialization

    /// Creates a divider
    /// - Parameters:
    ///   - orientation: Horizontal or vertical (default: .horizontal)
    ///   - style: Line style (default: .solid)
    ///   - color: Divider color (nil uses theme divider color)
    ///   - thickness: Line thickness (default: 1)
    ///   - text: Optional text to show in the middle
    ///   - spacing: Spacing around text (default: 16)
    public init(
        orientation: BSDividerOrientation = .horizontal,
        style: BSDividerStyle = .solid,
        color: Color? = nil,
        thickness: CGFloat = 1,
        text: String? = nil,
        spacing: CGFloat = 16
    ) {
        self.orientation = orientation
        self.style = style
        self.color = color
        self.thickness = thickness
        self.text = text
        self.spacing = spacing
    }

    // MARK: - Body

    public var body: some View {
        Group {
            if let text = text {
                textDivider(text)
            } else {
                simpleDivider
            }
        }
    }

    // MARK: - Private Views

    @ViewBuilder
    private var simpleDivider: some View {
        switch orientation {
        case .horizontal:
            lineView
                .frame(height: thickness)
        case .vertical:
            lineView
                .frame(width: thickness)
        }
    }

    @ViewBuilder
    private var lineView: some View {
        switch style {
        case .solid:
            Rectangle()
                .fill(dividerColor)
        case .dashed:
            DashedLine(dashLength: 6, gapLength: 4)
                .stroke(dividerColor, lineWidth: thickness)
        case .dotted:
            DashedLine(dashLength: 2, gapLength: 4)
                .stroke(dividerColor, lineWidth: thickness)
        }
    }

    private func textDivider(_ text: String) -> some View {
        HStack(spacing: spacing) {
            simpleDivider
            Text(text)
                .font(theme.caption1)
                .foregroundColor(theme.placeholder)
            simpleDivider
        }
    }

    private var dividerColor: Color {
        color ?? theme.divider
    }
}

// MARK: - Dashed Line Shape

/// A shape for drawing dashed lines
struct DashedLine: Shape {
    let dashLength: CGFloat
    let gapLength: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.width, y: rect.midY))
        return path
    }
}

extension DashedLine {
    func stroke(_ color: Color, lineWidth: CGFloat) -> some View {
        self.stroke(color, style: StrokeStyle(lineWidth: lineWidth, dash: [dashLength, gapLength]))
    }
}

// MARK: - Spacer Divider

/// A divider with configurable spacing
public struct BSSpacerDivider: View {

    private let height: CGFloat
    private let showLine: Bool
    private let color: Color?

    @Environment(\.theme) private var theme

    public init(
        height: CGFloat = 24,
        showLine: Bool = true,
        color: Color? = nil
    ) {
        self.height = height
        self.showLine = showLine
        self.color = color
    }

    public var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: height / 2)

            if showLine {
                BSDivider(color: color)
            }

            Spacer()
                .frame(height: height / 2)
        }
    }
}

// MARK: - Inset Divider

/// A divider with leading inset (common in lists)
public struct BSInsetDivider: View {

    private let leadingInset: CGFloat
    private let trailingInset: CGFloat
    private let color: Color?

    @Environment(\.theme) private var theme

    public init(
        leadingInset: CGFloat = 16,
        trailingInset: CGFloat = 0,
        color: Color? = nil
    ) {
        self.leadingInset = leadingInset
        self.trailingInset = trailingInset
        self.color = color
    }

    public var body: some View {
        BSDivider(color: color)
            .padding(.leading, leadingInset)
            .padding(.trailing, trailingInset)
    }
}

// MARK: - Preview

#if DEBUG
struct BSDivider_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 32) {
            VStack(spacing: 8) {
                Text("Above")
                BSDivider()
                Text("Below")
            }

            VStack(spacing: 8) {
                Text("Dashed")
                BSDivider(style: .dashed)
                Text("Dotted")
                BSDivider(style: .dotted)
            }

            BSDivider(text: "OR")

            HStack(spacing: 16) {
                Text("Left")
                BSDivider(orientation: .vertical)
                    .frame(height: 40)
                Text("Right")
            }

            BSInsetDivider(leadingInset: 48)

            BSSpacerDivider(height: 40)
        }
        .padding()
        .withTheme()
    }
}
#endif
