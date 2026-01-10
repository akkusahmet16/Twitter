//
//  TimelineView.swift
//  Twitter
//
//  Created by Akkuş on 30.12.2025.
//

import SwiftUI

struct TimelineView: View {
    
    // Manages the state and business logic for the timeline data.
    @StateObject private var viewModel = TimelineViewModel()
    
    // Binding to receive refresh signals from the MainTabView.
    @Binding var refreshTrigger: Bool
    
    // Controls the presentation of the New Tweet sheet.
    @State private var showNewTweetSheet = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) { // Align FAB to the bottom right corner
                
                Color.white.ignoresSafeArea()
                
                // --- CONTENT MANAGEMENT ---
                
                if viewModel.isLoading {
                    // LOADING STATE
                    ProgressView("Loading Tweets...")
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity) // Spread across the screen and center
                }
                else if let errorMessage = viewModel.errorMessage {
                    // Error State
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
                    // Empty screen
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
                
                // Floating Action Button (FAB)
                // This button triggers the sheet to compose a new tweet.
                // It utilizes the Real API (Write Access) unlike the read-only timeline.
                Button {
                    showNewTweetSheet = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 56, height: 56)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 4)
                }
                .padding()
                // Ensure the button doesn't move up when the keyboard appears.
                .ignoresSafeArea(.keyboard, edges: .bottom)
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "person.circle")
                        .foregroundColor(.primary)
                }
            }
            // Presents the 'NewTweetView' as a modal sheet.
            .sheet(isPresented: $showNewTweetSheet) {
                NewTweetView()
            }
            
            // Listens for tab bar taps to trigger a refresh.
            .onChange(of: refreshTrigger) { _ in
                triggerRefresh()
            }
            // Automatically fetches mock data when the view appears.
            .task {
                if viewModel.tweets.isEmpty {
                    print("App launched, requesting initial data...")
                    await viewModel.getTweets()
                }
            }
        }
    }
    
    // Helper function to initiate the data fetching task.
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
