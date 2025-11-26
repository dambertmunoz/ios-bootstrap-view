// BSSlider.swift
// BootstrapUI
//
// Customizable slider components with various styles
// Includes single value slider and range slider

import SwiftUI

// MARK: - BSSlider

/// A customizable slider component
public struct BSSlider: View {

    @Binding private var value: Double
    private let range: ClosedRange<Double>
    private let step: Double?
    private let style: SliderStyle
    private let showValue: Bool
    private let valueFormatter: (Double) -> String
    private let onEditingChanged: ((Bool) -> Void)?

    @Environment(\.theme) private var theme

    public enum SliderStyle {
        case `default`
        case minimal
        case gradient(colors: [Color])
        case stepped
    }

    public init(
        value: Binding<Double>,
        in range: ClosedRange<Double> = 0...100,
        step: Double? = nil,
        style: SliderStyle = .default,
        showValue: Bool = false,
        valueFormatter: @escaping (Double) -> String = { String(format: "%.0f", $0) },
        onEditingChanged: ((Bool) -> Void)? = nil
    ) {
        self._value = value
        self.range = range
        self.step = step
        self.style = style
        self.showValue = showValue
        self.valueFormatter = valueFormatter
        self.onEditingChanged = onEditingChanged
    }

    public var body: some View {
        VStack(spacing: theme.xs) {
            if showValue {
                HStack {
                    Spacer()
                    BSText(valueFormatter(value), style: .caption1, weight: .medium)
                        .foregroundColor(theme.primary)
                }
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Track background
                    trackBackground(width: geometry.size.width)

                    // Track fill
                    trackFill(width: geometry.size.width)

                    // Step marks
                    if case .stepped = style, let step = step {
                        stepMarks(width: geometry.size.width, step: step)
                    }

                    // Thumb
                    thumb
                        .offset(x: thumbOffset(width: geometry.size.width))
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { gesture in
                                    updateValue(gesture: gesture, width: geometry.size.width)
                                    onEditingChanged?(true)
                                }
                                .onEnded { _ in
                                    onEditingChanged?(false)
                                }
                        )
                }
            }
            .frame(height: 24)
        }
    }

    private func trackBackground(width: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(theme.border.opacity(0.3))
            .frame(height: 6)
    }

    @ViewBuilder
    private func trackFill(width: CGFloat) -> some View {
        let fillWidth = CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound)) * width

        switch style {
        case .gradient(let colors):
            LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing)
                .frame(width: max(0, fillWidth), height: 6)
                .clipShape(RoundedRectangle(cornerRadius: 4))
        default:
            RoundedRectangle(cornerRadius: 4)
                .fill(theme.primary)
                .frame(width: max(0, fillWidth), height: 6)
        }
    }

    private func stepMarks(width: CGFloat, step: Double) -> some View {
        let numberOfSteps = Int((range.upperBound - range.lowerBound) / step)

        return HStack(spacing: 0) {
            ForEach(0...numberOfSteps, id: \.self) { index in
                Circle()
                    .fill(theme.surface)
                    .frame(width: 4, height: 4)
                if index < numberOfSteps {
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 10)
    }

    private var thumb: some View {
        Circle()
            .fill(Color.white)
            .frame(width: 24, height: 24)
            .shadow(color: theme.onSurface.opacity(0.2), radius: 4, x: 0, y: 2)
            .overlay(
                Circle()
                    .fill(theme.primary)
                    .frame(width: 12, height: 12)
            )
    }

    private func thumbOffset(width: CGFloat) -> CGFloat {
        let percent = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return CGFloat(percent) * (width - 24)
    }

    private func updateValue(gesture: DragGesture.Value, width: CGFloat) {
        let percent = gesture.location.x / width
        var newValue = range.lowerBound + Double(percent) * (range.upperBound - range.lowerBound)

        // Clamp to range
        newValue = min(max(newValue, range.lowerBound), range.upperBound)

        // Apply step if specified
        if let step = step {
            newValue = round(newValue / step) * step
        }

        value = newValue
    }
}

// MARK: - BSRangeSlider

/// A range slider for selecting a range of values
public struct BSRangeSlider: View {

    @Binding private var lowerValue: Double
    @Binding private var upperValue: Double
    private let range: ClosedRange<Double>
    private let step: Double?
    private let showValues: Bool
    private let valueFormatter: (Double) -> String

    @State private var isDraggingLower = false
    @State private var isDraggingUpper = false

    @Environment(\.theme) private var theme

    public init(
        lowerValue: Binding<Double>,
        upperValue: Binding<Double>,
        in range: ClosedRange<Double> = 0...100,
        step: Double? = nil,
        showValues: Bool = true,
        valueFormatter: @escaping (Double) -> String = { String(format: "%.0f", $0) }
    ) {
        self._lowerValue = lowerValue
        self._upperValue = upperValue
        self.range = range
        self.step = step
        self.showValues = showValues
        self.valueFormatter = valueFormatter
    }

    public var body: some View {
        VStack(spacing: theme.xs) {
            if showValues {
                HStack {
                    BSText(valueFormatter(lowerValue), style: .caption1, weight: .medium)
                        .foregroundColor(theme.primary)
                    Spacer()
                    BSText(valueFormatter(upperValue), style: .caption1, weight: .medium)
                        .foregroundColor(theme.primary)
                }
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Track background
                    RoundedRectangle(cornerRadius: 4)
                        .fill(theme.border.opacity(0.3))
                        .frame(height: 6)

                    // Track fill (between thumbs)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(theme.primary)
                        .frame(width: fillWidth(width: geometry.size.width), height: 6)
                        .offset(x: lowerThumbOffset(width: geometry.size.width) + 12)

                    // Lower thumb
                    thumb(isActive: isDraggingLower)
                        .offset(x: lowerThumbOffset(width: geometry.size.width))
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { gesture in
                                    isDraggingLower = true
                                    updateLowerValue(gesture: gesture, width: geometry.size.width)
                                }
                                .onEnded { _ in
                                    isDraggingLower = false
                                }
                        )

                    // Upper thumb
                    thumb(isActive: isDraggingUpper)
                        .offset(x: upperThumbOffset(width: geometry.size.width))
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { gesture in
                                    isDraggingUpper = true
                                    updateUpperValue(gesture: gesture, width: geometry.size.width)
                                }
                                .onEnded { _ in
                                    isDraggingUpper = false
                                }
                        )
                }
            }
            .frame(height: 24)
        }
    }

    private func thumb(isActive: Bool) -> some View {
        Circle()
            .fill(Color.white)
            .frame(width: 24, height: 24)
            .shadow(color: theme.onSurface.opacity(0.2), radius: isActive ? 6 : 4, x: 0, y: 2)
            .overlay(
                Circle()
                    .fill(theme.primary)
                    .frame(width: isActive ? 14 : 12, height: isActive ? 14 : 12)
            )
            .scaleEffect(isActive ? 1.1 : 1.0)
            .animation(.spring(response: 0.3), value: isActive)
    }

    private func lowerThumbOffset(width: CGFloat) -> CGFloat {
        let percent = (lowerValue - range.lowerBound) / (range.upperBound - range.lowerBound)
        return CGFloat(percent) * (width - 24)
    }

    private func upperThumbOffset(width: CGFloat) -> CGFloat {
        let percent = (upperValue - range.lowerBound) / (range.upperBound - range.lowerBound)
        return CGFloat(percent) * (width - 24)
    }

    private func fillWidth(width: CGFloat) -> CGFloat {
        let lowerPercent = (lowerValue - range.lowerBound) / (range.upperBound - range.lowerBound)
        let upperPercent = (upperValue - range.lowerBound) / (range.upperBound - range.lowerBound)
        return CGFloat(upperPercent - lowerPercent) * (width - 24)
    }

    private func updateLowerValue(gesture: DragGesture.Value, width: CGFloat) {
        let percent = gesture.location.x / width
        var newValue = range.lowerBound + Double(percent) * (range.upperBound - range.lowerBound)

        // Clamp to range and upper value
        newValue = min(max(newValue, range.lowerBound), upperValue - (step ?? 1))

        if let step = step {
            newValue = round(newValue / step) * step
        }

        lowerValue = newValue
    }

    private func updateUpperValue(gesture: DragGesture.Value, width: CGFloat) {
        let percent = gesture.location.x / width
        var newValue = range.lowerBound + Double(percent) * (range.upperBound - range.lowerBound)

        // Clamp to range and lower value
        newValue = min(max(newValue, lowerValue + (step ?? 1)), range.upperBound)

        if let step = step {
            newValue = round(newValue / step) * step
        }

        upperValue = newValue
    }
}

// MARK: - BSLabeledSlider

/// A slider with labels at the ends
public struct BSLabeledSlider: View {

    @Binding private var value: Double
    private let range: ClosedRange<Double>
    private let minLabel: String
    private let maxLabel: String
    private let showValue: Bool

    @Environment(\.theme) private var theme

    public init(
        value: Binding<Double>,
        in range: ClosedRange<Double> = 0...100,
        minLabel: String,
        maxLabel: String,
        showValue: Bool = true
    ) {
        self._value = value
        self.range = range
        self.minLabel = minLabel
        self.maxLabel = maxLabel
        self.showValue = showValue
    }

    public var body: some View {
        VStack(spacing: theme.sm) {
            if showValue {
                BSText(String(format: "%.0f", value), style: .headline)
                    .foregroundColor(theme.primary)
            }

            HStack(spacing: theme.md) {
                BSText(minLabel, style: .caption1, color: .secondary)

                BSSlider(value: $value, in: range)

                BSText(maxLabel, style: .caption1, color: .secondary)
            }
        }
    }
}

// MARK: - BSDiscreteSlider

/// A slider with discrete options
public struct BSDiscreteSlider<T: Hashable>: View {

    @Binding private var selection: T
    private let options: [T]
    private let labelProvider: (T) -> String

    @Environment(\.theme) private var theme

    public init(
        selection: Binding<T>,
        options: [T],
        labelProvider: @escaping (T) -> String
    ) {
        self._selection = selection
        self.options = options
        self.labelProvider = labelProvider
    }

    public var body: some View {
        VStack(spacing: theme.sm) {
            // Current selection label
            BSText(labelProvider(selection), style: .headline)
                .foregroundColor(theme.primary)

            // Slider track with options
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Track
                    RoundedRectangle(cornerRadius: 4)
                        .fill(theme.border.opacity(0.3))
                        .frame(height: 6)

                    // Fill
                    RoundedRectangle(cornerRadius: 4)
                        .fill(theme.primary)
                        .frame(width: fillWidth(width: geometry.size.width), height: 6)

                    // Option dots
                    HStack {
                        ForEach(0..<options.count, id: \.self) { index in
                            Circle()
                                .fill(index <= currentIndex ? theme.primary : theme.border)
                                .frame(width: 8, height: 8)
                            if index < options.count - 1 {
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal, 8)

                    // Thumb
                    Circle()
                        .fill(Color.white)
                        .frame(width: 24, height: 24)
                        .shadow(color: theme.onSurface.opacity(0.2), radius: 4, x: 0, y: 2)
                        .overlay(
                            Circle()
                                .fill(theme.primary)
                                .frame(width: 12, height: 12)
                        )
                        .offset(x: thumbOffset(width: geometry.size.width))
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { gesture in
                                    updateSelection(gesture: gesture, width: geometry.size.width)
                                }
                        )
                }
            }
            .frame(height: 24)

            // Labels
            HStack {
                ForEach(0..<options.count, id: \.self) { index in
                    BSText(labelProvider(options[index]), style: .caption2, color: .secondary)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }

    private var currentIndex: Int {
        options.firstIndex(of: selection) ?? 0
    }

    private func fillWidth(width: CGFloat) -> CGFloat {
        guard options.count > 1 else { return 0 }
        let stepWidth = (width - 24) / CGFloat(options.count - 1)
        return stepWidth * CGFloat(currentIndex) + 12
    }

    private func thumbOffset(width: CGFloat) -> CGFloat {
        guard options.count > 1 else { return 0 }
        let stepWidth = (width - 24) / CGFloat(options.count - 1)
        return stepWidth * CGFloat(currentIndex)
    }

    private func updateSelection(gesture: DragGesture.Value, width: CGFloat) {
        guard options.count > 1 else { return }
        let stepWidth = width / CGFloat(options.count - 1)
        let index = Int(round(gesture.location.x / stepWidth))
        let clampedIndex = min(max(index, 0), options.count - 1)
        selection = options[clampedIndex]
    }
}

// MARK: - Preview

#if DEBUG
struct BSSlider_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 32) {
                BSSlider(value: .constant(50), showValue: true)

                BSSlider(
                    value: .constant(70),
                    style: .gradient(colors: [.blue, .purple]),
                    showValue: true
                )

                BSRangeSlider(
                    lowerValue: .constant(20),
                    upperValue: .constant(80)
                )

                BSLabeledSlider(
                    value: .constant(50),
                    minLabel: "Min",
                    maxLabel: "Max"
                )
            }
            .padding()
        }
        .withTheme()
    }
}
#endif
