//
//  XModels.swift
//  Twitter
//
//  Created by Akkuş on 30.11.2025.
//

import Foundation

struct XTPost: Identifiable, Codable {
    
    let id: String
    let text: String
    let author_id: String
    let created_at: String?
    let attachments: Attachments?
    let public_metrics: PublicMetrics?
    let referenced_tweets: [ReferencedTweet]?
    
    struct Attachments: Codable {
        let media_keys: [String]?
    }
    
    struct PublicMetrics: Codable {
        let reply_count: Int?
        let retweet_count:Int?
        let like_count: Int?
        let quote_count: Int?
        let impression_count: Int?
        let bookmark_count: Int?
    }
    
    struct ReferencedTweet: Codable {
        let type: String
        let id: String
    }
    
}

struct XTUser: Codable, Identifiable {
    let id: String
    let name: String
    let username: String
    let profile_image_url: String?
}

struct XTMedia: Codable, Identifiable {
    let media_key: String
    let type: String
    let url: String?
    let preview_image_url: String?
    
    var id: String {media_key}
}

struct XTUserTimeLineResponse: Codable {
    let data: [XTPost]?
    let includes: Includes?
    
    struct Includes: Codable {
        let users: [XTUser]?
        let media: [XTMedia]?
    }
}

