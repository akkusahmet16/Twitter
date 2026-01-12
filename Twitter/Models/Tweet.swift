//
//  Tweet.swift
//  Twitter
//
//  Created by Akkuş on 29.12.2025.
//

import Foundation

// The main response pattern returned from the API (Wrapper)
struct TwitterResponse: Codable {
    let data: [Tweet]?
}

// The tweet itself
struct Tweet: Codable, Identifiable {
    let id: String
    let text: String
    let created_at: String
    let author_id: String
    
    // New dynamic fields for UI
    // We make them optional sting/ints so if real API doesn't send them, app won't crash.
    var authorName: String? = "Unknown User"
    var authorUsername: String? = "unknown"
    var authorAvatar: String? = "person.circle.fill" // Default system icon
    
    // NEW FLAG: Determines if the avatar is an SF Symbol (ture) or an Asset Image (false).
    var isSystemAvatar: Bool = true
    
    // Engagement stats
    var replyCount: Int = 0
    var retweetCount: Int = 0
    var likeCount: Int = 0
}
