#!/bin/bash
# Fixes Xcode error: "No such module 'Flutter'"
set -e

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_DIR"

export PATH="$HOME/flutter/bin:$PATH"

echo "=========================================="
echo " Fix iOS build — Profile App"
echo "=========================================="

if ! command -v flutter >/dev/null 2>&1; then
  echo "ERROR: Flutter not found. Add to PATH:"
  echo '  export PATH="$HOME/flutter/bin:$PATH"'
  exit 1
fi

echo ""
echo "[1/4] flutter pub get (creates ios/Flutter/Generated.xcconfig)"
flutter pub get

if [ ! -f "ios/Flutter/Generated.xcconfig" ]; then
  echo "ERROR: Generated.xcconfig was not created. Check Flutter install."
  exit 1
fi
echo "OK: ios/Flutter/Generated.xcconfig exists"

echo ""
echo "[2/4] Check CocoaPods (pod)"
if ! command -v pod >/dev/null 2>&1; then
  echo ""
  echo "CocoaPods is NOT installed. Install it now (needs your Mac password):"
  echo ""
  echo "  sudo gem install cocoapods"
  echo ""
  echo "Then run this script again:"
  echo "  ./scripts/fix_ios_build.sh"
  echo ""
  exit 1
fi

echo "CocoaPods version: $(pod --version)"

echo ""
echo "[3/4] pod install (links Flutter module)"
cd ios
pod install
cd ..

echo ""
echo "[4/4] Open Xcode workspace"
open ios/Runner.xcworkspace

echo ""
echo "=========================================="
echo " In Xcode 15:"
echo "   1. Product → Clean Build Folder (Shift+Cmd+K)"
echo "   2. Scheme: Runner"
echo "   3. Device: iPhone 15 Pro (simulator)"
echo "   4. Run (Cmd+R)"
echo ""
echo " Or skip Xcode and run:"
echo "   flutter run"
echo "=========================================="
