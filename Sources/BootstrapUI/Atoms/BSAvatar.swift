// BSAvatar.swift
// BootstrapUI
//
// Avatar and profile image components
// Follows Single Responsibility Principle - handles avatar presentation

import SwiftUI

// MARK: - Avatar Size

/// Available avatar sizes
public enum BSAvatarSize: String, CaseIterable, Sendable {
    case xs
    case sm
    case md
    case lg
    case xl
    case xxl

    var dimension: CGFloat {
        switch self {
        case .xs: return 24
        case .sm: return 32
        case .md: return 40
        case .lg: return 56
        case .xl: return 80
        case .xxl: return 120
        }
    }

    var fontSize: CGFloat {
        switch self {
        case .xs: return 10
        case .sm: return 12
        case .md: return 16
        case .lg: return 22
        case .xl: return 32
        case .xxl: return 48
        }
    }

    var badgeSize: CGFloat {
        switch self {
        case .xs: return 8
        case .sm: return 10
        case .md: return 12
        case .lg: return 16
        case .xl: return 20
        case .xxl: return 24
        }
    }
}

// MARK: - Avatar Shape

/// Available avatar shapes
public enum BSAvatarShape: String, CaseIterable, Sendable {
    case circle
    case rounded
    case square
}

// MARK: - Avatar Component

/// A versatile avatar component for displaying user images or initials
///
/// Example usage:
/// ```swift
/// // With image
/// BSAvatar(imageURL: URL(string: "https://example.com/photo.jpg"))
///
/// // With initials
/// BSAvatar(initials: "JD")
///
/// // With system icon
/// BSAvatar(icon: "person.fill")
///
/// // With status
/// BSAvatar(initials: "AB", status: .online)
/// ```
public struct BSAvatar: View {

    // MARK: - Status

    public enum Status: String, CaseIterable {
        case online
        case offline
        case busy
        case away

        var color: Color {
            switch self {
            case .online: return .green
            case .offline: return .gray
            case .busy: return .red
            case .away: return .orange
            }
        }
    }

    // MARK: - Properties

    private let imageURL: URL?
    private let image: Image?
    private let initials: String?
    private let icon: String?
    private let size: BSAvatarSize
    private let shape: BSAvatarShape
    private let backgroundColor: Color?
    private let foregroundColor: Color?
    private let status: Status?
    private let hasBorder: Bool
    private let borderColor: Color?
    private let onTap: (() -> Void)?

    @Environment(\.theme) private var theme

    // MARK: - Initialization

    /// Creates an avatar with a remote image URL
    public init(
        imageURL: URL?,
        size: BSAvatarSize = .md,
        shape: BSAvatarShape = .circle,
        status: Status? = nil,
        hasBorder: Bool = false,
        borderColor: Color? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.imageURL = imageURL
        self.image = nil
        self.initials = nil
        self.icon = nil
        self.size = size
        self.shape = shape
        self.backgroundColor = nil
        self.foregroundColor = nil
        self.status = status
        self.hasBorder = hasBorder
        self.borderColor = borderColor
        self.onTap = onTap
    }

    /// Creates an avatar with a local image
    public init(
        image: Image,
        size: BSAvatarSize = .md,
        shape: BSAvatarShape = .circle,
        status: Status? = nil,
        hasBorder: Bool = false,
        borderColor: Color? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.imageURL = nil
        self.image = image
        self.initials = nil
        self.icon = nil
        self.size = size
        self.shape = shape
        self.backgroundColor = nil
        self.foregroundColor = nil
        self.status = status
        self.hasBorder = hasBorder
        self.borderColor = borderColor
        self.onTap = onTap
    }

    /// Creates an avatar with initials
    public init(
        initials: String,
        size: BSAvatarSize = .md,
        shape: BSAvatarShape = .circle,
        backgroundColor: Color? = nil,
        foregroundColor: Color? = nil,
        status: Status? = nil,
        hasBorder: Bool = false,
        borderColor: Color? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.imageURL = nil
        self.image = nil
        self.initials = String(initials.prefix(2)).uppercased()
        self.icon = nil
        self.size = size
        self.shape = shape
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.status = status
        self.hasBorder = hasBorder
        self.borderColor = borderColor
        self.onTap = onTap
    }

    /// Creates an avatar with a system icon
    public init(
        icon: String,
        size: BSAvatarSize = .md,
        shape: BSAvatarShape = .circle,
        backgroundColor: Color? = nil,
        foregroundColor: Color? = nil,
        status: Status? = nil,
        hasBorder: Bool = false,
        borderColor: Color? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.imageURL = nil
        self.image = nil
        self.initials = nil
        self.icon = icon
        self.size = size
        self.shape = shape
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.status = status
        self.hasBorder = hasBorder
        self.borderColor = borderColor
        self.onTap = onTap
    }

    // MARK: - Body

    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            avatarContent
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(avatarShape)
                .overlay(borderOverlay)

            if let status = status {
                statusIndicator(status)
            }
        }
        .onTapGesture {
            onTap?()
        }
    }

    // MARK: - Private Views

    @ViewBuilder
    private var avatarContent: some View {
        if let imageURL = imageURL {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    placeholderView
                case .empty:
                    ProgressView()
                        .frame(width: size.dimension, height: size.dimension)
                @unknown default:
                    placeholderView
                }
            }
        } else if let image = image {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else if let initials = initials {
            initialsView(initials)
        } else if let icon = icon {
            iconView(icon)
        } else {
            placeholderView
        }
    }

    private func initialsView(_ initials: String) -> some View {
        Text(initials)
            .font(.system(size: size.fontSize, weight: .semibold))
            .foregroundColor(foregroundColor ?? theme.onPrimary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgroundColor ?? theme.primary)
    }

    private func iconView(_ icon: String) -> some View {
        Image(systemName: icon)
            .font(.system(size: size.fontSize))
            .foregroundColor(foregroundColor ?? theme.onPrimary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgroundColor ?? theme.surface)
    }

    private var placeholderView: some View {
        Image(systemName: "person.fill")
            .font(.system(size: size.fontSize))
            .foregroundColor(theme.placeholder)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(theme.surface)
    }

    private func statusIndicator(_ status: Status) -> some View {
        Circle()
            .fill(status.color)
            .frame(width: size.badgeSize, height: size.badgeSize)
            .overlay(
                Circle()
                    .stroke(theme.background, lineWidth: 2)
            )
            .offset(x: statusOffset, y: statusOffset)
    }

    @ViewBuilder
    private var borderOverlay: some View {
        if hasBorder {
            avatarShape
                .stroke(borderColor ?? theme.border, lineWidth: 2)
        }
    }

    // MARK: - Computed Properties

    private var avatarShape: some Shape {
        switch shape {
        case .circle:
            return AnyShape(Circle())
        case .rounded:
            return AnyShape(RoundedRectangle(cornerRadius: theme.radiusMd))
        case .square:
            return AnyShape(Rectangle())
        }
    }

    private var statusOffset: CGFloat {
        switch shape {
        case .circle:
            return size.dimension * 0.05
        case .rounded, .square:
            return 0
        }
    }
}

// MARK: - AnyShape Helper

struct AnyShape: Shape {
    private let pathBuilder: (CGRect) -> Path

    init<S: Shape>(_ shape: S) {
        pathBuilder = { rect in
            shape.path(in: rect)
        }
    }

    func path(in rect: CGRect) -> Path {
        pathBuilder(rect)
    }
}

// MARK: - Avatar Group

/// A component for displaying a group of avatars with overlap
public struct BSAvatarGroup: View {

    private let avatars: [AvatarData]
    private let size: BSAvatarSize
    private let maxVisible: Int
    private let overlapRatio: CGFloat

    @Environment(\.theme) private var theme

    public struct AvatarData: Identifiable {
        public let id = UUID()
        public let imageURL: URL?
        public let initials: String?

        public init(imageURL: URL? = nil, initials: String? = nil) {
            self.imageURL = imageURL
            self.initials = initials
        }
    }

    public init(
        avatars: [AvatarData],
        size: BSAvatarSize = .md,
        maxVisible: Int = 4,
        overlapRatio: CGFloat = 0.3
    ) {
        self.avatars = avatars
        self.size = size
        self.maxVisible = maxVisible
        self.overlapRatio = overlapRatio
    }

    public var body: some View {
        HStack(spacing: -size.dimension * overlapRatio) {
            ForEach(Array(visibleAvatars.enumerated()), id: \.element.id) { index, avatar in
                Group {
                    if let url = avatar.imageURL {
                        BSAvatar(imageURL: url, size: size, hasBorder: true, borderColor: theme.background)
                    } else if let initials = avatar.initials {
                        BSAvatar(initials: initials, size: size, hasBorder: true, borderColor: theme.background)
                    } else {
                        BSAvatar(icon: "person.fill", size: size, hasBorder: true, borderColor: theme.background)
                    }
                }
                .zIndex(Double(visibleAvatars.count - index))
            }

            if remainingCount > 0 {
                BSAvatar(
                    initials: "+\(remainingCount)",
                    size: size,
                    backgroundColor: theme.surface,
                    foregroundColor: theme.onSurface,
                    hasBorder: true,
                    borderColor: theme.background
                )
            }
        }
    }

    private var visibleAvatars: [AvatarData] {
        Array(avatars.prefix(maxVisible))
    }

    private var remainingCount: Int {
        max(0, avatars.count - maxVisible)
    }
}

// MARK: - Preview

#if DEBUG
struct BSAvatar_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 24) {
            HStack(spacing: 16) {
                BSAvatar(initials: "JD", size: .xs)
                BSAvatar(initials: "AB", size: .sm)
                BSAvatar(initials: "CD", size: .md)
                BSAvatar(initials: "EF", size: .lg)
                BSAvatar(initials: "GH", size: .xl)
            }

            HStack(spacing: 16) {
                BSAvatar(icon: "person.fill", size: .md)
                BSAvatar(icon: "star.fill", size: .md, backgroundColor: .yellow)
                BSAvatar(initials: "BS", size: .md, shape: .rounded)
                BSAvatar(initials: "SQ", size: .md, shape: .square)
            }

            HStack(spacing: 16) {
                BSAvatar(initials: "ON", size: .lg, status: .online)
                BSAvatar(initials: "OF", size: .lg, status: .offline)
                BSAvatar(initials: "BU", size: .lg, status: .busy)
                BSAvatar(initials: "AW", size: .lg, status: .away)
            }

            BSAvatarGroup(
                avatars: [
                    .init(initials: "AB"),
                    .init(initials: "CD"),
                    .init(initials: "EF"),
                    .init(initials: "GH"),
                    .init(initials: "IJ"),
                    .init(initials: "KL"),
                ],
                size: .md
            )
        }
        .padding()
        .withTheme()
    }
}
#endif
