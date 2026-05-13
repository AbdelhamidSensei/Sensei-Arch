import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sensei/features/auth/di/auth_providers.dart';
import 'package:sensei/features/branch_selection/di/branch_selection_providers.dart';

class HomeShell extends ConsumerWidget {
  const HomeShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocation =
        GoRouterState.of(context).uri.toString();
    final selectedIndex = currentLocation.contains('/home/closed') ? 1 : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('LinkageApp'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authRepositoryProvider).clearSession();
              await ref.read(branchRepositoryProvider).clearBranch();
              ref.read(currentUserProvider.notifier).state = null;
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: const Color(0xFFB20018),
        onTap: (index) {
          if (index == 0) {
            context.go('/home/open');
          } else {
            context.go('/home/closed');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox),
            label: 'Open',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Closed',
          ),
        ],
      ),
    );
  }
}
