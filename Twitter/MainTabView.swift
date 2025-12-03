//
//  MainTabView.swift
//  Twitter
//
//  Created by Akkuş on 29.11.2025.
//

import SwiftUI
 
struct MainTabView: View {
    @State private var selectedTab: Tab = .homebutton
    
    var body: some View {
        
        ZStack(alignment: .bottom){
            
            //İçerikler
            Group {
                switch selectedTab {
                case .homebutton:
                    HomeView()
                case .searchbutton:
                    SearchView()
                case .notificationsbutton:
                    NotificationsView()
                case .messagebutton:
                    MessageView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.secondary)
            
            //Custom Tab Bar
            CustomTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

enum Tab {
    case homebutton
    case searchbutton
    case notificationsbutton
    case messagebutton
}


struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            // Üst ince çizgi - eski twitter görünümü
            Rectangle()
                .fill(Color(UIColor.systemGray3))
                .frame(height: 0.5)
            
            HStack {
                
                tabItem(icon: "HomeSolidIcon", tab: .homebutton)
                Spacer()
                tabItem(icon: "SearchSolidIcon", tab: .searchbutton)
                Spacer()
                tabItem(icon: "BellSolidIcon", tab: .notificationsbutton)
                Spacer()
                tabItem(icon: "MessageSolidIcon", tab: .messagebutton)
                
            }
            .padding(.horizontal, 32)
            .padding(.top, 12)
            .padding(.bottom, 16)
            .background(Color(.systemBackground))
        }
        .frame(maxWidth: .infinity)
    }
    
    private func tabItem(icon: String, tab: Tab) -> some View{
        Button{
            selectedTab = tab
        } label: {
            Image(icon)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .foregroundStyle(selectedTab == tab ? .blue : .gray)
        }
    }
}


 
#Preview {
    NavigationStack {
        MainTabView()
    }
}
