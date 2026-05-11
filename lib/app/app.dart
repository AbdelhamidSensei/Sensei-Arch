// ═══════════════════════════════════════════════════════════════════
// FILE:     app.dart
// LAYER:    app (root widget)
// PURPOSE:  The root MaterialApp widget that configures theme, router,
//           and top-level app settings.
//
// PLAIN ENGLISH:
//   Every Flutter app needs a root widget. This file creates a
//   MaterialApp.router which:
//   1. Sets up Material Design (themes, colors, text styles).
//   2. Connects GoRouter for navigation.
//   3. Is wrapped in a ConsumerWidget so it can read providers.
//
// WHO CREATES ME:
//   main.dart passes me to runApp() wrapped in a ProviderScope.
//
// WHO USES ME:
//   Flutter's engine renders this as the topmost widget.
//
// WHAT I TALK TO:
//   GoRouter (via routerProvider) for navigation configuration.
// ═══════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sensei/app/router.dart';

/// The root widget of the Sensei application.
///
/// PLAIN ENGLISH: the "frame" that holds everything — sets up colors,
/// fonts, and the navigation system. Every screen in the app lives
/// inside this widget.
///
/// Called by: main.dart's runApp().
/// Calls: GoRouter (provides the router delegate and parser).
class SenseiApp extends ConsumerWidget {
  const SenseiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Sensei',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
