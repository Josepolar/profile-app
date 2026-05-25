# Fix: CocoaPods not installed

See the same instructions in your Documents copy, or run from this folder:

```bash
sudo gem install cocoapods
export PATH="$HOME/flutter/bin:$PATH"
cd "/Users/ccs_ac/profile-app"
flutter pub get
cd ios && pod install && cd ..
flutter run
```

Or: `chmod +x scripts/install_and_run.sh && ./scripts/install_and_run.sh`
