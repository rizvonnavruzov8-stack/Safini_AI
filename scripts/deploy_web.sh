#!/bin/bash

# Exit on error
set -e

echo "🚀 Starting Safini AI Web Build..."

# 1. Clean previous builds
flutter clean

# 2. Get dependencies
flutter pub get

# 3. Generate models (Hive, etc.)
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Build for web
flutter build web --release --base-href "/"

echo "✅ Web build complete! Files are in build/web/"
