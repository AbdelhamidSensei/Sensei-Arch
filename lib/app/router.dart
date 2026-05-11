// ═══════════════════════════════════════════════════════════════════
// FILE:     router.dart
// LAYER:    app (navigation configuration)
// PURPOSE:  Defines all routes in the app using GoRouter.
//
// PLAIN ENGLISH:
//   The navigation "map" of the app. Defines every screen and its URL path.
//   Flow: Splash ('/') → Sign In ('/sign-in') → Home ('/home')
//   The users feature is accessible from '/users' (for demo/reference).
//
// WHO CREATES ME:
//   The `routerProvider` — accessed by MaterialApp.router in app.dart.
//
// WHO USES ME:
//   MaterialApp.router uses this for all navigation.
//   Screens call `context.go('/path')` to navigate.
//
// WHAT I TALK TO:
//   Screen widgets (as route destinations).
// ═══════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sensei/core/navigation/page_transitions.dart';
import 'package:sensei/features/auth/presentation/sign_in_screen.dart';
import 'package:sensei/features/home/presentation/home_screen.dart';
import 'package:sensei/features/splash/presentation/splash_screen.dart';
import 'package:sensei/features/users/presentation/detail/user_detail_screen.dart';
import 'package:sensei/features/users/presentation/list/users_list_screen.dart';

/// Riverpod provider for the app's [GoRouter] instance.
///
/// PLAIN ENGLISH: the navigation system. Splash checks auth state,
/// then routes to either sign-in or home.
///
/// Each route uses [PageTransitions] for screen-to-screen animations.
/// Replace `pageBuilder` with `builder` to remove the transition,
/// or swap to a different PageTransitions method to change the effect.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    // App starts at the splash screen.
    initialLocation: '/',
    routes: [
      // ─── Splash (no transition — it's the entry point) ──────
      GoRoute(
        path: '/',
        name: 'splash',
        pageBuilder: (context, state) => PageTransitions.none(
          key: state.pageKey,
          child: const SplashScreen(),
        ),
      ),

      // ─── Auth (fade in — feels like a fresh start) ──────────
      GoRoute(
        path: '/sign-in',
        name: 'signIn',
        pageBuilder: (context, state) => PageTransitions.fade(
          key: state.pageKey,
          child: const SignInScreen(),
        ),
      ),

      // ─── Home (fade-through — Material 3 top-level swap) ────
      GoRoute(
        path: '/home',
        name: 'home',
        pageBuilder: (context, state) => PageTransitions.fadeThrough(
          key: state.pageKey,
          child: const HomeScreen(),
        ),
      ),

      // ─── Users (slide — RTL/LTR aware, like fragment transactions) ─
      GoRoute(
        path: '/users',
        name: 'usersList',
        pageBuilder: (context, state) => PageTransitions.slide(
          key: state.pageKey,
          child: const UsersListScreen(),
        ),
        routes: [
          // Detail slides up + fades (modal style)
          GoRoute(
            path: ':id',
            name: 'userDetail',
            pageBuilder: (context, state) {
              final userId = int.parse(state.pathParameters['id']!);
              return PageTransitions.slideUpFade(
                key: state.pageKey,
                child: UserDetailScreen(userId: userId),
              );
            },
          ),
        ],
      ),
    ],
    // Fallback for unknown routes.
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Route not found: ${state.uri}'),
      ),
    ),
  );
});
