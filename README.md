# 🧠 Memory Match — Flutter Game

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-blue?logo=dart)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-green)
![License](https://img.shields.io/badge/License-MIT-yellow)

> CS5450 Mobile Programming | Exercise 2 | Lakehead University | Dr. Sabah Mohammed

A fun and colorful **memory card matching game** built with **Flutter & Dart**.

---

## 📁 Project Structure

```
memory_match/
├── lib/
│   ├── main.dart                        # App entry point
│   ├── models/
│   │   └── memory_card.dart             # Card data model
│   ├── controllers/
│   │   └── game_controller.dart         # Game logic, timer, match detection
│   ├── screens/
│   │   └── game_screen.dart             # Main UI screen
│   └── widgets/
│       ├── memory_card_widget.dart      # Card widget with 3D flip animation
│       └── win_dialog.dart              # Win popup dialog
├── assets/
│   └── images/                          # Image assets
├── pubspec.yaml                         # Dependencies & asset config
└── README.md
```

---

## ⚙️ Prerequisites

Make sure you have the following installed:

```bash
# Check Flutter installation
flutter --version

# Check Dart installation
dart --version

# Check all dependencies
flutter doctor -v
```

Expected output of `flutter doctor`:
```
[✓] Flutter (Channel stable, 3.x.x)
[✓] Android toolchain
[✓] Android Studio
[✓] Connected device
```

---

## 🚀 Installation & Setup

### 1. Clone the Repository

```bash
git clone https://github.com/<your-username>/memory_match.git
```

### 2. Navigate into the Project

```bash
cd memory_match
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Check Available Devices

```bash
flutter devices
```

Example output:
```
2 connected devices:
sdk gphone64 x86 64 (mobile) • emulator-5554 • android-x64 • Android 14 (API 34)
Chrome (web)                  • chrome        • web-javascript • Google Chrome
```

---

## ▶️ Running the App

### Run on Android Emulator

```bash
flutter run
```

### Run on a Specific Device

```bash
# Android emulator
flutter run -d emulator-5554

# Chrome (Web)
flutter run -d chrome

# Physical Android device
flutter run -d <device-id>
```

### Run in Release Mode

```bash
flutter run --release
```

---

## 📦 Build

### Build Android APK

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release
```

APK output location:
```
build/app/outputs/flutter-apk/app-release.apk
```

### Build for Web

```bash
flutter build web
```

---

## 🗂️ Key Files Explained

### `lib/main.dart`
```dart
void main() {
  runApp(const MemoryMatchApp());
}
```
Entry point of the app. Sets up `MaterialApp` with theme and launches `GameScreen`.

---

### `lib/models/memory_card.dart`
```dart
class MemoryCard {
  final int id;
  final String emoji;
  bool isFaceUp;
  bool isMatched;
}
```
Holds the state of each card — its emoji, whether it's flipped, and whether it's matched.

---

### `lib/controllers/game_controller.dart`
```dart
class GameController extends ChangeNotifier {
  void startNewGame() { ... }  // Resets board, starts preview
  void flipCard(int index) { ... }  // Handles card tap
  void _checkMatch() { ... }  // Compares two flipped cards
}
```
All game logic lives here — preview timer, match detection, move counter, win condition.

---

### `lib/screens/game_screen.dart`
```dart
class GameScreen extends StatefulWidget { ... }
```
Main UI — renders the header, stats bar, card grid, preview banner, and restart button.

---

### `lib/widgets/memory_card_widget.dart`
```dart
class MemoryCardWidget extends StatefulWidget {
  // Uses AnimationController for 3D flip effect
}
```
Individual card widget with a smooth 3D flip animation using `Matrix4.rotateY`.

---

## 🎮 Game Flow

```
App Launch
    │
    ▼
Cards shuffled + shown face-up (Preview: 3 seconds)
    │
    ▼
Cards flip face-down → Timer starts
    │
    ▼
Player taps a card → Card flips face-up
    │
    ▼
Player taps second card
    │
    ├── Match? ──► Both cards stay face-up (green) + matches++
    │
    └── No Match? ──► Both flip back after 1 second
    │
    ▼
All 10 pairs matched?
    │
    ▼
Win Dialog shown (Time + Moves)
    │
    ▼
Restart → New color + reshuffled board
```

---

## 🐛 Troubleshooting

### `flutter` command not found
```bash
# Add Flutter to PATH (Windows PowerShell)
$env:PATH += ";C:\flutter\bin"

# Add Flutter to PATH (Mac/Linux)
export PATH="$PATH:$HOME/flutter/bin"
```

### Gradle build failed
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### No devices found
```bash
# List all devices
flutter devices

# Open Android emulator manually
flutter emulators --launch <emulator-id>
```

### Dependencies out of date
```bash
flutter pub upgrade
```

---

## 📋 Dependencies

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6
```

> No third-party packages required — built entirely with Flutter core libraries.

---

## ✅ Grading Checklist

```
[✓] Flutter/Dart code only
[✓] 4x5 card grid (20 cards, 10 pairs)
[✓] 3D flip animation
[✓] Preview mode (3 seconds face-up at start)
[✓] Random card color per game
[✓] Live timer (starts after preview)
[✓] Move counter
[✓] Win dialog with score
[✓] Restart button
[✓] Works on Android Emulator
[✓] Works on Chrome (Web)
[✓] README.pdf included
[✓] GitHub public repository
[✓] ZIP uploaded to D2L
```

---

## 👨‍💻 Author

**Your Name**
Student — CS5450 Mobile Programming
Lakehead University

---

*Built with ❤️ using Flutter & Dart*
