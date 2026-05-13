// ═══════════════════════════════════════════════════════════════════
// FILE:     session_store_impl.dart
// LAYER:    core/security
// PURPOSE:  Concrete implementation of SessionStore using encrypted storage.
//
// PLAIN ENGLISH:
//   This is the REAL vault that saves the user's session JSON into
//   the phone's secure storage (iOS Keychain / Android EncryptedSharedPrefs).
//   It implements the SessionStore interface so the rest of the app
//   doesn't know or care about the encryption details.
//
// ANDROID EQUIVALENT:
//   Like a class that wraps EncryptedSharedPreferences:
//     class SessionStoreImpl(
//       private val encryptedPrefs: EncryptedSharedPreferences
//     ) : SessionStore { ... }
//
// WHY FlutterSecureStorage (not plain SharedPreferences)?
//   - SharedPreferences stores data in plain XML on Android → anyone with
//     root access can read tokens. Bad for security.
//   - FlutterSecureStorage uses Android Keystore + EncryptedSharedPreferences
//     on Android, and Keychain on iOS → data is encrypted at rest.
//   - For non-sensitive data (like branch selection), SharedPreferences is fine.
//     For tokens and session data → always use secure storage.
//
// WHO CREATES ME:
//   Riverpod provider `sessionStoreProvider` in core_providers.dart.
//
// WHO USES ME:
//   AuthRepositoryImpl (indirectly, via the SessionStore interface).
// ═══════════════════════════════════════════════════════════════════

import 'package:sensei/core/security/secure_keys.dart';
import 'package:sensei/core/security/secure_storage.dart';
import 'package:sensei/core/security/session_store.dart';

// 'implements' = this class promises to provide ALL methods from SessionStore.
// If we forget one, the compiler will complain. (Like Kotlin's `: SessionStore`)
class SessionStoreImpl implements SessionStore {
  // Constructor with named required parameter.
  // 'required' = must be provided, compiler enforces it.
  // In Kotlin: class SessionStoreImpl(private val secureStorage: SecureStorage)
  SessionStoreImpl({required SecureStorage secureStorage})
      : _secureStorage = secureStorage;

  // '_' prefix = private in Dart. Only this file can access it.
  // In Kotlin you'd use `private val`. In Dart, privacy is file-level
  // (not class-level like Java/Kotlin).
  final SecureStorage _secureStorage;

  // '@override' = we're implementing a method from the interface.
  // The compiler checks the signature matches. Without it, a typo
  // in the method name would silently create a NEW method instead
  // of implementing the interface method.
  @override
  Future<void> saveSession(String json) async {
    // 'await' = pause here until the write completes.
    // Like Kotlin's suspending function call inside a coroutine.
    // SecureKeys.kUserSession is a constant string key ("user_session").
    await _secureStorage.write(key: SecureKeys.kUserSession, value: json);
  }

  @override
  Future<String?> getSession() async {
    return _secureStorage.read(key: SecureKeys.kUserSession);
  }

  @override
  Future<void> clearSession() async {
    await _secureStorage.delete(key: SecureKeys.kUserSession);
  }
}
