// ═══════════════════════════════════════════════════════════════════
// FILE:     app_logger.dart
// LAYER:    core/logger
// PURPOSE:  Defines the contract (interface) for all logging in the app.
//
// PLAIN ENGLISH:
//   This is a promise: "any logger in this app will have these methods."
//   We program against this interface so we can swap implementations
//   (e.g., a fake logger in tests that records messages instead of printing).
//
//   The logger shows WHO is logging by accepting optional named params:
//   screen, viewModel, useCase, repository, className — just like the
//   Android/Kotlin Logger you're used to. This makes filtering and
//   tracing trivial: search "UsersListScreen" or "GetUsersUseCase"
//   in the console to see only that component's logs.
//
// WHO CREATES ME:
//   Nobody creates an abstract class directly — only its implementations.
//
// WHO USES ME:
//   Every class in the app that needs to log receives an AppLogger.
//
// WHAT I TALK TO:
//   Nothing — I'm a contract, not an implementation.
// ═══════════════════════════════════════════════════════════════════

/// The logging contract for the entire application.
///
/// PLAIN ENGLISH: a set of methods every logger must provide. Each method
/// accepts optional caller context (screen, viewModel, useCase, etc.)
/// so the log output shows exactly WHERE the message comes from.
///
/// Example output:
/// ```
/// D/SenseiLogger: [UsersListScreen][UsersListViewModel]: Loading users...
/// I/SenseiLogger: [GetUsersUseCase]: Invoked
/// D/SenseiLogger: [UsersRepositoryImpl]: Fetching from network
/// ```
///
/// Called by: every layer (ViewModels, UseCases, Repositories, Screens).
/// Calls: nothing — implementations decide where log lines go.
abstract class AppLogger {
  /// Log at verbose level — extremely detailed, debug-session only.
  ///
  /// [screen] — the Screen/Widget name (e.g., 'UsersListScreen').
  /// [viewModel] — the ViewModel name (e.g., 'UsersListViewModel').
  /// [useCase] — the UseCase name (e.g., 'GetUsersUseCase').
  /// [repository] — the Repository name (e.g., 'UsersRepositoryImpl').
  /// [className] — any other class name (interceptor, DAO, etc.).
  /// [message] — what happened.
  /// [error] — optional error object.
  /// [stack] — optional stack trace.
  void v(
    String message, {
    String? screen,
    String? viewModel,
    String? useCase,
    String? repository,
    String? className,
    Object? error,
    StackTrace? stack,
  });

  /// Log at debug level — useful during development.
  void d(
    String message, {
    String? screen,
    String? viewModel,
    String? useCase,
    String? repository,
    String? className,
    Object? error,
    StackTrace? stack,
  });

  /// Log at info level — general operational events.
  void i(
    String message, {
    String? screen,
    String? viewModel,
    String? useCase,
    String? repository,
    String? className,
    Object? error,
    StackTrace? stack,
  });

  /// Log at warning level — unexpected but recoverable.
  void w(
    String message, {
    String? screen,
    String? viewModel,
    String? useCase,
    String? repository,
    String? className,
    Object? error,
    StackTrace? stack,
  });

  /// Log at error level — a real failure the user might notice.
  void e(
    String message, {
    String? screen,
    String? viewModel,
    String? useCase,
    String? repository,
    String? className,
    Object? error,
    StackTrace? stack,
  });

  /// Log at "What a Terrible Failure" level — should never happen.
  void wtf(
    String message, {
    String? screen,
    String? viewModel,
    String? useCase,
    String? repository,
    String? className,
    Object? error,
    StackTrace? stack,
  });

  /// Log a long message that might exceed console limits (like logcat's 4k).
  /// Splits into chunks with a correlation ID so you can piece them together.
  void longD(
    String message, {
    String? screen,
    String? viewModel,
    String? useCase,
    String? repository,
    String? className,
    int chunkSize = 3500,
  });
}
