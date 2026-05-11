import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/enhance/presentation/pages/editor_page.dart';
import '../../features/enhance/presentation/pages/processing_page.dart';
import '../../features/enhance/presentation/pages/result_page.dart';
import '../../features/history/presentation/pages/history_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/paywall/presentation/pages/paywall_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../theme/app_colors.dart';
import 'routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.splash,
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const _SplashRedirect(),
      ),
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: Routes.editor,
        builder: (_, state) =>
            EditorPage(imagePath: state.extra! as String),
      ),
      GoRoute(
        path: Routes.processing,
        builder: (_, state) =>
            ProcessingPage(jobInput: state.extra! as Map<String, dynamic>),
      ),
      GoRoute(
        path: Routes.result,
        builder: (_, state) =>
            ResultPage(args: state.extra! as Map<String, String>),
      ),
      GoRoute(
        path: Routes.history,
        builder: (context, state) => const HistoryPage(),
      ),
      GoRoute(
        path: Routes.settings,
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: Routes.paywall,
        builder: (context, state) => const PaywallPage(),
      ),
    ],
  );
});

class _SplashRedirect extends StatefulWidget {
  const _SplashRedirect();

  @override
  State<_SplashRedirect> createState() => _SplashRedirectState();
}

class _SplashRedirectState extends State<_SplashRedirect> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    final prefs = await SharedPreferences.getInstance();
    final onboarded = prefs.getBool('onboarded_v1') ?? false;
    if (!mounted) return;
    if (onboarded) {
      context.go(Routes.home);
    } else {
      context.go(Routes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: AppColors.brandGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.auto_awesome,
                  size: 40, color: Colors.white),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
