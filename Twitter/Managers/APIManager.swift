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
    
    // --- 1. GET TWEET - MOCK DATA MODE---
    // We are forced to convert fake data because the API does not allow it.
    func fetchTweets(userId: String) async throws -> [Tweet] {
        
        print(" Due to Free Tier restrictions, Mock Data is being loaded...")
        
        // Sahte Tweetler Listesi
        return [
            Tweet(id: "1", text: "This tweet was created as a fake due to API restrictions. But the design looks great! 🔥", created_at: "2025-12-31T12:00:00Z", author_id: "1"),
            Tweet(id: "2", text: "Developing applications with SwiftUI and the MVVM architecture is a lot of fun. The XClone project is moving full steam ahead.", created_at: "2025-12-31T11:45:00Z", author_id: "1"),
            Tweet(id: "3", text: "Elon Musk may have made the timeline feature paid, but it won't stop Turkish developers. 🚀", created_at: "2025-12-30T09:30:00Z", author_id: "1"),
            Tweet(id: "4", text: "Don't forget to drink coffee while coding. You'll need it when debugging. ☕️", created_at: "2025-12-29T14:20:00Z", author_id: "1"),
            Tweet(id: "5", text: "Let's not forget to commit to GitHub. We don't want any regrets later.", created_at: "2025-12-28T16:10:00Z", author_id: "1")
        ]
    }
    
    // --- 2. POST A TWEET - REAL API MODE ---
    // This will actually work because the Free Tier allows you to tweet.
    func sendTweet(text: String) async throws -> Bool {
        
        let urlString = "https://api.twitter.com/2/tweets"
        
        guard let url = URL(string: urlString) else { throw APIError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // We are using the actual tokens in the Secrets file.
        // OAUTH 1.0a may be required, but for now we are trying Bearer.
        // OAUTH 1.0a may be required, but for now we are trying Bearer.
        request.setValue("Bearer \(Secrets.bearerToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = ["text": text]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            print("JSON Error")
            return false
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else { throw APIError.invalidResponse }
        
        // 201 Created = Successful
        if httpResponse.statusCode == 201 {
            print("✅ Tweet successfully sent! (Real API)")
            return true
        } else {
            let errorBody = String(data: data, encoding: .utf8) ?? "Unknown Error"
            print("🚨 Tweet Error: \(httpResponse.statusCode) - \(errorBody)")
            throw APIError.serverError(errorBody)
        }
    }
}
