import Foundation
import SwiftUI
import Combine

@MainActor
class TimelineViewModel: ObservableObject {
    
    @Published var tweets: [Tweet] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    func getTweets() async {
        print("ViewModel: Data retrieval process has started.")
        isLoading = true
        errorMessage = nil
        
        // DEFER: This runs after the function completes (even if an error occurs).
        // Prevents the "Loading" message from getting stuck.
        defer {
            isLoading = false
            print("ViewModel: The loading status has been closed.")
        }
        
        do {
            let userId = "11348282"
            
            let fetchedTweets = try await APIManager.shared.fetchTweets(userId: userId)
            
            self.tweets = fetchedTweets
            print("ViewModel: \(fetchedTweets.count) tweets successfully uploaded.")
            
        } catch {
            self.errorMessage = "Error: \(error.localizedDescription)"
            print("ViewModel Error: \(error)")
        }
    }
}
