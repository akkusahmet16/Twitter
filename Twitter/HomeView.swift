//
//  HomeView.swift
//  Twitter
//
//  Created by Akkuş on 28.11.2025.
//

import SwiftUI

// MARK: Tweet Model (her tweet için temel altyapı)

struct Tweet: Identifiable {
    let id = UUID()
    let authorName: String
    let handle: String
    let time: String
    let text: String
    let avatarURL: String?
    let avatarColor: Color
    var replyCount: Int
    var retweetCount: Int
    var likeCount: Int
    var goruntulenmeCount: Int
    var bookmarkCount: Int
    var media: [TweetMedia]
}

struct TweetMedia {
    let type: String
    let url: String
}

// MARK: - Ana Ekran (Home Timeline)

struct HomeView: View {
    @EnvironmentObject var auth: XAuthManager
    @EnvironmentObject var api: XAPIService
    @State private var showMenu: Bool = false
    // Örnek Timeline verileri - API bağlayınca direkt burayı API'den doldurulacak
    
    @State private var showComposer = false //Sağ alttaki + Buttonu

    var body: some View{
        ZStack(alignment: .leading) {

            // ANA İÇERİK: Navigation + Timeline + Sağ alt buton
            NavigationStack{
                VStack(spacing: 0) {
                    
                    if let apiError = api.errorMessage {
                        Text(apiError)
                            .font(.caption2)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                            .padding(.top, 4)
                    }
                    
                    ZStack(alignment: .bottomTrailing) {
                        List{
                            ForEach(api.posts) { post in
                                TweetRow(tweet: mapPostToTweet(post))
                                    .listRowInsets(.init(top:14, leading:16, bottom:14, trailing:16))
                            }
                        }
                        .listStyle(.plain)
                        .background(Color(uiColor:.systemGray6))
                        
                        Button {
                            Task {
                                
                                api.setUserAccessToken(auth.accessToken)
                                
                                if let userId = auth.meUserID {
                                    await api.fetchHomeTimeline(for: userId)
                                } else if let currentId = auth.currentUser?.id {
                                    //extra fallback
                                    await api.fetchHomeTimeline(for: currentId)
                                } else {
                                    api.errorMessage = "Kullanıcı ID bulunamadı"
                                }
                                
                            }
                        } label: {
                            Image("NewTweetIcon")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(.white)
                                .frame(width: 60, height: 60)
                                .background(Circle().fill(Color.blue))
                                .shadow(radius: 5, y: 3)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 80)
                    }
                    
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                withAnimation(.spring()) {
                                    showMenu.toggle()
                                }
                            } label: {
                                profileImageView
                            }
                        }
                        
                        ToolbarItem(placement: .principal) {
                            Image("TwitterLogoBlue")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32)
                                .padding(.top, 15)
                        }
                        
                        ToolbarItem(placement: .topBarTrailing){
                            Image("FeatureStrokeIcon")
                        }
                        
                    }
                    .padding(.top, 5)
                    
                    // Compose Tweet Sheet (şimdilik basit placeholder)
                    .sheet(isPresented: $showComposer) {
                        Text("Tweet Composer")
                            .font(.largeTitle)
                            .padding()
                    }
                }
                
                // SIDE MENU + KAPATMA ALANI
                if showMenu {
                    // Arkadaki karartma
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.spring()) {
                                showMenu = false
                            }
                        }
                    
                    // Menü içeriği
                    SideMenuView(
                        user: auth.currentUser,
                        onLogout: {
                            auth.signOut()
                            withAnimation(.spring()) {
                                showMenu = false
                            }
                        }
                    )
                    .frame(width: 280)
                    .transition(.move(edge: .leading))
                }
            }
        }
    }

    // Navbar'daki profil foto butonu için helper
    private var profileImageView: some View {
        Group {
            if let urlString = auth.currentUser?.profileImageURL,
               let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure(_):
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                    @unknown default:
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                    }
                }
                .frame(width: 32, height: 32)
                .clipShape(Circle())
            } else {
                Image("ahmet")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
            }
        }
    }
    
    private func mapPostToTweet(_ post: XTPost) -> Tweet {
        
        let user = api.userById[post.author_id]
        
        //zaman formatı
        let timeText: String
        if let created = post.created_at {
            timeText = String(created.prefix(10))
        } else {
            timeText = ""
        }
        
        //Metrics
        let replies = post.public_metrics?.reply_count ?? 0
        let retweets = post.public_metrics?.retweet_count ?? 0
        let likes = post.public_metrics?.like_count ?? 0
        let views = post.public_metrics?.impression_count ?? 0
        let bookmarks = post.public_metrics?.like_count ?? 0
        
        //media
        var mediaItems: [TweetMedia] = []
        if let keys = post.attachments?.media_keys {
            for key in keys {
                if let media = api.mediaByKey[key],
                   let url = media.url ?? media.preview_image_url {
                    mediaItems.append(
                        TweetMedia(type: media.type, url: url)
                    )
                }
            }
        }
        
        return Tweet(
            authorName: user?.name ?? "Bilinmeyen",
            handle: "@\(user?.username ?? "unknown")",
            time: timeText,
            text: post.text,
            avatarURL: user?.profile_image_url,
            avatarColor: .blue,
            replyCount: replies,
            retweetCount: retweets,
            likeCount: likes,
            goruntulenmeCount: views,
            bookmarkCount: bookmarks,
            media: mediaItems
        )
    }
}

//MARK: - Tweet Row (Her tweet hücresi)

struct TweetRow: View{
    let tweet: Tweet
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            
            //Avatar
            Group {
                if let urlString = tweet.avatarURL,
                   let url = URL(string: urlString) {
                    AsyncImage(url: url) {phase in
                        switch phase {
                        case .empty:
                            Circle()
                                .fill(Color.gray.opacity(0.4))
                            
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        case .failure(_):
                            Circle()
                                .fill(Color.gray.opacity(0.4))
                        @unknown default:
                            Circle()
                                .fill(Color.gray.opacity(0.4))
                        }
                    }
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
                } else {
                    Circle()
                        .fill(tweet.avatarColor)
                        .frame(width: 44, height: 44)
                }
            }
            //içerik
            VStack(alignment: .leading, spacing: 6) {
                
                //AD - Handle - Zaman
                HStack(spacing: 4){
                    Text(tweet.authorName)
                        .font(.subheadline)
                        .bold()
                    
                    Text(tweet.handle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Text("\(tweet.time)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.secondary)
                }
                
                //Tweet Metni - otomatik boyutlanır
                Text(tweet.text)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
                
                //Medya (varsa ilk foto)
                if let firstMedia = tweet.media.first,
                   let url = URL(string: firstMedia.url),
                   firstMedia.type == "photo" {
                    
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        case .failure(_):
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                        @unknown default:
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                }
                
                TweetActions(tweet: tweet)
                    .padding(.top, 4)
            }
        }
    }
}

// MARK: - Alt Buttonlar

struct TweetActions: View{
    
    let tweet: Tweet
    
    var body: some View {
        
        HStack(spacing: 0) {
            
            action("CommentStrokeIcon", tweet.replyCount)
            Spacer()
            action("RetweetStrokeIcon",tweet.retweetCount)
            Spacer()
            action("HeartStrokeIcon", tweet.likeCount)
            Spacer()
             
            Image("ShareStrokeIcon")
                .resizable()
                .fixedSize()
        }
        .padding(.top, 10)
    }
    
    func action(_ icon: String, _ count: Int, color: Color = .secondary) -> some View {
        
        HStack(spacing: 4){
            Image(icon)
                .resizable()
                .fixedSize()
                .foregroundStyle(color)
            
            Text(count.abbreviated)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            
            Spacer(minLength: 0)
        }
    }
    
    var shareButton: some View{
        Image(systemName: "square.and.arrow.up")
            .foregroundStyle(.secondary)
            .font(.caption)
    }
}

#Preview {
    
    let auth = XAuthManager()
    let api = XAPIService()
    HomeView()
        .environmentObject(XAuthManager())
        .environmentObject(XAPIService())
}
































































