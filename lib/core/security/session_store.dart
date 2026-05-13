// ═══════════════════════════════════════════════════════════════════
// FILE:     session_store.dart
// LAYER:    core/security
// PURPOSE:  Abstract interface for saving/loading the user's login session.
//
// PLAIN ENGLISH:
//   After login, we get a UserModel (token, name, branches, etc.).
//   We want to save it so the user doesn't have to login again next time.
//   This interface defines WHAT we can do (save/get/clear), but NOT HOW.
//   The "how" is in SessionStoreImpl.
//
// ANDROID EQUIVALENT:
//   Like creating an interface in Kotlin:
//     interface SessionStore {
//       suspend fun saveSession(json: String)
//       suspend fun getSession(): String?
//       suspend fun clearSession()
//     }
//
// WHY AN INTERFACE (not just a class)?
//   1. Testability: In tests, we can create a FakeSessionStore that stores
//      data in memory instead of the real encrypted vault.
//   2. Flexibility: We could swap the storage backend (SharedPrefs, Hive,
//      encrypted file) without changing any code that USES SessionStore.
//   3. Clean Architecture: Upper layers (Repository) depend on this
//      abstraction, not on the concrete implementation.
//
// ALTERNATIVE APPROACHES:
//   - Could use SharedPreferences directly (simpler but less secure)
//   - Could use Hive (fast local DB, but overkill for one JSON string)
//   - We chose FlutterSecureStorage because tokens are sensitive data
//     and should be encrypted at rest (iOS Keychain / Android Keystore)
//
// WHO CREATES ME:
//   Nobody directly — SessionStoreImpl implements this.
//
// WHO USES ME:
//   AuthRepositoryImpl saves/loads session through this interface.
// ═══════════════════════════════════════════════════════════════════

// 'abstract class' = cannot be instantiated directly. Only defines a contract.
// In Kotlin this would be an `interface`. Dart uses `abstract class` for the
// same purpose. (Dart 3 also has `abstract interface class` but `abstract class`
// is more common and allows default method implementations if needed later.)
abstract class SessionStore {
  // 'Future<void>' = an async operation that returns nothing when done.
  // Like Kotlin's `suspend fun saveSession(json: String)`.
  // We save the entire UserModel as a JSON string so we can restore it later.
  Future<void> saveSession(String json);

  // 'Future<String?>' = an async operation that returns a nullable String.
  // Returns null if no session was saved (first launch, or after logout).
  // Like Kotlin's `suspend fun getSession(): String?`
  Future<String?> getSession();

  // Deletes the saved session (called on logout).
  Future<void> clearSession();
}
