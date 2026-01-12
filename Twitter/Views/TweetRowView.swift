//
//  TweetRowView.swift
//  Twitter
//
//  Created by Akkuş on 30.12.2025.
//

import SwiftUI

struct TweetRowView: View {
    let tweet: Tweet
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack(alignment: .top, spacing: 12) {
                
                // MARK: - Avatar
                if tweet.isSystemAvatar {
                    Image(systemName: tweet.authorAvatar ?? "person.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                        .clipShape(Circle())
                } else {
                    Image(tweet.authorAvatar ?? "")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                }
                
                // MARK: - Content
                VStack(alignment: .leading, spacing: 4) {
                    
                    // Header
                    HStack {
                        Text(tweet.authorName ?? "Unknown")
                            .font(.headline)
                            .lineLimit(1)
                        
                        Text("@\(tweet.authorUsername ?? "unknown")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                        
                        Text("• 2h")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    // Tweet Text
                    Text(tweet.text)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .layoutPriority(1) // Prevents layout loop crashes
                    
                    // MARK: - Action Buttons
                    // Refactored into a reusable component to reduce code duplication
                    HStack(spacing: 0) {
                        TweetActionButton(icon: "CommentIcon", text: tweet.replyCount > 0 ? tweet.replyCount.formatCompact() : nil)
                        TweetActionButton(icon: "RetweetIcon", text: tweet.retweetCount > 0 ? tweet.retweetCount.formatCompact() : nil)
                        TweetActionButton(icon: "HeartIcon", text: tweet.likeCount > 0 ? tweet.likeCount.formatCompact() : nil)
                        TweetActionButton(icon: "ShareIcon", text: nil)
                    }
                    .padding(.top, 8)
                    .padding(.trailing, 16)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        
        Divider()
    }
}

// MARK: - Reusable Action Button
struct TweetActionButton: View {
    let icon: String
    let text: String?
    
    var body: some View {
        HStack(spacing: 4) {
            Image(icon)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 18, height: 18)
            
            if let text = text {
                Text(text)
                    .font(.caption)
                    .lineLimit(1)
            }
        }
        .foregroundColor(.secondary)
        .frame(maxWidth: .infinity, alignment: .leading) // Equal spacing
    }
}

// MARK: - Number Formatter Extension
extension Int {
    func formatCompact() -> String {
        let number = Double(self)
        let thousand = number / 1000
        let million = number / 1000000
        
        if million >= 1.0 { return String(format: "%.1fM", million) }
        else if thousand >= 1.0 { return String(format: "%.1fK", thousand) }
        else { return "\(self)" }
    }
}
