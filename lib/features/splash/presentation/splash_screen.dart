// ═══════════════════════════════════════════════════════════════════
// FILE:     splash_screen.dart
// LAYER:    presentation
// PURPOSE:  The first screen the user sees — shows app logo/branding
//           briefly, then navigates to auth or home based on login state.
//
// PLAIN ENGLISH:
//   A 2-second splash screen that checks if the user has a saved token.
//   If yes → navigate to Home. If no → navigate to Sign In.
//   This is where you'd do app initialization (load config, check version).
//
// WHO CREATES ME:
//   GoRouter (initial route '/').
//
// WHO USES ME:
//   The user sees this for ~2 seconds on app launch.
//
// WHAT I TALK TO:
//   SecureTokenStore (to check login state), GoRouter (to navigate).
// ═══════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sensei/core/di/core_providers.dart';

/// Splash screen — brief branding + login state check.
///
/// PLAIN ENGLISH: the "loading" screen. Shows the app name while
/// we check if the user is already logged in. Then redirects.
///
/// Called by: GoRouter (route '/').
/// Calls: SecureTokenStore, GoRouter.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  // 'initState' runs once when the widget is first inserted.
  // 'dispose' runs when it's removed — free resources here.
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    // Wait 2 seconds for splash branding.
    await Future<void>.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Check if user has a saved token (is logged in).
    final tokenStore = ref.read(secureTokenStoreProvider);
    final logger = ref.read(appLoggerProvider);
    final token = await tokenStore.getAccessToken();

    if (!mounted) return;

    if (token != null) {
      logger.i('User has token, navigating to Home', screen: 'SplashScreen');
      context.go('/home');
    } else {
      logger.i('No token, navigating to Sign In', screen: 'SplashScreen');
      context.go('/sign-in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App icon/logo placeholder.
            Icon(
              Icons.track_changes,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Sensei',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
