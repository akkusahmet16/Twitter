//
//  PKCE.swift
//  Twitter
//
//  Created by Akkuş on 1.12.2025.
//

import Foundation
import CryptoKit

struct PKCE  {
    let verifier: String
    let challenge: String
    let state: String
}

enum PKCEGenerator{
    
    static func generate() -> PKCE {
        let verifier = randomString(length: 64)
        let challenge = sha256Base64URL(verifier)
        let state = randomString(length: 32)
        return PKCE(verifier: verifier, challenge: challenge, state: state)
    }
    
    private static func randomString(length: Int) -> String {
        let chars = "abcdefghijklmnoprstuvwxyzABCDEFGHIJKLMNOPRSTUVWXYZ1234567890-._~"
        return String((0..<length).compactMap { _ in chars.randomElement()})
    }
    
    private static func sha256Base64URL(_ input: String) -> String {
        
        let data = Data(input.utf8)
        let hash = SHA256.hash(data: data)
        let hashData = Data(hash)
        var base64 = hashData.base64EncodedString()
        //URL-safe hale getir
        base64 = base64
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
        return base64
    }   
}

