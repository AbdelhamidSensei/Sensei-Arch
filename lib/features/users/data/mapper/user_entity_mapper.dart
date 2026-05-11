// ═══════════════════════════════════════════════════════════════════
// FILE:     user_entity_mapper.dart
// LAYER:    data/mapper
// PURPOSE:  Converts between Drift database entities and domain models.
//
// PLAIN ENGLISH:
//   The database stores users in rows with specific column types.
//   This mapper translates between those database rows and our clean
//   domain User model. It goes both ways: domain → DB (for saving)
//   and DB → domain (for reading cache).
//
// I CONVERT: UsersTableData ↔ User
//
// WHO CREATES ME:
//   Nobody — extension methods are available via import.
//
// WHO USES ME:
//   UsersRepositoryImpl uses this when caching and reading from DB.
//
// WHAT I TALK TO:
//   User (domain model), UsersTableData (Drift-generated row class).
// ═══════════════════════════════════════════════════════════════════

import 'package:drift/drift.dart';

import 'package:sensei/features/users/data/local/database/app_database.dart';
import 'package:sensei/features/users/domain/model/user.dart';

// ┌─ WHY MAPPERS EXIST ──────────────────────────────────────────
// │ We map DTO → Domain → Entity because each layer has different
// │ needs:
// │  - DTO matches the SERVER's JSON (can change without warning).
// │  - Domain model matches OUR APP's needs (stable contract).
// │  - Entity matches the DATABASE schema (may have extra columns).
// │ Mappers are the "translators" that keep these worlds separate.
// │ Change the server? Fix the DTO + mapper. App logic untouched.
// └──────────────────────────────────────────────────────────────

/// Extension that converts a Drift database row into a domain [User].
///
/// Called by: UsersRepositoryImpl when reading cached data.
/// Calls: creates [User] instances.
extension UserEntityMapper on UsersTableData {
  /// Converts a database row into a domain [User].
  User toDomain() {
    return User(
      id: id,
      name: name,
      email: email,
      phone: phone,
    );
  }
}

/// Extension for bulk conversion of database rows to domain models.
extension UserEntityListMapper on List<UsersTableData> {
  /// Converts a list of database rows into domain [User] models.
  List<User> toDomain() {
    return map((entity) => entity.toDomain()).toList();
  }
}

/// Extension that converts a domain [User] into a Drift companion
/// for inserting/updating in the database.
///
/// Called by: UsersRepositoryImpl when saving fetched data to cache.
extension UserToEntityMapper on User {
  /// Creates a Drift [UsersTableCompanion] for database insertion.
  ///
  /// PLAIN ENGLISH: packages the domain model into the shape the
  /// database expects for an INSERT or UPDATE operation.
  UsersTableCompanion toEntity() {
    return UsersTableCompanion(
      id: Value(id),
      name: Value(name),
      email: Value(email),
      phone: Value(phone),
    );
  }
}
