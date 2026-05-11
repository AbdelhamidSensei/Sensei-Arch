// ═══════════════════════════════════════════════════════════════════
// FILE:     user_detail_screen.dart
// LAYER:    presentation (View)
// PURPOSE:  Displays detailed information about a single user.
//
// PLAIN ENGLISH:
//   When the user taps a row in the list, they land here. This screen
//   shows the full user info (name, email, phone) in a nice layout.
//   It reads its state from the UserDetailViewModel.
//
// WHO CREATES ME:
//   GoRouter creates me when navigating to '/users/:id'.
//
// WHO USES ME:
//   The user sees this after tapping a list item.
//
// WHAT I TALK TO:
//   UserDetailViewModel (via Riverpod) for state.
// ═══════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sensei/features/users/di/users_providers.dart';
import 'package:sensei/features/users/presentation/detail/user_detail_ui_state.dart';

/// The user detail screen showing full info for one user.
///
/// PLAIN ENGLISH: the "profile page" — shows all available info for
/// the selected user with a nice Material layout.
///
/// Called by: GoRouter (route '/users/:id').
/// Calls: ViewModel via Riverpod.
class UserDetailScreen extends ConsumerWidget {
  const UserDetailScreen({
    super.key,
    required this.userId,
  });

  /// The ID of the user to display.
  final int userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(userDetailViewModelProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: Text(uiState.user?.name ?? 'User Detail'),
      ),
      body: _buildBody(context, uiState),
    );
  }

  Widget _buildBody(BuildContext context, UserDetailUiState uiState) {
    if (uiState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (uiState.errorMessage != null) {
      return Center(
        child: Text(
          uiState.errorMessage!,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    final user = uiState.user;
    if (user == null) {
      return const Center(child: Text('No user data available.'));
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 48,
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                style: const TextStyle(fontSize: 36),
              ),
            ),
          ),
          const SizedBox(height: 32),
          _DetailRow(icon: Icons.person, label: 'Name', value: user.name),
          const SizedBox(height: 16),
          _DetailRow(icon: Icons.email, label: 'Email', value: user.email),
          const SizedBox(height: 16),
          _DetailRow(icon: Icons.phone, label: 'Phone', value: user.phone),
        ],
      ),
    );
  }
}

/// A single row in the detail view showing an icon, label, and value.
class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ],
    );
  }
}
