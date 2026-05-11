// ═══════════════════════════════════════════════════════════════════
// FILE:     main.dart
// LAYER:    app (entry point)
// PURPOSE:  The very first file Dart executes. Sets up Riverpod and
//           launches the app.
//
// PLAIN ENGLISH:
//   This is line one of your Flutter app. `main()` is like Java/Kotlin's
//   `fun main()`. It wraps the entire widget tree in a `ProviderScope`
//   (which activates Riverpod's dependency injection) and then asks
//   Flutter to render our root widget (SenseiApp).
//
// WHO CREATES ME:
//   Nobody — the Dart VM calls `main()` when the app starts.
//
// WHO USES ME:
//   The Dart runtime, at app launch.
//
// WHAT I TALK TO:
//   Flutter engine (via runApp) and Riverpod (via ProviderScope).
//
// FULL DATA FLOW:
//   OS → Dart VM → main() → ProviderScope → SenseiApp → Router → Screen
// ═══════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sensei/app/app.dart';

/// The application entry point.
///
/// PLAIN ENGLISH: where everything begins. Three lines that boot the app:
/// 1. Ensure Flutter is initialized (needed for plugins).
/// 2. Wrap everything in ProviderScope (enables Riverpod DI).
/// 3. Run the root widget.
void main() {
  // Ensures Flutter's binding is ready before we do anything else.
  // Required if you call any Flutter API before runApp (like loading prefs).
  WidgetsFlutterBinding.ensureInitialized();

  // 'runApp' tells Flutter "here's the root widget — draw it on screen."
  // 'ProviderScope' is Riverpod's container — it stores all provider state.
  // Without it, ref.watch/ref.read would crash because there's no container.
  runApp(
    const ProviderScope(
      child: SenseiApp(),
    ),
  );
}
