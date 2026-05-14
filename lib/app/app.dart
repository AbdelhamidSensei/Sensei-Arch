// ═══════════════════════════════════════════════════════════════════
// FILE:     app.dart
// LAYER:    app (root widget)
// PURPOSE:  The root MaterialApp that sets up theme, navigation, and
//           top-level app configuration.
//
// PLAIN ENGLISH:
//   Every Flutter app needs a root widget. This is ours. It:
//   1. Sets up the Material Design theme (colors, fonts, button styles)
//   2. Connects GoRouter for screen navigation
//   3. Configures app-wide settings (no debug banner, app title)
//
// ANDROID EQUIVALENT:
//   Like your Application's theme in styles.xml + Activity's setContentView:
//     <style name="AppTheme" parent="Theme.MaterialComponents.NoActionBar">
//       <item name="colorPrimary">#B20018</item>
//     </style>
//   Plus the NavHostFragment setup for Jetpack Navigation.
//
// WHY ConsumerWidget (not StatelessWidget)?
//   ConsumerWidget gives us access to Riverpod's 'ref' parameter.
//   We need it to read the routerProvider (our GoRouter instance).
//   If we didn't need any providers, StatelessWidget would work fine.
//
// WHY useMaterial3: false?
//   The original Android app was built with Material 2 design.
//   Material 3 changes colors, shapes, and spacing significantly.
//   We use Material 2 to match the original app's look and feel.
//
// WHO CREATES ME:
//   main.dart passes me to runApp().
//
// WHO USES ME:
//   Flutter's engine renders this as the topmost widget.
// ═══════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sensei/app/router.dart';

class SenseiApp extends ConsumerWidget {
  const SenseiApp({super.key});

  // The primary brand color (IDH/Al Mokhtabar red)
  static const Color _primaryColor = Color(0xFFB20018);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read the GoRouter instance from our provider
    final router = ref.watch(routerProvider);

    // MaterialApp.router = a Material Design app with declarative routing.
    // '.router' variant uses GoRouter for navigation (instead of named routes).
    return MaterialApp.router(
      title: 'LinkageApp',
      debugShowCheckedModeBanner: false, // Hide the "DEBUG" banner

      // ── Theme configuration ──
      themeMode: ThemeMode.system,

      // Light theme
      theme: ThemeData(
        primaryColor: _primaryColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primaryColor,
          primary: _primaryColor,
        ),
        useMaterial3: false,
        appBarTheme: const AppBarTheme(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 4,
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
            foregroundColor: Colors.white,
          ),
        ),
      ),

      // Dark theme
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: _primaryColor,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primaryColor,
          brightness: Brightness.dark,
          primary: _primaryColor,
        ),
        useMaterial3: false,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A0A0A),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 4,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF0A0A0A),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
            foregroundColor: Colors.white,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF0A0A0A),
          selectedItemColor: _primaryColor,
          unselectedItemColor: Colors.grey,
        ),
      ),

      routerConfig: router,
    );
  }
}
