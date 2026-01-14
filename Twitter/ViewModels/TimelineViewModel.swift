//
//  TimelineViewModel.swift
//  Twitter
//
//  Created by Akkuş on 30.12.2025.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class TimelineViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var tweets: [Tweet] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // MARK: - Private Storage & Persistence Keys
    private var localUserTweets: [Tweet] = []
    private let saveKey = "saved_local_tweets" // Key for UserDefaults
    
    // MARK: - Initializer
    init() {
        // Load saved tweets from disk when the ViewModel is created (App start)
        loadLocalTweets()
    }
    
    // MARK: - Fetch Data
    func getTweets() async {
        isLoading = true
        errorMessage = nil
        
        // Ensure loading state is reset even if error occurs
        defer {
            isLoading = false
        }
        
        do {
            let userId = "11348282" // Target User ID
            let fetchedTweets = try await APIManager.shared.fetchTweets(userId: userId)
            
            // Merge Local Tweets with API Tweets
            // We put local tweets at the beginning so they persist after refresh
            self.tweets = self.localUserTweets + fetchedTweets
            print("ViewModel: \(fetchedTweets.count) tweets loaded.")
            
        } catch {
            self.errorMessage = error.localizedDescription
            print("ViewModel Error: \(error)")
        }
    }
    
    // MARK: - Locak Tweet Logic
    func addLocalTweet(text: String) {
        let newTweet = Tweet(id: UUID().uuidString,
                             text: text,
                             created_at: "Just Now",
                             author_id: "current_user",
                             authorName: "taklali e60",
                             authorUsername: "taklalie60",
                             authorAvatar: "taklalie60profile",
                             isSystemAvatar: false,
                             replyCount: 0,
                             retweetCount: 0,
                             likeCount: 0
                        )
        
        // 1. Add to local storage (So it survives refresh)
        localUserTweets.insert(newTweet, at: 0)
        
        // 2. Persist to Disk (Save permanetly)
        saveLocalTweets()
        
        // 3. Add to current view immediately with animation
        withAnimation {
            self.tweets.insert(newTweet, at: 0)
        }
    }
    
    // MARK: - Persistence Methods (Save & Load)
    
    /// Saves the 'localUserTweets' arrray to UserDefaults as JSON data
    private func saveLocalTweets() {
        do {
            let data = try JSONEncoder().encode(localUserTweets)
            UserDefaults.standard.set(data, forKey: saveKey)
            print("Local tweets saved to disk")
        } catch {
            print("Failed to save tweets: \(error)")
        }
    }
    
    /// Loads save tweets from UserDefaults.
    private func loadLocalTweets() {
        guard let data = UserDefaults.standard.data(forKey: saveKey) else { return }
        
        do {
            let savedTweets = try JSONDecoder().decode([Tweet].self, from: data)
            self.localUserTweets = savedTweets
            print("Loaded\(savedTweets.count) twets from disk")
        } catch {
            print("Failed to load twets: \(error)")
        }
    }
}
