//
//  RootView.swift
//  Twitter
//
//  Created by Akkuş on 2.12.2025.
//

import SwiftUI

struct RootView: View {

    @EnvironmentObject var auth: XAuthManager
    @EnvironmentObject var api: XAPIService
    
    var body: some View {
        Group {
            if !isLoggedIn {
                LoginView()
            } else {
                MainTabView()
            }
        }
        .onAppear {
            api.setUserAccessToken(auth.accessToken)
        }
        .onChange(of: auth.accessToken) { newValue in
            api.setUserAccessToken(newValue)
        }
    }
    
    private var isLoggedIn: Bool {
        auth.accessToken != nil && auth.currentUser != nil
    }
}

