//
//  MessageView.swift
//  Twitter
//
//

import SwiftUI
struct MessageView: View {
    
    // MARK: - Properties
    @State private var searchText = ""
    // Load the realistic mock conversations
    let conversations = MockData.conversations
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                // 1. Custom Search Bar
                HStack {
                    Image("SearchIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18)
                    TextField("Search Direct Message", text: $searchText)
                }
                .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .padding()
                
                // 2. Messages List
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(conversations) { conversation in
                            
                            // Navigation Link to the detailed Chat View
                            NavigationLink {
                                ChatView(conversation: conversation)
                            } label: {
                                ConversationRow(conversation: conversation)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .navigationTitle("Messages")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("taklalie60profile")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image("SettingsIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24)
                }
            }
        }
    }
}

// MARK: - Conversation Row Cpmponent
struct ConversationRow: View {
    let conversation: Conversation
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Image(conversation.userImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    
                    HStack {
                        Text(conversation.username)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        if conversation.isVerified {
                            Image("BlueTick")
                                .foregroundColor(.blue)
                                .font(.caption)
                        }
                        
                        Spacer()
                        
                        Text(conversation.timeAgo)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Text(conversation.lastMessage)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            .padding()
            
            // Custom Divider
            Divider().padding(.leading, 70)
        }
        .background(Color(.systemBackground))
    }
}

