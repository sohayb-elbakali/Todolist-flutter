# 📝 Flutter Todo List App

A modern, beautifully designed todo list app with Firebase backend and real-time sync.

## ✨ Features

**🔐 Authentication**
- Email/Password login with Firebase Auth
- Welcome screen on first login
- Persistent user sessions

**📋 Task Management (CRUD)**
- ✅ **Create** - Add tasks with title, description, and category
- 📖 **Read** - Real-time task list from Firestore
- ✏️ **Update** - Edit existing tasks
- 🗑️ **Delete** - Remove tasks with confirmation

**🎨 Design**
- Clean, modern UI with gradient backgrounds
- Category-based color coding (Personal, Work, Shopping, Others)
- Smooth animations and transitions
- Responsive card-based layout
- Personalized header with username

**☁️ Firebase Integration**
- **Firestore** - Real-time database for tasks
- **Authentication** - Secure user management
- **User-specific data** - Each user sees only their tasks

## 🚀 Quick Start

### Prerequisites
- Flutter SDK installed
- Firebase project created
- FlutterFire CLI installed: `dart pub global activate flutterfire_cli`

### Setup

```bash
# 1. Install dependencies
flutter pub get

# 2. Configure Firebase (generates firebase_options.dart)
flutterfire configure

# 3. Run the app
flutter run
```

**Note:** `firebase_options.dart` is not included in the repo for security. Use `flutterfire configure` to generate it.

## 📦 Tech Stack

- **Flutter** - UI framework
- **Firebase Auth** - User authentication
- **Cloud Firestore** - NoSQL database
- **SharedPreferences** - Local storage

## 🎨 Color Palette

| Category | Color | Hex |
|----------|-------|-----|
| Personal | Purple | #6C63FF |
| Work | Pink | #FF6B9D |
| Shopping | Teal | #4ECDC4 |
| Others | Coral | #FFA07A |

## 📱 Screenshots

- Welcome screen with user greeting
- Task list with category badges
- Add/Edit task modal
- Delete confirmation dialog

---

Built with ❤️ using Flutter & Firebase

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
