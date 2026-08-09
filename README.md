# growthBox React Native Android App (100% Offline)

![growthBox Logo](assets/icon.png)

> **"Manage your notes and todos with AI. Simple, fast, and intelligent."**

Official **React Native & Expo** Android application for [groowth-box.vercel.app](https://groowth-box.vercel.app).
Built as a robust alternative to Flutter, ensuring 100% build reliability on any Android system without NDK or Gradle version mismatches!

---

## ✨ Why React Native?

- **Zero Build Friction**: Uses Expo SDK 51 & React Native 0.74.x. No Gradle plugin loader script errors, no KotlinAndroidTarget exceptions, and no NDK version mismatches.
- **100% Offline Capable**: Built with `@react-native-async-storage/async-storage` for instantaneous offline persistence.
- **Exact Parity with Web**:
  - Dark theme (`#000000`, `#0A0A0A`, `#27272A`) and Light theme (`#FFFFFF`, `#FAFAFA`).
  - Cycling slogan typing animation (`"growthBox"`, `"Grow Daily"`, `"Level Up"`, `"Next Step"`, `"Move Forward"`, `"Unlock Potential"`).
  - Full Notes management with `#tag` badges, active/archived filters, and interactive editor modal.
  - Full Todos management with priority badges (**High** / **Medium** / **Low**), checkbox toggles, and editor modal.
  - Interactive productivity charts & stat cards on the Dashboard.

---

## 🚀 How to Build the APK (`app-release.apk`)

### 1. Build via EAS (Expo Application Services) - Free Cloud APK Builder
You don't even need Android Studio installed on your computer!
```bash
npm install -g eas-cli
npm install
eas build -p android --profile release
```
In 3 minutes, EAS generates a direct `.apk` download link!

### 2. Run Locally
```bash
npm install
npx expo start --android
```
