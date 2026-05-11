// ═══════════════════════════════════════════════════════════════════
// FILE:     log_level.dart
// LAYER:    core/logger
// PURPOSE:  Defines the severity levels for log messages.
//
// PLAIN ENGLISH:
//   Think of log levels like a volume knob for your app's diary.
//   "verbose" is whispering every tiny detail. "wtf" is screaming
//   that something impossible just happened. In release builds we
//   turn off the quiet levels so users never see debug spam.
//
// WHO CREATES ME:
//   Nobody "creates" an enum — Dart loads it when the app starts.
//
// WHO USES ME:
//   AppLoggerImpl checks the level before printing a message.
//
// WHAT I TALK TO:
//   Nothing — I'm a pure data definition.
// ═══════════════════════════════════════════════════════════════════

// 'enum' = a fixed set of named constants. Like Kotlin's enum class.
// Each value has an index (0, 1, 2…) which we use for severity comparison.

/// The severity levels for log messages, ordered from least to most severe.
///
/// PLAIN ENGLISH: a label we attach to every log line so we can filter
/// out noise. In release mode, only [warn], [error], and [wtf] are printed.
enum LogLevel {
  /// Extremely detailed info, rarely needed outside active debugging.
  verbose,

  /// Developer-only information useful during feature development.
  debug,

  /// General operational info (app started, screen opened).
  info,

  /// Something unexpected happened but the app can continue.
  warn,

  /// A failure occurred — the user likely noticed something wrong.
  error,

  /// "What a Terrible Failure" — should never happen in theory.
  wtf,
}
