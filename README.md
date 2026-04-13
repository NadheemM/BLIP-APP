# ⚡ Blip — Real-Time Chat Application

A clean, minimal real-time chat application built with **Flutter** and **Firebase**.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)

## ✨ Features

### 🔐 Authentication
- Google Sign-In via Firebase Auth
- User profile stored in Firestore (`users` collection)
- Persistent login state across sessions
- Profile picture and display name shown in the app

### 💬 Real-Time Messaging
- Messages sent and received in real-time using Firestore `StreamBuilder`
- Messages stored in Firestore `messages` collection
- Chat bubbles — sent (deep blue, right-aligned) / received (light grey, left-aligned)
- Sender name, profile avatar, and timestamp on each message
- Date dividers between messages from different days
- Smooth auto-scroll when new messages arrive

### 🗑️ Delete Messages
- Long-press on your own message to delete
- Bottom sheet confirmation with "Delete Message" option
- UID-based ownership verification
- Real-time deletion — disappears for all users instantly

### 🔔 Push Notifications (FCM)
- Firebase Cloud Messaging integration
- Notification permission request on launch
- FCM token stored in Firestore `users` collection
- Foreground notifications via `flutter_local_notifications`
- Background notifications via FCM service worker (web)
- Cloud Function included for auto-sending notifications on new messages

### 🎨 UI/UX
- Minimal, clean light theme with deep blue (`#1A3A6B`) accents
- Google Fonts (Inter) typography
- Animated splash screen with pulsing ⚡ logo
- Smooth page transitions (fade, slide)
- Animated message bubbles (scale + fade)
- Press-feedback on interactive elements

## 🛠️ Tech Stack

| Technology | Purpose |
|------------|---------|
| Flutter | Cross-platform UI framework |
| Firebase Auth | Google Sign-In authentication |
| Cloud Firestore | Real-time database for messages & users |
| Firebase Cloud Messaging | Push notifications |
| flutter_local_notifications | Foreground notification banners |
| Google Fonts | Inter font family |
| SharedPreferences | Local storage (legacy) |

## 📁 Project Structure

```
lib/
├── main.dart                        # App entry, Firebase init, auth routing
├── firebase_options.dart            # Firebase project configuration
├── screens/
│   ├── splash_screen.dart           # Animated splash with pulsing logo
│   ├── login_screen.dart            # Google Sign-In screen
│   ├── home_screen.dart             # Chat room listing with user greeting
│   └── chat_screen.dart             # Real-time chat with StreamBuilder
├── services/
│   ├── auth_service.dart            # Google Sign-In, user management
│   ├── chat_service.dart            # Firestore CRUD for messages
│   └── notification_service.dart    # FCM setup, local notifications
└── widgets/
    └── message_bubble.dart          # Animated chat bubble widget

functions/
├── index.js                         # Cloud Function for FCM notifications
└── package.json                     # Cloud Function dependencies

web/
├── firebase-messaging-sw.js         # FCM service worker for web
└── index.html                       # Web entry point
```

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.9+)
- A [Firebase project](https://console.firebase.google.com)
- Google Sign-In enabled in Firebase Authentication

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/NadheemM/BLIP-APP.git
   cd BLIP-APP
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
   - Enable **Google Sign-In** in Authentication → Sign-in method
   - Create a **Firestore Database** (start in test mode)
   - Update `lib/firebase_options.dart` with your Firebase config values
   - Or run `flutterfire configure` to auto-generate it

4. **Run the app**
   ```bash
   flutter run -d chrome    # Web
   flutter run -d android   # Android
   flutter run -d ios       # iOS
   ```

### Deploy Cloud Function (Optional)
Requires Firebase Blaze (pay-as-you-go) plan:
```bash
npm install -g firebase-tools
firebase login
cd functions && npm install && cd ..
firebase deploy --only functions
```

## 📱 Screens

| Splash | Login | Home | Chat |
|--------|-------|------|------|
| Animated ⚡ logo | Google Sign-In | Chat room card | Real-time messages |

## 🔥 Firestore Collections

### `messages`
| Field | Type | Description |
|-------|------|-------------|
| `text` | String | Message content |
| `sender` | String | Sender display name |
| `senderUid` | String | Sender's Firebase UID |
| `senderPhotoUrl` | String | Sender's Google profile photo URL |
| `timestamp` | Timestamp | Server timestamp |

### `users`
| Field | Type | Description |
|-------|------|-------------|
| `uid` | String | Firebase UID |
| `displayName` | String | Google display name |
| `email` | String | Google email |
| `photoURL` | String | Google profile photo URL |
| `fcmToken` | String | FCM registration token |
| `lastLogin` | Timestamp | Last login timestamp |

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

Made with ❤️ using Flutter & Firebase
