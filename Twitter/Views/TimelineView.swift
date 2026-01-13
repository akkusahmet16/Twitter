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
    
    @Binding var showMenu: Bool
    
    // Controls the presentation of the New Tweet sheet.
    @State private var showNewTweetSheet = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) { // Align FAB to the bottom right corner
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
                        Image("TwitterLogo")
                            .font(.system(size: 60))
                            .foregroundColor(.blue.opacity(0.5))
                        
                        Text("Flow Empty")
                            .font(.title2)
                            .bold()
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // Spread across the screen and center
                }
                else {
                    // LIST (Data Received)
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.tweets) { tweet in
                                // 1. Wrap the row in NavigationLink
                                NavigationLink {
                                TweetDetailView(tweet: tweet)
                                } label: {
                                    TweetRowView(tweet: tweet)
                                }
                                // 2. Apply Plain Button Style
                                // This prevents the text from turning blue and removes the list selection effect.
                                .buttonStyle(.plain)
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
                    Image("NewTweetIcon")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 70, height: 70)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 4)
                }
                .padding()
                // Ensure the button doesn't move up when the keyboard appears.
                .ignoresSafeArea(.keyboard, edges: .bottom)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            
            // MARK: - Custom ToolBar
            .toolbar {
                // 1. LEFT: Profile Picture
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation {
                            showMenu.toggle()
                        }
                        print("profile tap")
                    } label: {
                        Image("taklalie60profile")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .clipShape(Circle())
                            .foregroundColor(.primary)
                    }
                }
                
                // 2. MIDDLE: Twitter Logo (this is the main part)
                ToolbarItem(placement: .principal) {
                    Image("TwitterLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                }
                
                // 3. RIGHT: Features Icon
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        print("Features tap")
                    } label: {
                        Image("FeatureIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                }
            }
            // Presents the 'NewTweetView' as a modal sheet.
            .fullScreenCover(isPresented: $showNewTweetSheet) {
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
