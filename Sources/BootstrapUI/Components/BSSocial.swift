// BSSocial.swift
// BootstrapUI
//
// Social media specific components
// Post cards, comments, story rings, reactions

import SwiftUI

// MARK: - Post Card

/// A social media post card
public struct BSPostCard: View {

    private let authorName: String
    private let authorAvatar: URL?
    private let authorInitials: String?
    private let timestamp: String
    private let content: String
    private let imageURL: URL?
    private let likes: Int
    private let comments: Int
    private let shares: Int
    private let isLiked: Bool
    private let onLike: (() -> Void)?
    private let onComment: (() -> Void)?
    private let onShare: (() -> Void)?
    private let onProfileTap: (() -> Void)?

    @Environment(\.theme) private var theme

    public init(
        authorName: String,
        authorAvatar: URL? = nil,
        authorInitials: String? = nil,
        timestamp: String,
        content: String,
        imageURL: URL? = nil,
        likes: Int = 0,
        comments: Int = 0,
        shares: Int = 0,
        isLiked: Bool = false,
        onLike: (() -> Void)? = nil,
        onComment: (() -> Void)? = nil,
        onShare: (() -> Void)? = nil,
        onProfileTap: (() -> Void)? = nil
    ) {
        self.authorName = authorName
        self.authorAvatar = authorAvatar
        self.authorInitials = authorInitials
        self.timestamp = timestamp
        self.content = content
        self.imageURL = imageURL
        self.likes = likes
        self.comments = comments
        self.shares = shares
        self.isLiked = isLiked
        self.onLike = onLike
        self.onComment = onComment
        self.onShare = onShare
        self.onProfileTap = onProfileTap
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack(spacing: theme.sm) {
                avatarView
                    .onTapGesture { onProfileTap?() }

                VStack(alignment: .leading, spacing: 2) {
                    Text(authorName)
                        .font(theme.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(theme.onSurface)

                    Text(timestamp)
                        .font(theme.caption1)
                        .foregroundColor(theme.placeholder)
                }

                Spacer()

                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(theme.placeholder)
                }
            }
            .padding(theme.md)

            // Content
            Text(content)
                .font(theme.body)
                .foregroundColor(theme.onSurface)
                .padding(.horizontal, theme.md)
                .padding(.bottom, theme.sm)

            // Image
            if let url = imageURL {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(theme.surface)
                        .overlay(ProgressView())
                }
                .frame(maxHeight: 300)
                .clipped()
            }

            // Stats
            HStack(spacing: theme.lg) {
                Text("\(likes) likes")
                Text("\(comments) comments")
                Text("\(shares) shares")
            }
            .font(theme.caption1)
            .foregroundColor(theme.placeholder)
            .padding(.horizontal, theme.md)
            .padding(.vertical, theme.sm)

            BSDivider()

            // Actions
            HStack(spacing: 0) {
                actionButton(
                    icon: isLiked ? "heart.fill" : "heart",
                    label: "Like",
                    color: isLiked ? .red : theme.placeholder,
                    action: onLike
                )

                actionButton(
                    icon: "bubble.left",
                    label: "Comment",
                    color: theme.placeholder,
                    action: onComment
                )

                actionButton(
                    icon: "arrow.turn.up.right",
                    label: "Share",
                    color: theme.placeholder,
                    action: onShare
                )
            }
            .padding(.vertical, theme.xs)
        }
        .background(theme.background)
        .cornerRadius(theme.radiusMd)
        .shadow(color: theme.shadowSm.color, radius: theme.shadowSm.radius)
    }

    @ViewBuilder
    private var avatarView: some View {
        if let url = authorAvatar {
            BSAvatar(imageURL: url, size: .md)
        } else if let initials = authorInitials {
            BSAvatar(initials: initials, size: .md)
        } else {
            BSAvatar(icon: "person.fill", size: .md)
        }
    }

    private func actionButton(
        icon: String,
        label: String,
        color: Color,
        action: (() -> Void)?
    ) -> some View {
        Button(action: { action?() }) {
            HStack(spacing: theme.xs) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                Text(label)
                    .font(theme.subheadline)
            }
            .foregroundColor(color)
            .frame(maxWidth: .infinity)
            .padding(.vertical, theme.sm)
        }
    }
}

// MARK: - Comment

/// A single comment view
public struct BSComment: View {

    private let authorName: String
    private let authorAvatar: URL?
    private let authorInitials: String?
    private let content: String
    private let timestamp: String
    private let likes: Int
    private let isLiked: Bool
    private let onLike: (() -> Void)?
    private let onReply: (() -> Void)?

    @Environment(\.theme) private var theme

    public init(
        authorName: String,
        authorAvatar: URL? = nil,
        authorInitials: String? = nil,
        content: String,
        timestamp: String,
        likes: Int = 0,
        isLiked: Bool = false,
        onLike: (() -> Void)? = nil,
        onReply: (() -> Void)? = nil
    ) {
        self.authorName = authorName
        self.authorAvatar = authorAvatar
        self.authorInitials = authorInitials
        self.content = content
        self.timestamp = timestamp
        self.likes = likes
        self.isLiked = isLiked
        self.onLike = onLike
        self.onReply = onReply
    }

    public var body: some View {
        HStack(alignment: .top, spacing: theme.sm) {
            // Avatar
            if let url = authorAvatar {
                BSAvatar(imageURL: url, size: .sm)
            } else if let initials = authorInitials {
                BSAvatar(initials: initials, size: .sm)
            } else {
                BSAvatar(icon: "person.fill", size: .sm)
            }

            VStack(alignment: .leading, spacing: theme.xs) {
                // Comment bubble
                VStack(alignment: .leading, spacing: theme.xxs) {
                    Text(authorName)
                        .font(theme.caption1)
                        .fontWeight(.semibold)
                        .foregroundColor(theme.onSurface)

                    Text(content)
                        .font(theme.subheadline)
                        .foregroundColor(theme.onSurface)
                }
                .padding(theme.sm)
                .background(theme.surface)
                .cornerRadius(theme.radiusMd)

                // Actions
                HStack(spacing: theme.md) {
                    Text(timestamp)
                        .font(theme.caption2)
                        .foregroundColor(theme.placeholder)

                    Button("Like") { onLike?() }
                        .font(theme.caption2)
                        .fontWeight(isLiked ? .semibold : .regular)
                        .foregroundColor(isLiked ? theme.primary : theme.placeholder)

                    Button("Reply") { onReply?() }
                        .font(theme.caption2)
                        .foregroundColor(theme.placeholder)

                    if likes > 0 {
                        HStack(spacing: 2) {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 10))
                            Text("\(likes)")
                        }
                        .font(theme.caption2)
                        .foregroundColor(theme.placeholder)
                    }
                }
            }
        }
    }
}

// MARK: - Comment Thread

/// A thread of comments with replies
public struct BSCommentThread: View {

    public struct CommentData: Identifiable {
        public let id = UUID()
        public let authorName: String
        public let authorInitials: String?
        public let content: String
        public let timestamp: String
        public let likes: Int
        public let replies: [CommentData]

        public init(
            authorName: String,
            authorInitials: String? = nil,
            content: String,
            timestamp: String,
            likes: Int = 0,
            replies: [CommentData] = []
        ) {
            self.authorName = authorName
            self.authorInitials = authorInitials
            self.content = content
            self.timestamp = timestamp
            self.likes = likes
            self.replies = replies
        }
    }

    private let comments: [CommentData]

    @Environment(\.theme) private var theme

    public init(comments: [CommentData]) {
        self.comments = comments
    }

    public var body: some View {
        VStack(spacing: theme.md) {
            ForEach(comments) { comment in
                VStack(alignment: .leading, spacing: theme.sm) {
                    BSComment(
                        authorName: comment.authorName,
                        authorInitials: comment.authorInitials,
                        content: comment.content,
                        timestamp: comment.timestamp,
                        likes: comment.likes
                    )

                    // Replies
                    if !comment.replies.isEmpty {
                        VStack(spacing: theme.sm) {
                            ForEach(comment.replies) { reply in
                                BSComment(
                                    authorName: reply.authorName,
                                    authorInitials: reply.authorInitials,
                                    content: reply.content,
                                    timestamp: reply.timestamp,
                                    likes: reply.likes
                                )
                            }
                        }
                        .padding(.leading, theme.xl)
                    }
                }
            }
        }
    }
}

// MARK: - Story Ring

/// A story ring indicator around an avatar
public struct BSStoryRing: View {

    private let imageURL: URL?
    private let initials: String?
    private let hasStory: Bool
    private let isViewed: Bool
    private let size: BSAvatarSize
    private let onTap: (() -> Void)?

    @Environment(\.theme) private var theme

    public init(
        imageURL: URL? = nil,
        initials: String? = nil,
        hasStory: Bool = true,
        isViewed: Bool = false,
        size: BSAvatarSize = .lg,
        onTap: (() -> Void)? = nil
    ) {
        self.imageURL = imageURL
        self.initials = initials
        self.hasStory = hasStory
        self.isViewed = isViewed
        self.size = size
        self.onTap = onTap
    }

    public var body: some View {
        Button(action: { onTap?() }) {
            ZStack {
                // Ring
                if hasStory {
                    Circle()
                        .stroke(
                            isViewed ? theme.border : storyGradient,
                            lineWidth: 3
                        )
                        .frame(width: ringSize, height: ringSize)
                }

                // Avatar
                if let url = imageURL {
                    BSAvatar(imageURL: url, size: size)
                } else if let initials = initials {
                    BSAvatar(initials: initials, size: size)
                } else {
                    BSAvatar(icon: "person.fill", size: size)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var ringSize: CGFloat {
        size.dimension + 8
    }

    private var storyGradient: LinearGradient {
        LinearGradient(
            colors: [.purple, .red, .orange, .yellow],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Stories Row

/// A horizontal scrollable row of story rings
public struct BSStoriesRow: View {

    public struct StoryUser: Identifiable {
        public let id = UUID()
        public let name: String
        public let initials: String?
        public let imageURL: URL?
        public let hasStory: Bool
        public let isViewed: Bool

        public init(
            name: String,
            initials: String? = nil,
            imageURL: URL? = nil,
            hasStory: Bool = true,
            isViewed: Bool = false
        ) {
            self.name = name
            self.initials = initials
            self.imageURL = imageURL
            self.hasStory = hasStory
            self.isViewed = isViewed
        }
    }

    private let users: [StoryUser]
    private let showAddButton: Bool
    private let onUserTap: ((StoryUser) -> Void)?
    private let onAddTap: (() -> Void)?

    @Environment(\.theme) private var theme

    public init(
        users: [StoryUser],
        showAddButton: Bool = true,
        onUserTap: ((StoryUser) -> Void)? = nil,
        onAddTap: (() -> Void)? = nil
    ) {
        self.users = users
        self.showAddButton = showAddButton
        self.onUserTap = onUserTap
        self.onAddTap = onAddTap
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: theme.md) {
                // Add story button
                if showAddButton {
                    VStack(spacing: theme.xs) {
                        Button(action: { onAddTap?() }) {
                            ZStack {
                                Circle()
                                    .stroke(theme.border, style: StrokeStyle(lineWidth: 2, dash: [4]))
                                    .frame(width: 64, height: 64)

                                Image(systemName: "plus")
                                    .font(.system(size: 24))
                                    .foregroundColor(theme.primary)
                            }
                        }

                        Text("Add Story")
                            .font(theme.caption2)
                            .foregroundColor(theme.placeholder)
                    }
                }

                // User stories
                ForEach(users) { user in
                    VStack(spacing: theme.xs) {
                        BSStoryRing(
                            imageURL: user.imageURL,
                            initials: user.initials,
                            hasStory: user.hasStory,
                            isViewed: user.isViewed,
                            size: .lg,
                            onTap: { onUserTap?(user) }
                        )

                        Text(user.name)
                            .font(theme.caption2)
                            .foregroundColor(theme.onSurface)
                            .lineLimit(1)
                            .frame(width: 64)
                    }
                }
            }
            .padding(.horizontal, theme.md)
        }
    }
}

// MARK: - Reaction Picker

/// A reaction picker similar to Facebook/Slack
public struct BSReactionPicker: View {

    public struct Reaction: Identifiable, Equatable {
        public let id = UUID()
        public let emoji: String
        public let label: String

        public init(emoji: String, label: String) {
            self.emoji = emoji
            self.label = label
        }

        public static func == (lhs: Reaction, rhs: Reaction) -> Bool {
            lhs.id == rhs.id
        }
    }

    @Binding private var selectedReaction: Reaction?
    private let reactions: [Reaction]
    private let onSelect: ((Reaction) -> Void)?

    @Environment(\.theme) private var theme
    @State private var hoveredReaction: Reaction?

    public static let defaultReactions: [Reaction] = [
        Reaction(emoji: "👍", label: "Like"),
        Reaction(emoji: "❤️", label: "Love"),
        Reaction(emoji: "😂", label: "Haha"),
        Reaction(emoji: "😮", label: "Wow"),
        Reaction(emoji: "😢", label: "Sad"),
        Reaction(emoji: "😡", label: "Angry")
    ]

    public init(
        selectedReaction: Binding<Reaction?>,
        reactions: [Reaction] = defaultReactions,
        onSelect: ((Reaction) -> Void)? = nil
    ) {
        self._selectedReaction = selectedReaction
        self.reactions = reactions
        self.onSelect = onSelect
    }

    public var body: some View {
        HStack(spacing: theme.sm) {
            ForEach(reactions) { reaction in
                Button(action: {
                    withAnimation(.spring(response: 0.3)) {
                        selectedReaction = reaction
                    }
                    onSelect?(reaction)
                }) {
                    Text(reaction.emoji)
                        .font(.system(size: selectedReaction == reaction ? 32 : 24))
                        .scaleEffect(hoveredReaction == reaction ? 1.3 : 1)
                }
                .buttonStyle(PlainButtonStyle())
                .onHover { isHovered in
                    withAnimation(.spring(response: 0.2)) {
                        hoveredReaction = isHovered ? reaction : nil
                    }
                }
            }
        }
        .padding(.horizontal, theme.md)
        .padding(.vertical, theme.sm)
        .background(theme.surface)
        .cornerRadius(theme.radiusFull)
        .shadow(color: theme.shadowMd.color, radius: theme.shadowMd.radius)
    }
}

// MARK: - Preview

#if DEBUG
struct BSSocial_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Stories Row
                Text("Stories").font(.headline)
                BSStoriesRow(users: [
                    .init(name: "Alice", initials: "A"),
                    .init(name: "Bob", initials: "B", isViewed: true),
                    .init(name: "Charlie", initials: "C"),
                    .init(name: "Diana", initials: "D")
                ])

                // Post Card
                Text("Post Card").font(.headline)
                BSPostCard(
                    authorName: "John Doe",
                    authorInitials: "JD",
                    timestamp: "2 hours ago",
                    content: "Just shipped a new feature! Really excited about this one. What do you think?",
                    likes: 42,
                    comments: 8,
                    shares: 3,
                    isLiked: true
                )
                .padding(.horizontal)

                // Comments
                Text("Comments").font(.headline)
                BSCommentThread(comments: [
                    .init(
                        authorName: "Alice",
                        authorInitials: "A",
                        content: "This looks amazing! Great work!",
                        timestamp: "1h",
                        likes: 5,
                        replies: [
                            .init(
                                authorName: "John",
                                authorInitials: "J",
                                content: "Thanks Alice!",
                                timestamp: "45m"
                            )
                        ]
                    ),
                    .init(
                        authorName: "Bob",
                        authorInitials: "B",
                        content: "Can't wait to try it out!",
                        timestamp: "30m",
                        likes: 2
                    )
                ])
                .padding(.horizontal)

                // Reaction Picker
                Text("Reactions").font(.headline)
                BSReactionPicker(selectedReaction: .constant(nil))
            }
            .padding(.vertical)
        }
        .withTheme()
    }
}
#endif
