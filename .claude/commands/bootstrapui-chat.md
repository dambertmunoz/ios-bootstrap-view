# Generate BootstrapUI Chat Interface

Generate a SwiftUI chat interface using BootstrapUI components for: $ARGUMENTS

## Instructions

Create a complete chat interface with messages, input, and real-time features:

```swift
import SwiftUI
import BootstrapUI

struct ChatView: View {
    @State private var messages: [ChatMessage] = []
    @State private var inputText = ""
    @State private var isTyping = false

    @Environment(\.theme) private var theme

    var body: some View {
        VStack(spacing: 0) {
            // Header
            BSChatHeader(
                title: "Chat Name",
                subtitle: "Online",
                avatarName: "User Name"
            )

            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: theme.sm) {
                        ForEach(messages) { message in
                            BSChatBubble(
                                message: message.text,
                                isFromCurrentUser: message.isFromCurrentUser,
                                timestamp: message.timestamp,
                                status: message.status
                            )
                            .id(message.id)
                        }

                        if isTyping {
                            BSTypingIndicator()
                        }
                    }
                    .padding()
                }
                .onChange(of: messages.count) { _ in
                    if let lastMessage = messages.last {
                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
            }

            // Input
            BSMessageInput(
                text: $inputText,
                placeholder: "Type a message...",
                onSend: sendMessage
            )
        }
    }

    private func sendMessage() {
        guard !inputText.isEmpty else { return }
        // Send message logic
        inputText = ""
    }
}
```

## Available Chat Components

### BSChatBubble
```swift
// Basic message
BSChatBubble(
    message: "Hello!",
    isFromCurrentUser: true,
    timestamp: "10:30 AM"
)

// With status
BSChatBubble(
    message: "Message sent",
    isFromCurrentUser: true,
    timestamp: "10:30 AM",
    status: .sent  // .sending, .sent, .delivered, .read, .failed
)

// With reactions
BSChatBubble(
    message: "Great idea!",
    isFromCurrentUser: false,
    timestamp: "10:31 AM",
    reactions: ["👍", "❤️"]
)
```

### BSMessageInput
```swift
// Basic
BSMessageInput(text: $text, onSend: sendMessage)

// With attachments
BSMessageInput(
    text: $text,
    placeholder: "Type a message...",
    showAttachmentButton: true,
    onAttachment: showAttachmentOptions,
    onSend: sendMessage
)
```

### BSChatHeader
```swift
BSChatHeader(
    title: "John Doe",
    subtitle: "Online",
    avatarName: "John Doe",
    onBack: { dismiss() },
    onInfo: { showProfile() }
)
```

### BSTypingIndicator
```swift
// Shows animated typing dots
BSTypingIndicator()

// With user name
BSTypingIndicator(userName: "John")
```

### BSReactionPicker
```swift
BSReactionPicker(selected: $selectedReaction)

// Available reactions: 👍, ❤️, 😂, 😮, 😢, 😡
```

## Message Model

```swift
struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isFromCurrentUser: Bool
    let timestamp: String
    let status: BSChatBubble.Status
}
```

## Group Chat Pattern

```swift
ForEach(messages) { message in
    VStack(alignment: message.isFromCurrentUser ? .trailing : .leading) {
        if !message.isFromCurrentUser {
            BSText(message.senderName, style: .caption2)
                .foregroundColor(theme.placeholder)
        }

        BSChatBubble(
            message: message.text,
            isFromCurrentUser: message.isFromCurrentUser,
            timestamp: message.timestamp
        )
    }
}
```

## Image Messages

```swift
BSChatImageBubble(
    imageURL: message.imageURL,
    isFromCurrentUser: true,
    timestamp: "10:32 AM"
)
```

Generate the chat interface based on the user's requirements using these patterns.
