// ═══════════════════════════════════════════════════════════════════
// FILE:     log_tags.dart
// LAYER:    core/logger
// PURPOSE:  Central registry of string constants used as log tags.
//
// PLAIN ENGLISH:
//   Every log line gets a "tag" so you can filter the console output.
//   Instead of typing raw strings everywhere (easy to misspell), we
//   keep all tags here as constants. Searching "TAG_REPO" in the
//   console shows only repository-layer logs.
//
// WHO CREATES ME:
//   Nobody creates this — it's a container of compile-time constants.
//
// WHO USES ME:
//   Every class that calls AppLogger uses one of these tags.
// ═══════════════════════════════════════════════════════════════════

/// Centralized log tag constants used throughout the app.
///
/// PLAIN ENGLISH: short labels we attach to log lines so we can filter
/// by architectural layer in the console output.
///
/// Usage: `logger.d(LogTags.repo, 'fetching users from cache');`
abstract final class LogTags {
  // 'abstract final class' = cannot be instantiated or extended.
  // We use it as a namespace for constants (like Kotlin's companion object).

  // 'static const' = compile-time constant belonging to the class, not an instance.
  // 'const' values are inlined by the compiler — zero runtime cost.

  /// Network/HTTP layer (Dio interceptors).
  static const String net = 'TAG_NET';

  /// Retrofit API interface calls.
  static const String api = 'TAG_API';

  /// Repository implementations (data layer).
  static const String repo = 'TAG_REPO';

  /// Local database (Drift) operations.
  static const String db = 'TAG_DB';

  /// UseCase invocations (domain layer).
  static const String useCase = 'TAG_USECASE';

  /// ViewModel state transitions (presentation layer).
  static const String vm = 'TAG_VM';

  /// Widget/UI events (presentation layer).
  static const String ui = 'TAG_UI';

  /// Secure storage and token operations.
  static const String security = 'TAG_SECURITY';

  /// Dependency injection setup.
  static const String di = 'TAG_DI';
}
