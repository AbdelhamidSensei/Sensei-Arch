// ═══════════════════════════════════════════════════════════════════
// FILE:     secure_token_store_impl.dart
// LAYER:    core/security
// PURPOSE:  Implements SecureTokenStore using SecureStorage + AppLogger.
//
// PLAIN ENGLISH:
//   The concrete class that saves/loads auth tokens from the encrypted
//   vault. It logs every operation (but NEVER the token value itself —
//   only its length, so we can verify it was stored without leaking it).
//
// WHO CREATES ME:
//   Riverpod provider `secureTokenStoreProvider` in core_providers.dart.
//
// WHO USES ME:
//   AuthInterceptor reads tokens; future login/logout flows write them.
//
// WHAT I TALK TO:
//   SecureStorage (the vault), AppLogger (for audit trail).
// ═══════════════════════════════════════════════════════════════════

import 'package:sensei/core/logger/app_logger.dart';
import 'package:sensei/core/security/secure_keys.dart';
import 'package:sensei/core/security/secure_storage.dart';
import 'package:sensei/core/security/secure_token_store.dart';

/// Concrete token store that logs operations without leaking values.
///
/// PLAIN ENGLISH: the class that actually puts tokens into the vault
/// and gets them back out. Every operation is logged so you can see
/// in the console that things are working — but token values are NEVER
/// printed (only their length).
///
/// Called by: AuthInterceptor (read), login flow (write), logout (clear).
/// Calls: [SecureStorage], [AppLogger].
class SecureTokenStoreImpl implements SecureTokenStore {
  SecureTokenStoreImpl({
    required SecureStorage secureStorage,
    required AppLogger logger,
  })  : _secureStorage = secureStorage,
        _logger = logger;

  final SecureStorage _secureStorage;
  final AppLogger _logger;

  @override
  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(
      key: SecureKeys.kAccessToken,
      value: token,
    );
    // Log that we saved, but NEVER log the token value itself.
    _logger.i('Access token saved (len=${token.length})',
        className: 'SecureTokenStore');
  }

  @override
  Future<String?> getAccessToken() async {
    final token = await _secureStorage.read(key: SecureKeys.kAccessToken);
    _logger.v(
      token != null
          ? 'Access token read (len=${token.length})'
          : 'Access token not found',
      className: 'SecureTokenStore',
    );
    return token;
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(
      key: SecureKeys.kRefreshToken,
      value: token,
    );
    _logger.i('Refresh token saved (len=${token.length})',
        className: 'SecureTokenStore');
  }

  @override
  Future<String?> getRefreshToken() async {
    final token = await _secureStorage.read(key: SecureKeys.kRefreshToken);
    _logger.v(
      token != null
          ? 'Refresh token read (len=${token.length})'
          : 'Refresh token not found',
      className: 'SecureTokenStore',
    );
    return token;
  }

  @override
  Future<void> clear() async {
    await _secureStorage.delete(key: SecureKeys.kAccessToken);
    await _secureStorage.delete(key: SecureKeys.kRefreshToken);
    _logger.i('All tokens cleared', className: 'SecureTokenStore');
  }
}
