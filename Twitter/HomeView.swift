//
//  ContentView.swift
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
    let avatarColor: Color
    var replyCount: Int
    var retweetCount: Int
    var likeCount: Int
    var goruntulenmeCount: Int
    var bookmarkCount: Int
}

// MARK: - Ana Ekran (Home Timeline)

struct HomeView: View {
    // Örnek Timeline verileri - API bağlayınca direkt burayı API'den doldurulacak
    @State private var tweets: [Tweet] = [
        Tweet(authorName: "taklali e60", handle: "@spritfk", time: "15h", text: "Deneme 1 2 3 ... uzun uzun tweett spacing deneme 1 2 3 adwadawjv deneme fixed size deneme", avatarColor: .gray, replyCount: 120, retweetCount: 40, likeCount: 200, goruntulenmeCount: 234, bookmarkCount: 100),
        
        Tweet(authorName: "redbull fedaisi", handle: "@basat_8", time: "12h", text: "redbull kırmızısı", avatarColor: .red, replyCount: 100, retweetCount: 30, likeCount: 345, goruntulenmeCount: 765, bookmarkCount: 936),
        
        Tweet(authorName: "Akkus", handle: "@AhmetAkkys", time: "20h", text: "deneme2 1 3", avatarColor: .green, replyCount: 200, retweetCount: 100, likeCount: 300, goruntulenmeCount: 755, bookmarkCount: 542),
        
        Tweet(authorName: "deneme2", handle: "@deemesf", time: "12h", text: "bazı daha uzun bir tweet deneme 1 2 3 adwadawjv deneme fixed size deneme 1 2 3 adwadawjv deneme fixed size deneme", avatarColor: .blue, replyCount: 0, retweetCount: 274, likeCount: 27, goruntulenmeCount: 273, bookmarkCount: 956),
        
        Tweet(authorName: "deneme2", handle: "@deemesf", time: "12h", text: "bazı daha uzun bir tweet deneme 1 2 3 adwadawjv deneme fixed size deneme 1 2 3 adwadawjv deneme fixed size deneme", avatarColor: .purple, replyCount: 14, retweetCount: 250, likeCount: 924, goruntulenmeCount: 88, bookmarkCount: 956),
        
        Tweet(authorName: "deneme2", handle: "@deemesf", time: "12h", text: "bazı daha uzun bir tweet deneme 1 2 3 adwadawjv deneme fixed size deneme 1 2 3 adwadawjv deneme fixed size deneme", avatarColor: .orange, replyCount: 91, retweetCount: 273, likeCount: 836, goruntulenmeCount: 141, bookmarkCount: 956),
        
        Tweet(authorName: "deneme2", handle: "@deemesf", time: "12h", text: "bazı daha uzun bir tweet deneme 1 2 3 adwadawjv deneme fixed size deneme 1 2 3 adwadawjv deneme fixed size deneme", avatarColor: .cyan, replyCount: 24, retweetCount: 82, likeCount: 123, goruntulenmeCount: 84, bookmarkCount: 123),
        
        Tweet(authorName: "deneme2", handle: "@deemesf", time: "12h", text: "bazı daha uzun bir tweet deneme 1 2 3 adwadawjv deneme fixed size deneme 1 2 3 adwadawjv deneme fixed size deneme", avatarColor: .brown, replyCount: 243, retweetCount: 123, likeCount: 95, goruntulenmeCount: 254, bookmarkCount: 521),
        
        Tweet(authorName: "deneme2", handle: "@deemesf", time: "12h", text: "bazı daha uzun bir tweet deneme 1 2 3 adwadawjv deneme fixed size deneme 1 2 3 adwadawjv deneme fixed size deneme", avatarColor: .teal, replyCount: 721, retweetCount: 635, likeCount: 161, goruntulenmeCount: 142, bookmarkCount: 812),
        
        Tweet(authorName: "deneme2", handle: "@deemesf", time: "12h", text: "bazı daha uzun bir tweet deneme 1 2 3 adwadawjv deneme fixed size deneme 1 2 3 adwadawjv deneme fixed size deneme", avatarColor: .indigo, replyCount: 783, retweetCount: 734, likeCount: 925, goruntulenmeCount: 235, bookmarkCount: 956),
        
        Tweet(authorName: "deneme2", handle: "@deemesf", time: "12h", text: "bazı daha uzun bir tweet deneme 1 2 3 adwadawjv deneme fixed size deneme 1 2 3 adwadawjv deneme fixed size deneme", avatarColor: .mint, replyCount: 0, retweetCount: 732, likeCount: 825, goruntulenmeCount: 124, bookmarkCount: 623),
        
        Tweet(authorName: "deneme2", handle: "@deemesf", time: "12h", text: "bazı daha uzun bir tweet deneme 1 2 3 adwadawjv deneme fixed size deneme 1 2 3 adwadawjv deneme fixed size deneme", avatarColor: .yellow, replyCount: 162, retweetCount: 724, likeCount: 524, goruntulenmeCount: 463, bookmarkCount: 956),
        
        Tweet(authorName: "deneme2", handle: "@deemesf", time: "12h", text: "bazı daha uzun bir tweet deneme 1 2 3 adwadawjv deneme fixed size deneme 1 2 3 adwadawjv deneme fixed size deneme", avatarColor: .teal, replyCount: 721, retweetCount: 635, likeCount: 161, goruntulenmeCount: 142, bookmarkCount: 812),
        
        Tweet(authorName: "deneme2", handle: "@deemesf", time: "12h", text: "bazı daha uzun bir tweet deneme 1 2 3 adwadawjv deneme fixed size deneme 1 2 3 adwadawjv deneme fixed size deneme", avatarColor: .teal, replyCount: 721, retweetCount: 635, likeCount: 161, goruntulenmeCount: 142, bookmarkCount: 812),
        
        Tweet(authorName: "deneme2", handle: "@deemesf", time: "12h", text: "bazı daha uzun bir tweet deneme 1 2 3 adwadawjv deneme fixed size deneme 1 2 3 adwadawjv deneme fixed size deneme", avatarColor: .teal, replyCount: 721, retweetCount: 635, likeCount: 161, goruntulenmeCount: 142, bookmarkCount: 812),
        
        Tweet(authorName: "deneme2", handle: "@deemesf", time: "12h", text: "bazı daha uzun bir tweet deneme 1 2 3 adwadawjv deneme fixed size deneme 1 2 3 adwadawjv deneme fixed size deneme", avatarColor: .teal, replyCount: 721, retweetCount: 635, likeCount: 161, goruntulenmeCount: 142, bookmarkCount: 812),
        
        Tweet(authorName: "deneme2", handle: "@deemesf", time: "12h", text: "bazı daha uzun bir tweet deneme 1 2 3 adwadawjv deneme fixed size deneme 1 2 3 adwadawjv deneme fixed size deneme", avatarColor: .teal, replyCount: 721, retweetCount: 635, likeCount: 161, goruntulenmeCount: 142, bookmarkCount: 812),
        
        Tweet(authorName: "deneme2", handle: "@deemesf", time: "12h", text: "bazı daha uzun bir tweet deneme 1 2 3 adwadawjv deneme fixed size deneme 1 2 3 adwadawjv deneme fixed size deneme", avatarColor: .teal, replyCount: 721, retweetCount: 635, likeCount: 161, goruntulenmeCount: 142, bookmarkCount: 812),
        
        Tweet(authorName: "deneme2", handle: "@deemesf", time: "12h", text: "bazı daha uzun bir tweet deneme 1 2 3 adwadawjv deneme fixed size deneme 1 2 3 adwadawjv deneme fixed size deneme", avatarColor: .teal, replyCount: 721, retweetCount: 635, likeCount: 161, goruntulenmeCount: 142, bookmarkCount: 812),
        
        Tweet(authorName: "deneme2", handle: "@deemesf", time: "12h", text: "bazı daha uzun bir tweet deneme 1 2 3 adwadawjv deneme fixed size deneme 1 2 3 adwadawjv deneme fixed size deneme", avatarColor: .teal, replyCount: 721, retweetCount: 635, likeCount: 161, goruntulenmeCount: 142, bookmarkCount: 812),
        
        Tweet(authorName: "deneme2", handle: "@deemesf", time: "12h", text: "bazı daha uzun bir tweet deneme 1 2 3 adwadawjv deneme fixed size deneme 1 2 3 adwadawjv deneme fixed size deneme", avatarColor: .teal, replyCount: 721, retweetCount: 635, likeCount: 161, goruntulenmeCount: 142, bookmarkCount: 812),
        
        Tweet(authorName: "deneme2", handle: "@deemesf", time: "12h", text: "bazı daha uzun bir tweet deneme 1 2 3 adwadawjv deneme fixed size deneme 1 2 3 adwadawjv deneme fixed size deneme", avatarColor: .teal, replyCount: 721, retweetCount: 635, likeCount: 161, goruntulenmeCount: 142, bookmarkCount: 812),
        
        Tweet(authorName: "deneme2", handle: "@deemesf", time: "12h", text: "bazı daha uzun bir tweet deneme 1 2 3 adwadawjv deneme fixed size deneme 1 2 3 adwadawjv deneme fixed size deneme", avatarColor: .teal, replyCount: 721, retweetCount: 635, likeCount: 161, goruntulenmeCount: 142, bookmarkCount: 812),
        
        Tweet(authorName: "deneme2", handle: "@deemesf", time: "12h", text: "bazı daha uzun bir tweet deneme 1 2 3 adwadawjv deneme fixed size deneme 1 2 3 adwadawjv deneme fixed size deneme", avatarColor: .teal, replyCount: 721, retweetCount: 635, likeCount: 161, goruntulenmeCount: 142, bookmarkCount: 812),
        
        Tweet(authorName: "deneme2", handle: "@deemesf", time: "12h", text: "bazı daha uzun bir tweet deneme 1 2 3 adwadawjv deneme fixed size deneme 1 2 3 adwadawjv deneme fixed size deneme", avatarColor: .teal, replyCount: 721, retweetCount: 635, likeCount: 161, goruntulenmeCount: 142, bookmarkCount: 812),
        
        Tweet(authorName: "deneme2", handle: "@deemesf", time: "12h", text: "bazı daha uzun bir tweet deneme 1 2 3 adwadawjv deneme fixed size deneme 1 2 3 adwadawjv deneme fixed size deneme", avatarColor: .teal, replyCount: 721, retweetCount: 635, likeCount: 161, goruntulenmeCount: 142, bookmarkCount: 812),
        
        Tweet(authorName: "deneme2", handle: "@deemesf", time: "12h", text: "bazı daha uzun bir tweet deneme 1 2 3 adwadawjv deneme fixed size deneme 1 2 3 adwadawjv deneme fixed size deneme", avatarColor: .teal, replyCount: 721, retweetCount: 635, likeCount: 161, goruntulenmeCount: 142, bookmarkCount: 812),
        
        Tweet(authorName: "deneme2", handle: "@deemesf", time: "12h", text: "bazı daha uzun bir tweet deneme 1 2 3 adwadawjv deneme fixed size deneme 1 2 3 adwadawjv deneme fixed size deneme", avatarColor: .teal, replyCount: 721, retweetCount: 635, likeCount: 161, goruntulenmeCount: 142, bookmarkCount: 812),
        
        Tweet(authorName: "deneme2", handle: "@deemesf", time: "12h", text: "bazı daha uzun bir tweet deneme 1 2 3 adwadawjv deneme fixed size deneme 1 2 3 adwadawjv deneme fixed size deneme", avatarColor: .teal, replyCount: 721, retweetCount: 635, likeCount: 161, goruntulenmeCount: 142, bookmarkCount: 812),
        
        Tweet(authorName: "deneme2", handle: "@deemesf", time: "12h", text: "bazı daha uzun bir tweet deneme 1 2 3 adwadawjv deneme fixed size deneme 1 2 3 adwadawjv deneme fixed size deneme", avatarColor: .teal, replyCount: 721, retweetCount: 635, likeCount: 161, goruntulenmeCount: 142, bookmarkCount: 812),
        
        Tweet(authorName: "deneme2", handle: "@deemesf", time: "12h", text: "bazı daha uzun bir tweet deneme 1 2 3 adwadawjv deneme fixed size deneme 1 2 3 adwadawjv deneme fixed size deneme", avatarColor: .teal, replyCount: 721, retweetCount: 635, likeCount: 161, goruntulenmeCount: 142, bookmarkCount: 812),
        
        Tweet(authorName: "deneme2", handle: "@deemesf", time: "12h", text: "bazı daha uzun bir tweet deneme 1 2 3 adwadawjv deneme fixed size deneme 1 2 3 adwadawjv deneme fixed size deneme", avatarColor: .teal, replyCount: 721, retweetCount: 635, likeCount: 161, goruntulenmeCount: 142, bookmarkCount: 812),
        
        Tweet(authorName: "deneme2", handle: "@deemesf", time: "12h", text: "bazı daha uzun bir tweet deneme 1 2 3 adwadawjv deneme fixed size deneme 1 2 3 adwadawjv deneme fixed size deneme", avatarColor: .teal, replyCount: 721, retweetCount: 635, likeCount: 161, goruntulenmeCount: 142, bookmarkCount: 812),
        
        Tweet(authorName: "deneme2", handle: "@deemesf", time: "12h", text: "bazı daha uzun bir tweet deneme 1 2 3 adwadawjv deneme fixed size deneme 1 2 3 adwadawjv deneme fixed size deneme", avatarColor: .teal, replyCount: 721, retweetCount: 635, likeCount: 161, goruntulenmeCount: 142, bookmarkCount: 812),
        
        Tweet(authorName: "deneme2", handle: "@deemesf", time: "12h", text: "bazı daha uzun bir tweet deneme 1 2 3 adwadawjv deneme fixed size deneme 1 2 3 adwadawjv deneme fixed size deneme", avatarColor: .teal, replyCount: 721, retweetCount: 635, likeCount: 161, goruntulenmeCount: 142, bookmarkCount: 812)
    ]
    
    @State private var showComposer = false //Sağ alttaki + Buttonu
    
    
    var body: some View{
        NavigationStack{
            
            ZStack(alignment: .bottomTrailing) {
                
                // ---------------------------------
                //Time
                // -----------------------------------
                
                List{
                    ForEach(tweets) { tweet in
                        TweetRow(tweet: tweet).listRowInsets(.init(top:14, leading:16, bottom:14, trailing:16))
                    }
                }
                .listStyle(.plain).background(Color(uiColor:.systemGray6))
                
                
                // ---------------------------------
                // Sağ alt + buttonu
                // -----------------------------------
                Button {
                    showComposer = true
                } label: {
                    Image("NewTweetIcon")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 65, height: 65)
                        .background(Circle().fill(Color.blue))
                        .shadow(radius: 5, y: 3)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 24)
            }
            
            
            // ---------------------------------
            //NAVBAR - sol avatar, ortada kuş, sağda ayar ikonu
            // -----------------------------------
            
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Circle()
                        .fill(.blue)
                        .frame(width:32, height:32)
                        .overlay(
                            Image("ahmet")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 90)
                                .clipShape(Circle())
                        )
                }
                
                ToolbarItem(placement: .principal) {
                    Image("TwitterLogoBlue")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                }
                
                ToolbarItem(placement: .navigationBarTrailing){
                    Image("FeatureStrokeIcon")
                }
            }
            
            // ---------------------------------
            //Compose Tweet Sheet (şimdilik basit placeholder)
            // -----------------------------------
            .sheet(isPresented: $showComposer) {
                Text("Tweet Composer")
                    .font(.largeTitle)
                    .padding()
            }
        }
    }
}

//MARK: - Tweet Row (Her tweet hücresi)

struct TweetRow: View{
    
    let tweet: Tweet
    
    var body: some View {
        
        HStack(alignment: .top, spacing: 12) {
            
            //Avatar
            Circle()
                .fill(tweet.avatarColor)
                .frame(width: 44, height: 44)
            
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
                
                
                TweetActions(tweet: tweet)
                    .padding(.top, 4)
                
            }
        }
        
    }
}

// ======================================================
// MARK: - Alt Buttonlar
// ======================================================

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
            
            /*
            action("lines.measurement.horizontal.aligned.bottom", tweet.goruntulenmeCount)
            Spacer()
            */
             
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

//PREVIEW
#Preview {
    HomeView()
}
