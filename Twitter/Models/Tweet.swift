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
    // The date and author ID are currently missing and will be formatted later.
    let created_at: String?
    let author_id: String?
}
