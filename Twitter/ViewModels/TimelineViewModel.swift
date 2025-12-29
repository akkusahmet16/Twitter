//
//  TimelineViewModel.swift
//  Twitter
//
//  Created by Akkuş on 29.12.2025.
//

import Foundation
import SwiftUI
import Combine

//@MainActor: Ensures that tasks that update the interface are performed on the main thread.
//To prevent the UI from freezing or crashing

@MainActor
class TimelineViewModel: ObservableObject {
    
    // Data (variables) to be displayed on the screen
    @Published var tweets: [Tweet] = [] // Tweet List
    @Published var isLoading: Bool = false // is Loading?
    @Published var errorMessage: String? = nil // Is there an error message?
    
    // The function that pulls tweets
    func getTweets() async {
        
        // Start the loading animation
        isLoading = true
        errorMessage = nil
        
        do {
            // FOR TESTING: You need a Twitter User ID here.
            // In XAPI v2, a numeric ID (like 123456) is used instead of a username (@username).
            // For now, you can enter Elon Musk's ID or any ID you know here for testing.
            // If you don't know the ID, the "me" endpoint is different; for now, let's use the ID.
            // EXAMPLE: NASA's ID: "11348282"
            let userId = "11348282"
            
            // We tell the manager, "Go get the data."
            let fetchedTweets = try await APIManager.shared.fetchTweets(userId: userId)
            
            // We are adding the incoming data to the list.
            self.tweets = fetchedTweets
        } catch {
            // If there is an error, we catch the message
            self.errorMessage = "Tweets Could Not Be Retrieved: \(error.localizedDescription)"
            print("ViewModel Error: \(error)")
            
            // Process complete, loading icon closed
            isLoading = false
        }
    }
}
