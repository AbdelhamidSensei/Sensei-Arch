// ═══════════════════════════════════════════════════════════════════
// FILE:     user_dto_mapper.dart
// LAYER:    data/mapper
// PURPOSE:  Converts UserDto (server shape) → User (domain model).
//
// PLAIN ENGLISH:
//   The server sends us JSON with a certain shape (UserDto). Our app's
//   UI uses a different shape (User — maybe fewer fields, different
//   names, computed values). This mapper is the bridge between them.
//   If the server renames a field, we fix it HERE and nothing else changes.
//
// I CONVERT: UserDto → User
//
// WHO CREATES ME:
//   Nobody — extension methods are available everywhere the import is.
//
// WHO USES ME:
//   UsersRepositoryImpl calls `.toDomain()` on DTOs after fetching.
//
// WHAT I TALK TO:
//   User (domain model) — creates instances of it.
// ═══════════════════════════════════════════════════════════════════

import 'package:sensei/features/users/data/remote/dto/user_dto.dart';
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

// 'extension X on Y' adds methods to Y without modifying Y's source.
// We use it for clean mappers: dto.toDomain().

/// Extension that adds domain conversion to [UserDto].
///
/// PLAIN ENGLISH: attaches a `.toDomain()` method to UserDto so
/// the repository can write `dto.toDomain()` — clean and readable.
///
/// Called by: UsersRepositoryImpl after receiving DTOs from the API.
/// Calls: creates [User] instances.
extension UserDtoMapper on UserDto {
  /// Converts this DTO into a domain [User] model.
  ///
  /// PLAIN ENGLISH: translates "what the server said" into
  /// "what our app understands."
  User toDomain() {
    return User(
      id: id,
      name: name,
      email: email,
      phone: phone,
    );
  }
}

/// Extension that adds bulk domain conversion to lists of [UserDto].
///
/// PLAIN ENGLISH: same as above but for a whole list at once.
extension UserDtoListMapper on List<UserDto> {
  /// Converts a list of DTOs into a list of domain [User] models.
  List<User> toDomain() {
    // '.map' transforms each element; '.toList()' collects results.
    return map((dto) => dto.toDomain()).toList();
  }
}
