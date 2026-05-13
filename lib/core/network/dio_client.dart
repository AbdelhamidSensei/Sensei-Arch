// ═══════════════════════════════════════════════════════════════════
// FILE:     dio_client.dart
// LAYER:    core/network
// PURPOSE:  Configures and provides the single Dio instance used for
//           all HTTP communication in the app.
//
// PLAIN ENGLISH:
//   Dio is like OkHttp for Dart — it handles HTTP requests, timeouts,
//   headers, and interceptors (middleware that runs before/after each
//   request). This file sets up Dio with our base URL and attaches
//   interceptors for auth tokens and logging.
//
// WHO CREATES ME:
//   The Riverpod provider `dioProvider` in core_providers.dart.
//
// WHO USES ME:
//   Retrofit API interfaces receive the Dio instance to make calls.
//
// WHAT I TALK TO:
//   AuthInterceptor, LoggingInterceptor (both attached as middleware).
// ═══════════════════════════════════════════════════════════════════

import 'package:dio/dio.dart';

import 'package:sensei/core/network/auth_interceptor.dart';
import 'package:sensei/core/network/logging_interceptor.dart';

/// The base URL for all API requests.
// Top-level constants prefixed 'k' per our naming convention.
// 'const' = value known at compile time, no allocation at runtime.
const String kBaseUrl = 'https://mobresults.almokhtabar.com:4435';

/// Builds and configures the app-wide [Dio] HTTP client.
///
/// PLAIN ENGLISH: creates the "internet engine" with our server address,
/// timeout settings, and middleware (interceptors) plugged in.
///
/// Called by: `dioProvider` in core_providers.dart.
/// Calls: nothing at creation time; Dio makes calls when APIs use it.
///
/// [authInterceptor] — adds the Bearer token to requests.
/// [loggingInterceptor] — logs request/response details.
/// Returns a fully configured [Dio] instance.
Dio createDioClient({
  required AuthInterceptor authInterceptor,
  required LoggingInterceptor loggingInterceptor,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: kBaseUrl,
      // 'Duration' = Dart's way of expressing time spans.
      connectTimeout: const Duration(minutes: 3),
      receiveTimeout: const Duration(minutes: 3),
      sendTimeout: const Duration(minutes: 3),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Interceptors run in the order they're added.
  // Auth first (adds token) → Logging last (sees the final request).
  dio.interceptors.addAll([
    authInterceptor,
    loggingInterceptor,
  ]);

  return dio;
}
