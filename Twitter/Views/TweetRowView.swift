//
//  TweetRowView.swift
//  Twitter
//
//  Created by Akkuş on 30.12.2025.
//

import SwiftUI

struct TweetRowView: View {
    // The data source for this row
    let tweet: Tweet
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack(alignment: .top, spacing:12) {
                
                // MARK: - Dynamic Avatar ( Systsem or Asset )
                // We check the flag to decide how to load the image.
                if tweet.isSystemAvatar {
                    // Load SF Symbol
                    Image(systemName: tweet.authorAvatar ?? "person.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                        .clipShape(Circle())
                } else {
                    // Load from Assets
                    // Note: Ensure the image name in Mock Data matches your Asset name exactly.
                    Image(tweet.authorAvatar ?? "")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                }
                
                // MARK: - Content Area
                VStack(alignment: .leading, spacing: 4) {
                    
                    // Header: Dynamic Name and Username
                    HStack {
                        Text(tweet.authorName ?? "Unknown User")
                            .font(.headline)
                            .foregroundColor(.primary)
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
                    // We allow the text to stretch downward
                    Text(tweet.text)
                        .font(.body)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        // prevents layout crashes
                        .layoutPriority(1)
                    
                    
                    // MARK: - Dynamic Action Buttons
                    //Now binding the counts to the tweet model.
                    HStack(spacing: 0) {
                        
                        // 1. Reply
                        HStack(spacing: 4) {
                            Image("CommentIcon")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                            
                            // Dynamic Count
                            Text(tweet.replyCount > 0 ? tweet.replyCount.formatCompact() : "")
                                .font(.caption)
                                .lineLimit(1)
                        }
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(spacing: 4) {
                            Image("RetweetIcon")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                            Text(tweet.retweetCount > 0 ? tweet.retweetCount.formatCompact() : "")
                                .font(.caption)
                                .lineLimit(1)
                        }
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(spacing: 4) {
                            Image("HeartIcon")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                            Text(tweet.likeCount > 0 ? tweet.likeCount.formatCompact() : "")
                                .font(.caption)
                                .lineLimit(1)
                        }
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(spacing: 4) {
                            Image("ShareIcon")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                        }
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    .padding(.top, 8)
                    .padding(.trailing, 16)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        
        // Separator Line
        Divider()
    }
}

// MARK: - Integer Extension
extension Int {
    func formatCompact() -> String {
        let number = Double(self)
        let thousand = number / 1000
        let million = number / 1000000
        
        if million >= 1.0 {
            return String(format: "%.1fM", million)
        } else if thousand >= 1.0 {
            return String(format: "%.1fK", thousand)
        } else {
            return "\(self)"
        }
    }
}



// Design Preview
// We are testing how the interface looks with mock data.
/*
 #Preview {
 VStack {
 // Example 1: Standard Tweet
 TweetRowView(tweet: Tweet(id: "1", text: "Testing the layout stability. Even with large numbers, the buttons should remain aligned.", created_at: "2025", author_id: "1"))
 
 // Example 2: Checking alignment consistency
 TweetRowView(tweet: Tweet(id: "2", text: "Short tweet.", created_at: "2025", author_id: "1"))
 }
 }
 */


