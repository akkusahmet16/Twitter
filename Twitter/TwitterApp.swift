//
//  TwitterApp.swift
//  Twitter
//
//  Created by Akkuş on 28.11.2025.
//

import SwiftUI

@main
struct TwitterApp: App {
    
    @StateObject private var auth = XAuthManager()
    @StateObject private var api = XAPIService()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(auth)
                .environmentObject(api)
        }
    }
}
