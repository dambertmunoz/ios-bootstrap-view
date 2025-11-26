// BSText.swift
// BootstrapUI
//
// Typography component with predefined styles
// Follows Single Responsibility Principle - handles text presentation only

import SwiftUI

// MARK: - Text Style Enum

/// Available text styles mapped to typography tokens
public enum BSTextStyle: String, CaseIterable, Sendable {
    case largeTitle
    case title1
    case title2
    case title3
    case headline
    case body
    case callout
    case subheadline
    case footnote
    case caption1
    case caption2
}

// MARK: - Text Weight Enum

/// Available text weights
public enum BSTextWeight: String, CaseIterable, Sendable {
    case regular
    case medium
    case semibold
    case bold

    var fontWeight: Font.Weight {
        switch self {
        case .regular: return .regular
        case .medium: return .medium
        case .semibold: return .semibold
        case .bold: return .bold
        }
    }
}

// MARK: - Text Component

/// A styled text component following design system typography
///
/// Example usage:
/// ```swift
/// BSText("Hello World", style: .headline)
/// BSText("Subtitle", style: .subheadline, color: .secondary)
/// BSText("Bold Text", style: .body, weight: .bold)
/// ```
public struct BSText: View {

    // MARK: - Properties

    private let text: String
    private let style: BSTextStyle
    private let weight: BSTextWeight?
    private let color: BSTextColor
    private let alignment: TextAlignment
    private let lineLimit: Int?
    private let isSelectable: Bool

    @Environment(\.theme) private var theme

    // MARK: - Text Color

    public enum BSTextColor {
        case primary
        case secondary
        case tertiary
        case disabled
        case error
        case success
        case warning
        case custom(Color)

        func color(for theme: Theme) -> Color {
            switch self {
            case .primary: return theme.onBackground
            case .secondary: return theme.onSurface.opacity(0.7)
            case .tertiary: return theme.onSurface.opacity(0.5)
            case .disabled: return theme.disabled
            case .error: return theme.error
            case .success: return theme.success
            case .warning: return theme.warning
            case .custom(let color): return color
            }
        }
    }

    // MARK: - Initialization

    /// Creates a styled text view
    /// - Parameters:
    ///   - text: The text content
    ///   - style: Typography style (default: .body)
    ///   - weight: Optional font weight override
    ///   - color: Text color (default: .primary)
    ///   - alignment: Text alignment (default: .leading)
    ///   - lineLimit: Maximum number of lines (nil for unlimited)
    ///   - isSelectable: Whether text can be selected (default: false)
    public init(
        _ text: String,
        style: BSTextStyle = .body,
        weight: BSTextWeight? = nil,
        color: BSTextColor = .primary,
        alignment: TextAlignment = .leading,
        lineLimit: Int? = nil,
        isSelectable: Bool = false
    ) {
        self.text = text
        self.style = style
        self.weight = weight
        self.color = color
        self.alignment = alignment
        self.lineLimit = lineLimit
        self.isSelectable = isSelectable
    }

    // MARK: - Body

    public var body: some View {
        Text(text)
            .font(font)
            .fontWeight(weight?.fontWeight)
            .foregroundColor(color.color(for: theme))
            .multilineTextAlignment(alignment)
            .lineLimit(lineLimit)
            .textSelection(isSelectable ? .enabled : .disabled)
    }

    // MARK: - Computed Properties

    private var font: Font {
        switch style {
        case .largeTitle: return theme.largeTitle
        case .title1: return theme.title1
        case .title2: return theme.title2
        case .title3: return theme.title3
        case .headline: return theme.headline
        case .body: return theme.body
        case .callout: return theme.callout
        case .subheadline: return theme.subheadline
        case .footnote: return theme.footnote
        case .caption1: return theme.caption1
        case .caption2: return theme.caption2
        }
    }
}

// MARK: - Attributed Text Component

/// A component for displaying attributed text with multiple styles
public struct BSAttributedText: View {
    private let segments: [TextSegment]

    @Environment(\.theme) private var theme

    public struct TextSegment: Identifiable {
        public let id = UUID()
        public let text: String
        public let style: BSTextStyle
        public let weight: BSTextWeight?
        public let color: BSText.BSTextColor

        public init(
            _ text: String,
            style: BSTextStyle = .body,
            weight: BSTextWeight? = nil,
            color: BSText.BSTextColor = .primary
        ) {
            self.text = text
            self.style = style
            self.weight = weight
            self.color = color
        }
    }

    public init(segments: [TextSegment]) {
        self.segments = segments
    }

    public var body: some View {
        segments.reduce(Text("")) { result, segment in
            result + Text(segment.text)
                .font(font(for: segment.style))
                .fontWeight(segment.weight?.fontWeight)
                .foregroundColor(segment.color.color(for: theme))
        }
    }

    private func font(for style: BSTextStyle) -> Font {
        switch style {
        case .largeTitle: return theme.largeTitle
        case .title1: return theme.title1
        case .title2: return theme.title2
        case .title3: return theme.title3
        case .headline: return theme.headline
        case .body: return theme.body
        case .callout: return theme.callout
        case .subheadline: return theme.subheadline
        case .footnote: return theme.footnote
        case .caption1: return theme.caption1
        case .caption2: return theme.caption2
        }
    }
}

// MARK: - Label Component

/// A label component with icon and text
public struct BSLabel: View {
    private let text: String
    private let icon: String?
    private let style: BSTextStyle
    private let color: BSText.BSTextColor

    @Environment(\.theme) private var theme

    public init(
        _ text: String,
        icon: String? = nil,
        style: BSTextStyle = .body,
        color: BSText.BSTextColor = .primary
    ) {
        self.text = text
        self.icon = icon
        self.style = style
        self.color = color
    }

    public var body: some View {
        HStack(spacing: theme.xs) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: iconSize))
            }
            Text(text)
        }
        .font(font)
        .foregroundColor(color.color(for: theme))
    }

    private var font: Font {
        switch style {
        case .largeTitle: return theme.largeTitle
        case .title1: return theme.title1
        case .title2: return theme.title2
        case .title3: return theme.title3
        case .headline: return theme.headline
        case .body: return theme.body
        case .callout: return theme.callout
        case .subheadline: return theme.subheadline
        case .footnote: return theme.footnote
        case .caption1: return theme.caption1
        case .caption2: return theme.caption2
        }
    }

    private var iconSize: CGFloat {
        switch style {
        case .largeTitle: return 28
        case .title1: return 24
        case .title2: return 22
        case .title3: return 20
        case .headline: return 18
        case .body: return 16
        case .callout: return 15
        case .subheadline: return 14
        case .footnote: return 12
        case .caption1: return 11
        case .caption2: return 10
        }
    }
}

// MARK: - Preview

#if DEBUG
struct BSText_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 8) {
            BSText("Large Title", style: .largeTitle)
            BSText("Title 1", style: .title1)
            BSText("Title 2", style: .title2)
            BSText("Title 3", style: .title3)
            BSText("Headline", style: .headline)
            BSText("Body text goes here", style: .body)
            BSText("Callout text", style: .callout)
            BSText("Subheadline", style: .subheadline)
            BSText("Footnote", style: .footnote)
            BSText("Caption 1", style: .caption1)
            BSText("Caption 2", style: .caption2)

            Divider()

            BSText("Error Text", style: .body, color: .error)
            BSText("Success Text", style: .body, color: .success)
            BSLabel("Label with icon", icon: "star.fill")
        }
        .padding()
        .withTheme()
    }
}
#endif
