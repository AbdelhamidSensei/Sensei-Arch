// ═══════════════════════════════════════════════════════════════════
// FILE:     core_providers.dart
// LAYER:    core/di
// PURPOSE:  Riverpod providers for all core dependencies (logger,
//           network, security). The app's "wiring diagram".
//
// PLAIN ENGLISH:
//   Dependency Injection (DI) is a fancy way of saying "don't create
//   your own dependencies — receive them from outside." Riverpod
//   providers are the "factory" that creates objects and hands them
//   to whoever asks. This file is the central registry of those
//   factories for the core layer.
//
// WHO CREATES ME:
//   Dart loads this file at startup when other providers reference it.
//
// WHO USES ME:
//   Feature-level providers import these to get logger, Dio, etc.
//   Screens import these to access the logger.
//
// WHAT I TALK TO:
//   All core implementations (AppLoggerImpl, DioClient, SecureStorage, etc.)
// ═══════════════════════════════════════════════════════════════════

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sensei/core/logger/app_logger.dart';
import 'package:sensei/core/logger/app_logger_impl.dart';
import 'package:sensei/core/network/auth_interceptor.dart';
import 'package:sensei/core/network/dio_client.dart';
import 'package:sensei/core/network/logging_interceptor.dart';
import 'package:sensei/core/security/secure_storage.dart';
import 'package:sensei/core/security/secure_storage_impl.dart';
import 'package:sensei/core/security/secure_token_store.dart';
import 'package:sensei/core/security/secure_token_store_impl.dart';

// A Provider is a "recipe" for creating an object. Riverpod calls the
// recipe once and reuses the result. Like Hilt's @Provides in Android.

// ──────────────────────────────────────────────────────────────────
// LOGGER
// ──────────────────────────────────────────────────────────────────

/// Provides the single [AppLogger] instance used throughout the app.
///
/// PLAIN ENGLISH: the "recipe" that creates our logger. Every class
/// that needs to log asks Riverpod for this provider.
final appLoggerProvider = Provider<AppLogger>((ref) {
  return AppLoggerImpl();
});

// ──────────────────────────────────────────────────────────────────
// SECURITY
// ──────────────────────────────────────────────────────────────────

/// Provides the encrypted key-value storage implementation.
final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorageImpl();
});

/// Provides the token-specific storage built on top of [SecureStorage].
final secureTokenStoreProvider = Provider<SecureTokenStore>((ref) {
  // 'ref.watch' = subscribe to changes. Here we're just reading another
  // provider to get its value as a dependency.
  return SecureTokenStoreImpl(
    secureStorage: ref.watch(secureStorageProvider),
    logger: ref.watch(appLoggerProvider),
  );
});

// ──────────────────────────────────────────────────────────────────
// NETWORK
// ──────────────────────────────────────────────────────────────────

/// Provides the [AuthInterceptor] that attaches Bearer tokens.
final authInterceptorProvider = Provider<AuthInterceptor>((ref) {
  return AuthInterceptor(
    tokenStore: ref.watch(secureTokenStoreProvider),
    logger: ref.watch(appLoggerProvider),
  );
});

/// Provides the [LoggingInterceptor] that logs HTTP traffic.
final loggingInterceptorProvider = Provider<LoggingInterceptor>((ref) {
  return LoggingInterceptor(
    logger: ref.watch(appLoggerProvider),
  );
});

/// Provides the configured [Dio] HTTP client.
///
/// PLAIN ENGLISH: the "internet engine" — pre-configured with our
/// server URL and interceptors. Retrofit APIs receive this to make calls.
final dioProvider = Provider<Dio>((ref) {
  return createDioClient(
    authInterceptor: ref.watch(authInterceptorProvider),
    loggingInterceptor: ref.watch(loggingInterceptorProvider),
  );
});
