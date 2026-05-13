// ═══════════════════════════════════════════════════════════════════
// FILE:     auth_api.dart
// LAYER:    data/remote/api
// PURPOSE:  Makes the actual HTTP call to the login endpoint.
//
// PLAIN ENGLISH:
//   This is the class that talks to the server. It uses Dio (like OkHttp
//   in Android) to send a POST request with the user's credentials and
//   parse the JSON response into a LoginResponseDto.
//
// ANDROID EQUIVALENT:
//   Like a Retrofit interface in Kotlin:
//     interface AuthApi {
//       @POST("/api/auth/login")
//       suspend fun login(@Body request: LoginRequest): LoginResponseDto
//     }
//   But in Flutter there's no Retrofit annotation magic — we write the
//   Dio call manually. (There IS a retrofit_generator package for Dart,
//   but manual calls are simpler and more transparent for learning.)
//
// ALTERNATIVE APPROACHES:
//   - Use retrofit_generator package (generates Dio calls from annotations,
//     like Android Retrofit, but adds complexity with code generation)
//   - Use the http package (simpler but less powerful than Dio — no
//     interceptors, no automatic JSON encoding, no timeout configuration)
//   - Use GraphQL (if the API supported it)
//   - We chose manual Dio calls for clarity and full control.
//
// WHO CREATES ME:
//   Riverpod provider `authApiProvider` in auth_providers.dart.
//
// WHO USES ME:
//   AuthRepositoryImpl calls me to perform the login HTTP request.
// ═══════════════════════════════════════════════════════════════════

import 'package:dio/dio.dart';
import 'package:sensei/core/logger/app_logger.dart';
import 'package:sensei/features/auth/data/remote/dto/login_response_dto.dart';

class AuthApi {
  // Dio is injected (not created here) so we can:
  // 1. Share the same Dio instance across all APIs (same config)
  // 2. Mock it in tests
  // 3. Interceptors (auth token, logging) are already attached
  AuthApi({required Dio dio, required AppLogger logger})
      : _dio = dio,
        _logger = logger;

  final Dio _dio;
  final AppLogger _logger;

  /// Calls POST /api/auth/login with the user's credentials.
  ///
  /// The API expects: {"LoginID": "42696", "LoginPassword": "Essam@0123"}
  /// The API returns:  {"token": "eyJ...", "id": "1008299", "name": "Essam", ...}
  ///
  /// IMPORTANT: The request keys are PascalCase ("LoginID", not "loginId")
  /// because the .NET backend expects them that way. Always match the API spec!
  Future<LoginResponseDto> login(String loginId, String password) async {
    _logger.d(
      'login() called with loginId=$loginId',
      className: 'AuthApi',
    );
    _logger.d(
      'POST /api/auth/login → baseUrl=${_dio.options.baseUrl}',
      className: 'AuthApi',
    );

    try {
      // _dio.post() sends an HTTP POST request.
      // 'data' = the request body. Dio automatically converts the Map to JSON
      // because we set Content-Type: application/json in dio_client.dart.
      //
      // In Kotlin/Retrofit this would be:
      //   @POST("/api/auth/login")
      //   suspend fun login(@Body body: Map<String, String>): Response<LoginResponseDto>
      final response = await _dio.post(
        '/api/auth/login',
        data: {
          'LoginID': loginId,
          'LoginPassword': password,
        },
      );

      _logger.d(
        'login() raw response statusCode=${response.statusCode}, '
        'dataType=${response.data.runtimeType}',
        className: 'AuthApi',
      );
      _logger.longD(
        'login() response body: ${response.data}',
        className: 'AuthApi',
      );

      // Parse the JSON response into our DTO.
      // 'response.data' is already a Map<String, dynamic> because Dio
      // auto-decodes JSON responses (like Retrofit with GsonConverterFactory).
      // 'as Map<String, dynamic>' = type cast (tells Dart the exact type).
      final dto = LoginResponseDto.fromJson(
          response.data as Map<String, dynamic>);

      _logger.d(
        'login() parsed DTO: token=${dto.token != null ? "present" : "null"}, '
        'id=${dto.id}, name=${dto.name}, '
        'branches=${dto.companiesBranches.length}',
        className: 'AuthApi',
      );

      return dto;
    } catch (e, stack) {
      // 'catch (e, stack)' captures both the error AND the stack trace.
      // In Kotlin you'd only get the exception; stack trace is automatic.
      // In Dart, you must explicitly capture it with the second parameter.
      _logger.e(
        'login() EXCEPTION: $e',
        className: 'AuthApi',
        error: e,
        stack: stack,
      );
      // 'rethrow' re-throws the same exception without wrapping it.
      // The repository will catch it and convert it to a Resource.error.
      rethrow;
    }
  }
}
