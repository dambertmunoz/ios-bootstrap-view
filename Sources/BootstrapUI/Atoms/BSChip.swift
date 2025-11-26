// BSChip.swift
// BootstrapUI
//
// Chip/Tag components for selection and filtering
// Commonly used for categories, filters, and selections

import SwiftUI

// MARK: - Chip Style

/// Available chip visual styles
public enum BSChipStyle: String, CaseIterable, Sendable {
    case filled
    case outlined
    case soft
}

// MARK: - Chip Size

/// Available chip sizes
public enum BSChipSize: String, CaseIterable, Sendable {
    case small
    case medium
    case large

    var verticalPadding: CGFloat {
        switch self {
        case .small: return 4
        case .medium: return 6
        case .large: return 8
        }
    }

    var horizontalPadding: CGFloat {
        switch self {
        case .small: return 8
        case .medium: return 12
        case .large: return 16
        }
    }

    var font: Font {
        switch self {
        case .small: return .caption
        case .medium: return .subheadline
        case .large: return .body
        }
    }

    var iconSize: CGFloat {
        switch self {
        case .small: return 12
        case .medium: return 14
        case .large: return 16
        }
    }
}

// MARK: - Chip Component

/// A chip/tag component for displaying compact information
///
/// Example usage:
/// ```swift
/// BSChip("SwiftUI")
///
/// BSChip("iOS", style: .outlined, icon: "apple.logo")
///
/// BSChip("Removable", onDelete: { print("Deleted") })
/// ```
public struct BSChip: View {

    // MARK: - Properties

    private let label: String
    private let style: BSChipStyle
    private let size: BSChipSize
    private let icon: String?
    private let color: Color?
    private let isSelected: Bool
    private let isDisabled: Bool
    private let onTap: (() -> Void)?
    private let onDelete: (() -> Void)?

    @Environment(\.theme) private var theme

    // MARK: - Initialization

    public init(
        _ label: String,
        style: BSChipStyle = .soft,
        size: BSChipSize = .medium,
        icon: String? = nil,
        color: Color? = nil,
        isSelected: Bool = false,
        isDisabled: Bool = false,
        onTap: (() -> Void)? = nil,
        onDelete: (() -> Void)? = nil
    ) {
        self.label = label
        self.style = style
        self.size = size
        self.icon = icon
        self.color = color
        self.isSelected = isSelected
        self.isDisabled = isDisabled
        self.onTap = onTap
        self.onDelete = onDelete
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: size == .small ? 4 : 6) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: size.iconSize))
            }

            Text(label)
                .font(size.font)
                .fontWeight(.medium)

            if onDelete != nil {
                Button(action: { onDelete?() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: size.iconSize - 2, weight: .bold))
                }
            }
        }
        .padding(.vertical, size.verticalPadding)
        .padding(.horizontal, size.horizontalPadding)
        .foregroundColor(foregroundColor)
        .background(backgroundColor)
        .overlay(borderOverlay)
        .clipShape(Capsule())
        .opacity(isDisabled ? 0.5 : 1)
        .contentShape(Capsule())
        .onTapGesture {
            if !isDisabled {
                onTap?()
            }
        }
    }

    // MARK: - Computed Properties

    private var effectiveColor: Color {
        color ?? theme.primary
    }

    private var foregroundColor: Color {
        switch style {
        case .filled:
            return isSelected ? .white : effectiveColor
        case .outlined:
            return isSelected ? .white : effectiveColor
        case .soft:
            return isSelected ? .white : effectiveColor
        }
    }

    private var backgroundColor: Color {
        switch style {
        case .filled:
            return isSelected ? effectiveColor : effectiveColor.opacity(0.1)
        case .outlined:
            return isSelected ? effectiveColor : .clear
        case .soft:
            return isSelected ? effectiveColor : effectiveColor.opacity(0.15)
        }
    }

    @ViewBuilder
    private var borderOverlay: some View {
        if style == .outlined {
            Capsule()
                .stroke(effectiveColor, lineWidth: 1)
        }
    }
}

// MARK: - Selectable Chip

/// A chip that can be selected/deselected
public struct BSSelectableChip: View {

    private let label: String
    @Binding private var isSelected: Bool
    private let style: BSChipStyle
    private let size: BSChipSize
    private let icon: String?
    private let selectedIcon: String?
    private let color: Color?

    @Environment(\.theme) private var theme

    public init(
        _ label: String,
        isSelected: Binding<Bool>,
        style: BSChipStyle = .soft,
        size: BSChipSize = .medium,
        icon: String? = nil,
        selectedIcon: String? = "checkmark",
        color: Color? = nil
    ) {
        self.label = label
        self._isSelected = isSelected
        self.style = style
        self.size = size
        self.icon = icon
        self.selectedIcon = selectedIcon
        self.color = color
    }

    public var body: some View {
        BSChip(
            label,
            style: style,
            size: size,
            icon: isSelected ? selectedIcon : icon,
            color: color,
            isSelected: isSelected,
            onTap: { isSelected.toggle() }
        )
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

// MARK: - Chip Group (Single Selection)

/// A group of chips with single selection
public struct BSChipGroup<Item: Hashable>: View {

    private let items: [Item]
    @Binding private var selection: Item?
    private let style: BSChipStyle
    private let size: BSChipSize
    private let itemLabel: (Item) -> String
    private let itemIcon: ((Item) -> String?)?
    private let itemColor: ((Item) -> Color?)?

    @Environment(\.theme) private var theme

    public init(
        items: [Item],
        selection: Binding<Item?>,
        style: BSChipStyle = .soft,
        size: BSChipSize = .medium,
        itemLabel: @escaping (Item) -> String,
        itemIcon: ((Item) -> String?)? = nil,
        itemColor: ((Item) -> Color?)? = nil
    ) {
        self.items = items
        self._selection = selection
        self.style = style
        self.size = size
        self.itemLabel = itemLabel
        self.itemIcon = itemIcon
        self.itemColor = itemColor
    }

    public var body: some View {
        FlowLayout(spacing: theme.sm) {
            ForEach(items, id: \.self) { item in
                BSChip(
                    itemLabel(item),
                    style: style,
                    size: size,
                    icon: itemIcon?(item),
                    color: itemColor?(item),
                    isSelected: selection == item,
                    onTap: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selection = selection == item ? nil : item
                        }
                    }
                )
            }
        }
    }
}

// MARK: - Chip Group (Multiple Selection)

/// A group of chips with multiple selection
public struct BSMultiChipGroup<Item: Hashable>: View {

    private let items: [Item]
    @Binding private var selection: Set<Item>
    private let style: BSChipStyle
    private let size: BSChipSize
    private let itemLabel: (Item) -> String
    private let itemIcon: ((Item) -> String?)?

    @Environment(\.theme) private var theme

    public init(
        items: [Item],
        selection: Binding<Set<Item>>,
        style: BSChipStyle = .soft,
        size: BSChipSize = .medium,
        itemLabel: @escaping (Item) -> String,
        itemIcon: ((Item) -> String?)? = nil
    ) {
        self.items = items
        self._selection = selection
        self.style = style
        self.size = size
        self.itemLabel = itemLabel
        self.itemIcon = itemIcon
    }

    public var body: some View {
        FlowLayout(spacing: theme.sm) {
            ForEach(items, id: \.self) { item in
                BSChip(
                    itemLabel(item),
                    style: style,
                    size: size,
                    icon: itemIcon?(item),
                    isSelected: selection.contains(item),
                    onTap: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            if selection.contains(item) {
                                selection.remove(item)
                            } else {
                                selection.insert(item)
                            }
                        }
                    }
                )
            }
        }
    }
}

// MARK: - Input Chip (with delete)

/// An input chip that can be deleted
public struct BSInputChip: View {

    private let label: String
    private let icon: String?
    private let onDelete: () -> Void

    @Environment(\.theme) private var theme

    public init(
        _ label: String,
        icon: String? = nil,
        onDelete: @escaping () -> Void
    ) {
        self.label = label
        self.icon = icon
        self.onDelete = onDelete
    }

    public var body: some View {
        BSChip(
            label,
            style: .outlined,
            icon: icon,
            onDelete: onDelete
        )
    }
}

// MARK: - Flow Layout

/// A layout that wraps content to new lines
public struct FlowLayout: Layout {
    var spacing: CGFloat

    public init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )

        for (index, subview) in subviews.enumerated() {
            let point = result.positions[index]
            subview.place(
                at: CGPoint(x: bounds.minX + point.x, y: bounds.minY + point.y),
                proposal: .unspecified
            )
        }
    }

    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var rowHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)

                if x + size.width > maxWidth && x > 0 {
                    x = 0
                    y += rowHeight + spacing
                    rowHeight = 0
                }

                positions.append(CGPoint(x: x, y: y))
                rowHeight = max(rowHeight, size.height)
                x += size.width + spacing
            }

            self.size = CGSize(
                width: maxWidth,
                height: y + rowHeight
            )
        }
    }
}

// MARK: - Preview

#if DEBUG
struct BSChip_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Basic chips
                Text("Basic Chips").font(.headline)
                HStack(spacing: 8) {
                    BSChip("Default")
                    BSChip("Filled", style: .filled)
                    BSChip("Outlined", style: .outlined)
                }

                // With icons
                Text("With Icons").font(.headline)
                HStack(spacing: 8) {
                    BSChip("Swift", icon: "swift")
                    BSChip("iOS", icon: "iphone")
                    BSChip("macOS", icon: "laptopcomputer")
                }

                // Deletable
                Text("Deletable").font(.headline)
                HStack(spacing: 8) {
                    BSInputChip("Tag 1") {}
                    BSInputChip("Tag 2", icon: "tag") {}
                }

                // Sizes
                Text("Sizes").font(.headline)
                HStack(spacing: 8) {
                    BSChip("Small", size: .small)
                    BSChip("Medium", size: .medium)
                    BSChip("Large", size: .large)
                }

                // Colors
                Text("Colors").font(.headline)
                HStack(spacing: 8) {
                    BSChip("Success", color: .green, isSelected: true)
                    BSChip("Warning", color: .orange, isSelected: true)
                    BSChip("Error", color: .red, isSelected: true)
                }

                // Chip group
                Text("Chip Group").font(.headline)
                BSChipGroup(
                    items: ["All", "iOS", "macOS", "watchOS", "tvOS"],
                    selection: .constant("iOS"),
                    itemLabel: { $0 }
                )
            }
            .padding()
        }
        .withTheme()
    }
}
#endif
