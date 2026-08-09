# growthBox Android App (Flutter)

![growthBox Logo](assets/icon.png)

> **"Manage your notes and todos with AI. Simple, fast, and intelligent."**

Official Android Application for [growthBox](http://groowth-box.vercel.app), meticulously crafted in **Flutter & Material 3 / Cupertino** with exact design parity, premium animations, offline-first local storage, and cloud synchronization.

---

## ✨ Features & Architecture (100% Offline Capable)

- **100% Offline-First (`localStorage` mode)**: Fully functional offline mode using device storage (`SharedPreferences`). Create, edit, tag, archive, and delete notes & todos without requiring any internet connection. Everything stays private and stored locally on your device!
- **Exact Design Parity**: Custom Dark Theme (`#000000`, `#0A0A0A`, `#27272A`) and Light Theme (`#FFFFFF`, `#FAFAFA`) matching the web experience, with Amber (`#FCBB00`) and Red (`#FB2C36`) accents.
- **Cloud & API Sync**: Connects to the official `https://maniweb.pythonanywhere.com/api` backend for online authentication and data syncing.
- **Dynamic Slogan Animation**: Animated typing subtitle on the login screen cycling through:
  - `growthBox`
  - `Grow Daily`
  - `Level Up`
  - `Next Step`
  - `Move Forward`
  - `Unlock Potential`
- **Productivity Dashboard**: Real-time analytical SVG / Circular Progress charts (`fl_chart`) tracking Todo Completion Rate and Active vs. Archived Notes.
- **Full Notes Management**: Tagging system (`#tag`), search & filter bar, archive/unarchive toggle, and full note editor modal.
- **Full Todos Management**: Priority badges (**High** / **Medium** / **Low**), due date selector, checkbox completion toggle, and category filters.

---

## 📱 Folder Structure

```
growthbox_flutter/
├── android/                   # Full Android project configuration (build.gradle, AndroidManifest.xml)
├── assets/
│   ├── icon.png               # Official 460x460 growthBox logo
│   └── favicon.svg            # Official SVG logo
├── lib/
│   ├── main.dart              # Application entry point & theme provider setup
│   ├── models/                # Note, Todo, and User models with JSON serialization
│   ├── providers/             # State management (AuthProvider, NotesProvider, TodosProvider, ThemeProvider)
│   ├── screens/               # Splash, Login, Home, Dashboard, Notes, Todos, and Editor screens
│   ├── services/              # StorageService (local mode) & ApiService (online mode)
│   ├── theme/                 # AppColors & Dark/Light ThemeData matching vercel app
│   └── widgets/               # Reusable widgets (NoteCard, TodoItem, StatCard, NavDrawer, LogoWidget)
├── .github/workflows/         # Automated GitHub Actions APK Build workflow
├── build_apk.sh               # Local & Docker automated APK compilation script
└── pubspec.yaml               # Flutter package dependencies
```

---

## 🚀 How to Build the Android APK (`app-release.apk`)

### Option 1: One-Click GitHub Actions CI/CD (Recommended)
This repository includes a pre-configured GitHub Actions workflow (`.github/workflows/build_apk.yml`):
1. Push this project folder to any GitHub repository.
2. Go to the **Actions** tab in GitHub.
3. Click **Build Android APK** -> **Run workflow**.
4. In ~60 seconds, download your compiled **`growthbox-android-release-apk`** artifact directly from GitHub!

### Option 2: Build Locally via Flutter CLI
If you have Flutter SDK installed on your machine:
```bash
cd growthbox_flutter
flutter pub get
flutter pub run flutter_launcher_icons:main
flutter build apk --release
```
The compiled APK will be located at:
`build/app/outputs/flutter-apk/app-release.apk`

### Option 3: Build via Docker (Zero Flutter Setup)
If you have Docker installed:
```bash
./build_apk.sh
```
This will automatically spin up a container with Flutter and Android SDK, compile the APK, and output `app-release.apk` to your project folder.
