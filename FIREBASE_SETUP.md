# Firebase Setup Guide

This app now supports Firebase Firestore for persistent storage of book listings. Follow these steps to enable it.

## Step 1: Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Enter project name: `boook-marketplace`
4. Follow the setup wizard

## Step 2: Configure Firebase for Your Platform

### Android Configuration

1. Go to Firebase Console → Your Project → Project Settings
2. Under "Your apps", click "Add app" → Android
3. Download `google-services.json`
4. Move it to: `android/app/google-services.json`

### iOS Configuration

1. Go to Firebase Console → Your Project → Project Settings
2. Under "Your apps", click "Add app" → iOS
3. Download `GoogleService-Info.plist`
4. Open Xcode: `open ios/Runner.xcworkspace`
5. Drag `GoogleService-Info.plist` into the Runner folder
6. Ensure "Copy items if needed" is checked

## Step 3: Update Firebase Options

1. Install FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```

2. Configure Firebase for your project:
   ```bash
   cd /Users/gino/IdeaProjects/boook_marketplace
   flutterfire configure
   ```

   This will update `lib/firebase_options.dart` with your project credentials.

## Step 4: Set Up Firestore Database

1. Go to Firebase Console → Your Project → Firestore Database
2. Click "Create database"
3. Select: `Start in production mode`
4. Choose location: `Europe (or your region)`
5. Click "Create"

## Step 5: Set Firestore Security Rules

1. In Firestore Console, go to "Rules" tab
2. Replace the default rules with:

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /books/{document=**} {
      allow read: if true;
      allow create, update, delete: if true;
    }
  }
}
```

⚠️ **Warning**: These are permissive rules for development. For production, implement proper authentication and authorization.

## Step 6: Run the App

```bash
flutter pub get
flutter run
```

## How It Works

- **First Launch**: App loads sample books from `assets/data/books.json` and seeds Firestore
- **Adding Books**: New listings are saved to Firestore automatically
- **Data Persistence**: Books persist across app restarts
- **Fallback**: If Firebase isn't available, the app uses local JSON data

## Troubleshooting

### "Failed assertion: line 4081"
- Make sure Firebase is properly initialized in `main.dart`
- Check that `firebase_options.dart` has your correct credentials

### Books not appearing after restart
- Ensure Firestore is created and accessible
- Check Firestore Rules in Firebase Console
- Verify no errors in Logcat (Android) or Console (iOS)

### "Permission denied" errors
- Check your Firestore Rules (see Step 5)
- Make sure rules allow `read` and `create` operations

## Production Deployment

Before deploying to production:

1. **Enable Authentication**: Set up Firebase Authentication
2. **Secure Rules**: Implement proper security rules:
   ```firestore
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /books/{document=**} {
         allow read: if true;
         allow create, update: if request.auth.uid != null;
         allow delete: if request.auth.uid == resource.data.seller_uid;
       }
     }
   }
   ```
3. **Enable Indexes**: Create composite indexes as needed
4. **Set Up Backups**: Enable automatic backups in Firebase Console
5. **Monitor Usage**: Set up billing alerts

## Additional Resources

- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Cloud Firestore Documentation](https://firebase.google.com/docs/firestore)
- [Firebase Security Rules](https://firebase.google.com/docs/firestore/security/start)
