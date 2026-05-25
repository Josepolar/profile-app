#!/bin/bash
# Installs CocoaPods (one-time, needs Mac password) and runs the app.
set -e

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_DIR"

export PATH="$HOME/flutter/bin:$PATH"

echo "=============================================="
echo " Profile App — Install CocoaPods & Run"
echo "=============================================="
echo ""

# --- CocoaPods ---
if ! command -v pod >/dev/null 2>&1; then
  echo "CocoaPods is required for iOS (Firebase plugins)."
  echo "You will be asked for your Mac login password."
  echo ""
  sudo gem install cocoapods
  echo ""
fi

echo "CocoaPods: $(pod --version)"
echo ""

# --- Flutter ---
if ! command -v flutter >/dev/null 2>&1; then
  echo "ERROR: Flutter not found. Add to ~/.zshrc:"
  echo '  export PATH="$HOME/flutter/bin:$PATH"'
  exit 1
fi

echo "[1/4] flutter pub get"
flutter pub get

if [ ! -f "ios/Flutter/Generated.xcconfig" ]; then
  echo "ERROR: ios/Flutter/Generated.xcconfig missing after flutter pub get"
  exit 1
fi

echo "[2/4] pod install"
cd ios
pod install
cd ..

echo "[3/4] Open Simulator"
open -a Simulator 2>/dev/null || true

echo "[4/4] flutter run"
flutter run
