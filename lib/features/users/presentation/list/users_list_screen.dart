// ═══════════════════════════════════════════════════════════════════
// FILE:     users_list_screen.dart
// LAYER:    presentation (the "View" in MVVM)
// PURPOSE:  The widget that renders the users list on screen.
//           Contains ZERO business logic — only draws pixels.
//
// PLAIN ENGLISH:
//   This is what the user SEES. It reads the current UiState from
//   the ViewModel and draws either a loading spinner, an error
//   message with a retry button, or the actual list of users.
//   When the user taps a row, it navigates to the detail screen.
//   It NEVER fetches data itself — that's the ViewModel's job.
//
// WHO CREATES ME:
//   GoRouter creates me when the user navigates to the '/users' route.
//
// WHO USES ME:
//   The user! This is the actual visible screen.
//
// WHAT I TALK TO:
//   ⤵ UsersListViewModel (via Riverpod) — to get state and call actions.
//   ⤵ GoRouter (via context) — for navigation.
// ═══════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sensei/features/users/di/users_providers.dart';
import 'package:sensei/features/users/presentation/list/users_list_ui_state.dart';
import 'package:sensei/features/users/presentation/list/widgets/user_list_item.dart';

// 'ConsumerWidget' is a StatelessWidget that also receives a 'ref' so it
// can read providers. The Riverpod way to build reactive widgets.

/// The main users list screen.
///
/// PLAIN ENGLISH: the visual page showing all users. It watches the
/// ViewModel's state and redraws when state changes. No business logic
/// lives here — only layout and navigation.
///
/// Called by: GoRouter (when navigating to '/users').
/// Calls: ViewModel methods (refresh), GoRouter (navigation).
class UsersListScreen extends ConsumerWidget {
  const UsersListScreen({super.key});
  // 'super.key' forwards an optional Key to the parent Widget class.
  // Keys help Flutter tell widgets apart when rebuilding.

  // 'Widget build()' is called by Flutter whenever this widget needs to
  // redraw. Keep it pure: no side effects, no I/O.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 'BuildContext' is a handle to a widget's place in the tree.
    // We use it for navigation, theme, MediaQuery.

    // 'ref.watch' = subscribe to changes. The widget rebuilds when this
    // provider's value changes.
    final uiState = ref.watch(usersListViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        centerTitle: true,
      ),
      body: _buildBody(context, ref, uiState),
    );
  }

  /// Builds the body based on the current [uiState].
  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    UsersListUiState uiState,
  ) {
    // Pattern matching on the state to decide what to show.
    if (uiState.isLoading && uiState.users.isEmpty) {
      return const _LoadingView();
    }

    if (uiState.errorMessage != null && uiState.users.isEmpty) {
      return _ErrorView(
        message: uiState.errorMessage!,
        // '!' = "trust me, this is not null". We checked above.
        onRetryPressed: () {
          // 'ref.read' = read once, do NOT rebuild on changes. Use inside
          // callbacks (button taps), never in build().
          ref.read(usersListViewModelProvider.notifier).refresh();
        },
      );
    }

    return _UsersListView(
      users: uiState,
      onUserTapped: (userId) {
        // Navigate to the detail screen via GoRouter.
        context.go('/users/$userId');
      },
    );
  }
}

/// Loading spinner displayed while fetching data.
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

/// Error view with a message and retry button.
class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.onRetryPressed,
  });

  final String message;
  final VoidCallback onRetryPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetryPressed,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

/// The actual scrollable list of user cards.
class _UsersListView extends StatelessWidget {
  const _UsersListView({
    required this.users,
    required this.onUserTapped,
  });

  final UsersListUiState users;
  final void Function(int userId) onUserTapped;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: users.users.length,
      itemBuilder: (context, index) {
        final user = users.users[index];
        return UserListItem(
          user: user,
          onTapped: () => onUserTapped(user.id),
        );
      },
    );
  }
}
