//
//  LoginView.swift
//  Twitter
//
//  Created by Akkuş on 2.12.2025.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var auth: XAuthManager

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // Logo / başlık
            Image("TwitterLogoBlue")
                .resizable()
                .scaledToFit()
                .frame(width: 72, height: 72)

            Text("Twitter")
                .font(.title2)
                .bold()

            Text("Devam etmek için X hesabınla giriş yapman gerekiyor.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            // Hata mesajı
            if let error = auth.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.horizontal, 32)
            }

            // Giriş butonu
            Button {
                auth.signIn()
            } label: {
                HStack {
                    Image(systemName: "xmark")
                    Text("X ile Giriş Yap")
                        .bold()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(999)
                .padding(.horizontal, 32)
            }

            Spacer()

            Text("Bu sadece senin hesabın için kişisel bir client.")
                .font(.caption2)
                .foregroundColor(.secondary)
                .padding(.bottom, 16)
        }
    }
}
