# BookSwap — Book Marketplace App

A Flutter application that lets users browse, buy, swap, and give away books within their community. Users can post listings with title, author, condition, price, and contact details. The app supports infinite scrolling, search, filtering, and persistent dark/light theme preferences.

---

## Screenshots

| Browse | Book Detail | Add Listing |
|--------|-------------|-------------|
| ![Browse Screen](screenshots/browse.png) | ![Detail Screen](screenshots/detail.png) | ![Add Listing](screenshots/add_listing.png) |

---

## Setup & Run Instructions

**Requirements**
- Flutter SDK: **3.41.6** (stable)
- Dart SDK: 3.x
- Android emulator or physical device (iOS/Android)

**Installation**

```bash
# 1. Clone the repository
git clone <repo-url>
cd book_swap_marketplace

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run

# 4. Run all tests
flutter test
```

**Firebase Setup (optional)**

The app works offline using `assets/data/books.json` as a fallback. To enable Firestore:

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase (select your project)
flutterfire configure
```

Then create a Firestore database in the [Firebase Console](https://console.firebase.google.com) and deploy the security rules:

```bash
firebase deploy --only firestore:rules --project <your-project-id>
```

---

## Main Packages

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_riverpod` | ^2.5.1 | Reactive state management — manages books list, search, filters, and theme state |
| `go_router` | ^14.2.4 | Declarative navigation with named routes and deep-link support |
| `shared_preferences` | ^2.2.2 | Persists the user's light/dark theme preference across app restarts |
| `cached_network_image` | ^3.3.1 | Efficiently loads and caches book cover images from URLs |
| `firebase_core` | ^3.3.0 | Firebase SDK initialization required for all Firebase services |
| `cloud_firestore` | ^5.3.0 | Cloud database for persistent book listings with real-time sync |
| `intl` | ^0.19.0 | Date formatting for listing timestamps |
| `mockito` | ^5.4.4 | Mocking in unit and widget tests |

---

## Project Structure

```
lib/
├── models/         # BookListing model with fromJson/toJson
├── services/       # BookService (JSON) + FirestoreBookService (Firebase)
├── providers/      # BooksNotifier (pagination, search, filter) + ThemeNotifier
├── screens/        # browse, search, detail, add_listing, settings, about
├── widgets/        # BookListTile, ConditionBadge, LoadingWidget, AppErrorWidget, EmptyStateWidget
├── utils/          # Validators (all validation logic outside widgets)
├── theme/          # Light & dark MaterialTheme definitions
└── router/         # GoRouter configuration with named routes

assets/
└── data/books.json # Local seed data (fallback when Firebase is unavailable)

test/
├── models/         # BookListing fromJson/toJson unit tests
├── utils/          # Validator function unit tests
├── providers/      # BooksNotifier unit tests
└── widgets/        # BookListTile widget tests
```

---

## Developer
**Elisa Holzheid**

**Edin Putzu**

**Gino Chianese**
