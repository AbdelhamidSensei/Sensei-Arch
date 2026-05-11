// ═══════════════════════════════════════════════════════════════════
// FILE:     users_table.dart
// LAYER:    data/local (Drift database table definition)
// PURPOSE:  Defines the schema of the "users" table in the local SQLite DB.
//
// PLAIN ENGLISH:
//   Drift is an ORM (Object-Relational Mapper) for SQLite. Instead of
//   writing raw SQL, we define tables as Dart classes. Drift generates
//   the SQL and type-safe query methods for us. This file says "the
//   users table has columns: id (int), name (text), email (text), phone (text)."
//
// WHO CREATES ME:
//   Drift's code generator reads this and creates UsersTableData (the row
//   class) and UsersTableCompanion (for inserts).
//
// WHO USES ME:
//   UsersDao queries this table. The database includes this table.
//
// WHAT I TALK TO:
//   Nothing — it's a schema definition read by the generator.
// ═══════════════════════════════════════════════════════════════════

import 'package:drift/drift.dart';

/// Drift table definition for caching users locally.
///
/// PLAIN ENGLISH: tells Drift "create a SQLite table called 'users_table'
/// with these columns." Drift handles the CREATE TABLE SQL for us.
///
/// Called by: Drift code generator; UsersDao queries this.
/// Calls: nothing.
class UsersTable extends Table {
  /// Primary key — the user's unique ID from the backend.
  IntColumn get id => integer()();

  /// The user's display name.
  TextColumn get name => text()();

  /// The user's email address.
  TextColumn get email => text()();

  /// The user's phone number.
  TextColumn get phone => text()();

  // Tell Drift which column(s) form the primary key.
  @override
  Set<Column> get primaryKey => {id};
}
