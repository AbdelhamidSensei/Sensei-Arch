// ═══════════════════════════════════════════════════════════════════
// FILE:     user_list_item.dart
// LAYER:    presentation (reusable widget)
// PURPOSE:  A single row/card in the users list representing one user.
//
// PLAIN ENGLISH:
//   This widget draws one user's info as a Material card with their
//   name, email, and phone. Tapping it triggers the `onTapped` callback
//   which the parent screen uses to navigate to the detail view.
//
// WHO CREATES ME:
//   UsersListScreen creates one of me for each user in the list.
//
// WHO USES ME:
//   Only UsersListScreen (it's a presentation-layer widget).
//
// WHAT I TALK TO:
//   Nothing — it's a pure display widget. Gets data in, draws pixels out.
// ═══════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';

import 'package:sensei/features/users/domain/model/user.dart';

/// A card widget representing a single user in the list.
///
/// PLAIN ENGLISH: one row in the users list. Shows name, email, phone.
/// Tapping it fires [onTapped] which the parent handles (navigate).
///
/// Called by: UsersListScreen's ListView.builder.
/// Calls: nothing — only renders.
class UserListItem extends StatelessWidget {
  const UserListItem({
    super.key,
    required this.user,
    required this.onTapped,
  });

  /// The user data to display.
  final User user;

  /// Callback fired when this item is tapped.
  // Callbacks start with 'on': onRetryPressed, onUserTapped.
  final VoidCallback onTapped;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
          ),
        ),
        title: Text(user.name),
        subtitle: Text(user.email),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTapped,
      ),
    );
  }
}
