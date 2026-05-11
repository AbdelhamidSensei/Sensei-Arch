// ═══════════════════════════════════════════════════════════════════
// FILE:     users_api.dart
// LAYER:    data/remote (API interface implementation)
// PURPOSE:  Declares and implements the HTTP endpoints for the users feature.
//
// PLAIN ENGLISH:
//   This class wraps Dio HTTP calls for the /users endpoints.
//   It parses the JSON response into DTOs. By isolating HTTP calls
//   here, the repository never deals with Dio directly — if we
//   ever switch HTTP clients, only this file changes.
//
// WHO CREATES ME:
//   Riverpod provider `usersApiProvider` in users_providers.dart.
//
// WHO USES ME:
//   UsersRepositoryImpl calls my methods to fetch data from the server.
//
// WHAT I TALK TO:
//   Dio (HTTP client) → internet → server.
// ═══════════════════════════════════════════════════════════════════

import 'package:dio/dio.dart';

import 'package:sensei/features/users/data/remote/dto/user_dto.dart';

/// HTTP API for the /users endpoints.
///
/// PLAIN ENGLISH: a "menu" of server endpoints wrapped in type-safe
/// Dart methods. Each method makes one HTTP call and returns parsed DTOs.
///
/// Called by: UsersRepositoryImpl.
/// Calls: Dio → network → server.
class UsersApi {
  UsersApi(this._dio);

  final Dio _dio;

  /// GET /users — fetches all users from the server.
  ///
  /// Returns a list of [UserDto] parsed from the JSON response.
  Future<List<UserDto>> getUsers() async {
    final response = await _dio.get<List<dynamic>>('/users');
    // response.data is a List<dynamic> of JSON maps.
    return response.data!
        .map((json) => UserDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// GET /users/{id} — fetches a single user by ID.
  ///
  /// [id] — the user's unique identifier (path parameter).
  Future<UserDto> getUserById(int id) async {
    final response = await _dio.get<Map<String, dynamic>>('/users/$id');
    return UserDto.fromJson(response.data!);
  }
}
