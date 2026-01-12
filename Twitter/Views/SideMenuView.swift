//
//  SideMenuView.swift
//  Twitter
//

import SwiftUI

struct SideMenuView: View {
    
    @Binding var showMenu: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            // MARK: - Header (Avatar & Info)
            VStack(alignment: .leading, spacing: 10) {
                // Profile Picture (Mock Data)
                Image("taklalie60profile")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing:  4) {
                    HStack(spacing: 4) {
                        Text("ʇɐʞlɐlı ǝ60")
                            .font(.default)
                            .foregroundColor(.primary)
                        Image("BlueTick")
                            .resizable()
                            .frame(width: 14, height: 14)
                    }
                    
                    Text("@taklalie60")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Follower Stats
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Text("356").bold()
                        Text("Following").foregroundColor(.secondary)
                    }
                    HStack(spacing: 4) {
                        Text("175").bold()
                        Text("Followers").foregroundColor(.secondary)
                    }
                }
                .font(.caption)
                .padding(.top, 8)
            }
            .padding(.horizontal)
            .padding(.top, 60) // Safe Area
            
            
            // MARK: - Menu Items
            VStack(alignment: .leading, spacing: 24) {
                    
                VStack(alignment: .leading, spacing: 40) {
                    MenuRow(icon: "ProfileIcon", title: "Profile")
                    MenuRow(icon: "ListIcon", title: "Lists")
                    MenuRow(icon: "TopicIcon", title: "Topics")
                    MenuRow(icon: "BookmarksIcon", title: "Bookmarks")
                    MenuRow(icon: "MomentsIcon", title: "Moments")
                }
                .padding(.horizontal)
                .padding(.top, 10)
                .padding(.bottom, 5)
                    
                Divider()
                    
                VStack(alignment: .leading, spacing: 24) {
                    SettingsAndHelpCenter(title: "Settings and privacy")
                    SettingsAndHelpCenter(title: "Help Center")
                }
                .padding(.horizontal)
                .padding(.top, 5)
            }
            .padding(.top)
        
            Spacer()
            
            HStack {
                Image("Union")
                    .font(.title2)
            }
            .padding(.bottom, 40)
            .padding(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .frame(width: UIScreen.main.bounds.width * 0.75)
        .ignoresSafeArea()
    }
}

struct MenuRow: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(icon)
                .font(.title3)
                .frame(width: 24)
            Text(title)
                .font(.headline)
                .fontWeight(.regular)
            
            Spacer()
        }
        .foregroundColor(.primary)
    }
}

struct SettingsAndHelpCenter: View {
    let title: String
    
    var body: some View {
        HStack(spacing: 16) {
            Text(title)
                .font(.headline)
                .fontWeight(.regular)
            
            Spacer()
        }
        .foregroundColor(.primary)
    }
}

#Preview {
    SideMenuView(showMenu: .constant(true))
}
