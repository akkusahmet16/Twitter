//
//  ChatView.swift
//  Twitter
//

import SwiftUI

struct ChatView: View {
    
    // MARK: - Properties
    let conversation: Conversation // We pass the selected user info here
    
    @State private var messageText = ""
    @State private var messages: [Message] = MockData.chatHistory // Load mock chat
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: - Chat History
            ScrollView{
                LazyVStack(spacing: 12) {
                    Text("Today")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 8)
                    
                    ForEach(messages) { message in
                        MessageBubble(message: message)
                    }
                }
                .padding()
            }
            .onTapGesture {
                // Dismiss keyboard when tapping on chat
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            
            Divider()
            
            // MARK: - Input Area
            HStack(alignment: .bottom, spacing: 12) {
                //Media Button
                Button{ } label: {
                    Image("ImageIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                        .padding(.bottom, 8)
                }
                
                // Text Input
                HStack {
                    TextField("Start a message", text: $messageText)
                    
                    // Send Button (Only shows when typing)
                    if !messageText.isEmpty {
                        Button {
                            sendMessage()
                        } label: {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(20)
                
                // Voice Button (Only shows when NOT typing)
                if messageText.isEmpty {
                    Button { } label: {
                        Image(systemName: "mic")
                            .font(.title3)
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
        }
        // MARK: - Navigation Bar Customization
        .navigationTitle(conversation.username)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Image(systemName: "info.circle")
                    .foregroundColor(.blue)
            }
        }
    }
    
    // MARK: - Action
    func sendMessage(){
        let newMessage = Message(text: messageText, isCurrentUser: true, timestamp: Date())
        withAnimation{
            messages.append(newMessage)
            messageText = ""
        }
    }
}

// MARK: - Message Bubble Component
struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isCurrentUser { Spacer() }
            
            Text(message.text)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(message.isCurrentUser ? Color.blue : Color(.systemGray5))
                .foregroundColor(message.isCurrentUser ? .white : .primary)
                // Custom Chat Bubble Shape
                .clipShape(RoundedRectangle(cornerRadius: 20))
                // Add a little "tail" logic visualy by rounding corners differently?
            // For now, standard rounded corners look modern enough (like iMessage)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.75, alignment: message.isCurrentUser ? .trailing : .leading)
            
            if !message.isCurrentUser { Spacer() }
        }
    }
}

