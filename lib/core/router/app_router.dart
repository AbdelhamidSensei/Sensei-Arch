import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metrogo/l10n/app_localizations.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/map/presentation/pages/map_page.dart';
import '../../features/trip_planner/presentation/pages/trip_planner_page.dart';
import '../../features/trip_planner/presentation/pages/trip_result_page.dart';
import '../../features/trip_planner/domain/entities/trip_plan.dart';
import '../../features/stations/presentation/pages/stations_list_page.dart';
import '../../features/stations/presentation/pages/station_details_page.dart';
import '../../features/favorites/presentation/pages/favorites_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/onboarding/presentation/providers/onboarding_provider.dart';
import 'routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const _SplashRedirect(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => _HomeShell(child: child),
        routes: [
          GoRoute(
            path: '/map',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: MapPage()),
          ),
          GoRoute(
            path: '/plan',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: TripPlannerPage()),
          ),
          GoRoute(
            path: '/stations',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: StationsListPage()),
          ),
          GoRoute(
            path: '/favorites',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: FavoritesPage()),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: SettingsPage()),
          ),
        ],
      ),
      GoRoute(
        path: '/station/:id',
        builder: (context, state) => StationDetailsPage(
          stationId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.tripResult,
        builder: (context, state) => TripResultPage(
          tripPlan: state.extra as TripPlan,
        ),
      ),
    ],
  );
});

class _SplashRedirect extends ConsumerWidget {
  const _SplashRedirect();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboarding = ref.watch(onboardingCompletedProvider);
    return onboarding.when(
      data: (completed) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (completed) {
            context.go('/map');
          } else {
            context.go(AppRoutes.onboarding);
          }
        });
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go(AppRoutes.onboarding);
        });
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class _HomeShell extends StatefulWidget {
  final Widget child;
  const _HomeShell({required this.child});

  @override
  State<_HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<_HomeShell> {
  int _currentIndex = 0;

  static const _tabs = ['/map', '/plan', '/stations', '/favorites', '/settings'];

  @override
  Widget build(BuildContext context) {
    // Sync index with current route
    final location = GoRouterState.of(context).uri.toString();
    for (int i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i])) {
        _currentIndex = i;
        break;
      }
    }

    final l10n = AppL10n.of(context);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index != _currentIndex) {
            setState(() => _currentIndex = index);
            context.go(_tabs[index]);
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.map),
            label: l10n.tabMap,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.route),
            label: l10n.tabPlan,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.train),
            label: l10n.tabStations,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: l10n.tabFavorites,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: l10n.tabSettings,
          ),
        ],
      ),
    );
  }
}
