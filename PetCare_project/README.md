# 🐾 PetCare — Pet Health & Care Management Mobile Application

PetCare is a comprehensive mobile application designed to help pet owners easily manage their pets' daily activities, health records, feeding schedules, and vaccination reminders. It provides an intuitive, user-friendly interface for tracking important information about multiple pets, ensuring their overall well-being and keeping owners informed through smart tracking and reminders.

---

## 📱 Key Features

- **Authentication** — Secure Login and Sign-Up screens for users to create and access their pet care accounts.
- **Pet Profile Management** — A centralized hub to add and view pets, tracking their breed, age, weight, and gender.
- **Feeding Schedule Tracker** — An interactive daily checklist to monitor meal times, food types, and portion sizes.
- **Vaccination Records** — A dedicated tracking system for past and upcoming vaccinations, complete with overdue alerts.
- **Health Monitoring** — Visual weight tracking charts and a comprehensive log of vet visits.
- **Personalization** — User settings for dark mode, notifications, and language preferences.

---

## 🛠️ Technologies & Tools

| Category | Technology |
|---|---|
| Framework | Flutter (Cross-platform) |
| Language | Dart |
| Backend / Database | Firebase (Authentication + Cloud Firestore) |
| State Management | Core `setState` for dynamic UI updates |
| UI Components | Material Design — `Scaffold`, `ListView`, `Column`, `Row`, `Card`, `Drawer`, `BottomNavigationBar`, custom modal bottom sheets |
| Design | Gradient backgrounds, semi-transparent cards, color-coded health statuses, responsive layouts |

---

## 📂 Project Structure

```
lib/
├── main.dart                 # App entry point, Firebase init
├── login_screen.dart         # Firebase Auth sign-in
├── signup_screen.dart        # Firebase Auth registration
├── home_screen.dart          # Dashboard, Drawer, Quick Actions
├── my_pets_screen.dart       # Pet profile CRUD
├── feeding_screen.dart       # Feeding schedule tracker
├── health_screen.dart        # Vet visit / health log
├── vaccination_screen.dart   # Vaccination record tracker
└── about_screen.dart         # App & developer info
```

---

## 🖥️ App Screens

| Screen | File | Description |
|---|---|---|
| Login | `login_screen.dart` | Email/password sign-in via Firebase Auth |
| Sign Up | `signup_screen.dart` | New account creation, writes profile to Firestore |
| Home Dashboard | `home_screen.dart` | Central hub with Drawer + Bottom Nav, live pet list |
| My Pets | `my_pets_screen.dart` | Add/view/delete pet profiles |
| Feeding Schedule | `feeding_screen.dart` | Track meals with daily completion progress |
| Health Monitor | `health_screen.dart` | Log vet visits, weight, and notes |
| Vaccinations | `vaccination_screen.dart` | Track vaccine history and due dates |
| About | `about_screen.dart` | App info, features, developer credits |

---

## 🔥 Firebase Backend

PetCare uses **Firebase Authentication** for secure login/sign-up and **Cloud Firestore** as a real-time NoSQL database. UI updates instantly via `StreamBuilder` as data changes.

### Firestore Collections

| Collection | Fields |
|---|---|
| `users` | name, email, createdAt |
| `pets` | name, breed, age, ownerId |
| `feeding` | food, time, amount, done, ownerId |
| `health` | reason, doctor, weight, notes, ownerId |
| `vaccines` | name, date, due, doctor, status, ownerId |

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.x or later)
- Dart SDK (bundled with Flutter)
- Android Studio / VS Code with Flutter & Dart plugins
- A Firebase project with Authentication and Cloud Firestore enabled
- Your own `google-services.json` placed in `android/app/`

### Installation

```bash
# Clone the repository
git clone https://github.com/Areeb-alpha/MAD-Projects.git
cd MAD-Projects

# Install dependencies
flutter pub get

# Run the app
flutter run
```

> ⚠️ **Note:** This repo's `google-services.json` (if included) is tied to the original Firebase project. For your own development/testing, replace it with your own Firebase project config — see [Firebase setup docs](https://firebase.google.com/docs/flutter/setup).

See [`requirements.md`](requirements.md) for the full dependency list and environment setup details.

---

## 🎨 Design System

- **Background:** Off-white `#F5F5F0`
- **Primary Green** `#4CAF82` — success / branding
- **Orange** `#FF8C42` — feeding module / warnings
- **Purple** `#6C63FF` — vaccines / info
- **Red** `#E85D75` — overdue / alerts

Card-based layout with rounded corners, soft shadows, dual navigation (Bottom Nav + Drawer), and modal sheets/dialogs for data entry.

---

## 🔮 Future Enhancements

- Push notifications for feeding times and vaccine due dates
- Photo upload support for pet profiles
- Export health/vaccination reports (PDF, CSV)
- Dark mode
- Analytics dashboard with weight trend predictions
- Biometric & two-factor authentication

---

## 👥 Team

| Name | ID |
|---|---|
| Muhammad Mutahir | 40180 |
| Ghulam Hussain Jadoon | 43138 |
| Muhammad Areeb | 40179 |

**Course:** Mobile Application Development | **Semester:** Spring 2026 | **Instructor:** Omaid Ghayyur

---

## 📄 License

This project was developed for academic purposes as part of the Mobile Application Development course.
