<div align="center">
  
# 🐦 Twitter - The Classic Experience

[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)](https://developer.apple.com/ios/)
[![Swift Version](https://img.shields.io/badge/Swift-5.0+-orange.svg)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-15.0+-blue.svg)](https://developer.apple.com/xcode/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

**A faithful recreation of the classic Twitter experience before the X rebrand**

*Bringing back the nostalgia of the original Twitter interface with modern Swift and iOS development*

[Features](#-features) • [Screenshots](#-screenshots) • [Installation](#-installation) • [Architecture](#-architecture) • [Contributing](#-contributing)

</div>

---

## 📖 About

The changes made to Twitter after its acquisition were not well received by many users, including myself. This project aims to recreate the beloved classic Twitter experience - the interface, features, and feel of Twitter before it became X.

This is a complete iOS app built with Swift and UIKit/SwiftUI, faithfully replicating the original Twitter's design language, user interactions, and core features. It's a tribute to the platform that connected millions of people around the world.

## ✨ Features

### Core Functionality
- 🏠 **Home Timeline** - Chronological feed of tweets from followed accounts
- 🔍 **Search & Explore** - Discover trending topics and new accounts
- 🔔 **Notifications** - Real-time updates for mentions, likes, and retweets
- ✉️ **Direct Messages** - Private conversations with other users
- 👤 **Profile Management** - Customizable user profiles with bio, banner, and avatar

### Tweet Interactions
- ✍️ **Compose Tweets** - Create tweets with text, images, and polls
- 🔄 **Retweet & Quote Tweet** - Share content with your followers
- ❤️ **Like & Bookmark** - Save your favorite tweets
- 💬 **Reply & Thread** - Engage in conversations
- 📊 **Polls** - Create and participate in polls

### Classic Twitter UI Elements
- 🎨 Original Twitter blue color scheme (#1DA1F2)
- 🐦 Classic bird logo and branding
- 📱 Familiar navigation and gesture interactions
- 🌓 Light and dark mode support
- 🎭 Smooth animations and transitions

## 📱 Screenshots

> **Coming Soon**: Screenshots will be added as the app development progresses.

<div align="center">
  <i>Home Timeline • Search • Notifications • Profile</i>
</div>

## 🛠️ Requirements

- **iOS**: 15.0+
- **Xcode**: 15.0+
- **Swift**: 5.0+
- **CocoaPods** or **Swift Package Manager** (for dependencies)

## 📦 Installation

### Clone the Repository

```bash
git clone https://github.com/akkusahmet16/Twitter.git
cd Twitter
```

### Using CocoaPods

```bash
pod install
open Twitter.xcworkspace
```

### Using Swift Package Manager

1. Open `Twitter.xcodeproj` in Xcode
2. Dependencies will be automatically resolved
3. Build and run (⌘R)

### Configuration

1. Create a `Config.plist` file (not tracked in git)
2. Add your API keys and configuration:
   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
       <key>API_BASE_URL</key>
       <string>YOUR_API_URL</string>
   </dict>
   </plist>
   ```

## 🏗️ Architecture

The app follows clean architecture principles with MVVM pattern:

```
Twitter/
├── App/                    # App lifecycle and configuration
├── Models/                 # Data models and entities
├── Views/                  # UI components and screens
│   ├── Home/
│   ├── Search/
│   ├── Notifications/
│   ├── Messages/
│   └── Profile/
├── ViewModels/            # Business logic layer
├── Services/              # API and data services
├── Utilities/             # Helper functions and extensions
├── Resources/             # Assets, fonts, and localization
└── Supporting Files/      # Plists and configurations
```

### Key Technologies

- **UI Framework**: UIKit / SwiftUI (hybrid approach)
- **Networking**: URLSession with async/await
- **Image Loading**: SDWebImage / Kingfisher
- **Data Persistence**: Core Data / Realm
- **Dependency Injection**: Custom container
- **Reactive Programming**: Combine framework

## 🗺️ Roadmap

### Phase 1: Core Features (Current)
- [x] Project setup and architecture
- [ ] Authentication system
- [ ] Home timeline implementation
- [ ] Tweet composition
- [ ] Basic profile view

### Phase 2: Enhanced Features
- [ ] Search and explore
- [ ] Notifications system
- [ ] Direct messaging
- [ ] Media upload and preview
- [ ] Trending topics

### Phase 3: Advanced Features
- [ ] Lists functionality
- [ ] Bookmarks
- [ ] Moments
- [ ] Advanced search filters
- [ ] Analytics and insights

### Phase 4: Polish & Optimization
- [ ] Performance optimization
- [ ] Accessibility improvements
- [ ] Localization (multiple languages)
- [ ] Comprehensive testing
- [ ] App Store preparation

## 🤝 Contributing

Contributions are welcome! This project aims to recreate the classic Twitter experience as accurately as possible.

### How to Contribute

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add some amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Development Guidelines

- Follow Swift style guide and best practices
- Write clean, readable, and documented code
- Maintain the classic Twitter design language
- Add unit tests for new features
- Update documentation as needed

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

This project is a personal educational project and is not affiliated with, endorsed by, or connected to Twitter, Inc. (now X Corp) or any of its subsidiaries or affiliates. All trademarks, service marks, trade names, product names, and logos are the property of their respective owners.

This app is created for educational purposes and to demonstrate iOS development skills. It is not intended for commercial use or distribution.

## 🙏 Acknowledgments

- Thanks to the original Twitter design team for creating such an iconic interface
- The iOS developer community for their amazing resources and support
- All contributors who help bring back the classic Twitter experience

## 📧 Contact

**Ahmet Akkuş** - [@akkusahmet16](https://github.com/akkusahmet16)

Project Link: [https://github.com/akkusahmet16/Twitter](https://github.com/akkusahmet16/Twitter)

---

<div align="center">
  
**Built with ❤️ and nostalgia for the classic Twitter**

*"The bird is back"* 🐦

</div>
