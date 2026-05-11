// ═══════════════════════════════════════════════════════════════════
// FILE:     api_result.dart
// LAYER:    core/network
// PURPOSE:  A sealed class wrapping every possible outcome of an HTTP call.
//
// PLAIN ENGLISH:
//   Instead of throwing exceptions across layers (messy, easy to forget
//   to catch), we wrap every API call result in this sealed class.
//   The repository then pattern-matches on it — no try/catch needed.
//
// WHO CREATES ME:
//   The `safeApiCall` helper function wraps Dio/Retrofit responses.
//
// WHO USES ME:
//   Repository implementations switch on me to decide how to proceed.
//
// WHAT I TALK TO:
//   Nothing — I'm a data container.
// ═══════════════════════════════════════════════════════════════════

// ┌─ WHY ApiResult EXISTS ───────────────────────────────────────
// │ Exceptions are invisible in a function signature — you never
// │ know what might throw. ApiResult makes failure EXPLICIT in the
// │ return type, so the compiler reminds you to handle every case.
// │ Think of it as Kotlin's Result<T> or Rust's Result<T, E>.
// └──────────────────────────────────────────────────────────────

/// Wraps the outcome of an HTTP/API call without throwing exceptions.
///
/// PLAIN ENGLISH: "here's what happened when we talked to the server."
/// Either we got data back, or something went wrong — and this tells
/// you exactly which scenario occurred.
///
/// Called by: [safeApiCall] creates instances.
/// Calls: nothing.
sealed class ApiResult<T> {
  const ApiResult();
}

/// The HTTP call succeeded and returned data of type [T].
class ApiSuccess<T> extends ApiResult<T> {
  const ApiSuccess(this.data);

  /// The deserialized response body.
  final T data;
}

/// The server responded with an HTTP error (4xx/5xx).
class ApiHttpError<T> extends ApiResult<T> {
  const ApiHttpError({required this.statusCode, this.message});

  /// HTTP status code (e.g., 404, 500).
  final int statusCode;

  /// Optional body/message from the server.
  final String? message;
}

/// A network-level failure (no internet, DNS failure, timeout).
class ApiNetworkError<T> extends ApiResult<T> {
  const ApiNetworkError({this.message});

  /// Description of the network issue.
  final String? message;
}

/// Something unexpected happened (parsing error, unknown exception).
class ApiUnknownError<T> extends ApiResult<T> {
  const ApiUnknownError({this.error});

  /// The original error object.
  final Object? error;
}
