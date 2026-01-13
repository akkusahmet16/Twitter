//
//  TweetDetailView.swift
//  Twitter
//

import SwiftUI

struct TweetDetailView: View {
    
    // MARK: - Properties
    let tweet: Tweet
    @Environment(\.dismiss) var dismiss // To go back manually if needed
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                
                // MARK: - 1. User Info Header
                HStack(spacing: 12) {
                    // Dynamic Avatar Logic
                    if tweet.isSystemAvatar {
                        Image(systemName: tweet.authorAvatar ?? "person.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                            .clipShape(Circle())
                    } else {
                        Image(tweet.authorAvatar ?? "")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(tweet.authorName ?? "Unknown")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text("@\(tweet.authorUsername ?? "unknown")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    // Option Menu (Three dots)
                    Button {
                        //Action sheet for reporting/blocking
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                
                // MARK: - 2. Tweet Content (Big Text)
                Text(tweet.text)
                    .font(.title3) // Standart body font but slightly larger
                    .foregroundColor(.primary)
                    .padding(.horizontal)
                    .padding(.bottom, 12)
                
                // MARK: - 3. Meta Data (Date& Time)
                // Mock date for now, can be formatted from 'tweet.created_at' later
                HStack(spacing: 4) {
                    Text("10:30 AM")
                    Text("•")
                    Text("13 Jan 26")
                    Text("•")
                    Text("Twitter for iPhone")
                        .foregroundColor(.blue)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.horizontal)
                .padding(.bottom, 16)
                
                Divider()
                
                // MARK: - 4. Stats (Retweets & Likes)
                HStack(spacing: 24) {
                    HStack(spacing: 4) {
                        Text("\(tweet.retweetCount)").bold()
                        Text("Retweets").foregroundColor(.secondary)
                    }
                    HStack(spacing: 4) {
                        Text("\(tweet.likeCount)").bold()
                        Text("Likes").foregroundColor(.secondary)
                    }
                }
                .font(.subheadline)
                .padding()
                
                Divider()
                
                // MARK: - 5. Big Action Buttons
                HStack {
                    Spacer()
                    BigActionButton(icon: "CommentIcon")
                    Spacer()
                    BigActionButton(icon: "RetweetIcon")
                    Spacer()
                    BigActionButton(icon: "HeartIcon")
                    Spacer()
                    BigActionButton(icon: "ShareIcon")
                    Spacer()
                }
                .padding(.vertical,12)
                
                Divider()
                
                // MARK: - 6. Replies Section
                // Mocking replies using TweetRowView for consistency
                LazyVStack(spacing: 0) {
                    ForEach(0..<5) { _ in
                        TweetRowView(tweet: Tweet(
                            id: UUID().uuidString,
                            text: "This is a reply to the tweet above.",
                            created_at: "Now",
                            author_id: "reply_user",
                            authorName: "Reply User",
                            authorAvatar: "person.circle.fill",
                            isSystemAvatar: true,
                            replyCount: 2,
                            retweetCount: 0,
                            likeCount: 12
                            
                        ))
                    }
                }
            }
        }
        .navigationTitle("Tweet")
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

struct BigActionButton: View {
    let icon: String
    
    var body: some View {
        Button {
            // Action
        } label: {
            Image(icon)
                .font(.title2)
        }
    }
}
