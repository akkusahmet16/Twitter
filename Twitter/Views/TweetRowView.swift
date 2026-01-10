//
//  TweetRowView.swift
//  Twitter
//
//  Created by Akkuş on 30.12.2025.
//

import SwiftUI

struct TweetRowView: View {
    // This view fetches the data of a single tweet from an external source.
    let tweet: Tweet
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack(alignment: .top, spacing:12) {
                
                // Profile Picture Area
                // In the actual application, an asynchronous image loader (AsynImage) will be placed here.
                // For now, a placeholder has been used for design integrity.
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(.gray)
                    .clipShape(Circle())
                
                // Content and Title Area
                VStack(alignment: .leading, spacing: 4) {
                    
                    // Title: Name, Username, and Date
                    HStack {
                        Text("Uesr Name") // The author's name from API will appear here in the future.
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("@kusername") // API'den gelen handle
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        // Helper functions can be added for date formatting.
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
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // Action Buttons (Reply, Retweet, Like, Share)
                    // We can split the buttons into subviews to prevent code duplication.
                    HStack(spacing: 40) {
                        ActionIcons(icon: "CommentIcon", count: 12)
                        ActionIcons(icon: "RetweetIcon", count: 5342)
                        ActionIcons(icon: "HeartIcon", count: 3497654)
                        ActionIcons(icon: "ShareIcon", count: nil)
                    }
                    .padding(.top, 8)
                    padding(.trailing, 16)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        
        // Separator Line
        Divider()
    }
}

// MARK: - Helper View for Action Icons
struct ActionIcons: View {
    var icon: String
    var count: Int?
    
    var body: some View {
        HStack(spacing: 4) {
            Image(icon)
                .font(.subheadline)
            
            if let count = count {
                Text(count.formatCompact()) // Using the custom extension
                    .font(.caption)
                    .lineLimit(1)
            }
        }
        .foregroundColor(.secondary) // Icons are gray by default
        // CRITICAL: This ensure each button takes up equal width (25% each)
        // preventing layout ahifts when numbers get larger.
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Integer Extension for Compact Formatting
// Converts raw numbers into readable formats like 1.2K or 3.5M.
extension Int {
    func formatCompact() -> String {
        let number = Double(self)
        let thousand = number / 1000
        let million = number / 1000000
        
        if million >= 1.0 {
            return String(format:"%.1fM", million)
        } else if thousand >= 1.0 {
            return String(format: "%.1fK", thousand)
        } else {
            return "\(self)"
        }
    }
}


// Design Preview
// We are testing how the interface looks with mock data.
#Preview {
    VStack {
        // Example 1: Standard Tweet
        TweetRowView(tweet: Tweet(id: "1", text: "Testing the layout stability. Even with large numbers, the buttons should remain aligned.", created_at: "2025", author_id: "1"))
        
        // Example 2: Checking alignment consistency
        TweetRowView(tweet: Tweet(id: "2", text: "Short tweet.", created_at: "2025", author_id: "1"))
    }
}
