# BookSwap - Book Marketplace Application

A feature-rich Flutter application that enables users to browse, buy, and swap books in their community. Built with modern architecture patterns and state management.

## Project Description

BookSwap is a mobile marketplace platform where book enthusiasts can:
- **Browse** thousands of book listings from their community with infinite scrolling
- **Search** for specific books using advanced filters (category, condition, listing type)
- **Post** their own books for sale, swap, or free distribution with comprehensive form validation
- **Connect** with sellers through direct contact information
- **Customize** the app experience with persistent light/dark theme preferences

The application demonstrates modern Flutter development best practices with a clean, layered architecture supporting scalability and maintenance.

## Technical Requirements Met

✅ **Navigation**: Bottom navigation bar + side drawer menu  
✅ **List View**: Scrollable ListView with infinite pagination (10 items/page)  
✅ **Custom Widgets**: BookListTile widget with images and condition badges  
✅ **Detail Screen**: Full book details with seller information  
✅ **Validation**: Validators class with all validation logic outside widgets  
✅ **Theme**: Light/dark mode toggle with Material 3 design  
✅ **State Management**: Riverpod with reactive providers  
✅ **Architecture**: Layered (models/, services/, providers/, screens/, widgets/)  
✅ **Async Handling**: Loading, error, and empty states  
✅ **Navigation**: go_router with named routes  
✅ **Tests**: Unit + widget tests (all passing)  
✅ **About Screen**: Developer info with contact details  
✅ **Settings**: Theme preference persisted in shared_prefs  
✅ **Design**: Colors, icons, Material 3 components  

## Project Structure

```
lib/
├── main.dart                    # App entry point with Riverpod setup
├── models/
│   └── book_listing.dart       # Book model (fromJson/toJson)
├── services/
│   └── book_service.dart       # Data service for JSON + filtering
├── providers/
│   ├── books_provider.dart     # Books state (pagination + filters)
│   └── theme_provider.dart     # Theme state (SharedPreferences)
├── screens/
│   ├── home_screen.dart        # Shell with drawer + nav bar
│   ├── browse_screen.dart      # Book list (infinite scroll)
│   ├── search_screen.dart      # Search with validation
│   ├── book_detail_screen.dart # Book details
│   ├── add_listing_screen.dart # Form with validation
│   ├── settings_screen.dart    # Theme + preferences
│   └── about_screen.dart       # Developer info
├── widgets/
│   ├── book_list_tile.dart     # Custom list tile
│   ├── condition_badge.dart    # Condition indicator
│   ├── loading_widget.dart     # Loading state
│   ├── app_error_widget.dart   # Error state with retry
│   └── empty_state_widget.dart # Empty results state
├── theme/
│   └── app_theme.dart          # Light/dark themes
├── utils/
│   └── validators.dart         # All validation functions
└── router/
    └── app_router.dart         # go_router configuration

assets/
└── data/
    └── books.json              # Sample book data (20 entries)

test/
├── models/book_listing_test.dart      # Model tests
├── utils/validators_test.dart         # Validator tests
├── providers/books_provider_test.dart # State tests
└── widgets/book_list_tile_test.dart   # Widget tests
```

## Setup Instructions

### Requirements
- Flutter SDK: ^3.11.4
- Android SDK (emulator) or Xcode (iOS)

### Installation

```bash
# Navigate to project
cd boook_marketplace

# Install dependencies
flutter pub get

# Run app on emulator
flutter run

# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

## Main Packages & Why

| Package | Purpose |
|---------|---------|
| **flutter_riverpod** | Reactive state management |
| **go_router** | Declarative navigation |
| **shared_preferences** | Local theme persistence |
| **cached_network_image** | Efficient image loading |
| **intl** | Date formatting |

## Features

### Core
- Infinite pagination (10 books/page)
- Real-time search and filtering
- Form validation with clear errors
- Theme switching with persistence
- Error states with retry options
- Empty states with helpful messages

### Data
- JSON-based book data (easy Firebase migration)
- Service layer abstraction
- Model serialization (fromJson/toJson)

### UI/UX
- Material 3 design
- Condition badges with colors
- Category icons
- Loading indicators
- Responsive layout

## Testing

```bash
# Run all tests
flutter test

# Specific test file
flutter test test/utils/validators_test.dart

# With coverage report
flutter test --coverage
```

**Test Coverage**:
- Unit tests: Models, Validators, Providers
- Widget tests: BookListTile rendering and interactions

## Architecture Highlights

- **Layered Design**: Data → Logic → UI separation
- **Repository Pattern**: BookService abstraction
- **Provider Pattern**: Riverpod reactive state
- **Validator Pattern**: Pure validation functions
- **Custom Widgets**: Reusable BookListTile
- **No Business Logic in Widgets**: Clean separation of concerns

## Firebase Integration ✅ Implemented

The app now includes **Firebase Firestore** support for persistent storage!

**Features:**
- Automatic syncing of new book listings to Firestore
- Data persists across app restarts
- Graceful fallback to local JSON if Firebase unavailable
- Seamless setup with FlutterFire CLI

**To Enable Firebase:**

1. Set up Firebase project (free tier available)
2. Run: `flutterfire configure`
3. Update `lib/firebase_options.dart` with your credentials
4. Create Firestore database
5. Done! Books now persist in the cloud

See [FIREBASE_SETUP.md](FIREBASE_SETUP.md) for detailed instructions.

**Current State:**
- 🟢 Firebase code is ready (just needs configuration)
- 🟢 App works with or without Firebase
- 🟢 All books added are synced to Firestore

## Developer

**Group4**
gino@example.com

## Version

**v1.0.0** - April 2026 - Initial Release

---

Built with Flutter & Riverpod ❤️
