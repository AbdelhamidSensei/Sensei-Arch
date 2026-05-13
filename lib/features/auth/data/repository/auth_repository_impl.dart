// ═══════════════════════════════════════════════════════════════════
// FILE:     auth_repository_impl.dart
// LAYER:    data/repository (implements the domain interface)
// PURPOSE:  The REAL implementation of AuthRepository. Calls the API,
//           saves tokens, saves session, handles errors.
//
// PLAIN ENGLISH:
//   This is where the magic happens. When the user taps "Login":
//   1. Call the API (via AuthApi)
//   2. Check if the response has a token (= success)
//   3. Save the token to secure storage (for future API calls)
//   4. Save the full session as JSON (for auto-login on restart)
//   5. Return Resource.success(user)
//   If anything goes wrong → catch the error → return Resource.error
//
// ANDROID EQUIVALENT:
//   Like a Kotlin repository implementation:
//     class AuthRepositoryImpl(
//       private val api: AuthApi,
//       private val tokenStore: SecureTokenStore,
//       private val sessionStore: SessionStore
//     ) : AuthRepository {
//       override suspend fun login(...): Resource<UserModel> {
//         return try {
//           val response = api.login(...)
//           if (response.token != null) {
//             tokenStore.saveToken(response.token)
//             Resource.Success(response.toDomain())
//           } else {
//             Resource.Error(ServerError(...))
//           }
//         } catch (e: HttpException) { ... }
//       }
//     }
//
// WHY ALL THE ERROR HANDLING?
//   Network calls can fail in many ways:
//   - No internet → DioExceptionType.connectionError
//   - Server too slow → DioExceptionType.connectionTimeout
//   - Invalid credentials → HTTP 401
//   - Server crash → HTTP 500
//   - JSON parsing error → FormatException
//   We catch them ALL and convert to DomainError so the ViewModel
//   can show a user-friendly message without knowing about HTTP.
//
// WHO CREATES ME:
//   Riverpod provider `authRepositoryProvider` in auth_providers.dart.
//
// WHO USES ME:
//   LoginUseCase and GetSavedSessionUseCase call me via the interface.
// ═══════════════════════════════════════════════════════════════════

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:sensei/core/domain/domain_error.dart';
import 'package:sensei/core/logger/app_logger.dart';
import 'package:sensei/core/result/resource.dart';
import 'package:sensei/core/security/secure_token_store.dart';
import 'package:sensei/core/security/session_store.dart';
import 'package:sensei/features/auth/data/mapper/login_dto_mapper.dart';
import 'package:sensei/features/auth/data/remote/api/auth_api.dart';
import 'package:sensei/features/auth/domain/model/user_model.dart';
import 'package:sensei/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthApi api,
    required SecureTokenStore tokenStore,
    required SessionStore sessionStore,
    required AppLogger logger,
  })  : _api = api,
        _tokenStore = tokenStore,
        _sessionStore = sessionStore,
        _logger = logger;

  final AuthApi _api;
  final SecureTokenStore _tokenStore;
  final SessionStore _sessionStore;
  final AppLogger _logger;

  @override
  Future<Resource<UserModel>> login(String loginId, String password) async {
    _logger.d('login() called with loginId=$loginId',
        repository: 'AuthRepositoryImpl');

    try {
      _logger.d('login() calling AuthApi.login()...',
          repository: 'AuthRepositoryImpl');

      // Step 1: Call the API
      final response = await _api.login(loginId, password);

      _logger.d(
        'login() API returned token=${response.token != null ? "present(len=${response.token!.length})" : "null"}, '
        'id=${response.id}, name=${response.name}, '
        'branches=${response.companiesBranches.length}',
        repository: 'AuthRepositoryImpl',
      );

      // Step 2: Check if login succeeded (token is present)
      // The API returns a flat JSON with token when success, or without when failure.
      if (response.token != null && response.token!.isNotEmpty) {
        // Step 3: Convert DTO → domain model
        final user = response.toDomain();

        _logger.i(
          'login() SUCCESS: userId=${user.id}, name=${user.name}, '
          'tokenLen=${user.token.length}, '
          'branches=${user.companiesBranches.length}',
          repository: 'AuthRepositoryImpl',
        );

        // Step 4: Save the token (used by AuthInterceptor for future API calls)
        _logger.d('login() saving access token...',
            repository: 'AuthRepositoryImpl');
        await _tokenStore.saveAccessToken(user.token);

        // Step 5: Save the full session as JSON (for auto-login on app restart)
        // jsonEncode converts the Map to a JSON string.
        // user.toJson() converts UserModel to Map<String, dynamic>.
        _logger.d('login() saving session JSON...',
            repository: 'AuthRepositoryImpl');
        await _sessionStore.saveSession(jsonEncode(user.toJson()));

        _logger.d('login() returning Resource.success',
            repository: 'AuthRepositoryImpl');
        return Resource.success(user);
      }

      // Login failed — server returned response but no token
      _logger.w(
        'login() FAILED: no token in response, msg=${response.msg}',
        repository: 'AuthRepositoryImpl',
      );
      return Resource.error(
        ServerError(
          code: response.statusCode ?? 0,
          message: response.msg ?? 'Login failed. Invalid credentials.',
        ),
      );

    // 'on DioException' = only catch Dio-specific errors (network, timeout, HTTP)
    // 'catch (e, stack)' = capture both error and stack trace
    } on DioException catch (e, stack) {
      _logger.e(
        'login() DioException: type=${e.type}, '
        'httpStatus=${e.response?.statusCode}, message=${e.message}',
        repository: 'AuthRepositoryImpl',
        error: e,
        stack: stack,
      );

      // Convert Dio errors to domain errors:
      // Timeout or no connection → NetworkError (user sees "No internet")
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        _logger.e('login() → NetworkError',
            repository: 'AuthRepositoryImpl');
        return const ResourceError(NetworkError());
      }
      // HTTP 401 → UnauthorizedError (user sees "Invalid credentials")
      final statusCode = e.response?.statusCode;
      if (statusCode == 401) {
        _logger.e('login() → UnauthorizedError',
            repository: 'AuthRepositoryImpl');
        return const ResourceError(UnauthorizedError());
      }
      // Any other HTTP error → ServerError with status code and message
      _logger.e('login() → ServerError($statusCode)',
          repository: 'AuthRepositoryImpl');
      return Resource.error(
        ServerError(code: statusCode ?? 0, message: e.message),
      );

    // 'catch (e, stack)' = catch EVERYTHING else (JSON parse error, etc.)
    } catch (e, stack) {
      _logger.e(
        'login() UNKNOWN EXCEPTION: $e',
        repository: 'AuthRepositoryImpl',
        error: e,
        stack: stack,
      );
      return Resource.error(UnknownError(originalError: e));
    }
  }

  @override
  Future<UserModel?> getSavedSession() async {
    _logger.d('getSavedSession() called',
        repository: 'AuthRepositoryImpl');

    // Read the JSON string from secure storage
    final json = await _sessionStore.getSession();
    _logger.d(
      'getSavedSession() sessionJson=${json != null ? "present (len=${json.length})" : "null"}',
      repository: 'AuthRepositoryImpl',
    );

    if (json == null) return null;

    try {
      // Parse JSON string → Map → UserModel
      // jsonDecode is the opposite of jsonEncode
      final user =
          UserModel.fromJson(jsonDecode(json) as Map<String, dynamic>);
      _logger.i(
        'getSavedSession() restored user: id=${user.id}, name=${user.name}',
        repository: 'AuthRepositoryImpl',
      );
      return user;
    } catch (e, stack) {
      // If the saved JSON is corrupt or the model changed, parsing will fail.
      // We return null (= no saved session) instead of crashing.
      _logger.e(
        'getSavedSession() parse error: $e',
        repository: 'AuthRepositoryImpl',
        error: e,
        stack: stack,
      );
      return null;
    }
  }

  @override
  Future<void> clearSession() async {
    _logger.d('clearSession() called', repository: 'AuthRepositoryImpl');
    await _tokenStore.clear();        // Delete access + refresh tokens
    await _sessionStore.clearSession(); // Delete saved session JSON
    _logger.i('clearSession() done', repository: 'AuthRepositoryImpl');
  }
}
