// ═══════════════════════════════════════════════════════════════════
// FILE:     auth_interceptor.dart
// LAYER:    core/network
// PURPOSE:  A Dio interceptor that attaches the Bearer token to
//           outgoing requests (except public endpoints).
//
// PLAIN ENGLISH:
//   Before every HTTP request leaves the phone, this interceptor
//   checks if we have a saved auth token and sticks it into the
//   "Authorization" header. Some endpoints (like login) don't need
//   a token — those are "public" and we skip them.
//
// WHO CREATES ME:
//   The Riverpod provider system via core_providers.dart.
//
// WHO USES ME:
//   Dio calls me automatically for every request (I'm an interceptor).
//
// WHAT I TALK TO:
//   SecureTokenStore (to read the saved token).
//   AppLogger (to log that we attached/skipped the token).
// ═══════════════════════════════════════════════════════════════════

import 'package:dio/dio.dart';

import 'package:sensei/core/logger/app_logger.dart';
import 'package:sensei/core/security/secure_token_store.dart';

/// Attaches Bearer token to requests that require authentication.
///
/// PLAIN ENGLISH: the "bouncer" that puts your VIP pass (token) on
/// every request so the server knows who you are.
///
/// Called by: Dio (automatically, for every request).
/// Calls: [SecureTokenStore.getAccessToken], [AppLogger].
class AuthInterceptor extends Interceptor {
  // '@override' is a hint to the compiler that we're replacing a parent
  // method. Catches typos in the method name.

  AuthInterceptor({
    required SecureTokenStore tokenStore,
    required AppLogger logger,
  })  : _tokenStore = tokenStore,
        _logger = logger;

  final SecureTokenStore _tokenStore;
  final AppLogger _logger;

  /// Endpoints that don't need an auth token.
  static const List<String> _publicEndpoints = [
    '/api/auth/login',
  ];

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 'async' marks a function that returns a Future.
    // 'await' pauses until the Future completes.

    // Check if this endpoint is public (no token needed).
    final isPublic = _publicEndpoints.any(
      (endpoint) => options.path.contains(endpoint),
    );

    if (!isPublic) {
      // → Crosses into SECURITY layer to read the stored token.
      final token = await _tokenStore.getAccessToken();

      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
        _logger.v(
          'Token attached to ${options.method} ${options.path} (len=${token.length})',
          className: 'AuthInterceptor',
        );
      } else {
        _logger.w(
          'No token available for ${options.method} ${options.path}',
          className: 'AuthInterceptor',
        );
      }
    }

    // Continue the request pipeline.
    handler.next(options);
  }
}
