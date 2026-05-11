// ═══════════════════════════════════════════════════════════════════
// FILE:     users_dao.dart
// LAYER:    data/local (Data Access Object)
// PURPOSE:  Provides type-safe queries for the users_table in SQLite.
//
// PLAIN ENGLISH:
//   A DAO (Data Access Object) is the "doorman" for the database table.
//   Instead of writing raw SQL strings (error-prone), we write Dart
//   methods that Drift converts to SQL for us. Each method is one
//   database operation: "get all users", "insert users", "delete all".
//
// WHO CREATES ME:
//   The AppDatabase class includes this DAO; Riverpod provides access.
//
// WHO USES ME:
//   UsersRepositoryImpl calls my methods to read/write cached users.
//
// WHAT I TALK TO:
//   Drift's generated query engine (via the database connection).
// ═══════════════════════════════════════════════════════════════════

import 'package:sensei/features/users/data/local/database/app_database.dart';

/// Data Access Object for the [UsersTable].
///
/// PLAIN ENGLISH: the class that talks to the "users" table in SQLite.
/// Think of it as a waiter at a restaurant — you tell it what you want,
/// it goes to the kitchen (database) and brings it back.
///
/// Called by: UsersRepositoryImpl.
/// Calls: Drift's query engine (generated SQL).
class UsersDao {
  UsersDao(this._db);

  final AppDatabase _db;

  /// Fetches all cached users from the local database.
  ///
  /// Returns a [Future] that completes with all rows in the users table.
  Future<List<UsersTableData>> getAllUsers() {
    return _db.select(_db.usersTable).get();
  }

  /// Watches all cached users — emits a new list whenever the table changes.
  ///
  /// Returns a [Stream] that emits the full user list every time an
  /// insert, update, or delete occurs on the table.
  Stream<List<UsersTableData>> watchAllUsers() {
    return _db.select(_db.usersTable).watch();
  }

  /// Fetches a single cached user by [id].
  ///
  /// Returns null if the user isn't in the cache.
  Future<UsersTableData?> getUserById(int id) {
    return (_db.select(_db.usersTable)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  /// Inserts or replaces a list of users into the cache.
  ///
  /// PLAIN ENGLISH: saves users to the local database. If a user with
  /// the same ID already exists, it gets replaced with the new data.
  ///
  /// [users] — the list of companion objects to insert.
  Future<void> insertUsers(List<UsersTableCompanion> users) async {
    await _db.batch((batch) {
      batch.insertAllOnConflictUpdate(_db.usersTable, users);
    });
  }

  /// Deletes all users from the cache.
  Future<void> deleteAllUsers() {
    return _db.delete(_db.usersTable).go();
  }
}
