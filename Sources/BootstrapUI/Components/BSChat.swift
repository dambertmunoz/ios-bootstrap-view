// BSChat.swift
// BootstrapUI
//
// Chat/Messaging specific components
// Chat bubbles, typing indicators, message input

import SwiftUI

// MARK: - Message Status

/// Status of a sent message
public enum BSMessageStatus {
    case sending
    case sent
    case delivered
    case read
    case failed

    var icon: String {
        switch self {
        case .sending: return "clock"
        case .sent: return "checkmark"
        case .delivered: return "checkmark.circle"
        case .read: return "checkmark.circle.fill"
        case .failed: return "exclamationmark.circle"
        }
    }

    var color: Color {
        switch self {
        case .sending: return .gray
        case .sent: return .gray
        case .delivered: return .gray
        case .read: return .blue
        case .failed: return .red
        }
    }
}

// MARK: - Chat Bubble

/// A chat message bubble
public struct BSChatBubble: View {

    private let message: String
    private let timestamp: String?
    private let isOutgoing: Bool
    private let status: BSMessageStatus?
    private let showTail: Bool

    @Environment(\.theme) private var theme

    public init(
        message: String,
        timestamp: String? = nil,
        isOutgoing: Bool,
        status: BSMessageStatus? = nil,
        showTail: Bool = true
    ) {
        self.message = message
        self.timestamp = timestamp
        self.isOutgoing = isOutgoing
        self.status = status
        self.showTail = showTail
    }

    public var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            if isOutgoing { Spacer(minLength: 60) }

            VStack(alignment: isOutgoing ? .trailing : .leading, spacing: 2) {
                // Message bubble
                Text(message)
                    .font(theme.body)
                    .foregroundColor(isOutgoing ? .white : theme.onSurface)
                    .padding(.horizontal, theme.md)
                    .padding(.vertical, theme.sm)
                    .background(bubbleBackground)
                    .clipShape(BubbleShape(isOutgoing: isOutgoing, showTail: showTail))

                // Timestamp and status
                if timestamp != nil || status != nil {
                    HStack(spacing: 4) {
                        if let timestamp = timestamp {
                            Text(timestamp)
                                .font(theme.caption2)
                                .foregroundColor(theme.placeholder)
                        }

                        if let status = status, isOutgoing {
                            Image(systemName: status.icon)
                                .font(.system(size: 10))
                                .foregroundColor(status.color)
                        }
                    }
                }
            }

            if !isOutgoing { Spacer(minLength: 60) }
        }
    }

    private var bubbleBackground: Color {
        isOutgoing ? theme.primary : theme.surface
    }
}

// MARK: - Bubble Shape

struct BubbleShape: Shape {
    let isOutgoing: Bool
    let showTail: Bool
    let cornerRadius: CGFloat = 16
    let tailSize: CGFloat = 6

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let tailOffset: CGFloat = showTail ? tailSize : 0

        if isOutgoing {
            // Outgoing bubble (tail on right)
            path.addRoundedRect(
                in: CGRect(x: 0, y: 0, width: rect.width - tailOffset, height: rect.height),
                cornerSize: CGSize(width: cornerRadius, height: cornerRadius)
            )

            if showTail {
                path.move(to: CGPoint(x: rect.width - tailOffset, y: rect.height - cornerRadius))
                path.addLine(to: CGPoint(x: rect.width, y: rect.height))
                path.addLine(to: CGPoint(x: rect.width - tailOffset - 4, y: rect.height))
            }
        } else {
            // Incoming bubble (tail on left)
            path.addRoundedRect(
                in: CGRect(x: tailOffset, y: 0, width: rect.width - tailOffset, height: rect.height),
                cornerSize: CGSize(width: cornerRadius, height: cornerRadius)
            )

            if showTail {
                path.move(to: CGPoint(x: tailOffset, y: rect.height - cornerRadius))
                path.addLine(to: CGPoint(x: 0, y: rect.height))
                path.addLine(to: CGPoint(x: tailOffset + 4, y: rect.height))
            }
        }

        return path
    }
}

// MARK: - Image Message

/// A chat bubble with an image
public struct BSImageMessage: View {

    private let imageURL: URL?
    private let image: Image?
    private let caption: String?
    private let timestamp: String?
    private let isOutgoing: Bool
    private let status: BSMessageStatus?

    @Environment(\.theme) private var theme

    public init(
        imageURL: URL?,
        caption: String? = nil,
        timestamp: String? = nil,
        isOutgoing: Bool,
        status: BSMessageStatus? = nil
    ) {
        self.imageURL = imageURL
        self.image = nil
        self.caption = caption
        self.timestamp = timestamp
        self.isOutgoing = isOutgoing
        self.status = status
    }

    public init(
        image: Image,
        caption: String? = nil,
        timestamp: String? = nil,
        isOutgoing: Bool,
        status: BSMessageStatus? = nil
    ) {
        self.imageURL = nil
        self.image = image
        self.caption = caption
        self.timestamp = timestamp
        self.isOutgoing = isOutgoing
        self.status = status
    }

    public var body: some View {
        HStack {
            if isOutgoing { Spacer(minLength: 60) }

            VStack(alignment: isOutgoing ? .trailing : .leading, spacing: 2) {
                VStack(alignment: .leading, spacing: 0) {
                    // Image
                    Group {
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
                        } else if let image = image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }
                    }
                    .frame(maxWidth: 250, maxHeight: 200)
                    .clipped()

                    // Caption
                    if let caption = caption {
                        Text(caption)
                            .font(theme.body)
                            .foregroundColor(isOutgoing ? .white : theme.onSurface)
                            .padding(.horizontal, theme.sm)
                            .padding(.vertical, theme.xs)
                    }
                }
                .background(isOutgoing ? theme.primary : theme.surface)
                .cornerRadius(theme.radiusMd)

                // Timestamp and status
                if timestamp != nil || status != nil {
                    HStack(spacing: 4) {
                        if let timestamp = timestamp {
                            Text(timestamp)
                                .font(theme.caption2)
                                .foregroundColor(theme.placeholder)
                        }

                        if let status = status, isOutgoing {
                            Image(systemName: status.icon)
                                .font(.system(size: 10))
                                .foregroundColor(status.color)
                        }
                    }
                }
            }

            if !isOutgoing { Spacer(minLength: 60) }
        }
    }
}

// MARK: - Typing Indicator

/// An animated typing indicator
public struct BSTypingIndicator: View {

    @State private var animationOffset: Int = 0
    @Environment(\.theme) private var theme

    public init() {}

    public var body: some View {
        HStack {
            HStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(theme.placeholder)
                        .frame(width: 8, height: 8)
                        .offset(y: animationOffset == index ? -4 : 0)
                }
            }
            .padding(.horizontal, theme.md)
            .padding(.vertical, theme.sm)
            .background(theme.surface)
            .cornerRadius(theme.radiusMd)

            Spacer()
        }
        .onAppear {
            startAnimation()
        }
    }

    private func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.2)) {
                animationOffset = (animationOffset + 1) % 3
            }
        }
    }
}

// MARK: - Message Input

/// A chat message input field
public struct BSMessageInput: View {

    @Binding private var text: String
    private let placeholder: String
    private let showAttachmentButton: Bool
    private let onSend: () -> Void
    private let onAttachment: (() -> Void)?

    @Environment(\.theme) private var theme
    @FocusState private var isFocused: Bool

    public init(
        text: Binding<String>,
        placeholder: String = "Type a message...",
        showAttachmentButton: Bool = true,
        onSend: @escaping () -> Void,
        onAttachment: (() -> Void)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.showAttachmentButton = showAttachmentButton
        self.onSend = onSend
        self.onAttachment = onAttachment
    }

    public var body: some View {
        HStack(spacing: theme.sm) {
            // Attachment button
            if showAttachmentButton {
                Button(action: { onAttachment?() }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(theme.primary)
                }
            }

            // Text field
            HStack(spacing: theme.sm) {
                TextField(placeholder, text: $text, axis: .vertical)
                    .font(theme.body)
                    .lineLimit(1...5)
                    .focused($isFocused)

                // Emoji button
                Button(action: {}) {
                    Image(systemName: "face.smiling")
                        .font(.system(size: 20))
                        .foregroundColor(theme.placeholder)
                }
            }
            .padding(.horizontal, theme.md)
            .padding(.vertical, theme.sm)
            .background(theme.surface)
            .cornerRadius(theme.radiusFull)

            // Send button
            Button(action: sendMessage) {
                Image(systemName: text.isEmpty ? "mic.fill" : "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(theme.primary)
            }
            .disabled(text.isEmpty)
        }
        .padding(.horizontal, theme.md)
        .padding(.vertical, theme.sm)
        .background(theme.background)
    }

    private func sendMessage() {
        guard !text.isEmpty else { return }
        onSend()
    }
}

// MARK: - Chat Header

/// A header for chat screens
public struct BSChatHeader: View {

    private let name: String
    private let status: String?
    private let avatarURL: URL?
    private let avatarInitials: String?
    private let isOnline: Bool
    private let onBack: (() -> Void)?
    private let onProfileTap: (() -> Void)?
    private let onCallTap: (() -> Void)?
    private let onVideoTap: (() -> Void)?

    @Environment(\.theme) private var theme

    public init(
        name: String,
        status: String? = nil,
        avatarURL: URL? = nil,
        avatarInitials: String? = nil,
        isOnline: Bool = false,
        onBack: (() -> Void)? = nil,
        onProfileTap: (() -> Void)? = nil,
        onCallTap: (() -> Void)? = nil,
        onVideoTap: (() -> Void)? = nil
    ) {
        self.name = name
        self.status = status
        self.avatarURL = avatarURL
        self.avatarInitials = avatarInitials
        self.isOnline = isOnline
        self.onBack = onBack
        self.onProfileTap = onProfileTap
        self.onCallTap = onCallTap
        self.onVideoTap = onVideoTap
    }

    public var body: some View {
        HStack(spacing: theme.sm) {
            // Back button
            if let onBack = onBack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(theme.primary)
                }
            }

            // Avatar and info
            Button(action: { onProfileTap?() }) {
                HStack(spacing: theme.sm) {
                    // Avatar with online indicator
                    ZStack(alignment: .bottomTrailing) {
                        if let url = avatarURL {
                            BSAvatar(imageURL: url, size: .md)
                        } else if let initials = avatarInitials {
                            BSAvatar(initials: initials, size: .md)
                        } else {
                            BSAvatar(icon: "person.fill", size: .md)
                        }

                        if isOnline {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 12, height: 12)
                                .overlay(
                                    Circle()
                                        .stroke(theme.background, lineWidth: 2)
                                )
                        }
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(name)
                            .font(theme.headline)
                            .foregroundColor(theme.onSurface)

                        if let status = status {
                            Text(status)
                                .font(theme.caption1)
                                .foregroundColor(isOnline ? .green : theme.placeholder)
                        }
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())

            Spacer()

            // Action buttons
            HStack(spacing: theme.md) {
                if let onCallTap = onCallTap {
                    Button(action: onCallTap) {
                        Image(systemName: "phone.fill")
                            .font(.system(size: 20))
                            .foregroundColor(theme.primary)
                    }
                }

                if let onVideoTap = onVideoTap {
                    Button(action: onVideoTap) {
                        Image(systemName: "video.fill")
                            .font(.system(size: 20))
                            .foregroundColor(theme.primary)
                    }
                }
            }
        }
        .padding(.horizontal, theme.md)
        .padding(.vertical, theme.sm)
        .background(theme.background)
    }
}

// MARK: - Conversation List Item

/// A row for conversation lists
public struct BSConversationItem: View {

    private let name: String
    private let lastMessage: String
    private let timestamp: String
    private let avatarURL: URL?
    private let avatarInitials: String?
    private let unreadCount: Int
    private let isOnline: Bool
    private let isMuted: Bool
    private let onTap: (() -> Void)?

    @Environment(\.theme) private var theme

    public init(
        name: String,
        lastMessage: String,
        timestamp: String,
        avatarURL: URL? = nil,
        avatarInitials: String? = nil,
        unreadCount: Int = 0,
        isOnline: Bool = false,
        isMuted: Bool = false,
        onTap: (() -> Void)? = nil
    ) {
        self.name = name
        self.lastMessage = lastMessage
        self.timestamp = timestamp
        self.avatarURL = avatarURL
        self.avatarInitials = avatarInitials
        self.unreadCount = unreadCount
        self.isOnline = isOnline
        self.isMuted = isMuted
        self.onTap = onTap
    }

    public var body: some View {
        Button(action: { onTap?() }) {
            HStack(spacing: theme.md) {
                // Avatar with online indicator
                ZStack(alignment: .bottomTrailing) {
                    if let url = avatarURL {
                        BSAvatar(imageURL: url, size: .lg)
                    } else if let initials = avatarInitials {
                        BSAvatar(initials: initials, size: .lg)
                    } else {
                        BSAvatar(icon: "person.fill", size: .lg)
                    }

                    if isOnline {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 14, height: 14)
                            .overlay(
                                Circle()
                                    .stroke(theme.background, lineWidth: 2)
                            )
                    }
                }

                // Content
                VStack(alignment: .leading, spacing: theme.xxs) {
                    HStack {
                        Text(name)
                            .font(theme.subheadline)
                            .fontWeight(unreadCount > 0 ? .semibold : .regular)
                            .foregroundColor(theme.onSurface)

                        Spacer()

                        Text(timestamp)
                            .font(theme.caption1)
                            .foregroundColor(unreadCount > 0 ? theme.primary : theme.placeholder)
                    }

                    HStack {
                        Text(lastMessage)
                            .font(theme.subheadline)
                            .foregroundColor(unreadCount > 0 ? theme.onSurface : theme.placeholder)
                            .lineLimit(1)

                        Spacer()

                        HStack(spacing: 4) {
                            if isMuted {
                                Image(systemName: "bell.slash.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(theme.placeholder)
                            }

                            if unreadCount > 0 {
                                BSCountBadge(count: unreadCount)
                            }
                        }
                    }
                }
            }
            .padding(.vertical, theme.sm)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview

#if DEBUG
struct BSChat_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            // Header
            BSChatHeader(
                name: "Alice",
                status: "Online",
                avatarInitials: "A",
                isOnline: true,
                onBack: {},
                onCallTap: {},
                onVideoTap: {}
            )

            BSDivider()

            // Messages
            ScrollView {
                VStack(spacing: theme.sm) {
                    BSChatBubble(
                        message: "Hey! How are you?",
                        timestamp: "10:30 AM",
                        isOutgoing: false
                    )

                    BSChatBubble(
                        message: "I'm good, thanks! Just finished working on the new feature.",
                        timestamp: "10:32 AM",
                        isOutgoing: true,
                        status: .read
                    )

                    BSChatBubble(
                        message: "That's awesome! Can't wait to see it!",
                        timestamp: "10:33 AM",
                        isOutgoing: false
                    )

                    BSTypingIndicator()
                }
                .padding()
            }

            BSDivider()

            // Input
            BSMessageInput(text: .constant(""), onSend: {})
        }
        .withTheme()
    }

    static var theme: Theme { .light }
}
#endif
