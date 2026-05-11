# Sensei — Your Flutter MVVM + Clean Architecture Reference

> **Package:** `com.abdelhamid.sensei`
> **Dart package name:** `sensei`
> **Purpose:** A production-ready template project to copy-paste from for any new Flutter app.

---

## What is This Architecture?

**MVVM + Clean Architecture** splits your app into three strict layers:

- **Presentation** (View + ViewModel) — draws pixels, reacts to user taps.
- **Domain** (UseCases + Models + Repository interfaces) — pure business logic, zero Flutter imports.
- **Data** (Repository implementations + API + Database + Mappers) — talks to the internet and local storage.

The rule: **outer layers depend on inner layers, never the reverse.** This means you can swap your database, redesign your UI, or change your API without touching business logic.

---

## What This Project Includes

| Feature | Implementation |
|---------|---------------|
| State Management | `flutter_riverpod` (StateNotifier + Provider) |
| Navigation | `go_router` (declarative, deep-link ready) |
| Network | `dio` + interceptors (auth, logging) |
| Local DB | `drift` (SQLite ORM with code generation) |
| Serialization | `freezed` + `json_serializable` (immutable models) |
| Secure Storage | `flutter_secure_storage` (iOS Keychain / Android Keystore) |
| Logging | Custom `AppLogger` with caller context (Screen/VM/UseCase/Repo) |
| Testing | `mocktail` (mocks without code generation) |

---

## App Flow

```
Splash Screen (2s)
    |
    +-- Has saved token? --> Home Screen (text + counter + logout)
    |
    +-- No token? -------> Sign In Screen (email/password)
                                |
                                +-- On sign in --> Home Screen
```

### Routes

| Path | Screen | Purpose |
|------|--------|---------|
| `/` | SplashScreen | Branding + auth check |
| `/sign-in` | SignInScreen | Login form |
| `/home` | HomeScreen | Main landing page |
| `/users` | UsersListScreen | Demo: full MVVM feature |
| `/users/:id` | UserDetailScreen | Demo: detail with family provider |

---

## Logger Output Format

```
D/SenseiLogger: [UsersListViewModel 🧠]: loadUsers() invoked
I/SenseiLogger: [GetUsersUseCase 🎲]: Invoked
D/SenseiLogger: [UsersRepositoryImpl 📦]: getUsers() — network success (10 users)
D/SenseiLogger: [LoggingInterceptor]: ← 200 GET .../users (120ms)
V/SenseiLogger: [SecureTokenStore]: Access token read (len=45)
```

**Filter by:** class name, emoji (🧠 ViewModel, 🎲 UseCase, 📦 Repository, 🖥 Screen), or `SenseiLogger`.

---

## Folder Structure

```
lib/
├── main.dart                          # Entry point
├── app/
│   ├── app.dart                       # MaterialApp.router root
│   └── router.dart                    # GoRouter config
├── core/
│   ├── logger/                        # AppLogger interface + impl
│   ├── network/                       # Dio, interceptors, ApiResult
│   ├── result/                        # Resource<T> sealed class
│   ├── domain/                        # DomainError sealed class
│   ├── security/                      # SecureStorage, TokenStore
│   ├── di/                            # Core Riverpod providers
│   └── base/                          # BaseViewModel, UiEvent
└── features/
    ├── splash/presentation/           # Splash screen
    ├── auth/presentation/             # Sign-in screen
    ├── home/presentation/             # Home screen
    └── users/                         # Full MVVM demo feature
        ├── data/
        │   ├── remote/api/            # UsersApi (Dio calls)
        │   ├── remote/dto/            # UserDto (@freezed)
        │   ├── local/entity/          # UsersTable (Drift)
        │   ├── local/database/        # AppDatabase
        │   ├── local/dao/             # UsersDao
        │   ├── mapper/                # DTO↔Domain↔Entity mappers
        │   └── repository/            # UsersRepositoryImpl
        ├── domain/
        │   ├── model/                 # User (domain model)
        │   ├── repository/            # UsersRepository (interface)
        │   └── usecase/               # GetUsersUseCase, GetUserByIdUseCase
        ├── presentation/
        │   ├── list/                  # Screen, ViewModel, UiState, widgets
        │   └── detail/                # Screen, ViewModel, UiState
        └── di/                        # Feature providers
```

---

## How to Add a New Feature

1. **Create domain model** → `features/my_feature/domain/model/`
2. **Create repository interface** → `features/my_feature/domain/repository/`
3. **Create use case(s)** → `features/my_feature/domain/usecase/`
4. **Create DTO** → `features/my_feature/data/remote/dto/`
5. **Create API class** → `features/my_feature/data/remote/api/`
6. **Create mapper** → `features/my_feature/data/mapper/`
7. **Create repository impl** → `features/my_feature/data/repository/`
8. **Create UiState** → `features/my_feature/presentation/`
9. **Create ViewModel** → extends `BaseViewModel<UiState>`
10. **Create Screen** → `ConsumerWidget` with `ref.watch(viewModelProvider)`
11. **Wire providers** → `features/my_feature/di/`
12. **Add route** → `app/router.dart`
13. **Run** → `dart run build_runner build --delete-conflicting-outputs`

---

## Trace: "User taps Sign In"

1. `SignInScreen` 🖥 — button `onPressed` fires
2. Logger: `D/SenseiLogger: [SignInScreen 🖥]: Sign in button pressed`
3. Simulates 1s network delay (real app: call auth API here)
4. `SecureTokenStore` — saves demo token
5. Logger: `I/SenseiLogger: [SecureTokenStore]: Access token saved (len=32)`
6. `GoRouter` — `context.go('/home')`
7. `HomeScreen` appears

---

## Trace: "User opens Users list" (full MVVM flow)

1. **UsersListScreen** 🖥 → `ref.watch(usersListViewModelProvider)`
2. **UsersListViewModel** 🧠 → constructor calls `loadUsers()`
3. **GetUsersUseCase** 🎲 → `call()` delegates to repository
4. **UsersRepositoryImpl** 📦 → emits `Loading`, reads cache, calls API
5. **AuthInterceptor** → attaches token (or warns)
6. **LoggingInterceptor** → logs `→ GET /users`
7. **Network** → HTTP request
8. **LoggingInterceptor** → logs `← 200 (150ms)`
9. **UsersRepositoryImpl** 📦 → maps DTO→Domain, saves cache, emits `Success`
10. **UsersListViewModel** 🧠 → `state = state.copyWith(users: ...)`
11. **UsersListScreen** 🖥 → rebuilds with user list

---

## Commands

```bash
# Install dependencies
flutter pub get

# Generate code (freezed, drift, json_serializable)
dart run build_runner build --delete-conflicting-outputs

# Run app
flutter run

# Run tests
flutter test

# Analyze for issues
flutter analyze
```

---

## Key Patterns to Copy

| Pattern | Where to find it |
|---------|-----------------|
| Sealed Resource (Loading/Success/Error) | `core/result/resource.dart` |
| DomainError mapping | `core/network/error_mapper.dart` |
| Safe API call (no exceptions) | `users_repository_impl.dart` → `_safeApiCall` |
| Cache-first + network refresh | `users_repository_impl.dart` → `getUsers()` |
| StateNotifier ViewModel | `users_list_view_model.dart` |
| Freezed UiState with copyWith | `users_list_ui_state.dart` |
| Family provider (per-ID) | `users_providers.dart` → `userDetailViewModelProvider` |
| Auth interceptor + token store | `core/security/` + `core/network/auth_interceptor.dart` |
| Custom logger with context | `core/logger/app_logger_impl.dart` |

---

## What to Learn Next

- **Widgets:** https://docs.flutter.dev/ui/widgets
- **State Management:** https://docs.flutter.dev/data-and-backend/state-mgmt
- **Riverpod:** https://riverpod.dev/docs/introduction/getting-started
- **GoRouter:** https://pub.dev/documentation/go_router/latest/
- **Drift (SQLite):** https://drift.simonbinder.eu/docs/getting-started/
- **Freezed:** https://pub.dev/packages/freezed
- **Testing:** https://docs.flutter.dev/testing
