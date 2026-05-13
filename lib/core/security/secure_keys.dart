// ═══════════════════════════════════════════════════════════════════
// FILE:     secure_keys.dart
// LAYER:    core/security
// PURPOSE:  String constants used as keys in secure storage.
//
// PLAIN ENGLISH:
//   When we save a token into the phone's secure vault (Keychain/Keystore),
//   we need a "label" (key) to find it later. These constants prevent
//   typos — if you mistype a constant name, the compiler catches it;
//   if you mistype a raw string, you get silent bugs.
//
// WHO CREATES ME:
//   Nobody — compile-time constants exist from app launch.
//
// WHO USES ME:
//   SecureTokenStoreImpl reads/writes using these keys.
// ═══════════════════════════════════════════════════════════════════

/// Keys used to store/retrieve values from secure storage.
///
/// PLAIN ENGLISH: labels for the items in our secure vault, like
/// labels on safe deposit boxes at a bank.
abstract final class SecureKeys {
  /// Key for the short-lived access token (used for API calls).
  static const String kAccessToken = 'access_token';

  /// Key for the long-lived refresh token (used to get a new access token).
  static const String kRefreshToken = 'refresh_token';

  /// Key for the serialized user session JSON.
  static const String kUserSession = 'user_session';
}
