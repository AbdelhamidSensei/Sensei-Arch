// ═══════════════════════════════════════════════════════════════════
// FILE:     auth_providers.dart
// LAYER:    di (Dependency Injection)
// PURPOSE:  Wires up all auth feature dependencies using Riverpod providers.
//
// PLAIN ENGLISH:
//   This is the "wiring diagram" for the auth feature. It tells Riverpod:
//   "When someone asks for an AuthApi, create one with this Dio instance."
//   "When someone asks for a LoginViewModel, create one with these UseCases."
//   etc.
//
// ANDROID EQUIVALENT:
//   Like a Hilt Module in Android:
//     @Module
//     @InstallIn(SingletonComponent::class)
//     object AuthModule {
//       @Provides fun provideAuthApi(dio: Dio): AuthApi = AuthApi(dio)
//       @Provides fun provideAuthRepository(api: AuthApi, ...): AuthRepository = AuthRepositoryImpl(...)
//       @Provides fun provideLoginUseCase(repo: AuthRepository): LoginUseCase = LoginUseCase(repo)
//     }
//
// WHY PROVIDERS (not just "new Class()" everywhere)?
//   1. Singleton management — Riverpod creates ONE instance and reuses it.
//   2. Dependency chain — providers automatically resolve dependencies.
//      AuthRepository needs AuthApi → AuthApi needs Dio → already provided!
//   3. Testing — override any provider with a fake/mock in tests.
//   4. Lifecycle — autoDispose cleans up when the screen is gone.
//
// IMPORTANT CONCEPTS:
//   - Provider<T>: creates a value once and caches it (like @Singleton)
//   - StateNotifierProvider<VM, State>: creates a ViewModel with observable state
//   - .autoDispose: destroys the ViewModel when no one is watching it
//     (when the screen is disposed). Without it, the ViewModel lives forever.
//   - ref.watch(otherProvider): gets the value of another provider.
//     If that provider changes, this one is recreated too.
//
// WHO CREATES ME:
//   Dart loads this when any code imports auth_providers.dart.
//
// WHO USES ME:
//   LoginScreen reads loginViewModelProvider.
//   Other features read authRepositoryProvider (e.g., HomeShell for logout).
// ═══════════════════════════════════════════════════════════════════

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sensei/core/di/core_providers.dart';
import 'package:sensei/features/auth/data/remote/api/auth_api.dart';
import 'package:sensei/features/auth/data/repository/auth_repository_impl.dart';
import 'package:sensei/features/auth/domain/repository/auth_repository.dart';
import 'package:sensei/features/auth/domain/usecase/get_saved_session_use_case.dart';
import 'package:sensei/features/auth/domain/usecase/login_use_case.dart';
import 'package:sensei/features/auth/presentation/login/login_ui_state.dart';
import 'package:sensei/features/auth/presentation/login/login_view_model.dart';

// ── Data layer providers ────────────────────────────────────────

/// Creates the AuthApi with the shared Dio client and logger.
final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApi(
    dio: ref.watch(dioProvider),           // Dio from core_providers
    logger: ref.watch(appLoggerProvider),   // Logger from core_providers
  );
});

/// Creates the AuthRepository implementation.
/// Provider<AuthRepository> = the TYPE is the interface, but the VALUE
/// is the concrete class. This way, consumers only know the interface.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    api: ref.watch(authApiProvider),
    tokenStore: ref.watch(secureTokenStoreProvider),
    sessionStore: ref.watch(sessionStoreProvider),
    logger: ref.watch(appLoggerProvider),
  );
});

// ── Domain layer providers ──────────────────────────────────────

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(
    repository: ref.watch(authRepositoryProvider),
    logger: ref.watch(appLoggerProvider),
  );
});

final getSavedSessionUseCaseProvider = Provider<GetSavedSessionUseCase>((ref) {
  return GetSavedSessionUseCase(
    repository: ref.watch(authRepositoryProvider),
    logger: ref.watch(appLoggerProvider),
  );
});

// ── Presentation layer provider ─────────────────────────────────

/// Creates the LoginViewModel. 'autoDispose' destroys it when the
/// LoginScreen is no longer visible (saves memory, stops lingering API calls).
///
/// StateNotifierProvider<ViewModel, State> = a provider that:
///   1. Creates a StateNotifier (ViewModel)
///   2. Exposes its state (LoginUiState) for ref.watch()
///   3. Allows access to the notifier (ViewModel methods) via .notifier
///
/// Usage in screen:
///   final state = ref.watch(loginViewModelProvider);        // read state
///   ref.read(loginViewModelProvider.notifier).login(...);   // call method
final loginViewModelProvider =
    StateNotifierProvider.autoDispose<LoginViewModel, LoginUiState>((ref) {
  return LoginViewModel(
    loginUseCase: ref.watch(loginUseCaseProvider),
    getSavedSessionUseCase: ref.watch(getSavedSessionUseCaseProvider),
    appLogger: ref.watch(appLoggerProvider),
  );
});
