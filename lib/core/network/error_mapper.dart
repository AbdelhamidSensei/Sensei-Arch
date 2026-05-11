// ═══════════════════════════════════════════════════════════════════
// FILE:     error_mapper.dart
// LAYER:    core/network
// PURPOSE:  Converts ApiResult error variants into DomainError values.
//
// PLAIN ENGLISH:
//   This is the "translator" between the network world (HTTP codes,
//   timeouts) and the domain world (unauthorized, server error).
//   It's the single place in the app where network concepts become
//   business concepts — nowhere else should know about HTTP codes.
//
// WHO CREATES ME:
//   Nobody creates it — it's a static utility class.
//
// WHO USES ME:
//   Repository implementations call ErrorMapper.toDomain(...).
//
// WHAT I TALK TO:
//   Reads ApiResult variants, produces DomainError variants.
// ═══════════════════════════════════════════════════════════════════

import 'package:sensei/core/domain/domain_error.dart';
import 'package:sensei/core/network/api_result.dart';

/// Maps [ApiResult] error variants to [DomainError] values.
///
/// PLAIN ENGLISH: translates "what went wrong on the network" into
/// "what went wrong in business terms". The UI only sees DomainErrors.
///
/// Called by: Repository implementations.
/// Calls: nothing — pure mapping logic.
abstract final class ErrorMapper {
  /// Converts a failed [ApiResult] into a [DomainError].
  ///
  /// [result] must NOT be [ApiSuccess] — call this only for error cases.
  /// Returns the appropriate [DomainError] subtype.
  static DomainError toDomain<T>(ApiResult<T> result) {
    return switch (result) {
      ApiSuccess<T>() =>
        // This should never be called with a success, but handle gracefully.
        const UnknownError(),
      ApiHttpError<T>(statusCode: 401) => const UnauthorizedError(),
      ApiHttpError<T>(:final statusCode, :final message) =>
        ServerError(code: statusCode, message: message),
      ApiNetworkError<T>() => const NetworkError(),
      ApiUnknownError<T>(:final error) => UnknownError(originalError: error),
    };
  }
}
