//
//  SearchView.swift
//  Twitter
//

import SwiftUI

struct SearchView: View {
    
    // MARK: - Properties
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            // 1. Search Bar Area
            SearchBar(text: $searchText)
                .padding()
            
            // 2. List Area (Scrollable)
            ScrollView{
                LazyVStack {
                    // We will populate this list with user later
                    ForEach(0..<10) { _ in
                        UserCell()
                    }
                }
            }
        }
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SearchBar: View {
    
    @Binding var text: String
    
    var body: some View {
        HStack {
            // Magnify Icon
            Image("SearchIcon")
                
            // Text Input Field
            TextField("Search Twitter", text: $text)
            
            // Clear Button (x) - Only shows when typing
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                })
            }
        }
        .padding(10)
        .background(Color(.systemBackground))
        .cornerRadius(10)
    }
}

struct UserCell: View {
    var body: some View {
        HStack(spacing: 12) {
            Image("taklalie60profile")
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 44)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text("taklalı e60")
                    .font(.headline)
                    .foregroundColor(.primary)
                    
                Text("@taklalie60")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

