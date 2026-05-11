// ═══════════════════════════════════════════════════════════════════
// FILE:     secure_token_store.dart
// LAYER:    core/security
// PURPOSE:  Abstract interface specifically for token CRUD operations.
//
// PLAIN ENGLISH:
//   While SecureStorage is a generic vault, this interface is specialized
//   for auth tokens. It knows about "access token" and "refresh token"
//   specifically. This makes the API clearer for consumers — they call
//   `getAccessToken()` instead of `read(key: 'access_token')`.
//
// WHO CREATES ME:
//   SecureTokenStoreImpl implements this.
//
// WHO USES ME:
//   AuthInterceptor (reads token), login flow (saves tokens).
// ═══════════════════════════════════════════════════════════════════

/// Contract for storing and retrieving authentication tokens.
///
/// PLAIN ENGLISH: a specialized vault interface that speaks in "tokens"
/// rather than generic keys/values. Makes the code self-documenting.
///
/// Called by: AuthInterceptor, any future login/logout logic.
/// Calls: nothing (interface).
abstract class SecureTokenStore {
  /// Saves the short-lived access token.
  Future<void> saveAccessToken(String token);

  /// Retrieves the access token, or null if not saved.
  Future<String?> getAccessToken();

  /// Saves the long-lived refresh token.
  Future<void> saveRefreshToken(String token);

  /// Retrieves the refresh token, or null if not saved.
  Future<String?> getRefreshToken();

  /// Deletes both tokens (logout).
  Future<void> clear();
}
