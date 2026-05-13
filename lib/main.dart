// ═══════════════════════════════════════════════════════════════════
// FILE:     main.dart
// LAYER:    app (entry point — the very first code that runs)
// PURPOSE:  Initializes Flutter, pre-loads dependencies, launches the app.
//
// PLAIN ENGLISH:
//   This is line one of the app. Like Kotlin's fun main() or
//   Android's Application.onCreate(). Three things happen here:
//   1. Ensure Flutter engine is ready (needed before using plugins)
//   2. Pre-load SharedPreferences (async, must complete before app starts)
//   3. Start the app with Riverpod's dependency injection container
//
// ANDROID EQUIVALENT:
//   Like your Application class:
//     class MyApp : Application() {
//       override fun onCreate() {
//         super.onCreate()
//         Hilt.init(this)
//         val prefs = SharedPreferences.getInstance(this)
//         // start activity...
//       }
//     }
//
// WHY PRE-LOAD SharedPreferences?
//   SharedPreferences.getInstance() is async (reads from disk).
//   If we don't await it here, the first provider that uses it would
//   crash because the instance isn't ready yet. By loading it in main(),
//   we guarantee it's available before any widget builds.
//
// WHY ProviderScope WITH overrides?
//   sharedPreferencesProvider is defined with "throw UnimplementedError()"
//   because it can't be created synchronously. We override it here with
//   the actual instance we pre-loaded. This pattern is common in Riverpod
//   for async initialization.
// ═══════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sensei/app/app.dart';
import 'package:sensei/core/di/core_providers.dart';

// 'void main()' = the entry point. Dart VM calls this when the app launches.
// 'async' = this function contains await calls (asynchronous operations).
void main() async {
  // Must be called before any Flutter API (plugins, prefs, etc.).
  // Like calling super.onCreate() in Android — sets up the engine.
  WidgetsFlutterBinding.ensureInitialized();

  // Set the status bar color to dark red (matches the app theme).
  // 'SystemChrome' = Flutter's API for controlling system UI (status bar, nav bar).
  // Like Window.statusBarColor in Android.
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xFF8E0000),
  ));

  // Pre-load SharedPreferences (reads from disk, returns a Future).
  // 'await' = pause here until it completes (like Kotlin's runBlocking).
  final prefs = await SharedPreferences.getInstance();

  // 'runApp' tells Flutter "render this widget tree on screen".
  // Like setContentView() in Android Activity.
  //
  // 'ProviderScope' = Riverpod's dependency injection container.
  // Like Hilt's HiltAndroidApp — must wrap the entire app.
  // Without it, ref.watch() and ref.read() would crash.
  //
  // 'overrides' = replace a provider's default implementation.
  // sharedPreferencesProvider normally throws (can't create sync),
  // so we override it with the pre-loaded instance.
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const SenseiApp(),
    ),
  );
}
