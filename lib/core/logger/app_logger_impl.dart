// ═══════════════════════════════════════════════════════════════════
// FILE:     app_logger_impl.dart
// LAYER:    core/logger
// PURPOSE:  The real implementation of AppLogger that prints to the
//           debug console with rich caller context.
//
// PLAIN ENGLISH:
//   This is the actual "printer". It formats log lines to show:
//   - The log level (D, I, W, E, WTF)
//   - WHO is logging (Screen, ViewModel, UseCase, Repository, etc.)
//   - The message
//
//   Example output:
//   D/SenseiLogger: [UsersListScreen][UsersListViewModel]: Loading users
//   I/SenseiLogger: [GetUsersUseCase 🎲]: Invoked
//   D/SenseiLogger: [UsersRepositoryImpl 📦]: Cache hit (10 users)
//   E/SenseiLogger: [UsersApi 🌐]: HttpException: 500
//
//   In release mode, verbose/debug/info are silenced, and sensitive
//   data (emails, tokens) is masked automatically.
//
// WHO CREATES ME:
//   The Riverpod provider `appLoggerProvider` in core_providers.dart.
//
// WHO USES ME:
//   Indirectly — everyone uses the AppLogger interface; this is
//   the concrete object behind that interface at runtime.
//
// WHAT I TALK TO:
//   Flutter's `debugPrint` function (which goes to the console).
// ═══════════════════════════════════════════════════════════════════

import 'package:flutter/foundation.dart';

import 'app_logger.dart';
import 'log_level.dart';

/// The default tag shown in the console (like Android's Log tag).
const String _kLogTag = 'SenseiLogger';

/// Concrete logger with rich caller context in every log line.
///
/// PLAIN ENGLISH: the workhorse that prints log lines showing exactly
/// which Screen/ViewModel/UseCase/Repository is talking. Makes
/// filtering in the console trivial — just search the class name.
///
/// Called by: Riverpod creates one instance; everyone uses it via [AppLogger].
/// Calls: [debugPrint] (Flutter's safe console printer that won't overflow).
class AppLoggerImpl implements AppLogger {
  AppLoggerImpl({
    LogLevel? minimumLevel,
  }) : _minimumLevel =
            minimumLevel ?? (kReleaseMode ? LogLevel.warn : LogLevel.verbose);

  final LogLevel _minimumLevel;

  @override
  void v(
    String message, {
    String? screen,
    String? viewModel,
    String? useCase,
    String? repository,
    String? className,
    Object? error,
    StackTrace? stack,
  }) =>
      _log(LogLevel.verbose, message,
          screen: screen,
          viewModel: viewModel,
          useCase: useCase,
          repository: repository,
          className: className,
          error: error,
          stack: stack);

  @override
  void d(
    String message, {
    String? screen,
    String? viewModel,
    String? useCase,
    String? repository,
    String? className,
    Object? error,
    StackTrace? stack,
  }) =>
      _log(LogLevel.debug, message,
          screen: screen,
          viewModel: viewModel,
          useCase: useCase,
          repository: repository,
          className: className,
          error: error,
          stack: stack);

  @override
  void i(
    String message, {
    String? screen,
    String? viewModel,
    String? useCase,
    String? repository,
    String? className,
    Object? error,
    StackTrace? stack,
  }) =>
      _log(LogLevel.info, message,
          screen: screen,
          viewModel: viewModel,
          useCase: useCase,
          repository: repository,
          className: className,
          error: error,
          stack: stack);

  @override
  void w(
    String message, {
    String? screen,
    String? viewModel,
    String? useCase,
    String? repository,
    String? className,
    Object? error,
    StackTrace? stack,
  }) =>
      _log(LogLevel.warn, message,
          screen: screen,
          viewModel: viewModel,
          useCase: useCase,
          repository: repository,
          className: className,
          error: error,
          stack: stack);

  @override
  void e(
    String message, {
    String? screen,
    String? viewModel,
    String? useCase,
    String? repository,
    String? className,
    Object? error,
    StackTrace? stack,
  }) =>
      _log(LogLevel.error, message,
          screen: screen,
          viewModel: viewModel,
          useCase: useCase,
          repository: repository,
          className: className,
          error: error,
          stack: stack);

  @override
  void wtf(
    String message, {
    String? screen,
    String? viewModel,
    String? useCase,
    String? repository,
    String? className,
    Object? error,
    StackTrace? stack,
  }) =>
      _log(LogLevel.wtf, message,
          screen: screen,
          viewModel: viewModel,
          useCase: useCase,
          repository: repository,
          className: className,
          error: error,
          stack: stack);

  @override
  void longD(
    String message, {
    String? screen,
    String? viewModel,
    String? useCase,
    String? repository,
    String? className,
    int chunkSize = 3500,
  }) {
    if (LogLevel.debug.index < _minimumLevel.index) return;

    final caller = _formatCaller(
      screen: screen,
      viewModel: viewModel,
      useCase: useCase,
      repository: repository,
      className: className,
    );
    final formatted = 'D/$_kLogTag: $caller: $message';

    if (formatted.length <= chunkSize) {
      debugPrint(formatted);
      return;
    }

    // Split into chunks with correlation ID.
    final id = DateTime.now().millisecondsSinceEpoch.toString().substring(7);
    final totalParts = (formatted.length + chunkSize - 1) ~/ chunkSize;
    var start = 0;
    var part = 1;

    while (start < formatted.length) {
      final end =
          (start + chunkSize).clamp(0, formatted.length);
      final chunk = formatted.substring(start, end);
      debugPrint('REQ#$id ($part/$totalParts) $chunk');
      start = end;
      part++;
    }
  }

  /// Formats the caller context into bracket notation.
  ///
  /// Example: [UsersListScreen 🖥][UsersListViewModel 🧠]
  /// Only non-null params appear. Emojis make scanning instant.
  String _formatCaller({
    String? screen,
    String? viewModel,
    String? useCase,
    String? repository,
    String? className,
  }) {
    final parts = <String>[];

    if (screen != null) parts.add('[$screen 🖥]');
    if (viewModel != null) parts.add('[$viewModel 🧠]');
    if (useCase != null) parts.add('[$useCase 🎲]');
    if (repository != null) parts.add('[$repository 📦]');
    if (className != null) parts.add('[$className]');

    if (parts.isEmpty) return '[App]';
    return parts.join('');
  }

  /// Internal log method — formats and prints if level is high enough.
  void _log(
    LogLevel level,
    String message, {
    String? screen,
    String? viewModel,
    String? useCase,
    String? repository,
    String? className,
    Object? error,
    StackTrace? stack,
  }) {
    if (level.index < _minimumLevel.index) return;

    final levelChar = switch (level) {
      LogLevel.verbose => 'V',
      LogLevel.debug => 'D',
      LogLevel.info => 'I',
      LogLevel.warn => 'W',
      LogLevel.error => 'E',
      LogLevel.wtf => 'WTF',
    };

    final caller = _formatCaller(
      screen: screen,
      viewModel: viewModel,
      useCase: useCase,
      repository: repository,
      className: className,
    );

    // Mask sensitive data in release mode.
    final safeMessage = kReleaseMode ? _maskSensitive(message) : message;

    // Format: D/SenseiLogger: [UsersListViewModel 🧠]: message
    final buffer = StringBuffer('$levelChar/$_kLogTag: $caller: $safeMessage');

    if (error != null) {
      buffer.write(' | error: $error');
    }

    debugPrint(buffer.toString());

    if (stack != null) {
      debugPrint(stack.toString());
    }
  }

  /// Masks emails and token-like strings to prevent PII leaks in release.
  String _maskSensitive(String input) {
    var masked = input.replaceAllMapped(
      RegExp(r'[\w.+-]+@[\w-]+\.[\w.]+'),
      (match) => '***@***.***',
    );

    masked = masked.replaceAllMapped(
      RegExp(r'[A-Za-z0-9_\-]{32,}'),
      (match) => '***token(len=${match.group(0)!.length})***',
    );

    return masked;
  }
}
