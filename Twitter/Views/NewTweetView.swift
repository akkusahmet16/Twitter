//
//  NewTweetView.swift
//  Twitter
//

import SwiftUI

struct NewTweetView: View {
    // Environment variable to dismiss the sheet programmatically.
    @Environment(\.dismiss) var dismiss
    
    // State to hold the user's input.
    @State private var tweetText: String = ""
    
    // Controls the loading indicator during the network request.
    @State private var isSending: Bool = false
    
    // Error handling states.
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    // Focus state for the keyboard
    @FocusState private var isFocused: Bool
    
    // We observe the same ViewModel from the parent
    @ObservedObject var viewModel: TimelineViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: - CUSTOM HEADER
            HStack {
                // Cancel Button
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.blue)
                .font(.body)
                
                Spacer()
                
                // Tweet Button (Text Style)
                Button {
                    sendTweetAction()
                } label: {
                    if isSending {
                        ProgressView()
                            .padding(.trailing, 8)
                    } else {
                        Text("Tweet")
                            .font(.headline)
                            .foregroundColor(tweetText.isEmpty ? Color.white.opacity(0.5) : Color.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(tweetText.isEmpty ? Color.blue.opacity(0.5) : Color.blue)
                            .clipShape(Capsule())
                    }
                }
                .disabled(tweetText.isEmpty || isSending)
            }
            .padding()
            
            Divider()
            
            // MARK: - Input Area
            HStack(alignment: .top, spacing: 12) {
                // Left: Profile Picture
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .foregroundColor(.gray)
                
                // Right: Text Area
                ZStack(alignment: .topLeading) {
                    // Placeholder Text
                    if tweetText.isEmpty {
                        Text("What's happening?")
                            .foregroundColor(.gray)
                            .font(.title3)
                            .padding(.top, 8)
                            .padding(.leading, 5)
                    }
                    
                    // Main Text Editor
                    TextEditor(text: $tweetText)
                        .font(.title3)
                        .focused($isFocused)
                        .frame(maxHeight: .infinity)
                        .scrollContentBackground(.hidden)
                }
            }
            .padding(16)
            
            Spacer()
            
            // MARK: - Toolbar Area
            VStack(spacing: 0) {
                Divider()
                HStack(spacing: 20) {
                    Button {} label: { Image("ImageIcon").font(.title3) }
                    Button {} label: { Image("GifIcon").font(.title3) }
                    Button {} label: { Image("StatsIcon").font(.title3) }
                    Button {} label: { Image("LocationIcon").font(.title3) }
                    
                    Spacer()
                    
                    HStack(spacing: 16) {
                        Circle()
                            .stroke(Color.blue.opacity(0.3), lineWidth: 2)
                            .frame(width: 20, height: 20)
                        
                        Button {} label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                                .foregroundColor(.blue)
                        }
                    }
                }
                .foregroundColor(.blue)
                .padding()
            }
            .background(Color(.systemBackground))
        }
        // View Modifiers
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isFocused = true
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    // MARK: - Actions
    // This function must be outside the 'body' property
    private func sendTweetAction() {
        Task {
            isFocused = false
            isSending = true
            
            do {
                let success = try await APIManager.shared.sendTweet(text: tweetText)
                
                if success {
                    viewModel.addLocalTweet(text: tweetText)
                    dismiss() // Corrected: Added parenthesis to call the function
                }
            } catch {
                errorMessage = "Failed to post tweet. \nDetails: \(error.localizedDescription)"
                showError = true
            }
            isSending = false
        }
    }
}

