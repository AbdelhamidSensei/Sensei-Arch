# PhotoRevive AI

One tap. Old photos, new life. AI-powered photo enhancement and restoration built with Flutter.

## Features
- Enhance: 2-4x upscale of any photo (Real-ESRGAN)
- Restore Face: revive old/blurry faces (CodeFormer)
- Colorize: bring black-and-white memories to life
- Before/after slider, save to gallery, share
- Local history (Hive) - your photos never leave your device unless you tap "Enhance"
- Light & dark themes, Material 3

## Run locally
1. `cp .env.example .env` and fill `REPLICATE_API_TOKEN` (or leave empty to use the offline mock).
2. `flutter pub get`
3. `flutter run`

## Build release APK
```
flutter build apk --release --split-per-abi
```

## Test
```
flutter test --coverage
flutter test integration_test/app_flow_test.dart
```

## Architecture
Clean Architecture (data -> domain -> presentation) per feature.
State: Riverpod 2. Routing: GoRouter. Networking: Dio.
Storage: Hive (history) + SharedPreferences (flags) + flutter_secure_storage (tokens).

## License
MIT
