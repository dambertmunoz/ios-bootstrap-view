# Generate BootstrapUI Dashboard

Generate a SwiftUI dashboard view using BootstrapUI components for: $ARGUMENTS

## Instructions

Create a dashboard with cards, charts, stats, and navigation:

```swift
import SwiftUI
import BootstrapUI

struct DashboardView: View {
    @State private var selectedTab = 0

    @Environment(\.theme) private var theme

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: theme.lg) {
                    // Stats row
                    HStack(spacing: theme.md) {
                        StatCard(title: "Users", value: "1,234", icon: "person.fill", trend: "+12%")
                        StatCard(title: "Revenue", value: "$45.2K", icon: "dollarsign.circle.fill", trend: "+8%")
                    }

                    // Chart card
                    BSCollapsibleCard(title: "Analytics", icon: "chart.bar.fill") {
                        BSBarChart(data: chartData)
                            .frame(height: 200)
                    }

                    // Recent activity
                    BSCollapsibleCard(title: "Recent Activity", icon: "clock.fill", badge: "3") {
                        BSActivityTimeline(activities: activities)
                    }

                    // Quick actions
                    BSCard {
                        VStack(alignment: .leading, spacing: theme.md) {
                            BSText("Quick Actions", style: .headline)

                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: theme.md) {
                                QuickActionButton(title: "Add User", icon: "person.badge.plus")
                                QuickActionButton(title: "Reports", icon: "doc.text.fill")
                                QuickActionButton(title: "Settings", icon: "gear")
                                QuickActionButton(title: "Help", icon: "questionmark.circle")
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Dashboard")
        }
    }
}
```

## Available Dashboard Components

### Stat Cards
```swift
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let trend: String?

    var body: some View {
        BSCard {
            VStack(alignment: .leading, spacing: theme.sm) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(theme.primary)
                    Spacer()
                    if let trend = trend {
                        BSBadge(trend, color: trend.hasPrefix("+") ? .success : .error)
                    }
                }

                BSText(value, style: .title1, weight: .bold)
                BSText(title, style: .caption1, color: .secondary)
            }
        }
    }
}
```

### Charts
```swift
// Bar Chart
BSBarChart(data: [
    .init(label: "Jan", value: 120),
    .init(label: "Feb", value: 180),
    .init(label: "Mar", value: 150)
])

// Line Chart
BSLineChart(data: [
    .init(x: 0, y: 10),
    .init(x: 1, y: 25),
    .init(x: 2, y: 18)
])

// Pie Chart
BSPieChart(slices: [
    .init(value: 35, label: "iOS", color: .blue),
    .init(value: 25, label: "Android", color: .green),
    .init(value: 40, label: "Web", color: .orange)
])

// Progress Ring
BSProgressRing(progress: 0.75, label: "75%")
```

### Activity Timeline
```swift
BSActivityTimeline(activities: [
    .init(
        title: "New user registered",
        subtitle: "john@example.com",
        time: "2 min ago",
        icon: "person.badge.plus",
        iconColor: .green
    ),
    .init(
        title: "Payment received",
        subtitle: "$99.00",
        time: "1 hour ago",
        icon: "creditcard.fill",
        iconColor: .blue
    )
])
```

### Collapsible Sections
```swift
BSCollapsibleCard(title: "Section Title", icon: "folder.fill", badge: "New") {
    // Content
}

BSExpandableSection(title: "Advanced", subtitle: "Additional options") {
    // Expandable content
}
```

### Quick Action Grid
```swift
struct QuickActionButton: View {
    let title: String
    let icon: String

    var body: some View {
        BSButton(title, style: .outline, icon: icon, isFullWidth: true) {
            // Action
        }
    }
}
```

## Dashboard with Tabs

```swift
struct TabbedDashboardView: View {
    @State private var selectedTab = 0

    var body: some View {
        VStack(spacing: 0) {
            BSSegmentedControl(
                selection: $selectedTab,
                options: ["Overview", "Analytics", "Reports"],
                style: .underlined
            )

            TabView(selection: $selectedTab) {
                OverviewTab().tag(0)
                AnalyticsTab().tag(1)
                ReportsTab().tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}
```

## KPI Dashboard Pattern

```swift
struct KPIDashboard: View {
    var body: some View {
        ScrollView {
            VStack(spacing: theme.lg) {
                // Primary KPIs
                HStack(spacing: theme.md) {
                    KPICard(title: "Total Sales", value: "$125,430", change: .up(12.5))
                    KPICard(title: "Orders", value: "1,842", change: .up(8.2))
                }

                HStack(spacing: theme.md) {
                    KPICard(title: "Avg Order", value: "$68.12", change: .down(2.1))
                    KPICard(title: "Customers", value: "3,291", change: .up(15.3))
                }

                // Trend chart
                BSCard {
                    VStack(alignment: .leading) {
                        BSText("Revenue Trend", style: .headline)
                        BSLineChart(data: revenueData)
                            .frame(height: 200)
                    }
                }
            }
            .padding()
        }
    }
}
```

Generate the dashboard based on the user's requirements using these patterns.
