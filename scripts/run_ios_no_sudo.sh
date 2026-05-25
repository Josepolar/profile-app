#!/bin/bash
set -e
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_DIR"
export PATH="$HOME/flutter/bin:$HOME/.homebrew/bin:$PATH"
if ! command -v pod >/dev/null 2>&1; then
  echo "Run: ./scripts/install_cocoapods_no_sudo.sh"
  exit 1
fi
flutter pub get
cd ios && pod install && cd ..
open -a Simulator 2>/dev/null || true
flutter run
