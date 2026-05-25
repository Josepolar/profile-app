# Setup checklist

Use this after cloning the repo.

**Open in Xcode:** see [OPEN_IN_XCODE.md](OPEN_IN_XCODE.md) or run `./scripts/setup_ios.sh`

- [x] iOS/Xcode project generated (`ios/Runner.xcworkspace`)
- [ ] Install Flutter, Xcode, CocoaPods
- [x] Run `flutter pub get` (or use `./scripts/setup_ios.sh`)
- [ ] Create Firebase project in console
- [ ] Run `flutterfire configure`
- [ ] Enable Email/Password in Authentication
- [ ] Create Firestore database
- [ ] Enable Storage
- [ ] Deploy `firestore.rules` and `storage.rules`
- [ ] `cd ios && pod install`
- [ ] `flutter run` on iOS Simulator
