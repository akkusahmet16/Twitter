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
        HStack(alignment: .top, spacing:12) {
            
            // Profile Picture Area
            // In the actual application, an asynchronous image loader (AsynImage) will be placed here.
            // For now, a placeholder has been used for design integrity.
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 48, height: 48)
                .foregroundStyle(.gray.opacity(0.5))
                .clipShape(Circle())
            
            // Content and Title Area
            VStack(alignment: .leading, spacing: 4) {
                
                // Title: Name, Username, and Date
                HStack {
                    Text("Kullanıcı") // The author's name from API will appear here in the future.
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("@kullanici") // API'den gelen handle
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    // Helper functions can be added for date formatting.
                    Text("2s")
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
                    actionButton(icon: "bubble.left", count: 12)
                    actionButton(icon: "arrow.2.squarepath", count: 5)
                    actionButton(icon: "heart", count: 34)
                    actionButton(icon: "square.and.arrow.up", count: nil)
                    Spacer()
                }
                .padding(.top, 8)
                .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        // separator line between list items
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(.gray.opacity(0.3)),
            alignment: .bottom
        )
    }
    
    // The helper function that creates action buttons (ViewBuilder)
    // This way, we keep the main body simple.
    @ViewBuilder
    private func actionButton(icon: String, count: Int?) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.subheadline)
            if let count = count {
                Text("\(count)")
                    .font(.caption)
            }
        }
    }
}

// Design Preview
// We are testing how the interface looks with mock data.
#Preview {
    TweetRowView(tweet: Tweet(id: "1", text: "First UI test for our Twitter clone project. We are careful to write clean code using the MVVM architecture.", created_at: nil, author_id: nil))
        .previewLayout(.sizeThatFits)
}
