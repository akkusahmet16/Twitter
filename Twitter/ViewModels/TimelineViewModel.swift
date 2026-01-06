import Foundation
import SwiftUI
import Combine

@MainActor
class TimelineViewModel: ObservableObject {
    
    @Published var tweets: [Tweet] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    func getTweets() async {
        print("🧠 ViewModel: Veri çekme işlemi başladı.")
        isLoading = true
        errorMessage = nil
        
        // DEFER: Fonksiyon bitince (hata olsa bile) burası çalışır.
        // Yükleniyor yazısının takılı kalmasını engeller.
        defer {
            isLoading = false
            print("🧠 ViewModel: Yükleme durumu kapatıldı.")
        }
        
        do {
            // Mock Data olduğu için ID önemli değil ama formalite icabı yazıyoruz.
            let userId = "11348282"
            
            let fetchedTweets = try await APIManager.shared.fetchTweets(userId: userId)
            
            self.tweets = fetchedTweets
            print("🧠 ViewModel: \(fetchedTweets.count) adet tweet başarıyla yüklendi.")
            
        } catch {
            self.errorMessage = "Hata: \(error.localizedDescription)"
            print("🧠 ViewModel Hatası: \(error)")
        }
    }
}
