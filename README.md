# 🐦 XClone (SwiftUI Edition)

A native iOS Twitter (X) clone built with **SwiftUI** and **MVVM** architecture. This project demonstrates modern iOS development practices, networking with Async/Await, and handling real-world API limitations creatively.

## 🚀 Project Overview
This app mimics the core functionality of the X mobile app. The main goal is to build a scalable, clean, and maintainable codebase using the latest Swift features.

**Note on Data Source:**
Due to the recent X API v2 limitations (Free Tier does not allow "Read" access to Timelines), the app utilizes a **Custom Mock Data Engine** for fetching tweets. However, the "Post Tweet" feature is designed to work with the **Real Live API**.

## 🎯 Goals & Features

### ✅ Completed / In Progress
- **MVVM Architecture:** Clean separation of concerns (Model - View - ViewModel).
- **Network Layer:** A robust `APIManager` handling Generic requests, decoding, and error management.
- **Async/Await:** Modern concurrency for smooth data fetching.
- **Smart Fallback System:** Automatically switches to Mock Data when API limits (401/403) are detected.
- **UI Design:** Custom `TweetRow` and `Timeline` views matching the original design language.

### 🔜 To Be Implemented
- [ ] **Real Tweet Posting:** Connecting the FAB (Floating Action Button) to the `POST /2/tweets` endpoint.
- [ ] **Authentication:** OAuth 2.0 integration.
- [ ] **Search & Explore:** Querying users and hashtags.
- [ ] **Profile Page:** Fetching user details (Bio, Followers, etc.).
- [ ] **Media Support:** Uploading images with tweets.

## 🛠 Tech Stack
* **Language:** Swift 5
* **UI Framework:** SwiftUI
* **Architecture:** MVVM
* **Concurrency:** Swift Concurrency (Async/Await)
* **Versioning:** Git

---

*This project is for educational purposes and is not affiliated with X Corp.*
