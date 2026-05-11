// ═══════════════════════════════════════════════════════════════════
// FILE:     users_repository_impl.dart
// LAYER:    data (repository implementation)
// PURPOSE:  The real implementation of UsersRepository that coordinates
//           between the remote API and local database cache.
//
// PLAIN ENGLISH:
//   This is where "get me the users" actually DOES something. It:
//   1. Emits "loading" so the UI shows a spinner.
//   2. Checks the local cache (Drift) — if we have data, emit it fast.
//   3. Calls the remote API for fresh data.
//   4. Saves fresh data to the cache for next time.
//   5. Emits the fresh data (or an error if the network failed).
//   This pattern is called "NetworkBoundResource" — cache-first, then refresh.
//
// WHO CREATES ME:
//   Riverpod provider `usersRepositoryProvider` in users_providers.dart.
//
// WHO USES ME:
//   UseCases call my methods (via the UsersRepository interface).
//
// WHAT I TALK TO:
//   ⤵ UsersApi        → makes HTTP requests.
//   ⤵ UsersDao        → reads/writes local cache.
//   ⤵ AppLogger       → logs every step.
//
// FULL DATA FLOW THROUGH ME:
//   UseCase → [ME: Repository] → Api → Network
//   Network → Api → [ME: Repository] → Dao → DB
//   DB → Dao → [ME: Repository] → UseCase → ViewModel
// ═══════════════════════════════════════════════════════════════════

import 'package:sensei/core/logger/app_logger.dart';
import 'package:sensei/core/network/api_result.dart';
import 'package:sensei/core/result/resource.dart';
import 'package:sensei/features/users/data/local/dao/users_dao.dart';
import 'package:sensei/features/users/data/mapper/user_dto_mapper.dart';
import 'package:sensei/features/users/data/mapper/user_entity_mapper.dart';
import 'package:sensei/features/users/data/remote/api/users_api.dart';
import 'package:sensei/features/users/data/remote/dto/user_dto.dart';
import 'package:sensei/features/users/domain/model/user.dart';
import 'package:sensei/features/users/domain/repository/users_repository.dart';
import 'package:sensei/core/network/error_mapper.dart';

import 'package:dio/dio.dart';

/// Concrete implementation of [UsersRepository].
///
/// PLAIN ENGLISH: the class that actually fetches users from the internet
/// and caches them locally. Implements the NetworkBoundResource pattern:
/// emit cache first (fast), then fetch from network, save, and emit fresh data.
///
/// Called by: UseCases (via the interface).
/// Calls: [UsersApi], [UsersDao], [AppLogger].
class UsersRepositoryImpl implements UsersRepository {
  UsersRepositoryImpl({
    required UsersApi api,
    required UsersDao dao,
    required AppLogger logger,
  })  : _api = api,
        _dao = dao,
        _logger = logger;

  static const _kName = 'UsersRepositoryImpl';

  final UsersApi _api;
  final UsersDao _dao;
  final AppLogger _logger;

  @override
  // 'async*' marks a function that returns a Stream. 'yield' emits one
  // value to that stream.
  Stream<Resource<List<User>>> getUsers() async* {
    // Step 1: Emit loading state.
    _logger.d('getUsers() — emitting loading', repository: _kName);
    yield Resource.loading();

    // Step 2: Try to emit cached data first (fast).
    try {
      final cachedEntities = await _dao.getAllUsers();
      if (cachedEntities.isNotEmpty) {
        final cachedUsers = cachedEntities.toDomain();
        _logger.d('getUsers() — emitting cache (${cachedUsers.length} users)', repository: _kName);
        yield Resource.success(cachedUsers);
      }
    } catch (dbError) {
      _logger.w('getUsers() — cache read failed', repository: _kName, error: dbError);
      // Don't fail — we'll still try the network.
    }

    // Step 3: Fetch from network.
    // → Crosses into DATA layer via API call.
    final apiResult = await _safeApiCall(() => _api.getUsers());

    // Step 4: Handle the result.
    switch (apiResult) {
      case ApiSuccess<List<UserDto>>(:final data):
        _logger.d('getUsers() — network success (${data.length} users)', repository: _kName);

        // Save to cache for next time.
        try {
          final companions = data.toDomain().map((user) => user.toEntity()).toList();
          await _dao.insertUsers(companions);
          _logger.d('getUsers() — saved to cache', repository: _kName);
        } catch (dbError) {
          _logger.w('getUsers() — cache write failed', repository: _kName, error: dbError);
        }

        // Emit fresh network data.
        yield Resource.success(data.toDomain());

      case ApiHttpError<List<UserDto>>():
      case ApiNetworkError<List<UserDto>>():
      case ApiUnknownError<List<UserDto>>():
        final domainError = ErrorMapper.toDomain(apiResult);
        _logger.e('getUsers() — network error: $domainError', repository: _kName);
        yield Resource.error(domainError);
    }
  }

  @override
  Stream<Resource<User>> getUserById(int id) async* {
    _logger.d('getUserById($id) — emitting loading', repository: _kName);
    yield Resource.loading();

    // Try cache first.
    try {
      final cachedEntity = await _dao.getUserById(id);
      if (cachedEntity != null) {
        _logger.d('getUserById($id) — emitting cache', repository: _kName);
        yield Resource.success(cachedEntity.toDomain());
      }
    } catch (dbError) {
      _logger.w('getUserById($id) — cache read failed', repository: _kName, error: dbError);
    }

    // Fetch from network.
    final apiResult = await _safeApiCall(() => _api.getUserById(id));

    switch (apiResult) {
      case ApiSuccess<UserDto>(:final data):
        _logger.d('getUserById($id) — network success', repository: _kName);

        try {
          await _dao.insertUsers([data.toDomain().toEntity()]);
        } catch (dbError) {
          _logger.w('getUserById($id) — cache write failed', repository: _kName, error: dbError);
        }

        yield Resource.success(data.toDomain());

      case ApiHttpError<UserDto>():
      case ApiNetworkError<UserDto>():
      case ApiUnknownError<UserDto>():
        final domainError = ErrorMapper.toDomain(apiResult);
        _logger.e('getUserById($id) — network error: $domainError', repository: _kName);
        yield Resource.error(domainError);
    }
  }

  /// Wraps an async API call in an [ApiResult] — catches all exceptions.
  ///
  /// PLAIN ENGLISH: a safety net. No matter what goes wrong inside the
  /// API call (timeout, parse error, server down), we catch it here and
  /// wrap it in a nice sealed class instead of letting exceptions fly.
  ///
  /// [block] — the async function to execute (e.g., `() => _api.getUsers()`).
  /// Returns an [ApiResult] that's either success or one of the error variants.
  Future<ApiResult<T>> _safeApiCall<T>(Future<T> Function() block) async {
    try {
      final data = await block();
      return ApiSuccess(data);
    } on DioException catch (dioError) {
      // Map Dio-specific errors to our ApiResult variants.
      return switch (dioError.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout ||
        DioExceptionType.connectionError =>
          ApiNetworkError(message: dioError.message),
        DioExceptionType.badResponse => ApiHttpError(
            statusCode: dioError.response?.statusCode ?? 0,
            message: dioError.response?.statusMessage,
          ),
        _ => ApiUnknownError(error: dioError),
      };
    } catch (unknownError) {
      return ApiUnknownError(error: unknownError);
    }
  }
}
