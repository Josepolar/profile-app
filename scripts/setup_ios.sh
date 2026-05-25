#!/bin/bash
# Run this in macOS Terminal (not Xcode) to install dependencies and open Xcode.
set -e

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_DIR"

# Use Flutter from ~/flutter if not in PATH
if ! command -v flutter >/dev/null 2>&1; then
  if [ -x "$HOME/flutter/bin/flutter" ]; then
    export PATH="$HOME/flutter/bin:$PATH"
  else
    echo "Flutter not found. Install from https://docs.flutter.dev/get-started/install/macos"
    echo "Or clone: git clone https://github.com/flutter/flutter.git -b 3.22.3 --depth 1 ~/flutter"
    exit 1
  fi
fi

echo "==> Flutter version"
flutter --version

echo "==> Getting Dart packages"
flutter pub get

echo "==> Installing iOS CocoaPods (if pod is available)"
if command -v pod >/dev/null 2>&1; then
  cd ios && pod install && cd ..
else
  echo ""
  echo "WARNING: CocoaPods ('pod') is not installed yet."
  echo "Install in Terminal (one time), then re-run this script:"
  echo "  sudo gem install cocoapods"
  echo "  cd ios && pod install"
  echo ""
  echo "You can still open Xcode now; the first build may fail until pods are installed."
fi

echo "==> Opening Xcode workspace"
open ios/Runner.xcworkspace

echo ""
echo "Done. In Xcode:"
echo "  1. Select scheme: Runner"
echo "  2. Select an iPhone simulator"
echo "  3. Press Run (Cmd+R)"
echo ""
echo "For Firebase, run: flutterfire configure"
