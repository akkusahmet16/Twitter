//
//  APIManager.swift
//  Twitter
//
//  Created by Akkuş on 30.12.2025.
//

import Foundation

// MARK: - API Manager
// Singleton class responsible for handling all network requests.
class APIManager {
    
    static let shared = APIManager()
    
    // Custom Error Types
    enum APIError: Error {
        case invalidURL
        case invalidResponse
        case serverError(String)
    }
    
    private init() {}
    
    // MARK: - Fetch Tweets (Hybrid Mode)
    /// Fetches tweets from the Real API. Falls back to Mock Data if rate-limited or unauthorized.
    func fetchTweets(userId: String) async throws -> [Tweet] {
        
        let urlString = "https://api.twitter.com/2/users/\(userId)/tweets?tweet.fields=created_at,author_id&max_results=5"
        
        guard let url = URL(string: urlString) else { return generateMockTweets() }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // OAuth 1.0a Authentication
        let authHeader = OAuth.generateHeader(url: urlString, method: "GET", params: [:])
        request.setValue(authHeader, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print("APIManager: Requesting timeline data...")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                // Fallback on 401 (Unauthorized) or 429 (Too Many Requests)
                if httpResponse.statusCode != 200 {
                    print("API Limit/Error (Code: \(httpResponse.statusCode)). Switching to Mock Data.")
                    return generateMockTweets()
                }
            }
            
            let decodedResponse = try JSONDecoder().decode(TwitterResponse.self, from: data)
            print("Success: Real API data received!")
            return decodedResponse.data ?? generateMockTweets()
            
        } catch {
            print("Network Error: \(error). Returning Mock Data.")
            return generateMockTweets()
        }
    }
    
    // MARK: - Post Tweet
    func sendTweet(text: String) async throws -> Bool {
        let urlString = "https://api.twitter.com/2/tweets"
        guard let url = URL(string: urlString) else { throw APIError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let authHeader = OAuth.generateHeader(url: urlString, method: "POST", params: [:])
        request.setValue(authHeader, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = ["text": text]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            return false
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else { throw APIError.invalidResponse }
        
        if httpResponse.statusCode == 201 {
            print("✅ Tweet successfully posted!")
            return true
        } else {
            let errorBody = String(data: data, encoding: .utf8) ?? "Unknown"
            print("❌ Post Error: \(httpResponse.statusCode) - \(errorBody)")
            throw APIError.serverError(errorBody)
        }
    }
    
    // MARK: - Mock Data Generator
    private func generateMockTweets() -> [Tweet] {
        return [
            Tweet(
                id: UUID().uuidString,
                text: "Sende yargılanacaksın Elon Musk!",
                created_at: "2025-01-08T10:00:00Z",
                author_id: "1",
                authorName: "ʇɐʞlɐlı ǝ60",
                authorUsername: "taklalie60",
                authorAvatar: "taklalie60profile",
                isSystemAvatar: false, // Asset Image
                replyCount: 32,
                retweetCount: 12,
                likeCount: 63214
            ),
            Tweet(
                id: UUID().uuidString,
                text: "SwiftUI layout engine is pure magic once you understand Frames vs Spacers.",
                created_at: "2025-01-07T12:00:00Z",
                author_id: "2",
                authorName: "Sarah Connor",
                authorUsername: "sarah_c",
                authorAvatar: "person.circle.fill",
                isSystemAvatar: true,
                replyCount: 21,
                retweetCount: 51,
                likeCount: 849
            ),
            Tweet(
                id: UUID().uuidString,
                text: "Mock data is a lifesaver when the API rate limit hits hard.",
                created_at: "2025-01-08T09:30:00Z",
                author_id: "3",
                authorName: "Tech Insider",
                authorUsername: "tech_insider",
                authorAvatar: "person.circle.fill",
                isSystemAvatar: true,
                replyCount: 102,
                retweetCount: 850,
                likeCount: 5400
            ),
            Tweet(
                id: UUID().uuidString,
                text: "Hello World! Checking the responsive design on iPhone SE.",
                created_at: "2025-01-07T11:00:00Z",
                author_id: "4",
                authorName: "John Doe",
                authorUsername: "johndoe",
                authorAvatar: "person.circle.fill",
                isSystemAvatar: true,
                replyCount: 0,
                retweetCount: 1,
                likeCount: 4
            )
        ]
    }
}
