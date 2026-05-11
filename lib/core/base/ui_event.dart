// ═══════════════════════════════════════════════════════════════════
// FILE:     ui_event.dart
// LAYER:    core/base
// PURPOSE:  Base class for one-shot UI events (Snackbar, navigation, etc.)
//
// PLAIN ENGLISH:
//   Some things should happen ONCE (show a toast, navigate away).
//   If we put them in UiState, they'd re-fire on every rebuild.
//   UiEvents are consumed once by `ref.listen` and then forgotten.
//   Think of them as "fire and forget" notifications from ViewModel to UI.
//
// WHO CREATES ME:
//   ViewModels emit UiEvent subclasses.
//
// WHO USES ME:
//   Screens listen via `ref.listen` and react (show Snackbar, etc.).
// ═══════════════════════════════════════════════════════════════════

/// Base class for one-shot events that the UI should react to once.
///
/// PLAIN ENGLISH: a message from the ViewModel saying "do this thing
/// right now, then forget about it." Unlike state (which persists),
/// events are consumed and gone.
///
/// Called by: ViewModels create specific subclasses.
/// Calls: nothing — it's a data container.
abstract class UiEvent {
  const UiEvent();
}

/// A generic event that carries a user-facing message.
///
/// Useful for showing Snackbars, toasts, or dialogs.
class ShowMessageEvent extends UiEvent {
  const ShowMessageEvent(this.message);

  /// The message to display to the user.
  final String message;
}

/// An event requesting navigation to a specific route.
class NavigateEvent extends UiEvent {
  const NavigateEvent(this.route);

  /// The route path to navigate to (e.g., '/users/42').
  final String route;
}
