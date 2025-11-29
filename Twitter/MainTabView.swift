//
//  MainTabView.swift
//  Twitter
//
//  Created by Akkuş on 29.11.2025.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        
        TabView {
            HomeView()
                .tabItem {
                    Image("HomeSolidIcon")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaledToFit()
                        .frame(width: 22, height: 22, alignment: .center)
                        .clipped()
                    Text("Home")
                }
            
            SearchView()
                .tabItem{
                    Image("SearchSolidIcon")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 0.1, height: 0.1, alignment: .center)
                    Text("Search")
                }
            
            NotificationsView()
                .tabItem{
                    Image("BellSolidIcon")
                        .symbolRenderingMode(.monochrome)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 0.1, height: 0.1, alignment: .center)
                    Text("Notifications")
                }
            
            MessageView()
                .tabItem{
                    Image("MessageSolidIcon")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 0.1, height: 0.1, alignment: .center)
                    Text("Dm")
                }
        }
    }
}

#Preview {
    MainTabView()
}
