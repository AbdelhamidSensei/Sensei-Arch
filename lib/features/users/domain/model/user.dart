// ═════════════���════════════════════════════════════��════════════════
// FILE:     user.dart
// LAYER:    domain (the pure business model)
// PURPOSE:  The domain model representing a User in OUR app's world.
//
// PLAIN ENGLISH:
//   This is what a "User" means to our app — not what the server
//   sends us (that's the DTO), not what the database stores (that's
//   the Entity). This model has only the fields the UI actually needs.
//   It's immutable (can't change after creation) which prevents bugs.
//
// WHO CREATES ME:
//   Mappers convert DTOs/Entities → this model.
//
// WHO USES ME:
//   UseCases return me; ViewModels display me; UI renders me.
//
// WHAT I TALK TO:
//   Nothing — I'm a pure data class with no dependencies.
//
// FULL DATA FLOW THROUGH ME:
//   Server JSON → DTO → Mapper → [ME: User] → ViewModel → Screen
// ═════════════════════════════════════���═════════════════════════════

import 'package:freezed_annotation/freezed_annotation.dart';

// These 'part' directives tell the build_runner code generator where to
// put the generated code. You'll see .freezed.dart and .g.dart files
// appear after running `dart run build_runner build`.
part 'user.freezed.dart';

// '@freezed' generates immutable data class boilerplate: ==, hashCode,
// copyWith, toString, fromJson. It's like Kotlin's data class on steroids.

/// A domain model representing a user in the application.
///
/// PLAIN ENGLISH: the app's idea of what a "user" is. Only contains
/// fields the UI cares about — nothing server-specific or DB-specific.
///
/// Called by: UseCases return lists of these; Screens display them.
/// Calls: nothing — pure data.
@freezed
class User with _$User {
  /// Creates an immutable [User] instance.
  ///
  /// [id] — unique identifier from the backend.
  /// [name] — display name.
  /// [email] — email address.
  /// [phone] — phone number (may be formatted differently per region).
  const factory User({
    required int id,
    required String name,
    required String email,
    required String phone,
  }) = _User;
}
