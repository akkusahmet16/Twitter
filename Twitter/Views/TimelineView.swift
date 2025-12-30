//
//  TimelineView.swift
//  Twitter
//
//  Created by Akkuş on 30.12.2025.
//

import SwiftUI

struct TimelineView: View {
    
    // ViewModel connection
    // Data management and business logic revolve entirely around the ViewModel.
    // View only observes the state
    @StateObject private var viewModel = TimelineViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background color (If necessary)
                Color.white.ignoresSafeArea()
                
                if viewModel.isLoading {
                    ProgressView("Loading Tweets...")
                } else if let errorMessage = viewModel.errorMessage {
                    // Error notification screen
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text("An error occurred")
                            .font(.headline)
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Button("Try Again") {
                            Task {
                                await viewModel.getTweets()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    // We are displaying the list in a successful state
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.tweets) { tweet in
                                TweetRowView(tweet: tweet)
                                // Click actions can be added here
                            }
                        }
                    }
                    // "Pull to Refresh" feature
                    .refreshable {
                        await viewModel.getTweets()
                    }
                }
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // The left and right navbar buttons will be added here (Profile, Settings, etc.)
                ToolbarItem(placement: .navigationBarLeading) {
                                    Button(action: {
                                        // Profil menüsü açılacak
                                    }) {
                                        Image(systemName: "person.circle")
                                    }
                                }
            }
            // MARK: Due to xAPI limitations, the auto-renewal feature is currently disabled.
            /*
            // We start pulling the data when the view first opens.
            .task {
                // If the list is empty, fetch the data; if it is full (if you have returned from another page), do not fetch it again.
                if viewModel.tweets.isEmpty {
                    await viewModel.getTweets()
                }
            }
            */
        }
    }
}

#Preview {
    TimelineView()
}
