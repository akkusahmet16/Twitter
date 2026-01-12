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
    
    @Published var tweets: [Tweet] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // Fetch data asynchronously
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
            self.tweets = fetchedTweets
            print("ViewModel: \(fetchedTweets.count) tweets loaded.")
            
        } catch {
            self.errorMessage = error.localizedDescription
            print("ViewModel Error: \(error)")
        }
    }
}
