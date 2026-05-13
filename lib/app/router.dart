// ═══════════════════════════════════════════════════════════════════
// FILE:     router.dart
// LAYER:    app (navigation)
// PURPOSE:  Defines all routes/screens in the app using GoRouter.
//
// PLAIN ENGLISH:
//   This is the "navigation map" of the app. It defines:
//   - Which URL path maps to which screen
//   - How screens animate when transitioning
//   - Which screens share a bottom navigation bar (ShellRoute)
//   - Which screens are outside the shell (scanner = no bottom nav)
//
// NAVIGATION FLOW:
//   /login → /branch-selection → /home/open (or /home/closed) → /scanner/:id
//
// ANDROID EQUIVALENT:
//   Like Jetpack Navigation's nav_graph.xml:
//     <navigation startDestination="@id/loginFragment">
//       <fragment id="loginFragment" ... />
//       <fragment id="branchSelectionFragment" ... />
//       <navigation id="home_graph">  <!-- nested graph = ShellRoute -->
//         <fragment id="openPackagesFragment" ... />
//         <fragment id="closedPackagesFragment" ... />
//       </navigation>
//       <fragment id="scannerFragment" ... />  <!-- outside nested graph -->
//     </navigation>
//
// KEY CONCEPTS:
//
//   1. GoRoute = a single screen with a URL path.
//      Like a <fragment> destination in nav_graph.xml.
//
//   2. ShellRoute = a wrapper that adds persistent UI (bottom nav bar)
//      around child routes. The children share the same Scaffold.
//      Like a nested navigation graph with a BottomNavigationView.
//
//   3. PageTransitions = custom animations between screens.
//      Like Android's R.anim.slide_in_right / R.anim.fade_in.
//
//   4. context.go('/path') = navigate and REPLACE the stack.
//      context.push('/path') = navigate and ADD to the stack.
//      context.pop() = go back (like pressing the back button).
//
//   5. NavigatorKey = each navigator has its own back stack.
//      _rootNavigatorKey = the app's main navigator.
//      _shellNavigatorKey = the bottom nav's nested navigator.
//      The scanner uses parentNavigatorKey: _rootNavigatorKey to
//      appear OUTSIDE the shell (full screen, no bottom nav).
//
// WHO CREATES ME:
//   The Riverpod `routerProvider` creates the GoRouter instance.
//
// WHO USES ME:
//   MaterialApp.router in app.dart consumes this for all navigation.
// ═══════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sensei/core/navigation/page_transitions.dart';
import 'package:sensei/features/auth/presentation/login/login_screen.dart';
import 'package:sensei/features/branch_selection/presentation/branch_selection_screen.dart';
import 'package:sensei/features/home/presentation/home_shell.dart';
import 'package:sensei/features/packages/presentation/closed/closed_packages_screen.dart';
import 'package:sensei/features/packages/presentation/open/open_packages_screen.dart';
import 'package:sensei/features/packages/presentation/scanner/scanner_screen.dart';

// Navigator keys — like navController IDs in Jetpack Navigation.
// Each key identifies a separate navigation stack.
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login', // App starts at login screen

    routes: [
      // ── Login screen (fade transition — feels like a fresh start) ──
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => PageTransitions.fade(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),

      // ── Branch selection (slide in from right) ──
      GoRoute(
        path: '/branch-selection',
        name: 'branchSelection',
        pageBuilder: (context, state) => PageTransitions.slide(
          key: state.pageKey,
          child: const BranchSelectionScreen(),
        ),
      ),

      // ── Home shell (contains bottom nav with Open and Closed tabs) ──
      // ShellRoute wraps child routes with a shared Scaffold that has
      // a BottomNavigationBar. Children share the same app bar and bottom nav.
      // Like a Fragment with BottomNavigationView + NavHostFragment in Android.
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        // 'builder' wraps each child route with the HomeShell widget.
        // 'child' is the current active route's screen.
        builder: (context, state, child) => HomeShell(child: child),
        routes: [
          // Open packages tab
          GoRoute(
            path: '/home/open',
            name: 'openPackages',
            pageBuilder: (context, state) => PageTransitions.fadeThrough(
              key: state.pageKey,
              child: const OpenPackagesScreen(),
            ),
          ),
          // Closed packages tab
          GoRoute(
            path: '/home/closed',
            name: 'closedPackages',
            pageBuilder: (context, state) => PageTransitions.fadeThrough(
              key: state.pageKey,
              child: const ClosedPackagesScreen(),
            ),
          ),
        ],
      ),

      // ── Scanner screen (slides up like a modal, OUTSIDE the shell) ──
      // parentNavigatorKey: _rootNavigatorKey makes this screen appear
      // at the root level (full screen, no bottom navigation bar).
      // ':packageId' is a path parameter — extracted in the pageBuilder.
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/scanner/:packageId',
        name: 'scanner',
        pageBuilder: (context, state) {
          // Extract the package ID from the URL.
          // state.pathParameters['packageId'] returns a String.
          // int.parse converts it to an int.
          final packageId =
              int.parse(state.pathParameters['packageId']!);
          return PageTransitions.slideUp(
            key: state.pageKey,
            child: ScannerScreen(packageId: packageId),
          );
        },
      ),
    ],

    // Fallback screen for unknown routes (should never happen in production)
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Route not found: ${state.uri}'),
      ),
    ),
  );
});
