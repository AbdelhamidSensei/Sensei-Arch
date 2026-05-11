// ═══════════════════════════════════════════════════════════════════
// FILE:     secure_storage_impl.dart
// LAYER:    core/security
// PURPOSE:  Implements SecureStorage using flutter_secure_storage.
//
// PLAIN ENGLISH:
//   This is the real vault. On iOS it talks to the Keychain (Apple's
//   encrypted credential store). On Android it uses
//   EncryptedSharedPreferences backed by the hardware Keystore.
//   The data survives app restarts and is deleted on uninstall.
//
// WHO CREATES ME:
//   The Riverpod provider `secureStorageProvider` in core_providers.dart.
//
// WHO USES ME:
//   SecureTokenStoreImpl calls my read/write/delete methods.
//
// WHAT I TALK TO:
//   flutter_secure_storage package (which talks to the OS).
// ═══════════════════════════════════════════════════════════════════

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:sensei/core/security/secure_storage.dart';

/// Real implementation of [SecureStorage] using OS-level encryption.
///
/// PLAIN ENGLISH: the actual encrypted vault backed by iOS Keychain
/// or Android Keystore. flutter_secure_storage handles the platform
/// differences for us.
///
/// Called by: Riverpod creates one instance; SecureTokenStoreImpl uses it.
/// Calls: [FlutterSecureStorage] methods.
class SecureStorageImpl implements SecureStorage {
  SecureStorageImpl()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
          iOptions: IOSOptions(
            accessibility: KeychainAccessibility.first_unlock_this_device,
          ),
        );

  final FlutterSecureStorage _storage;

  @override
  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<String?> read({required String key}) async {
    return _storage.read(key: key);
  }

  @override
  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }

  @override
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
