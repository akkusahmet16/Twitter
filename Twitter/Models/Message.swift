//
//  Message.swift
//  Twitter
//

import Foundation

// MARK: - Message Model
// Represents a single bubble inside the chat view.
struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isCurrentUser: Bool
    let timestamp: Date
}

// MARK: - Conversation Model
// Represents a row in the main Message list (The user we are talking to).
struct Conversation: Identifiable {
    let id = UUID()
    let username: String
    let handle: String
    let userImage: String // Asset Image
    let lastMessage: String
    let timeAgo: String
    let isVerified: Bool
}

struct MockData {
    // 1. Data for the Messages List (Different perople)
    static let conversations: [Conversation] = [
        Conversation(username: "Elon Musk", handle: "elonmusk", userImage: "elonmuskprofile", lastMessage: "When are we launching the app to Mars?",timeAgo: "2m", isVerified: true),
        Conversation(username: "Tim Cook", handle: "tim_cook", userImage: "timcookprofile", lastMessage: "I love the SwiftUI impementation! Good Job.", timeAgo: "1h", isVerified: true),
        Conversation(username: "Steve Jobs", handle: "stevejobs", userImage: "stevejobspprofile", lastMessage: "One more thing... fix that padding", timeAgo: "1d", isVerified: false),
        Conversation(username: "Donald Trump", handle: "realtrump", userImage: "trumpprofile", lastMessage: "I took over Venezuela in just an hour and a half. Nobody’s ever done it that fast. Believe me.", timeAgo:  "2d", isVerified: false),
        Conversation(username: "Design Team", handle: "design-core", userImage: "", lastMessage: "New assets are ready for the dark mode", timeAgo: "5d", isVerified: true),
        Conversation(username: "Mom", handle: "mom", userImage: "", lastMessage: "Dont forget eat dinner", timeAgo: "1w", isVerified: false)
    ]
    
    // 2. Data for a spesific Chat (Inside the chat view)
    static let chatHistory: [Message] = [
        Message(text: "Hey! I saw your latest commit on GitHub.", isCurrentUser: false, timestamp: Date()),
        Message(text: "Thanks! Yeah, I refactored the whole navigation stack", isCurrentUser: true, timestamp: Date()),
        Message(text: "It looks much smoother now. Native feel is 100%", isCurrentUser: false, timestamp: Date()),
        Message(text: "That was the goal! No more laggy transitions", isCurrentUser: true, timestamp: Date()),
        Message(text: "Great work, Let's push to production next week", isCurrentUser: false, timestamp: Date())
    ]
}

