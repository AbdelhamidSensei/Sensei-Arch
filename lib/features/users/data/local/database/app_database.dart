// ═══════════════════════════════════════════════════════════════════
// FILE:     app_database.dart
// LAYER:    data/local (Drift database definition)
// PURPOSE:  The root database class that ties together all tables and DAOs.
//
// PLAIN ENGLISH:
//   This is the "main control panel" for the local SQLite database.
//   It lists every table and DAO the database contains. Drift reads
//   this class during code generation and creates all the SQL setup,
//   migration, and query code we need.
//
// WHO CREATES ME:
//   Riverpod provider `appDatabaseProvider` in users_providers.dart.
//
// WHO USES ME:
//   DAOs are accessed through this database instance.
//
// WHAT I TALK TO:
//   SQLite (via sqlite3_flutter_libs), Drift's generated code.
// ═══════════════════════════════════════════════════════════════════

import 'package:drift/drift.dart';

import 'package:sensei/features/users/data/local/entity/users_table.dart';

// This 'part' tells build_runner where to put the generated database code.
part 'app_database.g.dart';

/// The application's SQLite database powered by Drift.
///
/// PLAIN ENGLISH: the single local database instance. It knows about
/// all tables and provides access to DAOs. The schema version lets
/// Drift handle migrations when you add/change tables in the future.
///
/// Called by: Riverpod creates one instance at app startup.
/// Calls: SQLite engine (via generated code).
@DriftDatabase(tables: [UsersTable])
class AppDatabase extends _$AppDatabase {
  /// Creates the database with the given [QueryExecutor].
  ///
  /// The executor determines where the database file lives on disk.
  AppDatabase(super.e);

  /// The schema version. Increment this when you change table definitions
  /// and add a migration strategy in [migration].
  @override
  int get schemaVersion => 1;
}
