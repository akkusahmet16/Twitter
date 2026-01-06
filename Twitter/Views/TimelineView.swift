//
//  TimelineView.swift
//  Twitter
//
//  Created by Akkuş on 30.12.2025.
//

import SwiftUI

struct TimelineView: View {
    
    @StateObject private var viewModel = TimelineViewModel()
    
    // We are listening for the refresh signal from MainTabView.
    @Binding var refreshTrigger: Bool
    
    // Visibility status of the tweet screen
    @State private var showNewTweetSheet = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) { // Align FAB to the bottom right corner
                
                Color.white.ignoresSafeArea()
                
                // --- CONTENT MANAGEMENT ---
                
                if viewModel.isLoading {
                    // LOADING
                    ProgressView("Loading Tweets...")
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity) // Spread across the screen and center
                }
                else if let errorMessage = viewModel.errorMessage {
                    // Error Screen
                    VStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text("Could not load")
                            .font(.headline)
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.gray)
                        Button("Try Again") {
                            triggerRefresh()
                        }
                        .padding(.top, 4)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                else if viewModel.tweets.isEmpty {
                    // BLANK SCREEN
                    VStack(spacing: 20) {
                        Image(systemName: "bird")
                            .font(.system(size: 60))
                            .foregroundColor(.blue.opacity(0.5))
                        
                        Text("Flow Empty")
                            .font(.title2)
                            .bold()
                        
                        Text("Tap the Home icon below to see the tweets.")
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // Spread across the screen and center
                }
                else {
                    // LIST (Data Received)
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.tweets) { tweet in
                                TweetRowView(tweet: tweet)
                            }
                        }
                    }
                    .refreshable {
                        await viewModel.getTweets()
                    }
                }
                
                // Floating Action Button (FAB) - To be activated in the future
                /*
                Button {
                    showNewTweetSheet = true
                } label: {
                    Image(systemName: "plus")
                    // ... Design codes ...
                }
                */
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "person.circle")
                        .foregroundColor(.primary)
                }
            }
            // Signal Listener
            .onChange(of: refreshTrigger) { _ in
                triggerRefresh()
            }
            // AUTO-START: Fetch data when the application opens
            .task {
                if viewModel.tweets.isEmpty {
                    print("The application has opened, data is being requested...")
                    await viewModel.getTweets()
                }
            }
        }
    }
    
    private func triggerRefresh() {
        Task {
            print("Data retrieval request triggered...")
            await viewModel.getTweets()
        }
    }
}

#Preview {
    TimelineView(refreshTrigger: .constant(false))
}
