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
    
    var body: some View{
        
        // We are replacing the standard TabView with Binding.
        // This way, if the user clicks on the already open tab again, we can catch it.
        TabView(selection: Binding(
            get: { selectedTab },
            set: { newValue in
            // If the user is already on the Home Page (0) and clicks on the Home Page again:
                if newValue == selectedTab && newValue == 0 {
                    // Trigger fire (TimelineView is listening to this)
                    homeRefreshTrigger.toggle()
                    print("The Home button was pressed again -> Refresh request sent")
                }
                // Change the tab
                selectedTab = newValue
            }
        )) {
            
            // 1. Tab: Timeline
            // Trigger ($homeRefreshTrigger) rusting on the underside.
            TimelineView(refreshTrigger: $homeRefreshTrigger)
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                }
                .tag(0)
            
            // 3. Tab: Search (Currently empty)
            Text("Search Tab (add will be soon)")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                .tag(1)
            
            // 3. Tab: Notifications ( Currently empty )
            Text("Notifications( will be a soon )")
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "bell.fill": "bell")
                }
                .tag(2)
            
            // 4. Tab: Messages
            Text("Messages ( will be a soon )")
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "envelope.fill" : "envelope")
                }
                .tag(3)
        }
        // Set the TabBar color (optional)
        .accentColor(.blue)
    }
}
#Preview {
    MainTabView()
}

