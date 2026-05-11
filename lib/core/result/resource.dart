// ═══════════════════════════════════════════════════════════════════
// FILE:     resource.dart
// LAYER:    core/result
// PURPOSE:  A sealed class representing the three states any async
//           operation can be in: Loading, Success, or Error.
//
// PLAIN ENGLISH:
//   When you fetch data, three things can happen: you're still waiting
//   (Loading), you got the data (Success), or something went wrong
//   (Error). Instead of juggling separate booleans (isLoading, hasError),
//   we use ONE object that can only be in ONE state at a time.
//   The compiler then forces us to handle every case — no forgotten states.
//
// WHO CREATES ME:
//   Repository implementations emit Resource values in their Streams.
//
// WHO USES ME:
//   UseCases pass me through; ViewModels switch on me to update UiState.
//
// WHAT I TALK TO:
//   DomainError (the error payload inside Resource.error).
// ═══════════════════════════════════════════════════════════════════

import 'package:sensei/core/domain/domain_error.dart';

// ┌─ WHY RESOURCE EXISTS (the pattern) ──────────────────────────
// │ Modeling loading/success/error as a sealed class gives us:
// │  1. Compile-time exhaustiveness — forget a case? Compiler warns.
// │  2. Single source of truth — no conflicting booleans.
// │  3. Immutability — safer in async/concurrent code.
// │ It's the Dart equivalent of Kotlin's sealed class Resource<T>.
// └──────────────────────────────────────────────────────────────

// 'sealed' = a closed family of subtypes. The compiler checks our switch
// covers all cases — no defaults needed.

/// Represents the state of an asynchronous data operation.
///
/// PLAIN ENGLISH: one object that tells you "still loading", "here's
/// your data", or "something broke — here's why". ViewModels switch
/// on this to decide what the screen should show.
///
/// Called by: Repositories emit these via Streams.
/// Calls: nothing — it's a data container.
sealed class Resource<T> {
  // 'const' constructor allows subclasses to also be const.
  const Resource();

  /// The operation is in progress. Optionally carries stale [data]
  /// (e.g., cached results shown while refreshing).
  // 'factory' constructor can return any subtype or a cached instance,
  // unlike normal constructors that always return 'this' class.
  factory Resource.loading({T? data}) = ResourceLoading<T>;

  /// The operation completed successfully with [data].
  factory Resource.success(T data) = ResourceSuccess<T>;

  /// The operation failed with a [DomainError].
  factory Resource.error(DomainError error, {T? data}) = ResourceError<T>;
}

/// Loading state — optionally carries stale data for optimistic UI.
class ResourceLoading<T> extends Resource<T> {
  const ResourceLoading({this.data});

  /// Stale data from cache, shown while fresh data loads.
  // 'final' = can't reassign after first set.
  final T? data;
}

/// Success state — always carries the requested data.
class ResourceSuccess<T> extends Resource<T> {
  const ResourceSuccess(this.data);

  /// The successfully fetched/computed data.
  final T data;
}

/// Error state — carries the domain error and optionally stale data.
class ResourceError<T> extends Resource<T> {
  const ResourceError(this.error, {this.data});

  /// What went wrong, expressed in domain terms (not HTTP codes).
  final DomainError error;

  /// Stale data that may still be useful to display.
  final T? data;
}
