import SwiftUI

struct ContentView: View {
    @StateObject private var auth = XAuthManager()
    @StateObject private var api  = XAPIService()

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: - Kullanıcı bilgileri (header)
                Group {
                    if auth.accessToken != nil {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Giriş yapıldı ✅")
                                .font(.headline)

                            if let id = auth.meUserID {
                                Text("Kullanıcı ID: \(id)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            } else {
                                Text("Kullanıcı bilgileri alınıyor...")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    } else {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Henüz giriş yapılmadı")
                                .font(.headline)
                            Text("Giriş yaptıktan sonra kendi timeline'ını çekebileceksin.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.horizontal)

                // MARK: - Hata mesajları
                if let authError = auth.errorMessage {
                    Text("Auth hata: \(authError)")
                        .font(.caption2)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }

                if let apiError = api.errorMessage {
                    Text("API hata: \(apiError)")
                        .font(.caption2)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }

                // MARK: - Butonlar
                HStack(spacing: 12) {
                    Button("X ile Giriş Yap") {
                        auth.signIn()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(auth.accessToken != nil) // Giriş yaptıysa tekrar basamasın

                    Button("Timeline'ı Getir") {
                        Task {
                            // access token'i API service'e geçir
                            api.setUserAccessToken(auth.accessToken)

                            if let userId = auth.meUserID {
                                await api.fetchHomeTimeline(for: userId)
                            } else {
                                api.errorMessage = "Kullanıcı ID bulunamadı. Giriş sonrası /users/me çağrısını kontrol et."
                            }
                        }
                    }
                    .buttonStyle(.bordered)
                    .disabled(auth.accessToken == nil || auth.meUserID == nil || api.isLoading)
                }
                .padding(.horizontal)

                Text("Tweet sayısı: \(api.posts.count)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)

                // MARK: - Timeline listesi
                if api.isLoading {
                    VStack {
                        Spacer()
                        ProgressView("Timeline yükleniyor...")
                        Spacer()
                    }
                } else if api.posts.isEmpty {
                    Spacer()
                    Text("Henüz timeline çekilmedi veya sonuç yok.")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                } else {
                    List(api.posts) { post in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(post.text)
                                .font(.body)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("X Timeline")
        }
    }
}

#Preview {
    ContentView()
}
