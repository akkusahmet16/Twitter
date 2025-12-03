//
//  XAuthConfig.swift
//  Twitter
//
//  Created by Akkuş on 1.12.2025.
//

import Foundation

enum XAuthConfig {
    static let clientID = Secrets.xClientID
    
    // x portalda eklediğin redirect ile birebir aynı olacak
    static let redirectURI = "mytwitterclone://auth-callback"
    
    //iOS'ta callback scheme'i (redirect URI'nin baş kısmı)
    static let callbackScheme = "mytwitterclone"
    
    //ihtiyacımız olan scope'lar
    //tweet.read + user.read = timeline için
    //offline.access = refresh token için
    static let scopes = [
        "tweet.read",
        "users.read",
        "offline.access"
    ]
}
