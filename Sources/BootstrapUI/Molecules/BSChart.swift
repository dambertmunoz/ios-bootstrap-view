// BSChart.swift
// BootstrapUI
//
// Basic chart components for data visualization
// Includes Bar, Line, and Pie charts

import SwiftUI

// MARK: - Chart Data Point

/// A single data point for charts
public struct BSChartDataPoint: Identifiable {
    public let id = UUID()
    public let label: String
    public let value: Double
    public let color: Color?

    public init(label: String, value: Double, color: Color? = nil) {
        self.label = label
        self.value = value
        self.color = color
    }
}

// MARK: - Bar Chart

/// A simple bar chart component
///
/// Example usage:
/// ```swift
/// BSBarChart(data: [
///     BSChartDataPoint(label: "Jan", value: 100),
///     BSChartDataPoint(label: "Feb", value: 150),
///     BSChartDataPoint(label: "Mar", value: 120)
/// ])
/// ```
public struct BSBarChart: View {

    private let data: [BSChartDataPoint]
    private let barColor: Color?
    private let showLabels: Bool
    private let showValues: Bool
    private let isHorizontal: Bool
    private let animationDuration: Double

    @Environment(\.theme) private var theme
    @State private var animationProgress: Double = 0

    public init(
        data: [BSChartDataPoint],
        barColor: Color? = nil,
        showLabels: Bool = true,
        showValues: Bool = true,
        isHorizontal: Bool = false,
        animationDuration: Double = 0.8
    ) {
        self.data = data
        self.barColor = barColor
        self.showLabels = showLabels
        self.showValues = showValues
        self.isHorizontal = isHorizontal
        self.animationDuration = animationDuration
    }

    public var body: some View {
        Group {
            if isHorizontal {
                horizontalBars
            } else {
                verticalBars
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: animationDuration)) {
                animationProgress = 1
            }
        }
    }

    private var verticalBars: some View {
        HStack(alignment: .bottom, spacing: theme.sm) {
            ForEach(data) { point in
                VStack(spacing: theme.xs) {
                    if showValues {
                        Text(formatValue(point.value))
                            .font(theme.caption2)
                            .foregroundColor(theme.placeholder)
                    }

                    RoundedRectangle(cornerRadius: theme.radiusSm)
                        .fill(point.color ?? barColor ?? theme.primary)
                        .frame(height: barHeight(for: point.value) * animationProgress)
                        .frame(maxWidth: .infinity)

                    if showLabels {
                        Text(point.label)
                            .font(theme.caption2)
                            .foregroundColor(theme.placeholder)
                            .lineLimit(1)
                    }
                }
            }
        }
    }

    private var horizontalBars: some View {
        VStack(spacing: theme.sm) {
            ForEach(data) { point in
                HStack(spacing: theme.sm) {
                    if showLabels {
                        Text(point.label)
                            .font(theme.caption1)
                            .foregroundColor(theme.onSurface)
                            .frame(width: 60, alignment: .leading)
                    }

                    GeometryReader { geometry in
                        RoundedRectangle(cornerRadius: theme.radiusSm)
                            .fill(point.color ?? barColor ?? theme.primary)
                            .frame(width: barWidth(for: point.value, in: geometry) * animationProgress)
                    }
                    .frame(height: 24)

                    if showValues {
                        Text(formatValue(point.value))
                            .font(theme.caption1)
                            .foregroundColor(theme.placeholder)
                            .frame(width: 50, alignment: .trailing)
                    }
                }
            }
        }
    }

    private var maxValue: Double {
        data.map(\.value).max() ?? 1
    }

    private func barHeight(for value: Double) -> CGFloat {
        let ratio = value / maxValue
        return CGFloat(ratio) * 150
    }

    private func barWidth(for value: Double, in geometry: GeometryProxy) -> CGFloat {
        let ratio = value / maxValue
        return CGFloat(ratio) * geometry.size.width
    }

    private func formatValue(_ value: Double) -> String {
        if value >= 1000000 {
            return String(format: "%.1fM", value / 1000000)
        } else if value >= 1000 {
            return String(format: "%.1fK", value / 1000)
        } else if value == floor(value) {
            return String(format: "%.0f", value)
        }
        return String(format: "%.1f", value)
    }
}

// MARK: - Line Chart

/// A simple line chart component
public struct BSLineChart: View {

    private let data: [BSChartDataPoint]
    private let lineColor: Color?
    private let fillGradient: Bool
    private let showDots: Bool
    private let showLabels: Bool
    private let animationDuration: Double

    @Environment(\.theme) private var theme
    @State private var animationProgress: Double = 0

    public init(
        data: [BSChartDataPoint],
        lineColor: Color? = nil,
        fillGradient: Bool = true,
        showDots: Bool = true,
        showLabels: Bool = true,
        animationDuration: Double = 1.0
    ) {
        self.data = data
        self.lineColor = lineColor
        self.fillGradient = fillGradient
        self.showDots = showDots
        self.showLabels = showLabels
        self.animationDuration = animationDuration
    }

    public var body: some View {
        VStack(spacing: theme.sm) {
            GeometryReader { geometry in
                ZStack {
                    // Grid lines
                    gridLines(in: geometry)

                    // Fill area
                    if fillGradient {
                        fillArea(in: geometry)
                    }

                    // Line
                    linePath(in: geometry)
                        .trim(from: 0, to: animationProgress)
                        .stroke(
                            lineColor ?? theme.primary,
                            style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round)
                        )

                    // Dots
                    if showDots {
                        dots(in: geometry)
                    }
                }
            }

            // Labels
            if showLabels {
                HStack {
                    ForEach(data) { point in
                        Text(point.label)
                            .font(theme.caption2)
                            .foregroundColor(theme.placeholder)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: animationDuration)) {
                animationProgress = 1
            }
        }
    }

    private func gridLines(in geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            ForEach(0..<5) { index in
                Rectangle()
                    .fill(theme.border.opacity(0.3))
                    .frame(height: 1)
                if index < 4 {
                    Spacer()
                }
            }
        }
    }

    private func linePath(in geometry: GeometryProxy) -> Path {
        var path = Path()
        guard data.count > 1 else { return path }

        let points = dataPoints(in: geometry)

        path.move(to: points[0])
        for index in 1..<points.count {
            path.addLine(to: points[index])
        }

        return path
    }

    private func fillArea(in geometry: GeometryProxy) -> some View {
        let points = dataPoints(in: geometry)
        var fillPath = Path()

        guard points.count > 1 else { return AnyView(EmptyView()) }

        fillPath.move(to: CGPoint(x: points[0].x, y: geometry.size.height))
        fillPath.addLine(to: points[0])

        for index in 1..<points.count {
            fillPath.addLine(to: points[index])
        }

        fillPath.addLine(to: CGPoint(x: points.last!.x, y: geometry.size.height))
        fillPath.closeSubpath()

        return AnyView(
            fillPath
                .fill(
                    LinearGradient(
                        colors: [
                            (lineColor ?? theme.primary).opacity(0.3),
                            (lineColor ?? theme.primary).opacity(0.05)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .opacity(animationProgress)
        )
    }

    private func dots(in geometry: GeometryProxy) -> some View {
        let points = dataPoints(in: geometry)

        return ForEach(Array(points.enumerated()), id: \.offset) { index, point in
            Circle()
                .fill(lineColor ?? theme.primary)
                .frame(width: 8, height: 8)
                .position(point)
                .opacity(animationProgress)
        }
    }

    private func dataPoints(in geometry: GeometryProxy) -> [CGPoint] {
        guard data.count > 0 else { return [] }

        let maxValue = data.map(\.value).max() ?? 1
        let minValue = data.map(\.value).min() ?? 0
        let range = maxValue - minValue
        let effectiveRange = range > 0 ? range : 1

        let stepX = geometry.size.width / CGFloat(max(1, data.count - 1))

        return data.enumerated().map { index, point in
            let x = CGFloat(index) * stepX
            let normalizedValue = (point.value - minValue) / effectiveRange
            let y = geometry.size.height * (1 - CGFloat(normalizedValue))
            return CGPoint(x: x, y: y)
        }
    }
}

// MARK: - Pie Chart

/// A simple pie chart component
public struct BSPieChart: View {

    private let data: [BSChartDataPoint]
    private let showLabels: Bool
    private let showPercentages: Bool
    private let innerRadius: CGFloat
    private let animationDuration: Double

    @Environment(\.theme) private var theme
    @State private var animationProgress: Double = 0

    private let defaultColors: [Color] = [
        .blue, .green, .orange, .purple, .red, .cyan, .yellow, .pink
    ]

    public init(
        data: [BSChartDataPoint],
        showLabels: Bool = true,
        showPercentages: Bool = true,
        innerRadius: CGFloat = 0, // 0 = full pie, > 0 = donut
        animationDuration: Double = 0.8
    ) {
        self.data = data
        self.showLabels = showLabels
        self.showPercentages = showPercentages
        self.innerRadius = innerRadius
        self.animationDuration = animationDuration
    }

    public var body: some View {
        HStack(spacing: theme.lg) {
            // Pie
            GeometryReader { geometry in
                let size = min(geometry.size.width, geometry.size.height)

                ZStack {
                    ForEach(Array(slices.enumerated()), id: \.element.id) { index, slice in
                        pieSlice(slice, at: index, size: size)
                    }

                    // Center hole for donut
                    if innerRadius > 0 {
                        Circle()
                            .fill(theme.background)
                            .frame(width: size * innerRadius, height: size * innerRadius)
                    }

                    // Center text
                    if innerRadius > 0 {
                        VStack(spacing: 2) {
                            Text(formatValue(total))
                                .font(theme.headline)
                                .fontWeight(.bold)

                            Text("Total")
                                .font(theme.caption2)
                                .foregroundColor(theme.placeholder)
                        }
                    }
                }
                .frame(width: size, height: size)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
            .aspectRatio(1, contentMode: .fit)

            // Legend
            if showLabels {
                legend
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: animationDuration)) {
                animationProgress = 1
            }
        }
    }

    private func pieSlice(_ slice: PieSlice, at index: Int, size: CGFloat) -> some View {
        PieSliceShape(
            startAngle: slice.startAngle,
            endAngle: slice.endAngle,
            innerRadius: innerRadius
        )
        .fill(slice.color)
        .frame(width: size, height: size)
        .scaleEffect(animationProgress)
    }

    private var legend: some View {
        VStack(alignment: .leading, spacing: theme.sm) {
            ForEach(Array(slices.enumerated()), id: \.element.id) { index, slice in
                HStack(spacing: theme.sm) {
                    Circle()
                        .fill(slice.color)
                        .frame(width: 12, height: 12)

                    Text(slice.label)
                        .font(theme.caption1)
                        .foregroundColor(theme.onSurface)

                    Spacer()

                    if showPercentages {
                        Text(String(format: "%.0f%%", slice.percentage * 100))
                            .font(theme.caption1)
                            .foregroundColor(theme.placeholder)
                    }
                }
            }
        }
    }

    // MARK: - Slices

    private struct PieSlice: Identifiable {
        let id = UUID()
        let label: String
        let value: Double
        let color: Color
        let startAngle: Angle
        let endAngle: Angle
        let percentage: Double
    }

    private var total: Double {
        data.map(\.value).reduce(0, +)
    }

    private var slices: [PieSlice] {
        var currentAngle: Double = -90 // Start from top

        return data.enumerated().map { index, point in
            let percentage = point.value / max(total, 1)
            let angle = percentage * 360

            let slice = PieSlice(
                label: point.label,
                value: point.value,
                color: point.color ?? defaultColors[index % defaultColors.count],
                startAngle: .degrees(currentAngle),
                endAngle: .degrees(currentAngle + angle),
                percentage: percentage
            )

            currentAngle += angle
            return slice
        }
    }

    private func formatValue(_ value: Double) -> String {
        if value >= 1000000 {
            return String(format: "%.1fM", value / 1000000)
        } else if value >= 1000 {
            return String(format: "%.1fK", value / 1000)
        }
        return String(format: "%.0f", value)
    }
}

// MARK: - Pie Slice Shape

struct PieSliceShape: Shape {
    let startAngle: Angle
    let endAngle: Angle
    let innerRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let innerRadiusValue = radius * innerRadius

        var path = Path()

        if innerRadius > 0 {
            // Donut slice
            path.addArc(
                center: center,
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: false
            )
            path.addArc(
                center: center,
                radius: innerRadiusValue,
                startAngle: endAngle,
                endAngle: startAngle,
                clockwise: true
            )
            path.closeSubpath()
        } else {
            // Full pie slice
            path.move(to: center)
            path.addArc(
                center: center,
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: false
            )
            path.closeSubpath()
        }

        return path
    }
}

// MARK: - Progress Ring

/// A circular progress indicator
public struct BSProgressRing: View {

    private let progress: Double
    private let lineWidth: CGFloat
    private let color: Color?
    private let showPercentage: Bool

    @Environment(\.theme) private var theme
    @State private var animatedProgress: Double = 0

    public init(
        progress: Double,
        lineWidth: CGFloat = 10,
        color: Color? = nil,
        showPercentage: Bool = true
    ) {
        self.progress = min(max(progress, 0), 1)
        self.lineWidth = lineWidth
        self.color = color
        self.showPercentage = showPercentage
    }

    public var body: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(theme.border, lineWidth: lineWidth)

            // Progress ring
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    color ?? theme.primary,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            // Percentage text
            if showPercentage {
                Text("\(Int(animatedProgress * 100))%")
                    .font(theme.headline)
                    .fontWeight(.bold)
                    .foregroundColor(theme.onSurface)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { _, newValue in
            withAnimation(.easeOut(duration: 0.3)) {
                animatedProgress = newValue
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct BSChart_Previews: PreviewProvider {
    static let sampleData = [
        BSChartDataPoint(label: "Jan", value: 120),
        BSChartDataPoint(label: "Feb", value: 180),
        BSChartDataPoint(label: "Mar", value: 90),
        BSChartDataPoint(label: "Apr", value: 250),
        BSChartDataPoint(label: "May", value: 200),
        BSChartDataPoint(label: "Jun", value: 150)
    ]

    static var previews: some View {
        ScrollView {
            VStack(spacing: 40) {
                // Bar Chart
                Text("Bar Chart").font(.headline)
                BSBarChart(data: sampleData)
                    .frame(height: 200)

                // Horizontal Bar Chart
                Text("Horizontal Bar Chart").font(.headline)
                BSBarChart(data: sampleData, isHorizontal: true)
                    .frame(height: 200)

                // Line Chart
                Text("Line Chart").font(.headline)
                BSLineChart(data: sampleData)
                    .frame(height: 200)

                // Pie Chart
                Text("Pie Chart").font(.headline)
                BSPieChart(data: Array(sampleData.prefix(4)))
                    .frame(height: 200)

                // Donut Chart
                Text("Donut Chart").font(.headline)
                BSPieChart(data: Array(sampleData.prefix(4)), innerRadius: 0.5)
                    .frame(height: 200)

                // Progress Ring
                Text("Progress Ring").font(.headline)
                HStack(spacing: 30) {
                    BSProgressRing(progress: 0.25)
                        .frame(width: 80, height: 80)
                    BSProgressRing(progress: 0.50, color: .orange)
                        .frame(width: 80, height: 80)
                    BSProgressRing(progress: 0.75, color: .green)
                        .frame(width: 80, height: 80)
                }
            }
            .padding()
        }
        .withTheme()
    }
}
#endif
