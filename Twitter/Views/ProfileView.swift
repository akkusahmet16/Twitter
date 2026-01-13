//
//  ProfileView.swift
//  Twitter
//
//

import SwiftUI

struct ProfileView: View {
    // MARK: - Properties
    // Handles the dismissal of the view (Back button logic)
    @Environment(\.presentationMode) var mode
    
    // Animation namespace for the sliding filter bar
    @Namespace var animation
    @State private var selectionFilter: String = "Tweets"
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: - 1. Top navigation Bar
            // Custom navigation bar with a back button and a search button overlaying the header.
            HStack {
                Button {
                    mode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.black.opacity(0.6))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Button {
                    // Action for search (placeholder)
                } label: {
                    Image("SearchIcon")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.black.opacity(0.6))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal)
            // Ensure the buttons are reachable within the Safe Area
            .padding(.top, 50)
            .zIndex(1) // Keeps navigation on the top of the header image
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    // MARK: - 2. Parallax Header
                    // Uses GeometryReader to create a stretching effect when pulling down.
                    GeometryReader { reader in
                        let y = reader.frame(in: .global).minY
                        
                        Image("HeaderImage") // Ensure "HeaderImage" exist in Assets, or it will be empty
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            // Adjust height dynamically based on scroll offset (y)
                            .frame(width: UIScreen.main.bounds.width, height: y > 0 ? 150 + y : 150)
                            .clipped()
                            .offset(y: y > 0 ? -y : 0) // Moves image up/down to create parallax
                    }
                    .frame(height: 150)
                    
                    // MARK: - 3. Profile Info Area
                    // Contains Avatar, Edit Button, and User Details
                    
                    // Avatar & Edit Profile Button Row
                    HStack(alignment: .bottom) {
                        Image("taklalie60profile") // Your custom asset
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 75, height: 75)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color(.systemBackground), lineWidth: 4)) // Border
                            .offset(y: -35) // Overlay with the header
                        
                        Spacer()
                        
                        Button {
                            // Edit Profile Action (Placeholder)
                        } label: {
                            Text("Edit Profile")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                )
                        }
                        .offset(y: -10)
                    }
                    .padding(.horizontal)
                    
                    // User Details (Name, Bio, Location)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("ʇɐʞlɐlı ǝ60")
                            .font(.title2).bold()
                            .foregroundColor(.primary)
                        Text("@taklalie60")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("iOS Developer | Swift & SwiftUI | Coffe Lover")
                            .font(.body)
                            .foregroundColor(.primary)
                            .padding(.vertical, 8)
                        
                        // Metadata Row (Location & Date)
                        HStack(spacing: 16) {
                            HStack(spacing: 4) {
                                Image("LocationIcon")
                                Text("Bursa, TR")
                            }
                            HStack(spacing: 4) {
                                Image("CalendarIcon")
                                Text("Joined January 2026")
                            }
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                        
                        // Follower Counts
                        HStack(spacing: 16) {
                            HStack(spacing:4) {
                                Text("356").bold().foregroundColor(.primary)
                                Text("Following").foregroundColor(.secondary)
                            }
                            HStack(spacing: 4) {
                                Text("175").bold().foregroundColor(.primary)
                                Text("Followers").foregroundColor(.secondary)
                            }
                        }
                        .font(.subheadline)
                        .padding(.vertical, 8)
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // MARK: - 4. Sliding Filter Bar
                    // Allows switching between Tweets, Replies, etc.
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            FilterButton(title: "Tweets")
                            FilterButton(title: "Replies")
                            FilterButton(title: "Media")
                            FilterButton(title: "Likes")
                        }
                        Divider()
                    }
                    .padding(.top, 10)
                    
                    // MARK: - 5. Tweet List
                    // Displaysthe tweets belonging to this user.
                    // Using mock data for UI demonstration.
                    LazyVStack(spacing: 0) {
                        ForEach(0..<10) { _ in
                            TweetRowView(tweet: Tweet(
                                id: UUID().uuidString,
                                text: "This is a mock tweet for the profile view, It demonstrates how the list scrolls beneath the header.",
                                created_at: "Now",
                                author_id: "1",
                                authorName: "taklalıe60",
                                authorUsername: "@taklalie60",
                                authorAvatar: "taklalie60profile",
                                isSystemAvatar: false,
                                replyCount: Int.random(in: 0...50),
                                retweetCount: Int.random(in: 0...100),
                                likeCount: Int.random(in: 0...5000)
                            ))
                        }
                    }
                }
            }
        }
        .ignoresSafeArea(.all, edges: .top) // Allows header image to touch the top edge
        .background(Color(.systemBackground))
        .navigationBarHidden(true) // Hides default nav bar to use our custom one
    }
    
    // MARK: - Helper Component: Filter Button
    @ViewBuilder
    func FilterButton(title: String) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.subheadline)
                .fontWeight(selectionFilter == title ? .bold : .regular)
                .foregroundColor(selectionFilter == title ? .blue : .secondary)
            
            // Animated Underline Indicator
            if selectionFilter == title {
                Capsule()
                    .foregroundColor(.blue)
                    .frame(height: 3)
                // MatchedGeometryEffect handles the sliding animation
                    .matchedGeometryEffect(id: "filter", in: animation)
            } else {
                Capsule()
                    .foregroundColor(.clear)
                    .frame(height: 3)
            }
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle()) // Expands tap area
        .onTapGesture {
            withAnimation(.easeInOut) {
                selectionFilter = title
            }
        }
    }
}

#Preview {
    ProfileView()
}
