//
//  XAuthManager.swift
//  Twitter
//
//  Created by Akkuş on 1.12.2025.
//

import Foundation
import AuthenticationServices
import UIKit
import Combine

struct XUser: Codable {
    let id: String
    let name: String
    let username: String
    let profileImageURL: String?
    let followerCount: Int?
    let followingCount: Int?
}

struct XTokenResponse: Codable {
    let token_type: String
    let access_token: String
    let expires_in: Int?
    let scope: String?
    let refresh_token: String?
}

@MainActor
final class XAuthManager: NSObject, ObservableObject {
    @Published var accessToken: String?
    @Published var refreshToken: String?
    @Published var errorMessage: String?
    @Published var meUserID: String? // /2/users/me'den gelecek
    
    @Published var currentUser: XUser?

    private var currentPKCE: PKCE?
    
    private let accessTokenKey = "x_access_token"
    private let refreshTokenKey = "x_refresh_token"
    private let userKey = "x_current_user"
    
    override init () {
        super.init()
        loadFromStorage()
    }
    
    
    private func loadFromStorage() {
        
        let defaults = UserDefaults.standard
        
        if let token = defaults.string(forKey: accessTokenKey) {
            self.accessToken = token
        }
        
        if let r = defaults.string(forKey: refreshTokenKey) {
            self.refreshToken = r
        }
        
        if let data = defaults.data(forKey: userKey),
           let user = try? JSONDecoder().decode(XUser.self, from: data) {
            self.currentUser = user
            self.meUserID = user.id
        }
    }
    
    private func persist(){
        let defaults = UserDefaults.standard
        
        defaults.set(accessToken, forKey: accessTokenKey)
        defaults.set(refreshToken, forKey: refreshTokenKey)
        
        if let user = currentUser,
           let data = try? JSONEncoder().encode(user) {
            defaults.set(data, forKey: userKey)
        }
    }
    

    func signIn() {
        let pkce = PKCEGenerator.generate()
        self.currentPKCE = pkce

        // Scope'ları tek string'e çevir
        let scopeString = XAuthConfig.scopes.joined(separator: " ")

        let encodedRedirect = XAuthConfig.redirectURI
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            ?? XAuthConfig.redirectURI

        let encodedScopes = scopeString
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            ?? scopeString

        // X OAuth2 authorize URL
        let urlString = """
        https://x.com/i/oauth2/authorize?response_type=code&client_id=\(XAuthConfig.clientID)&redirect_uri=\(encodedRedirect)&scope=\(encodedScopes)&state=\(pkce.state)&code_challenge=\(pkce.challenge)&code_challenge_method=S256
        """

        guard let url = URL(string: urlString) else {
            self.errorMessage = "Authorize URL oluşturulamadı"
            return
        }

        let session = ASWebAuthenticationSession(
            url: url,
            callbackURLScheme: XAuthConfig.callbackScheme
        ) { [weak self] callbackURL, error in
            guard let self else { return }

            if let error = error {
                self.errorMessage = "Giriş iptal / hata: \(error.localizedDescription)"
                return
            }

            guard let callbackURL = callbackURL,
                  let components = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false),
                  let queryItems = components.queryItems else {
                self.errorMessage = "Callback URL çözülemedi"
                return
            }

            let code = queryItems.first(where: { $0.name == "code" })?.value
            let state = queryItems.first(where: { $0.name == "state" })?.value

            guard let code, let state else {
                self.errorMessage = "code/state parametresi yok"
                return
            }

            guard state == pkce.state else {
                self.errorMessage = "State uyuşmuyor (CSRF koruması)"
                return
            }

            Task {
                await self.exchangeCodeForToken(code: code, pkce: pkce)
            }
        }

        // iOS 13+ için
        session.presentationContextProvider = self
        session.prefersEphemeralWebBrowserSession = true
        session.start()
    }
    
    func signOut(){
        accessToken = nil
        refreshToken = nil
        currentUser = nil
        meUserID = nil
        errorMessage = nil
        
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: accessTokenKey)
        defaults.removeObject(forKey: refreshTokenKey)
        defaults.removeObject(forKey: userKey)
        
    }

    private func exchangeCodeForToken(code: String, pkce: PKCE) async {
        guard let url = URL(string: "https://api.x.com/2/oauth2/token") else {
            self.errorMessage = "Token URL hatası"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        // X docs'a göre form body: code, grant_type, client_id, redirect_uri, code_verifier
        let bodyParams: [String: String] = [
            "code": code,
            "grant_type": "authorization_code",
            "client_id": XAuthConfig.clientID,
            "redirect_uri": XAuthConfig.redirectURI,
            "code_verifier": pkce.verifier
        ]

        let bodyString = bodyParams
            .map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" }
            .joined(separator: "&")

        request.httpBody = bodyString.data(using: .utf8)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let http = response as? HTTPURLResponse else {
                self.errorMessage = "Token response HTTP değil"
                return
            }

            guard (200...299).contains(http.statusCode) else {
                let txt = String(data: data, encoding: .utf8) ?? ""
                self.errorMessage = "Token isteği hatası: \(http.statusCode)\n\(txt)"
                return
            }

            let decoded = try JSONDecoder().decode(XTokenResponse.self, from: data)
            self.accessToken = decoded.access_token
            self.refreshToken = decoded.refresh_token
            self.errorMessage = nil
            
            persist() // tokenleri kaydet

            // Girişten sonra kendi user id'mizi çekelim
            await fetchMe()
        } catch {
            self.errorMessage = "Token isteği patladı: \(error.localizedDescription)"
        }
    }

    private func fetchMe() async {
        guard let token = accessToken else { return }
        
        //user.fields ile ekstra alan
        guard let url = URL(string: "https://api.x.com/2/users/me?user.fields=profile_image_url,public_metrics") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let http = response as? HTTPURLResponse,
                  (200...299).contains(http.statusCode) else {
                let txt = String(data: data, encoding: .utf8) ?? ""
                print("Me isteği hata: \(txt)")
                return
            }

            struct MeResponse: Codable {
                
                struct Metrics: Codable {
                    let follower_count: Int?
                    let following_count: Int?
                }
                struct User: Codable {
                    let id: String
                    let name: String
                    let username: String
                    let profile_img_url: String?
                    let public_metrics:Metrics?
                }
                let data: User
            }

            let decoded = try JSONDecoder().decode(MeResponse.self, from: data)
            let u = decoded.data
            
            self.meUserID = u.id
            
            self.currentUser = XUser(
                id: u.id,
                name: u.name,
                username: u.username,
                profileImageURL: u.profile_img_url,
                followerCount: u.public_metrics?.follower_count,
                followingCount: u.public_metrics?.following_count
            )
            
            persist() //useri kaydet
            
        } catch {
            print("Me isteği patladı: \(error)")
        }
    }
}

// ASWebAuthenticationSession için gerekli
extension XAuthManager: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        // En basit hali, keyWindow vs. olabilir
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? UIWindow()
    }
}
