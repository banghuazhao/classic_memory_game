# Classic Memory Game

A Flutter memory card-matching game for iOS and Android. Flip cards to find matching pairs across multiple game modes, themes, and difficulty levels.

[![Download on the App Store](https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg)](https://apps.apple.com/app/memory-games-match-pairs-card/id1617593078)

## Features

- **Levels mode** — 15 timed levels with increasing grid sizes and time pressure
- **Challenges mode** — 9 unique challenges with specific win conditions
- **Marathon mode** — endless play across 6 progressively harder stages, with personal best tracking
- **6 card themes** — Candy, Fruit, Animal, Emoji, Number, Symbol
- **Localization** — English, Simplified Chinese, Traditional Chinese
- **Background music & sound effects**
- **In-app review** — prompts at session milestones

## Requirements

- Flutter 3.44+ / Dart 3.12+
- Xcode 15+ (iOS)
- Android SDK 36, NDK 28.2, AGP 8.11+

## Getting Started

```bash
flutter pub get
flutter run
```

For iOS, run `pod install` in the `ios/` directory if needed.

Before running, set up your ad IDs (see [Ad Monetization](#ad-monetization) below).

## Ad Monetization

The app uses Google AdMob with:

| Format | Placement |
|--------|-----------|
| Banner | Bottom of all game screens |
| App Open | On app foreground resume |
| Interstitial | After theme change (Home), after completing a level or challenge |

Debug builds use [AdMob test IDs](https://developers.google.com/admob/ios/test-ads) automatically — no config needed.

### Setting up production ad IDs

Production ad IDs are kept out of version control. Copy the example files and fill in your real IDs before a release build:

**Dart (ad unit IDs):**
```bash
cp lib/util/ads_config.dart.example lib/util/ads_config.dart
# Edit lib/util/ads_config.dart with your real AdMob ad unit IDs
```

**iOS (app ID):**
```bash
cp ios/Flutter/AdsConfig.xcconfig.example ios/Flutter/AdsConfig.xcconfig
# Edit ios/Flutter/AdsConfig.xcconfig with your real iOS AdMob app ID
```

**Android (app ID):** Add to `android/local.properties` (already gitignored):
```
admob.applicationId=ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX
```

Without `admob.applicationId` set, the AdMob test app ID is used as a fallback.

## Building for Release

**Android APK:**
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

**Android App Bundle (Play Store):**
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

Signing is configured via `android/key.properties` (gitignored). See [Flutter docs](https://docs.flutter.dev/deployment/android#signing-the-app) for setup.

**iOS:**
```bash
flutter build ipa
```

## Project Structure

```
lib/
├── main.dart                  # App entry, MobileAds init, App Open ad setup
├── data/
│   └── data.dart              # Game state, card category data, per-level score accessors
├── screen/
│   ├── home_screen.dart       # Home, theme picker, interstitial on theme change
│   ├── level.dart             # Levels gameplay (timed, 15 levels)
│   ├── Challenges_level.dart  # Challenges gameplay (9 challenges)
│   ├── memoryGame.dart        # Marathon gameplay (6 stages)
│   ├── challenges_page.dart   # Challenge selection screen
│   ├── challenges.dart        # Level selection screen
│   ├── more_apps_page.dart    # More apps screen
│   └── colors.dart            # App theme colors
├── util/
│   ├── ads_manager.dart       # Ad unit ID routing (debug vs release), AppOpenAdManager
│   ├── ads_config.dart        # Production ad unit IDs (git-ignored)
│   ├── ads_config.dart.example
│   ├── in_app_reviewer_helper.dart
│   └── others.dart            # SharedPreferences helper, CategoryHelper
└── generated/                 # Auto-generated localization files
```

## Version

`1.1.0+10`
