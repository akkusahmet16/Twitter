//
//  NotificationsView.swift
//  Twitter
//
//

import SwiftUI
struct NotificationsView: View {
    
    // MARK: - Properties
    @State private var selectedFilter: String = "All"
    @Namespace var animation
    
    var body: some View {
        VStack {
            // 1. Top Filter Bar (All / Mentions)
            HStack {
                filterButton(title: "All")
                filterButton(title: "Mentions")
            }
            .padding(.top)
            .background(Color(.systemBackground))
            
            // 2. Notifications List
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(0..<1) { _ in
                        NotificationCell()
                    }
                }
            }
        }
        .navigationTitle("Notifivations")
        .navigationBarTitleDisplayMode(.inline)
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Image("SettingsIcon")
            }
        }
    }
    
    // MARK: - Helper: Filter Button
    @ViewBuilder
    func filterButton(title: String) -> some View {
        VStack {
            Text(title)
                .font(.subheadline)
                .fontWeight(selectedFilter == title ? .bold : .regular)
                .foregroundColor(selectedFilter == title ? .blue : .secondary)
            
            if selectedFilter == title {
                Capsule()
                    .foregroundColor(.blue)
                    .frame(height: 3)
                    .matchedGeometryEffect(id: "filter", in: animation)
            } else {
                Capsule()
                    .foregroundColor(.clear)
                    .frame(height: 3)
            }
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                selectedFilter = title
            }
        }
    }
}

// MARK: - Notification Cell Component
struct NotificationCell: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                
                // Icon (Star, Heart, User, etc.)
                Image("StarSolidIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Image("taklalie60profile")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                    
                    (Text("In case you missed ") +
                     Text("Saad El-Banna").bold() +
                     Text("'s Tweet"))
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    
                    
                    Text("SwiftUI is changing the game for iOS development!")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            
            Divider()
        }
    }
}
