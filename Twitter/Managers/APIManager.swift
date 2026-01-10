import Foundation

class APIManager {
    
    static let shared = APIManager()
    
    // Hata Tanımları
    enum APIError: Error {
        case invalidURL
        case invalidResponse
        case serverError(String)
    }
    
    private init() {}
    
    // MARK: - 1. Fetch Tweets (GET) - Hybrid Mode
    /// Attempts to fetch real tweets first. If the API rate limits or permissions fail ( common in Free Tier),
    /// it automatically falls back to Mock Data to ensure the UI remains populated.
    func fetchTweets(userId: String) async throws -> [Tweet] {
        
        // Target User ID (e.g., Nasa: 11348282) for testing.
        // we limit results to 5 to converse the monthly cap if ti exists.
        let urlString = "https://api.twitter.com/2/users/11348282/tweets?tweet.fields=created_at,author_id&max_results=5"
        
        guard let url = URL(string: urlString) else { return generateMockTweets() }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Even for GET requests, we use OAuth 1.0a to maximize success probability.
        let authHeader = OAuth.generateHeader(url: urlString, method: "GET", params: [:])
        request.setValue(authHeader, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print("APIManager: Attempting to fetch real timeline data...")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                // If we hit a 429 (Rate Limit) or 401/403 (Unauthorized), fallback to Mock Data.
                if httpResponse.statusCode != 200 {
                    print("API Restriction (Code: \(httpResponse.statusCode)). Switching to Mock Data fallback.")
                    return generateMockTweets()
                }
            }
            let decodedResponse = try JSONDecoder().decode(TwitterResponse.self, from: data)
            print("Success: Real API data received!")
            return decodedResponse.data ?? generateMockTweets()
        } catch {
            print("Network or Decoding Error: \(error). Returning Mock Data.")
            return generateMockTweets()
        }
    }
    
    // MARK: - mock Data Generator
    /// Returns a list of dummy tweets to simulate a populated feed when the API is unavailable.
    private func generateMockTweets() -> [Tweet] {
        return [
            Tweet(id: "1", text: "This tweet is displayed via Mock Data due to API limits. But the tweet you are about to post will be REAL! 😎", created_at: "2025-01-08T10:00:00Z", author_id: "1"),
            Tweet(id: "2", text: "Building an X Clone with SwiftUI is more fun than I expected.", created_at: "2025-01-08T09:30:00Z", author_id: "1"),
            Tweet(id: "3", text: "Testing the timeline fallback mechanism...", created_at: "2025-01-07T12:00:00Z", author_id: "1")
        ]
    }
    
    // --- 2. POST A TWEET - REAL API MODE ---
    // This will actually work because the Free Tier allows you to tweet.
    func sendTweet(text: String) async throws -> Bool {
        
        let urlString = "https://api.twitter.com/2/tweets"
        
        guard let url = URL(string: urlString) else { throw APIError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // --- CHANGE: using OAuth 1.0a instead of Bearer Token ---
        // This generates a unique signature for every request using your Access Tokens.
        let authHeader = (OAuth.generateHeader(url: urlString, method: "POST", params: [:]))
        
        request.setValue(authHeader, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print("Outgoing Header: \(authHeader)")
        
        let body: [String: String] = ["text": text]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            print("JSON Error")
            return false
        }
        
        print("Sending Tweet via OAuth 1.0a...")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else { throw APIError.invalidResponse }
        
        // 201 Created = Successful
        if httpResponse.statusCode == 201 {
            print("Tweet successfully sent! (Real API)")
            return true
        } else {
            let errorBody = String(data: data, encoding: .utf8) ?? "Unknown Error"
            print("Tweet Error: \(httpResponse.statusCode) - \(errorBody)")
            throw APIError.serverError(errorBody)
        }
    }
}
