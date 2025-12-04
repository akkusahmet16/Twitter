//
//  XAPIService.swift
//  Twitter
//
//  Created by Akkuş on 30.11.2025.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class XAPIService: ObservableObject {
    
    @Published var posts: [XTPost] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var userById: [String: XTUser] = [:]
    @Published var mediaByKey: [String: XTMedia] = [:]
    
    private let bearerToken: String
    private var userAccessToken: String?
    
    init(bearerToken: String = Secrets.xBearerToken) {
        self.bearerToken = bearerToken
    }
    
    func setUserAccessToken(_ token: String?) {
        self.userAccessToken = token
    }
    
    //app bearer ile kendi twitlerim
    func fetchUserTweets(userID: String = Secrets.xUserID) async {
    
        print("fetchUserTweets  çağırıldı. UserID = \(userID)")
     
        // x API v2 user timeline endpoint
        //Docs: GET /2/user/:id:tweets
        //max_results=3 - max fetch edilecek tweet sayısı!!
        let urlString = """
            https://api.x.com/2/users/\(userID)/tweets?max_results=5&tweet.fields=created_at
            """
        
        guard let url = URL(string: urlString) else {
            self.errorMessage = "Geçersiz URL"
            print("Geçersiz URL: \(urlString)")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            print("Response geldi")
            
            guard let http = response as? HTTPURLResponse else {
                self.errorMessage = "Geçersiz Response"
                print("http değil response")
                return
            }
            
            print("status code: \(http.statusCode)")
            
            //429 gibi hataları yakala
            guard (200...299).contains(http.statusCode) else {
                let body = String(data: data, encoding: .utf8) ?? ""
                //self.errorMessage = "X API hata: \(http.statusCode)\n\(body)"
                let msg = "X api hata: \(http.statusCode)\n\(body)"
                print("status code: \(http.statusCode)")
                print("headers: \(http.allHeaderFields)")
                
                if let resetStr = http.allHeaderFields["x-rate-limit-reset"] as? String,
                   let resetInt = Int(resetStr) {
                    let resetDate = Date(timeIntervalSince1970: TimeInterval(resetInt))
                    print("Bu endpoint için limit şurda sıfırlanacak: \(resetDate)")
                }
                
                self.errorMessage = msg
                print("hata: \(msg)")
                return
            }
            
            // debug için gelen JSON'u bir kere loglayalım
            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON response:\n\(jsonString)")
            }
            
            do {
                
                let decoded = try JSONDecoder().decode(XTUserTimeLineResponse.self, from: data)
                self.posts = decoded.data ?? []
                self.errorMessage = nil
                print("decode ok, post sayısı = \(self.posts.count)")
            } catch {
                self.errorMessage = "Decode Hatası: \(error.localizedDescription)"
                print("decode hatası: \(error)")
            }
        } catch {
            self.errorMessage = "istek patladı: \(error.localizedDescription)"
            print("istek patladı: \(error)")
        }
    }
    
    //Home timeline çekme
    func fetchHomeTimeline(for userId: String) async {
        guard let token = userAccessToken else {
            self.errorMessage = "Önce kullanıcı girişi yapman lazım."
            print("Home Time Line: Access Token yok")
            return
        }
        
        let urlString = """
        https://api.x.com/2/users/\(userId)/timelines/reverse_chronological?max_results=5&tweet.fields=created_at,attachments,public_metrics,referenced_tweets&expansions=author_id,attachments.media_keys&user.fields=name,username,profile_image_url&media.fields=url,preview_image_url,width,height,type
        """
        
        print("Home timeline isteği URL: \(urlString)")
        await performTimeLineRequest(urlString: urlString, token: token)
    }
    
    @MainActor
    private func performTimeLineRequest(urlString: String, token: String) async {
        // Aynı anda birden fazla timeline çekme isteğini engeller
        if isLoading { return }
        isLoading = true
        defer { isLoading = false }
        
        guard let url = URL(string: urlString) else {
            self.errorMessage = "Geçersiz URL"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let http = response as? HTTPURLResponse else {
                self.errorMessage = "Geçersiz response"
                return
            }
            
            guard (200...299).contains(http.statusCode) else {
                let txt = String(data: data, encoding: .utf8) ?? ""
                self.errorMessage = "X API hatası: \(http.statusCode)\n\(txt)"
                return
            }
            
            let decoded = try JSONDecoder().decode(XTUserTimeLineResponse.self, from: data)
            
            // POST LISTESİ
            self.posts = decoded.data ?? []
            
            // KULLANICI DICTIONARY (author_id → user)
            if let users = decoded.includes?.users {
                self.userById = Dictionary(uniqueKeysWithValues:
                    users.map { ($0.id, $0) }
                )
            } else {
                self.userById = [:]
            }
            
            // MEDYA DICTIONARY (media_key → media)
            if let media = decoded.includes?.media {
                self.mediaByKey = Dictionary(uniqueKeysWithValues:
                    media.map { ($0.media_key, $0) }
                )
            } else {
                self.mediaByKey = [:]
            }
            
            print("➡️ Post sayısı:", posts.count)
            print("➡️ User sayısı:", userById.count)
            print("➡️ Media sayısı:", mediaByKey.count)
            
            self.errorMessage = nil
            
        } catch {
            self.errorMessage = "İstek Patladı: \(error.localizedDescription)"
        }
    }
}

