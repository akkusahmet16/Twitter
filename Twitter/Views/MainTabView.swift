//
//  MainTabView.swift
//  Twitter
//
//  Created by Akkuş on 31.12.2025.
//

import SwiftUI

struct MainTabView: View {
    
    // Using Enum for safer tab management
    enum Tab: Int {
        case home = 0
        case search = 1
        case notifications = 2
        case messages = 3
    }
    
    @State private var selectedTab: Tab = .home
    @State private var homeRefreshTrigger = false
    
    // State to control the sid emenu visibility
    @State private var showMenu = false
    
    // State to control the Profile View presentation
    @State private var showProfile = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            
            // MARK: - Main Content
            TabView(selection: $selectedTab) {
                
                // 1. Timeline
                TimelineView(refreshTrigger: $homeRefreshTrigger, showMenu: $showMenu)
                    .tabItem {
                        Image(selectedTab == .home ? "HomeSolidIcon" : "HomeIcon")
                    }
                    .tag(Tab.home)
                
                // 2. Search
                SearchView()
                    .tabItem {
                        Image(selectedTab == .search ? "SearchSolidIcon" : "SearchIcon")
                    }
                    .tag(Tab.search)
                
                // 3. Notifications
                NotificationsView()
                    .tabItem {
                        Image(selectedTab == .notifications ? "BellSolidIcon" : "BellIcon")
                    }
                    .tag(Tab.notifications)
                
                // 4. Messages
                MessageView()
                    .tabItem {
                        Image(selectedTab == .messages ? "MessageSolidIcon" : "MessageIcon")
                    }
                    .tag(Tab.messages)
            }
            .accentColor(.blue)
            .offset(x: showMenu ? UIScreen.main.bounds.width * 0.75 : 0) // Slide effect
            .disabled(showMenu) // Disable interaction when menu is open
            
            // MARK: - Overlay (Dimming Effect)
            if showMenu {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture { withAnimation { showMenu = false } }
                    .zIndex(1)
                    // Swipe to close on overlay
                    .gesture(dragToCloseGesture)
            }
            
            // MARK: - Side Menu (Drawer)
            if showMenu {
                SideMenuView(showMenu: $showMenu, showProfile: $showProfile)
                    .transition(.move(edge: .leading))
                    .zIndex(2)
                    // Swipe to close on menu
                    .gesture(dragToCloseGesture)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showMenu)
        // Presents the ProfileView full screen when triggered
        .fullScreenCover(isPresented: $showProfile) {
            ProfileView()
        }
        
    }
    
    // Shared Gesture Logic
    private var dragToCloseGesture: some Gesture {
        DragGesture()
            .onEnded { value in
                if value.translation.width < -50 {
                    withAnimation { showMenu = false }
                }
            }
    }
}
