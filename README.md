# Sensei

My first Flutter MVVM + Clean Architecture reference project.

**Package:** `com.abdelhamid.sensei`

## Architecture

MVVM + Clean Architecture with three layers:
- **Presentation** — Screens (ConsumerWidget) + ViewModels (StateNotifier)
- **Domain** — UseCases + Models + Repository interfaces (pure Dart)
- **Data** — Repository implementations + API (Dio) + Local DB (Drift) + Mappers

## Tech Stack

- State: `flutter_riverpod`
- Navigation: `go_router`
- Network: `dio`
- Local DB: `drift`
- Models: `freezed` + `json_serializable`
- Security: `flutter_secure_storage`
- Testing: `mocktail`

## Quick Start

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

See `lib/_READ_THIS_FIRST.md` for the full architecture guide.
