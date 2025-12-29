//
//  APIManager.swift
//  Twitter
//
//  Created by Akkuş on 29.12.2025.
//

import Foundation

class APIManager {
    // Singleton: Accessible from anywhere
    static let shared = APIManager()
    
    // My own error definitions (Cleaner and clearer)
    enum APIError: Error {
        case invaildURL
        case invaildResponse
        case serverError(String) // Carries the error message from the server
    }
    
    private init() {}
    
    // The function that pulls tweets
    func fetchTweets(userId: String) async throws -> [Tweet] {
        
        // MARK: 1. Endpoint: The address for fetching a user's tweets
        // Note: Due to Elon Musk changing the API, the limits on the Free tier are very strict.
        
        let urlString = "https://api.twitter.com/2/users/\(userId)/tweets?tweet.fields=created_at,author_id"
        
        guard let url = URL(string: urlString) else {
            throw APIError.invaildURL
        }
        
        
        // MARK: 2. Request Preparation
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // ATTENTION: We are retrieving the password from the Secrets file.
        request.setValue("Baere \(Secrets.bearerToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        // MARK: 3. Submit Request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check the response code (200 OK?)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if httpResponse.statusCode != 200 {
            // If there is an error, print it to the console
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown Error"
            print("API Error: \(httpResponse.statusCode) - \(errorMessage)")
            throw URLError(.badServerResponse)
        }
        
        
        // MARK: 4. Converting incoming JSON data to a Swift object (Decoding)
        let decodedResponse = try JSONDecoder().decode(TwitterResponse.self, from: data )
        
        // EIf the data is empty, it returns an empty array.
        return decodedResponse.data ?? []
        
    }
}
