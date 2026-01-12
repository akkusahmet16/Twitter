//
//  Tweet.swift
//  Twitter
//
//  Created by Akkuş on 29.12.2025.
//

import Foundation

// MARK: - API Response Wrapper
struct TwitterResponse: Codable {
    let data: [Tweet]?
}

// MARK: - Tweet Model
// Represents a single tweet entity with support for both API and Mock data.
struct Tweet: Codable, Identifiable {
    let id: String
    let text: String
    let created_at: String
    let author_id: String
    
    // MARK: - Dynamic UI Properties
    // Optional fields to handle missing API data gracefully.
    var authorName: String? = "Unknown User"
    var authorUsername: String? = "unknown"
    var authorAvatar: String? = "person.circle.fill"
    
    // Flag to distinguish between SF Symbols (true) and Asset Images (false)
    var isSystemAvatar: Bool = true
    
    // MARK: - Engagement Metrics
    var replyCount: Int = 0
    var retweetCount: Int = 0
    var likeCount: Int = 0
}
