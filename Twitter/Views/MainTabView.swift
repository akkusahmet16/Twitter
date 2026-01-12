//
//  MainTabView.swift
//  Twitter
//
//  Created by Akkuş on 31.12.2025.
//

import SwiftUI

struct MainTabView: View {
    // We are following the selected tab (0: Home, 1: Search, 2: Notifications...))
    @State private var selectedTab: Int = 0
    
    // Homepage refresh trigger
    // Every time this variable changes (true/false), TimelineView will interpret it as a "Refresh" command.
    @State private var homeRefreshTrigger: Bool = false
    
    @State private var showMenu = false
    
    @GestureState private var dragOffset: CGFloat = 0
    
    var body: some View{
        
        // ZStack: Layer logic. The application will be at the bottom, the menu at the top.
        ZStack(alignment: .leading) {
            
            // We are replacing the standard TabView with Binding.
            // This way, if the user clicks on the already open tab again, we can catch it.
            TabView(selection: $selectedTab) {
                
                // 1. Tab: Timeline
                // Trigger ($homeRefreshTrigger) rusting on the underside.
                TimelineView(refreshTrigger: $homeRefreshTrigger, showMenu: $showMenu)
                    .tabItem {
                        Image(selectedTab == 0 ? "HomeSolidIcon" : "HomeIcon")
                    }
                    .tag(0)
                
                // 2. Tab: Search (Currently empty)
                Text("Search Tab (add will be soon)")
                    .tabItem {
                        Image(selectedTab == 0 ? "SearchSolidIcon" : "SearchIcon")
                    }
                    .tag(1)
                
                // 3. Tab: Notifications ( Currently empty )
                Text("Notifications( will be a soon )")
                    .tabItem {
                        Image(selectedTab == 2 ? "BellSolidIcon": "BellIcon")
                    }
                    .tag(2)
                
                // 4. Tab: Messages
                Text("Messages ( will be a soon )")
                    .tabItem {
                        Image(selectedTab == 3 ? "MessageSolidIcon" : "MessageIcon")
                    }
                    .tag(3)
            }
            // Set the TabBar color (optional)
            .accentColor(.blue)
            
            // When the menu opens, push the background slightly to the right (optional, Twitter does this).
            .offset(x: showMenu ? UIScreen.main.bounds.width * 0.75 : 0)
            .disabled(showMenu)  // Do not click on the back button while the menu is open.
            
            // 2. LAYER: Darkening Effect (Overlay)
            if showMenu {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showMenu = false
                        }
                    }
                    .zIndex(1)
            }
            if showMenu {
                SideMenuView(showMenu: $showMenu)
                    .transition(.move(edge: .leading))
                    .zIndex(2)
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -50 {
                        withAnimation {
                            showMenu = false
                        }
                    }
                }
        )
        .animation(.easeInOut(duration: 0.3), value: showMenu)
    }
}
#Preview {
    MainTabView()
}

