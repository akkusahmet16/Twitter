//
//  OAuth.swift
//  Twitter
//
//  Created by Akkuş on 8.01.2026.
//


import Foundation
import CommonCrypto

struct OAuth {
    
    // Generates the OAuth 1.0a Authorization Header
    static func generateHeader(url: String, method: String, params: [String: String]) -> String {
        
        // 1. Collected Secrets
        let consumerKey = Secrets.apiKey
        let consumerSecret = Secrets.apiSecret
        let accessToken = Secrets.accessToken
        let tokenSecret = Secrets.accessTokenSecret
        
        // 2. Generate Nonce and Timestamp
        let nonce = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        let timestamp = String(Int(Date().timeIntervalSince1970))
        
        // 3. Create Parameter Dictionary
        var parameters = [
            "oauth_consumer_key": consumerKey,
            "oauth_nonce": nonce,
            "oauth_signature_method": "HMAC_SHA1",
            "oauth_timestamp": timestamp,
            "oauth_token": accessToken,
            "oauth_version": "1.0"
        ]
        
        // Note: For JSON body requests (like posting a tweet), body parameters are NOT included in the OAuth signature.
        // Only query parameters would be added here if we had them.
        
        // 4. Create Signature Base String
        let parametersString = parameters.sorted { $0.key < $1.key }
            .map { "\($0.key.percentEncoded)=\($0.value.percentEncoded)" }
            .joined(separator: "&")
        
        let baseString = "\(method)&\(url.percentEncoded)&\(parametersString.percentEncoded)"
        
        // 5. Create Signing Key
        let signingKey = "\(consumerSecret.percentEncoded)&\(tokenSecret.percentEncoded)"
        
        // 6. Calculate Signature (HMAC_SHA1)
        let signature = hmac(string: baseString, key: signingKey)
        
        parameters["oauth_signature"] = signature
        
        // 7. Construct Header String
        let headerString = "OAuth " + parameters.sorted { $0.key < $1.key }
            .map { "\($0.key)=\"\($0.value.percentEncoded)\"" }
            .joined(separator: ", ")
        
        return headerString
    }
    
    // Helper: Percent Encoding (RFC 3986)
    // Twitter requires a very specific type of encoding (e.g., spaces to %20, not +)
    private static func hmac(string: String, key: String) -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        let data = string.data(using: .utf8)!
        let keyData = key.data(using: .utf8)!
        
        keyData.withUnsafeBytes { keyBytes in
            data.withUnsafeBytes { dataBytes in
                CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), keyBytes.baseAddress, keyData.count, dataBytes.baseAddress, data.count, &digest)
            }
        }
        return Data(digest).base64EncodedString()
    }
}

// Helper Extension for String Encoding
extension String {
    var percentEncoded: String {
        var allowed = CharacterSet.alphanumerics
        allowed.insert(charactersIn: "-._~") // Unreserved characters per RFC 3986
        return self.addingPercentEncoding(withAllowedCharacters: allowed) ?? self
    }
}
