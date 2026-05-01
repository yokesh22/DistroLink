# DistroLink

Distributor order-taking app. Distributors visit shops across multiple locations and capture orders that flow into a Google Sheet for downstream fulfilment.

- **Platforms:** Android (min API 26 / Android 8) and iOS
- **State management:** Riverpod
- **Storage backend:** Google Sheets (auth approach TBD)

See [`docs/`](docs/README.md) for architecture, setup, and decision records.

## Quick start

```bash
flutter pub get
dart run build_runner watch -d
flutter run
```

## Repo layout

```
lib/        application code (feature-first under lib/features/)
test/       unit + widget tests
android/    Android platform code
ios/        iOS platform code
assets/     images, icons, fonts
docs/       architecture, setup, ADRs
```
