//
//  SideMenuView.swift
//  Twitter
//
//  Created by Akkuş on 12.01.2026.
//

import SwiftUI

struct SideMenuView: View {
    
    @Binding var showMenu: Bool
    
    var body: some View {
        GeometryReader { geometry in
            
            // Calculate dynamic avatar size (10% of screen width)
            let avatarSize = geometry.size.width * 0.10
            
            VStack(alignment: .leading) {
                
                // MARK: - Header
                VStack(alignment: .leading, spacing: 10) {
                    
                    // Avatar
                    Image("taklalie60profile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: avatarSize, height: avatarSize)
                        .clipShape(Circle())
                    
                    // User Info
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 4) {
                            Text("taklalı e60")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Image("BlueTick") // Verified Badge
                                .resizable()
                                .frame(width: 14, height: 14)
                        }
                        
                        Text("@taklalie60")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // Stats
                    HStack(spacing: 12) {
                        StatText(count: "356", label: "Following")
                        StatText(count: "175", label: "Followers")
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal)
                .padding(.top, geometry.safeAreaInsets.top + 10) // Dynamic Safe Area
                
                // MARK: - Menu List
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // Main Options
                        VStack(alignment: .leading, spacing: 32) {
                            MenuRow(icon: "ProfileIcon", title: "Profile")
                            MenuRow(icon: "ListIcon", title: "Lists")
                            MenuRow(icon: "TopicIcon", title: "Topics")
                            MenuRow(icon: "BookmarksIcon", title: "Bookmarks")
                            MenuRow(icon: "MomentsIcon", title: "Moments")
                        }
                        .padding(.top, 20)
                        
                        Divider().padding(.vertical, 10)
                        
                        // Footer Options
                        VStack(alignment: .leading, spacing: 20) {
                            MenuTextRow(title: "Settings and privacy")
                            MenuTextRow(title: "Help Center")
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                // MARK: - Bottom Footer
                HStack {
                    Image("Union") // Theme Icon
                        .font(.title2)
                }
                .padding(.bottom, geometry.safeAreaInsets.bottom > 0 ? 0 : 20)
                .padding(.bottom, 20)
                .padding(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground))
            .frame(width: UIScreen.main.bounds.width * 0.75)
            .ignoresSafeArea()
        }
    }
}

// MARK: - Helper Components
struct MenuRow: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(icon).font(.title3).frame(width: 24)
            Text(title).font(.headline).fontWeight(.regular)
            Spacer()
        }.foregroundColor(.primary)
    }
}

struct MenuTextRow: View {
    let title: String
    var body: some View {
        HStack {
            Text(title).font(.headline).fontWeight(.regular)
            Spacer()
        }.foregroundColor(.primary)
    }
}

struct StatText: View {
    let count: String
    let label: String
    var body: some View {
        HStack(spacing: 4) {
            Text(count)
                .font(.caption).bold()
            Text(label).foregroundColor(.secondary).font(.caption)
        }
    }
}
