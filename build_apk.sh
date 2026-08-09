#!/usr/bin/env bash
set -e

echo "=========================================================="
echo "    growthBox Flutter Android APK Builder"
echo "=========================================================="

# Check if flutter is installed locally
if command -v flutter &> /dev/null; then
    echo "[+] Flutter SDK detected locally. Building release APK..."
    flutter pub get
    flutter pub run flutter_launcher_icons:main
    flutter build apk --release
    echo "----------------------------------------------------------"
    echo "[SUCCESS] APK built successfully!"
    echo "Output: $(pwd)/build/app/outputs/flutter-apk/app-release.apk"
    echo "----------------------------------------------------------"
# Check if docker is installed for containerized APK build
elif command -v docker &> /dev/null; then
    echo "[+] Flutter not found locally, but Docker is available!"
    echo "[+] Launching containerized APK build using cirrusci/flutter..."
    docker run --rm -v "$(pwd)":/app -w /app cirrusci/flutter:latest bash -c "
        flutter pub get &&
        flutter pub run flutter_launcher_icons:main &&
        flutter build apk --release
    "
    echo "----------------------------------------------------------"
    echo "[SUCCESS] Docker APK build finished!"
    echo "Output: $(pwd)/build/app/outputs/flutter-apk/app-release.apk"
    echo "----------------------------------------------------------"
else
    echo "[ERROR] Neither Flutter SDK nor Docker was found locally."
    echo "Please install Flutter SDK (https://docs.flutter.dev/get-started/install)"
    echo "OR push this repo to GitHub to build the APK automatically via GitHub Actions (.github/workflows/build_apk.yml)."
    exit 1
fi
