// BSTimeline.swift
// BootstrapUI
//
// Timeline components for displaying chronological events
// Supports various styles and customization options

import SwiftUI

// MARK: - BSTimeline

/// A timeline view for displaying chronological events
public struct BSTimeline<Item: Identifiable, Content: View>: View {

    private let items: [Item]
    private let style: Style
    private let content: (Item, Int) -> Content

    @Environment(\.theme) private var theme

    public enum Style {
        case left
        case right
        case alternating
        case centered
    }

    public init(
        items: [Item],
        style: Style = .left,
        @ViewBuilder content: @escaping (Item, Int) -> Content
    ) {
        self.items = items
        self.style = style
        self.content = content
    }

    public var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                timelineItem(item: item, index: index, isLast: index == items.count - 1)
            }
        }
    }

    @ViewBuilder
    private func timelineItem(item: Item, index: Int, isLast: Bool) -> some View {
        switch style {
        case .left:
            leftAlignedItem(item: item, index: index, isLast: isLast)
        case .right:
            rightAlignedItem(item: item, index: index, isLast: isLast)
        case .alternating:
            alternatingItem(item: item, index: index, isLast: isLast)
        case .centered:
            centeredItem(item: item, index: index, isLast: isLast)
        }
    }

    private func leftAlignedItem(item: Item, index: Int, isLast: Bool) -> some View {
        HStack(alignment: .top, spacing: theme.md) {
            // Timeline line and dot
            VStack(spacing: 0) {
                Circle()
                    .fill(theme.primary)
                    .frame(width: 12, height: 12)

                if !isLast {
                    Rectangle()
                        .fill(theme.border)
                        .frame(width: 2)
                }
            }

            // Content
            content(item, index)
                .padding(.bottom, theme.lg)

            Spacer(minLength: 0)
        }
    }

    private func rightAlignedItem(item: Item, index: Int, isLast: Bool) -> some View {
        HStack(alignment: .top, spacing: theme.md) {
            Spacer(minLength: 0)

            // Content
            content(item, index)
                .padding(.bottom, theme.lg)

            // Timeline line and dot
            VStack(spacing: 0) {
                Circle()
                    .fill(theme.primary)
                    .frame(width: 12, height: 12)

                if !isLast {
                    Rectangle()
                        .fill(theme.border)
                        .frame(width: 2)
                }
            }
        }
    }

    private func alternatingItem(item: Item, index: Int, isLast: Bool) -> some View {
        HStack(alignment: .top, spacing: theme.md) {
            if index % 2 == 0 {
                content(item, index)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.bottom, theme.lg)
            } else {
                Spacer()
            }

            // Timeline line and dot
            VStack(spacing: 0) {
                Circle()
                    .fill(theme.primary)
                    .frame(width: 12, height: 12)

                if !isLast {
                    Rectangle()
                        .fill(theme.border)
                        .frame(width: 2)
                }
            }

            if index % 2 == 1 {
                content(item, index)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, theme.lg)
            } else {
                Spacer()
            }
        }
    }

    private func centeredItem(item: Item, index: Int, isLast: Bool) -> some View {
        VStack(spacing: theme.sm) {
            Circle()
                .fill(theme.primary)
                .frame(width: 16, height: 16)

            content(item, index)

            if !isLast {
                Rectangle()
                    .fill(theme.border)
                    .frame(width: 2, height: theme.lg)
            }
        }
    }
}

// MARK: - BSTimelineEvent

/// A pre-styled timeline event item
public struct BSTimelineEvent: View {

    private let title: String
    private let subtitle: String?
    private let time: String?
    private let icon: String?
    private let iconColor: Color?
    private let status: Status?

    @Environment(\.theme) private var theme

    public enum Status {
        case completed
        case current
        case upcoming
        case error
    }

    public init(
        title: String,
        subtitle: String? = nil,
        time: String? = nil,
        icon: String? = nil,
        iconColor: Color? = nil,
        status: Status? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.time = time
        self.icon = icon
        self.iconColor = iconColor
        self.status = status
    }

    public var body: some View {
        HStack(alignment: .top, spacing: theme.md) {
            // Icon/status indicator
            statusIndicator

            // Content
            VStack(alignment: .leading, spacing: theme.xxs) {
                HStack {
                    BSText(title, style: .headline)

                    Spacer()

                    if let time = time {
                        BSText(time, style: .caption1, color: .secondary)
                    }
                }

                if let subtitle = subtitle {
                    BSText(subtitle, style: .subheadline, color: .secondary)
                }
            }
        }
    }

    private var statusIndicator: some View {
        ZStack {
            Circle()
                .fill(statusColor.opacity(0.2))
                .frame(width: 32, height: 32)

            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(iconColor ?? statusColor)
            } else if let status = status {
                Image(systemName: statusIcon)
                    .font(.system(size: 14))
                    .foregroundColor(statusColor)
            }
        }
    }

    private var statusColor: Color {
        guard let status = status else { return iconColor ?? theme.primary }
        switch status {
        case .completed: return theme.success
        case .current: return theme.primary
        case .upcoming: return theme.placeholder
        case .error: return theme.error
        }
    }

    private var statusIcon: String {
        guard let status = status else { return "circle.fill" }
        switch status {
        case .completed: return "checkmark"
        case .current: return "circle.fill"
        case .upcoming: return "circle"
        case .error: return "exclamationmark"
        }
    }
}

// MARK: - BSActivityTimeline

/// A timeline for activity/history logs
public struct BSActivityTimeline: View {

    private let activities: [Activity]

    @Environment(\.theme) private var theme

    public struct Activity: Identifiable {
        public let id = UUID()
        public let title: String
        public let description: String?
        public let time: String
        public let icon: String
        public let iconColor: Color

        public init(
            title: String,
            description: String? = nil,
            time: String,
            icon: String,
            iconColor: Color
        ) {
            self.title = title
            self.description = description
            self.time = time
            self.icon = icon
            self.iconColor = iconColor
        }
    }

    public init(activities: [Activity]) {
        self.activities = activities
    }

    public var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(activities.enumerated()), id: \.element.id) { index, activity in
                HStack(alignment: .top, spacing: theme.md) {
                    // Timeline
                    VStack(spacing: 0) {
                        // Icon circle
                        ZStack {
                            Circle()
                                .fill(activity.iconColor.opacity(0.2))
                                .frame(width: 36, height: 36)

                            Image(systemName: activity.icon)
                                .font(.system(size: 14))
                                .foregroundColor(activity.iconColor)
                        }

                        // Connector line
                        if index < activities.count - 1 {
                            Rectangle()
                                .fill(theme.border)
                                .frame(width: 2)
                                .frame(maxHeight: .infinity)
                        }
                    }

                    // Content
                    VStack(alignment: .leading, spacing: theme.xxs) {
                        HStack {
                            BSText(activity.title, style: .subheadline, weight: .medium)
                            Spacer()
                            BSText(activity.time, style: .caption2, color: .secondary)
                        }

                        if let description = activity.description {
                            BSText(description, style: .caption1, color: .secondary)
                        }
                    }
                    .padding(.bottom, theme.md)
                }
            }
        }
    }
}

// MARK: - BSOrderTimeline

/// A timeline specifically for order tracking
public struct BSOrderTimeline: View {

    private let steps: [OrderStep]

    @Environment(\.theme) private var theme

    public struct OrderStep: Identifiable {
        public let id = UUID()
        public let title: String
        public let subtitle: String?
        public let time: String?
        public let status: Status

        public enum Status {
            case completed
            case current
            case pending
        }

        public init(
            title: String,
            subtitle: String? = nil,
            time: String? = nil,
            status: Status
        ) {
            self.title = title
            self.subtitle = subtitle
            self.time = time
            self.status = status
        }
    }

    public init(steps: [OrderStep]) {
        self.steps = steps
    }

    public var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                HStack(alignment: .top, spacing: theme.md) {
                    // Status indicator
                    VStack(spacing: 0) {
                        ZStack {
                            Circle()
                                .fill(stepColor(for: step.status).opacity(0.2))
                                .frame(width: 28, height: 28)

                            if step.status == .completed {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(theme.success)
                            } else if step.status == .current {
                                Circle()
                                    .fill(theme.primary)
                                    .frame(width: 10, height: 10)
                            } else {
                                Circle()
                                    .stroke(theme.border, lineWidth: 2)
                                    .frame(width: 10, height: 10)
                            }
                        }

                        if index < steps.count - 1 {
                            Rectangle()
                                .fill(
                                    step.status == .completed ? theme.success : theme.border
                                )
                                .frame(width: 2, height: 40)
                        }
                    }

                    // Content
                    VStack(alignment: .leading, spacing: theme.xxs) {
                        BSText(step.title, style: .subheadline, weight: step.status == .current ? .semibold : .regular)
                            .foregroundColor(step.status == .pending ? theme.placeholder : theme.onSurface)

                        if let subtitle = step.subtitle {
                            BSText(subtitle, style: .caption1, color: .secondary)
                        }

                        if let time = step.time {
                            BSText(time, style: .caption2, color: .secondary)
                        }
                    }

                    Spacer()
                }
            }
        }
    }

    private func stepColor(for status: OrderStep.Status) -> Color {
        switch status {
        case .completed: return theme.success
        case .current: return theme.primary
        case .pending: return theme.border
        }
    }
}

// MARK: - Preview

#if DEBUG
struct BSTimeline_Previews: PreviewProvider {
    struct SampleEvent: Identifiable {
        let id = UUID()
        let title: String
        let time: String
    }

    static var previews: some View {
        ScrollView {
            VStack(spacing: 32) {
                BSOrderTimeline(steps: [
                    .init(title: "Order Placed", subtitle: "Your order has been confirmed", time: "Dec 1, 10:30 AM", status: .completed),
                    .init(title: "Processing", subtitle: "Preparing your items", time: "Dec 1, 2:00 PM", status: .completed),
                    .init(title: "Shipped", subtitle: "On the way to you", time: "Dec 2, 9:00 AM", status: .current),
                    .init(title: "Delivered", status: .pending)
                ])

                BSDivider()

                BSActivityTimeline(activities: [
                    .init(title: "John commented", description: "Great work!", time: "2m ago", icon: "bubble.left.fill", iconColor: .blue),
                    .init(title: "Sarah liked your post", time: "5m ago", icon: "heart.fill", iconColor: .red),
                    .init(title: "New follower", description: "Mike started following you", time: "10m ago", icon: "person.fill", iconColor: .green)
                ])
            }
            .padding()
        }
        .withTheme()
    }
}
#endif
