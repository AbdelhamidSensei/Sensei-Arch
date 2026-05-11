// ═══════════════════════════════════════════════════════════════════
// FILE:     home_screen.dart
// LAYER:    presentation
// PURPOSE:  The main home screen after authentication — simple text + counter.
//
// PLAIN ENGLISH:
//   This is the "logged in" landing page. Shows "Home" text in the center
//   and a counter (to demonstrate state). Also has a logout button that
//   clears the token and returns to sign-in. Use this as a template
//   for your real home screen.
//
// WHO CREATES ME:
//   GoRouter (route '/home').
//
// WHO USES ME:
//   User sees this after signing in successfully.
//
// WHAT I TALK TO:
//   SecureTokenStore (for logout), GoRouter (navigation), AppLogger.
// ═══════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sensei/core/di/core_providers.dart';

/// The main home screen — simple text + counter demo.
///
/// PLAIN ENGLISH: the landing page after login. Shows "Home" and
/// a counter to demonstrate stateful interaction. The logout button
/// clears the token and navigates back to sign-in.
///
/// Called by: GoRouter (route '/home').
/// Calls: SecureTokenStore (logout), GoRouter, AppLogger.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    final logger = ref.read(appLoggerProvider);
    logger.d('Counter incremented to $_counter', screen: 'HomeScreen');
  }

  Future<void> _onLogoutPressed() async {
    final logger = ref.read(appLoggerProvider);
    final tokenStore = ref.read(secureTokenStoreProvider);

    logger.i('Logout pressed', screen: 'HomeScreen');
    await tokenStore.clear();

    if (!mounted) return;
    context.go('/sign-in');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _onLogoutPressed,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Home',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 32),
            Text(
              'Counter: $_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'You are authenticated!',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
