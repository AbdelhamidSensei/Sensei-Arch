import 'package:flutter/foundation.dart';

import 'app_logger.dart';
import 'log_level.dart';

const String _kLogTag = 'LinkageApp';

class AppLoggerImpl implements AppLogger {
  AppLoggerImpl({
    LogLevel? minimumLevel,
  }) : _minimumLevel =
            minimumLevel ?? (kReleaseMode ? LogLevel.warn : LogLevel.verbose);

  final LogLevel _minimumLevel;

  // ── Level labels & decorations ────────────────────────────────

  static const _levelConfig = {
    LogLevel.verbose: ('V', '⚪'),
    LogLevel.debug:   ('D', '🔵'),
    LogLevel.info:    ('I', '🟢'),
    LogLevel.warn:    ('W', '🟡'),
    LogLevel.error:   ('E', '🔴'),
    LogLevel.wtf:     ('!', '💥'),
  };

  static const _layerEmoji = {
    'screen':     '🖥️ ',
    'viewModel':  '🧠',
    'useCase':    '⚙️ ',
    'repository': '📦',
    'className':  '🔧',
  };

  static const _divider    = '┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄';
  static const _topBorder  = '┌$_divider';
  static const _botBorder  = '└$_divider';
  static const _midBorder  = '├$_divider';

  // ── Public API ────────────────────────────────────────────────

  @override
  void v(String message, {String? screen, String? viewModel, String? useCase, String? repository, String? className, Object? error, StackTrace? stack}) =>
      _log(LogLevel.verbose, message, screen: screen, viewModel: viewModel, useCase: useCase, repository: repository, className: className, error: error, stack: stack);

  @override
  void d(String message, {String? screen, String? viewModel, String? useCase, String? repository, String? className, Object? error, StackTrace? stack}) =>
      _log(LogLevel.debug, message, screen: screen, viewModel: viewModel, useCase: useCase, repository: repository, className: className, error: error, stack: stack);

  @override
  void i(String message, {String? screen, String? viewModel, String? useCase, String? repository, String? className, Object? error, StackTrace? stack}) =>
      _log(LogLevel.info, message, screen: screen, viewModel: viewModel, useCase: useCase, repository: repository, className: className, error: error, stack: stack);

  @override
  void w(String message, {String? screen, String? viewModel, String? useCase, String? repository, String? className, Object? error, StackTrace? stack}) =>
      _log(LogLevel.warn, message, screen: screen, viewModel: viewModel, useCase: useCase, repository: repository, className: className, error: error, stack: stack);

  @override
  void e(String message, {String? screen, String? viewModel, String? useCase, String? repository, String? className, Object? error, StackTrace? stack}) =>
      _log(LogLevel.error, message, screen: screen, viewModel: viewModel, useCase: useCase, repository: repository, className: className, error: error, stack: stack);

  @override
  void wtf(String message, {String? screen, String? viewModel, String? useCase, String? repository, String? className, Object? error, StackTrace? stack}) =>
      _log(LogLevel.wtf, message, screen: screen, viewModel: viewModel, useCase: useCase, repository: repository, className: className, error: error, stack: stack);

  @override
  void longD(String message, {String? screen, String? viewModel, String? useCase, String? repository, String? className, int chunkSize = 3500}) {
    if (LogLevel.debug.index < _minimumLevel.index) return;

    final caller = _formatCaller(screen: screen, viewModel: viewModel, useCase: useCase, repository: repository, className: className);
    final tag = '$_kLogTag';
    final prefix = '│ 🔵 D';
    final header = '$prefix $caller';

    debugPrint('$tag $header');

    if (message.length <= chunkSize) {
      debugPrint('$tag │    $message');
    } else {
      final id = DateTime.now().millisecondsSinceEpoch.toString().substring(7);
      final totalParts = (message.length + chunkSize - 1) ~/ chunkSize;
      var start = 0;
      var part = 1;
      while (start < message.length) {
        final end = (start + chunkSize).clamp(0, message.length);
        debugPrint('$tag │    [$id $part/$totalParts] ${message.substring(start, end)}');
        start = end;
        part++;
      }
    }
  }

  // ── Internals ─────────────────────────────────────────────────

  String _formatCaller({String? screen, String? viewModel, String? useCase, String? repository, String? className}) {
    final parts = <String>[];
    if (screen != null)     parts.add('${_layerEmoji['screen']} $screen');
    if (viewModel != null)  parts.add('${_layerEmoji['viewModel']} $viewModel');
    if (useCase != null)    parts.add('${_layerEmoji['useCase']} $useCase');
    if (repository != null) parts.add('${_layerEmoji['repository']} $repository');
    if (className != null)  parts.add('${_layerEmoji['className']} $className');
    if (parts.isEmpty) return 'App';
    return parts.join(' → ');
  }

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

    final (levelChar, emoji) = _levelConfig[level]!;
    final caller = _formatCaller(screen: screen, viewModel: viewModel, useCase: useCase, repository: repository, className: className);
    final safeMessage = kReleaseMode ? _maskSensitive(message) : message;
    final tag = '$_kLogTag';

    final isImportant = level.index >= LogLevel.warn.index;

    if (isImportant) {
      debugPrint('$tag $_topBorder');
    }

    debugPrint('$tag │ $emoji $levelChar  $caller');
    debugPrint('$tag │    $safeMessage');

    if (error != null) {
      debugPrint('$tag $_midBorder');
      debugPrint('$tag │ 🔴 ERROR: $error');
    }

    if (stack != null) {
      debugPrint('$tag $_midBorder');
      final lines = stack.toString().split('\n').take(8);
      for (final line in lines) {
        if (line.trim().isNotEmpty) {
          debugPrint('$tag │    $line');
        }
      }
    }

    if (isImportant) {
      debugPrint('$tag $_botBorder');
    }
  }

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
