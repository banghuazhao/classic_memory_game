# Classic Memory Game

A Flutter memory card-matching game for iOS and Android. Flip cards to find matching pairs across multiple game modes, themes, and difficulty levels.

## Features

- **Levels mode** — 15 timed levels with increasing grid sizes and time pressure
- **Challenges mode** — 9 unique challenges with specific win conditions
- **Marathon mode** — endless play across 6 progressively harder stages, with personal best tracking
- **6 card themes** — Candy, Fruit, Animal, Emoji, Number, Symbol
- **Localization** — English, Simplified Chinese, Traditional Chinese
- **Background music & sound effects**

## Ad Monetization

The app uses Google AdMob with:

| Format | Placement |
|--------|-----------|
| Banner | Bottom of all game screens |
| App Open | On app foreground resume |
| Interstitial | After theme change (Home), after completing a level or challenge |

### Setting up ad IDs

Production ad IDs are kept out of version control. Before building for release, copy the example files and fill in your real IDs:

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

**Android (app ID):** The production app ID is in `android/app/src/main/AndroidManifest.xml`. The debug manifest (`android/app/src/debug/AndroidManifest.xml`) uses the AdMob test app ID automatically.

Debug builds use [AdMob test IDs](https://developers.google.com/admob/ios/test-ads) automatically — no config needed.

## Getting Started

**Prerequisites:** Flutter SDK, Xcode (iOS), Android Studio (Android)

```bash
flutter pub get
flutter run
```

For iOS, run `pod install` in the `ios/` directory if needed.

## Project Structure

```
lib/
├── main.dart                  # App entry, MobileAds init, App Open ad setup
├── screen/
│   ├── home_screen.dart       # Home, theme picker, interstitial on theme change
│   ├── level.dart             # Levels gameplay (timed)
│   ├── Challenges_level.dart  # Challenges gameplay
│   ├── memoryGame.dart        # Marathon gameplay
│   ├── challenges_page.dart   # Challenge selection
│   ├── challenges.dart        # Level selection
│   └── colors.dart            # Theme colors
├── util/
│   ├── ads_manager.dart       # Ad unit ID routing (debug vs release)
│   ├── ads_config.dart        # Production ad unit IDs (git-ignored)
│   ├── ads_config.dart.example
│   └── others.dart
└── data/
    └── data.dart              # Game state and card category data
```

## Version

`1.0.8+9`
