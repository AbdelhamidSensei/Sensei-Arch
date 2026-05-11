// ═══════════════════════════════════════════════════════════════════
// FILE:     domain_error.dart
// LAYER:    core/domain
// PURPOSE:  A sealed class of all possible errors the app can encounter,
//           expressed in business terms (not HTTP codes or exceptions).
//
// PLAIN ENGLISH:
//   The UI doesn't care that the server returned HTTP 401 — it cares
//   that the user is "unauthorized". This file translates technical
//   errors into human-understandable categories. The ViewModel can
//   then show the right message without knowing anything about HTTP.
//
// WHO CREATES ME:
//   ErrorMapper (in core/network/) converts ApiResult errors into me.
//
// WHO USES ME:
//   Resource.error carries me; ViewModels switch on me for error UX.
//
// WHAT I TALK TO:
//   Nothing — I'm a pure data definition.
// ═══════════════════════════════════════════════════════════════════

/// All possible domain-level errors in the application.
///
/// PLAIN ENGLISH: a menu of "what went wrong" options that the UI
/// can understand without importing network or database packages.
///
/// Called by: ErrorMapper creates instances; ViewModel switches on them.
/// Calls: nothing.
sealed class DomainError {
  const DomainError();
}

/// No internet connection or the server is unreachable.
class NetworkError extends DomainError {
  const NetworkError();
}

/// The server responded with an error status code.
class ServerError extends DomainError {
  const ServerError({required this.code, this.message});

  /// The HTTP status code (e.g., 500, 403).
  final int code;

  /// Optional server-provided error message.
  // 'String?' = a String OR null. Without the '?', null is forbidden (null-safety).
  final String? message;
}

/// The user's session has expired or token is invalid (HTTP 401).
class UnauthorizedError extends DomainError {
  const UnauthorizedError();
}

/// Input validation failed (e.g., empty required field).
class ValidationError extends DomainError {
  const ValidationError({required this.field, required this.reason});

  /// Which field failed validation.
  final String field;

  /// Why it failed.
  final String reason;
}

/// An unexpected/unknown error that doesn't fit other categories.
class UnknownError extends DomainError {
  const UnknownError({this.originalError});

  /// The original error object for debugging (never shown to user).
  final Object? originalError;
}
