# Requirements — PetCare

Flutter projects don't use a `requirements.txt` (that's a Python convention) — dependencies are declared in `pubspec.yaml`. This file documents everything needed to set up and run the project, plus a copy of the dependency list for quick reference.

---

## 1. Environment Requirements

| Tool | Minimum Version | Notes |
|---|---|---|
| Flutter SDK | 3.x+ | https://docs.flutter.dev/get-started/install |
| Dart SDK | Bundled with Flutter | — |
| Android Studio / VS Code | Latest | With Flutter & Dart plugins installed |
| Android SDK | API 21+ | For Android builds |
| Xcode | Latest (macOS only) | Required only for iOS builds |
| Firebase CLI | Latest | `npm install -g firebase-tools` (optional, for managing Firebase) |
| Git | Any recent version | For cloning/pushing the repo |

Verify your Flutter setup:
```bash
flutter doctor
```

---

## 2. Flutter Package Dependencies

These are declared in `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  cloud_firestore: ^6.6.0
  firebase_core: ^4.11.0
  firebase_auth: ^6.5.3
```

Install them with:
```bash
flutter pub get
```

---

## 3. Firebase Setup (Required)

The app depends on a connected Firebase project for Authentication and Cloud Firestore.

1. Create a project at [Firebase Console](https://console.firebase.google.com/).
2. Enable **Authentication → Email/Password** sign-in method.
3. Enable **Cloud Firestore** (start in test mode for development).
4. Register an Android app with package name matching `android/app/build.gradle` (`applicationId`).
5. Download `google-services.json` and place it in:
   ```
   android/app/google-services.json
   ```
6. (iOS) Download `GoogleService-Info.plist` and add it to the iOS runner via Xcode if building for iOS.

> ⚠️ Do **not** commit your own production `google-services.json` / API keys to a public repo. Add it to `.gitignore` if the project will be public, and document setup steps for collaborators instead.

---

## 4. Firestore Collections Expected

The app reads/writes to these collections — no manual creation needed, Firestore creates them on first write:

- `users`
- `pets`
- `feeding`
- `health`
- `vaccines`

---

## 5. Running the Project

```bash
git clone https://github.com/Areeb-alpha/MAD-Projects.git
cd MAD-Projects
flutter pub get
flutter run
```

To build a release APK:
```bash
flutter build apk --release
```

---

## 6. Recommended `.gitignore` additions

```
# Flutter / Dart
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
build/
.idea/

# Firebase secrets (if keeping repo public)
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
```
