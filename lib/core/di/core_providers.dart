import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sensei/core/logger/app_logger.dart';
import 'package:sensei/core/logger/app_logger_impl.dart';
import 'package:sensei/core/network/auth_interceptor.dart';
import 'package:sensei/core/network/dio_client.dart';
import 'package:sensei/core/network/logging_interceptor.dart';
import 'package:sensei/core/security/secure_storage.dart';
import 'package:sensei/core/security/secure_storage_impl.dart';
import 'package:sensei/core/security/secure_token_store.dart';
import 'package:sensei/core/security/secure_token_store_impl.dart';
import 'package:sensei/core/security/session_store.dart';
import 'package:sensei/core/security/session_store_impl.dart';

// ── LOGGER ──────────────────────────────────────────────────────

final appLoggerProvider = Provider<AppLogger>((ref) {
  return AppLoggerImpl();
});

// ── SHARED PREFERENCES ──────────────────────────────────────────

/// Must be overridden in main.dart ProviderScope with the pre-initialized instance.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});

// ── SECURITY ────────────────────────────────────────────────────

final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorageImpl();
});

final secureTokenStoreProvider = Provider<SecureTokenStore>((ref) {
  return SecureTokenStoreImpl(
    secureStorage: ref.watch(secureStorageProvider),
    logger: ref.watch(appLoggerProvider),
  );
});

final sessionStoreProvider = Provider<SessionStore>((ref) {
  return SessionStoreImpl(
    secureStorage: ref.watch(secureStorageProvider),
  );
});

// ── NETWORK ─────────────────────────────────────────────────────

final authInterceptorProvider = Provider<AuthInterceptor>((ref) {
  return AuthInterceptor(
    tokenStore: ref.watch(secureTokenStoreProvider),
    logger: ref.watch(appLoggerProvider),
  );
});

final loggingInterceptorProvider = Provider<LoggingInterceptor>((ref) {
  return LoggingInterceptor(
    logger: ref.watch(appLoggerProvider),
  );
});

final dioProvider = Provider<Dio>((ref) {
  return createDioClient(
    authInterceptor: ref.watch(authInterceptorProvider),
    loggingInterceptor: ref.watch(loggingInterceptorProvider),
  );
});
