// BSAccordion.swift
// BootstrapUI
//
// Expandable/collapsible accordion components
// Supports single and multiple expansion modes

import SwiftUI

// MARK: - BSAccordion

/// An accordion container for expandable sections
public struct BSAccordion<Item: Identifiable, Header: View, Content: View>: View {

    private let items: [Item]
    private let allowMultiple: Bool
    private let header: (Item, Bool) -> Header
    private let content: (Item) -> Content

    @State private var expandedItems: Set<Item.ID> = []

    @Environment(\.theme) private var theme

    public init(
        items: [Item],
        allowMultiple: Bool = false,
        @ViewBuilder header: @escaping (Item, Bool) -> Header,
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.items = items
        self.allowMultiple = allowMultiple
        self.header = header
        self.content = content
    }

    public var body: some View {
        VStack(spacing: 0) {
            ForEach(items) { item in
                accordionItem(item)

                if item.id != items.last?.id {
                    BSDivider()
                }
            }
        }
        .background(theme.surface)
        .cornerRadius(theme.radiusMd)
        .overlay(
            RoundedRectangle(cornerRadius: theme.radiusMd)
                .stroke(theme.border, lineWidth: 1)
        )
    }

    private func accordionItem(_ item: Item) -> some View {
        let isExpanded = expandedItems.contains(item.id)

        return VStack(spacing: 0) {
            // Header button
            Button {
                toggleItem(item)
            } label: {
                header(item, isExpanded)
            }
            .buttonStyle(.plain)

            // Expandable content
            if isExpanded {
                BSDivider()

                content(item)
                    .padding(theme.md)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isExpanded)
    }

    private func toggleItem(_ item: Item) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            if expandedItems.contains(item.id) {
                expandedItems.remove(item.id)
            } else {
                if !allowMultiple {
                    expandedItems.removeAll()
                }
                expandedItems.insert(item.id)
            }
        }
    }
}

// MARK: - BSAccordionHeader

/// A pre-styled accordion header
public struct BSAccordionHeader: View {

    private let title: String
    private let subtitle: String?
    private let icon: String?
    private let isExpanded: Bool

    @Environment(\.theme) private var theme

    public init(
        title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        isExpanded: Bool
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.isExpanded = isExpanded
    }

    public var body: some View {
        HStack(spacing: theme.md) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(theme.primary)
                    .frame(width: 24)
            }

            VStack(alignment: .leading, spacing: theme.xxs) {
                BSText(title, style: .headline)

                if let subtitle = subtitle {
                    BSText(subtitle, style: .caption1, color: .secondary)
                }
            }

            Spacer()

            Image(systemName: "chevron.down")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(theme.placeholder)
                .rotationEffect(.degrees(isExpanded ? 180 : 0))
        }
        .padding(theme.md)
        .contentShape(Rectangle())
    }
}

// MARK: - BSExpandableSection

/// A simple expandable section
public struct BSExpandableSection<Content: View>: View {

    private let title: String
    private let subtitle: String?
    private let icon: String?
    private let initiallyExpanded: Bool
    private let content: () -> Content

    @State private var isExpanded: Bool

    @Environment(\.theme) private var theme

    public init(
        title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        initiallyExpanded: Bool = false,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.initiallyExpanded = initiallyExpanded
        self.content = content
        self._isExpanded = State(initialValue: initiallyExpanded)
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Header
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: theme.md) {
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(.system(size: 18))
                            .foregroundColor(theme.primary)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        BSText(title, style: .headline)

                        if let subtitle = subtitle {
                            BSText(subtitle, style: .caption1, color: .secondary)
                        }
                    }

                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(theme.placeholder)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(theme.md)
                .background(theme.surface)
                .cornerRadius(isExpanded ? 0 : theme.radiusMd)
            }
            .buttonStyle(.plain)

            // Content
            if isExpanded {
                content()
                    .padding(theme.md)
                    .background(theme.background)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(theme.surface)
        .cornerRadius(theme.radiusMd)
        .overlay(
            RoundedRectangle(cornerRadius: theme.radiusMd)
                .stroke(theme.border, lineWidth: 1)
        )
    }
}

// MARK: - BSCollapsibleCard

/// A card that can be collapsed
public struct BSCollapsibleCard<Content: View>: View {

    private let title: String
    private let icon: String?
    private let badge: String?
    private let isCollapsible: Bool
    private let content: () -> Content

    @State private var isExpanded = true

    @Environment(\.theme) private var theme

    public init(
        title: String,
        icon: String? = nil,
        badge: String? = nil,
        isCollapsible: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.icon = icon
        self.badge = badge
        self.isCollapsible = isCollapsible
        self.content = content
    }

    public var body: some View {
        BSCard {
            VStack(spacing: 0) {
                // Header
                HStack(spacing: theme.sm) {
                    if let icon = icon {
                        Image(systemName: icon)
                            .foregroundColor(theme.primary)
                    }

                    BSText(title, style: .headline)

                    if let badge = badge {
                        BSBadge(badge, size: .small, color: .primary)
                    }

                    Spacer()

                    if isCollapsible {
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                isExpanded.toggle()
                            }
                        } label: {
                            Image(systemName: "chevron.down")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(theme.placeholder)
                                .rotationEffect(.degrees(isExpanded ? 0 : -90))
                        }
                    }
                }

                // Content
                if isExpanded {
                    BSDivider()
                        .padding(.vertical, theme.sm)

                    content()
                }
            }
        }
    }
}

// MARK: - BSFAQAccordion

/// An FAQ-style accordion
public struct BSFAQAccordion: View {

    private let faqs: [FAQ]

    @State private var expandedIndex: Int?

    @Environment(\.theme) private var theme

    public struct FAQ: Identifiable {
        public let id = UUID()
        public let question: String
        public let answer: String

        public init(question: String, answer: String) {
            self.question = question
            self.answer = answer
        }
    }

    public init(faqs: [FAQ]) {
        self.faqs = faqs
    }

    public var body: some View {
        VStack(spacing: theme.sm) {
            ForEach(Array(faqs.enumerated()), id: \.element.id) { index, faq in
                faqItem(faq, index: index)
            }
        }
    }

    private func faqItem(_ faq: FAQ, index: Int) -> some View {
        let isExpanded = expandedIndex == index

        return VStack(spacing: 0) {
            // Question
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    expandedIndex = isExpanded ? nil : index
                }
            } label: {
                HStack(alignment: .top, spacing: theme.md) {
                    BSText("Q", style: .headline, weight: .bold)
                        .foregroundColor(theme.primary)
                        .frame(width: 24)

                    BSText(faq.question, style: .body, weight: .medium)
                        .multilineTextAlignment(.leading)

                    Spacer()

                    Image(systemName: isExpanded ? "minus" : "plus")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(theme.primary)
                }
                .padding(theme.md)
            }
            .buttonStyle(.plain)

            // Answer
            if isExpanded {
                HStack(alignment: .top, spacing: theme.md) {
                    BSText("A", style: .headline, weight: .bold)
                        .foregroundColor(theme.success)
                        .frame(width: 24)

                    BSText(faq.answer, style: .body, color: .secondary)
                        .multilineTextAlignment(.leading)

                    Spacer()
                }
                .padding(.horizontal, theme.md)
                .padding(.bottom, theme.md)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(theme.surface)
        .cornerRadius(theme.radiusMd)
        .overlay(
            RoundedRectangle(cornerRadius: theme.radiusMd)
                .stroke(isExpanded ? theme.primary : theme.border, lineWidth: 1)
        )
    }
}

// MARK: - Preview

#if DEBUG
struct BSAccordion_Previews: PreviewProvider {
    struct Section: Identifiable {
        let id = UUID()
        let title: String
        let content: String
    }

    static var previews: some View {
        ScrollView {
            VStack(spacing: 24) {
                BSExpandableSection(title: "Section 1", icon: "star.fill") {
                    BSText("This is the content of section 1")
                }

                BSFAQAccordion(faqs: [
                    .init(question: "What is BootstrapUI?", answer: "BootstrapUI is a comprehensive SwiftUI component library following Atomic Design principles."),
                    .init(question: "Is it free to use?", answer: "Yes, BootstrapUI is open source and free to use in your projects."),
                    .init(question: "How do I get started?", answer: "Simply add BootstrapUI as a Swift Package dependency and import it in your project.")
                ])

                BSCollapsibleCard(title: "Card Title", icon: "folder.fill", badge: "New") {
                    BSText("Card content goes here")
                }
            }
            .padding()
        }
        .withTheme()
    }
}
#endif
