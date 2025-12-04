//
//  MessageView.swift
//  Twitter
//
//  Created by Akkuş on 29.11.2025.
//

import SwiftUI

struct MessageView: View {
    
    @EnvironmentObject var auth: XAuthManager
    
    var body: some View {
        Button {
            auth.signOut()
        } label: {
            HStack {
                Image(systemName: "xmark")
                Text("oturumu kapat")
                    .bold()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(999)
            .padding(.horizontal, 32)
        }
    }
}

#Preview {
    MessageView()
}
