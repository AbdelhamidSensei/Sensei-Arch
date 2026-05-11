// ═══════════════════════════════════════════════════════════════════
// FILE:     secure_storage.dart
// LAYER:    core/security
// PURPOSE:  Abstract interface for encrypted key-value storage.
//
// PLAIN ENGLISH:
//   This is the contract for a "vault" on the phone. On iOS it maps to
//   Keychain; on Android to EncryptedSharedPreferences backed by
//   Keystore. We define an interface so tests can use a fake vault.
//
// WHO CREATES ME:
//   Nobody directly — SecureStorageImpl implements this.
//
// WHO USES ME:
//   SecureTokenStoreImpl uses this to actually read/write tokens.
// ═══════════════════════════════════════════════════════════════════

/// Contract for encrypted key-value storage on the device.
///
/// PLAIN ENGLISH: a safe where we can put secrets (tokens, API keys)
/// that only our app can open. The OS encrypts them for us.
///
/// Called by: SecureTokenStoreImpl.
/// Calls: nothing (it's an interface).
abstract class SecureStorage {
  /// Writes [value] encrypted under [key].
  ///
  // 'Future<void>' = a Future that completes with no return value.
  // 'Future<T>' = a value that will arrive later (Kotlin's Deferred / JS Promise).
  Future<void> write({required String key, required String value});

  /// Reads the encrypted value stored under [key].
  ///
  /// Returns null if the key doesn't exist.
  Future<String?> read({required String key});

  /// Deletes the value stored under [key].
  Future<void> delete({required String key});

  /// Deletes all values in secure storage.
  Future<void> deleteAll();
}
