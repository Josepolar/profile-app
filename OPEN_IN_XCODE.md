# Open this project in Xcode

You do **not** need a terminal inside Xcode. Use **macOS Terminal** (or Cursor terminal) once, then open Xcode.

## One-time setup (Terminal)

1. Open **Terminal** (Spotlight → type `Terminal`)
2. Run:

```bash
cd /Users/ccs_ac/profile-app
chmod +x scripts/setup_ios.sh
./scripts/setup_ios.sh
```

This will:
- Download Flutter packages (`flutter pub get`)
- Install iOS pods if CocoaPods is installed
- Open **`ios/Runner.xcworkspace`** in Xcode automatically

## If CocoaPods is missing

```bash
sudo gem install cocoapods
cd /Users/ccs_ac/profile-app/ios
pod install
open Runner.xcworkspace
```

## Open Xcode manually

In Finder, go to:

`profile-app` → `ios` → double-click **`Runner.xcworkspace`**

Always open **`.xcworkspace`**, not `.xcodeproj`.

## Run in Xcode

1. Top bar: scheme **Runner**
2. Device: any **iPhone** simulator (e.g. iPhone 15)
3. Click **Run** (▶) or `Cmd + R`

## Flutter on PATH (optional)

Add to `~/.zshrc`:

```bash
export PATH="$HOME/flutter/bin:$PATH"
```

Then run `flutter run` from the project folder instead of Xcode.

## Firebase (required for login)

The app builds without Firebase config, but auth will fail until you run:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
cd ios && pod install
```

See `README.md` for full Firebase setup.
