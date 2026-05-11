// ═══════════════════════════════════════════════════════════════════
// FILE:     base_view_model.dart
// LAYER:    core/base
// PURPOSE:  A base class for all ViewModels providing common utilities
//           like event emission and logging.
//
// PLAIN ENGLISH:
//   Instead of repeating the same boilerplate in every ViewModel
//   (setting up events, getting a logger), we put it here once.
//   Every ViewModel extends this and inherits the helpers.
//
// WHO CREATES ME:
//   Nobody directly — concrete ViewModels extend this.
//
// WHO USES ME:
//   All feature ViewModels (e.g., UsersListViewModel).
//
// WHAT I TALK TO:
//   AppLogger (for state transition logging).
// ═══════════════════════════════════════════════════════════════════

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sensei/core/base/ui_event.dart';
import 'package:sensei/core/logger/app_logger.dart';

// ┌─ WHY ViewModel/StateNotifier EXISTS ─────────────────────────
// │ The Screen (Widget) should only know how to DRAW pixels.
// │ Business logic (fetch data, decide what to show) lives here.
// │ Benefits:
// │  1. Testable without a real screen (no widget test needed).
// │  2. Survives config changes (rotation) if scoped correctly.
// │  3. Single source of truth for the screen's state.
// │ This is the MVVM "ViewModel" — not to be confused with
// │ Android's Jetpack ViewModel (similar idea, different tool).
// └──────────────────────────────────────────────────────────────

// 'StateNotifier<T>' is Riverpod's way of holding mutable state that
// widgets can observe. When you set `state = newValue`, all watchers
// rebuild. It's like Kotlin's StateFlow + ViewModel combined.

/// Base class for all ViewModels in the app.
///
/// PLAIN ENGLISH: provides event emission and logging so you don't
/// have to set them up in every ViewModel.
///
/// [S] is the UiState type this ViewModel manages.
///
/// Called by: concrete ViewModels extend this.
/// Calls: [AppLogger] for state transition logging.
abstract class BaseViewModel<S> extends StateNotifier<S> {
  // 'super(initialState)' passes the initial state up to StateNotifier.
  BaseViewModel(super.initialState, {required this.logger});

  /// Logger available to all ViewModels for state transition logging.
  final AppLogger logger;

  /// Emits a state transition and logs it.
  ///
  /// PLAIN ENGLISH: changes the screen's state and writes a log line
  /// so you can trace what happened in the console.
  ///
  /// [newState] — the new state to emit.
  /// [reason] — a short description of why the state changed.
  void emit(S newState, {String? reason}) {
    final message = reason ?? 'State updated';
    logger.d('$message → ${newState.runtimeType}',
        viewModel: runtimeType.toString());
    state = newState;
  }
}

/// A simple StateNotifier that holds a single [UiEvent] value.
///
/// PLAIN ENGLISH: a mailbox for one-shot events. The ViewModel puts
/// an event in; the Screen picks it up via `ref.listen` and clears it.
///
/// Called by: ViewModels post events; Screens listen.
class UiEventNotifier extends StateNotifier<UiEvent?> {
  UiEventNotifier() : super(null);

  /// Posts a new event for the UI to consume.
  void post(UiEvent event) {
    state = event;
  }

  /// Clears the event after the UI has consumed it.
  void clear() {
    state = null;
  }
}
