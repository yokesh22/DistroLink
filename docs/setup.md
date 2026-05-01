# Setup

## Prerequisites

- Flutter SDK 3.11+ (Dart 3.11+)
- Android SDK with API 26+ image (or a physical Android 8+ device)
- Xcode (for iOS builds — Mac only)

## First run

```bash
flutter pub get
flutter run
```

## Codegen (Riverpod, Freezed, JSON)

The app uses code generation for immutable models, JSON (de)serialization, and Riverpod providers. Run a watcher in a separate terminal during development:

```bash
dart run build_runner watch -d
```

One-shot build (CI or after a clean):

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Lint & test

```bash
flutter analyze       # runs very_good_analysis
flutter test          # runs widget + unit tests
```

## Build artifacts

```bash
flutter build apk --debug
flutter build apk --release
flutter build appbundle --release   # Play Store upload
flutter build ios --release         # Mac only
```

## Notes

- `riverpod_lint` and `custom_lint` are intentionally **not** installed yet — the riverpod 3.x ecosystem hasn't published versions compatible with the rest of our deps. Revisit once `riverpod_lint` supports `riverpod ^3.3`.
- Launcher icon and splash screen packages (`flutter_launcher_icons`, `flutter_native_splash`) are installed but unconfigured. Configure them after we have a logo.
