// ═══════════════════════════════════════════════════════════════════
// FILE:     sign_in_screen.dart
// LAYER:    presentation
// PURPOSE:  A simple sign-in screen with email/password fields.
//           For demo purposes, any input "signs in" by saving a fake token.
//
// PLAIN ENGLISH:
//   This is the login page. In a real app you'd call an auth API.
//   For this demo/template, pressing "Sign In" saves a fake token
//   and navigates to Home. This demonstrates the auth flow pattern:
//   enter credentials → call API → save token → navigate.
//
// WHO CREATES ME:
//   GoRouter (route '/sign-in').
//
// WHO USES ME:
//   User lands here from Splash if not authenticated.
//
// WHAT I TALK TO:
//   SecureTokenStore (to save token), GoRouter (to navigate), AppLogger.
// ═══════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sensei/core/di/core_providers.dart';

/// Sign-in screen with email and password fields.
///
/// PLAIN ENGLISH: the login page. For demo purposes, any input works.
/// In production, you'd validate fields and call a real auth API.
///
/// Called by: GoRouter (route '/sign-in').
/// Calls: SecureTokenStore, GoRouter, AppLogger.
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSignInPressed() async {
    final logger = ref.read(appLoggerProvider);
    final tokenStore = ref.read(secureTokenStoreProvider);

    logger.d('Sign in button pressed', screen: 'SignInScreen');

    setState(() => _isLoading = true);

    // Simulate network delay (in real app, call auth API here).
    await Future<void>.delayed(const Duration(seconds: 1));

    // Save a fake token (in real app, save the token from API response).
    await tokenStore.saveAccessToken('demo_token_${DateTime.now().millisecondsSinceEpoch}');

    logger.i('Sign in successful, navigating to Home', screen: 'SignInScreen');

    if (!mounted) return;

    // Navigate to home and clear the back stack (can't go back to sign-in).
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Icon(
                    Icons.track_changes,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome to Sensei',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to continue',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 48),

                  // Email field
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password field
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Sign In button
                  FilledButton(
                    onPressed: _isLoading ? null : _onSignInPressed,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Sign In'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
