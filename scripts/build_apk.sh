#!/bin/bash

# Exit on error
set -e

echo "🚀 Starting Safini AI Android Build..."

# 1. Get dependencies
flutter pub get

# 2. Build APK
# Using --split-per-abi to make individual APKs smaller if needed, 
# but usually a single fat APK is easier for sharing.
flutter build apk --release

echo "✅ Android build complete! File is in build/app/outputs/flutter-apk/app-release.apk"
