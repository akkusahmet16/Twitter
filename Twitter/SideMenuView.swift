//
//  SideMenuView.swift
//  Twitter
//
//  Created by Akkuş on 2.12.2025.
//

import SwiftUI

struct SideMenuView: View {
    let user: XUser?
    let onLogout: () -> Void
    
    var body: some View{
        
        VStack(alignment: .leading, spacing: 16) {
            
            //kullanıcı bilgileri
            if let user = user {
                HStack(alignment: .center, spacing: 12) {
                    
                    //profil foto
                    if let urlString = user.profileImageURL,
                       let url = URL(string: urlString) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 48, height: 48)
                                    .clipShape(Circle())
                            case .failure(_):
                                Circle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 48, height: 48)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }else {
                        Circle()
                            .fill(Color.gray.opacity(0.4))
                            .frame(width: 48, height: 48)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(user.name)
                            .font(.headline)
                        Text("@\(user.username)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                
                HStack(spacing: 16) {
                    
                    if let following = user.followingCount {
                        Text("\(following) Following")
                    }
                    if let followers = user.followerCount {
                        Text("\(followers) Followers")
                    }
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }else {
                Text("User Information Loading...")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Divider()
                .padding(.vertical, 8)
            
            //Menü itemleri eklenecek
            VStack(alignment: .leading, spacing:12) {
                Text("Profile")
                Text("Lists")
                Text("Bookmarks")
                Text("Settings")
            }
            .font(.body)
            
            Spacer()
            
            Button(role: .destructive){
                onLogout()
            } label: {
                Text("Close X session ")
                    .font(.body)
                    .bold()
            }
            
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        
    }
}

