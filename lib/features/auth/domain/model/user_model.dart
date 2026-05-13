// ═══════════════════════════════════════════════════════════════════
// FILE:     user_model.dart
// LAYER:    domain (the heart of Clean Architecture)
// PURPOSE:  Defines the UserModel — the app's internal representation
//           of a logged-in user. This is what the UI and business logic
//           work with. It's INDEPENDENT of the API response format.
//
// PLAIN ENGLISH:
//   When the user logs in, the server sends back a JSON blob with
//   token, id, name, branches, etc. We DON'T pass that raw JSON
//   around the app. Instead, we convert it into this clean model.
//   If the API changes its field names tomorrow, only the mapper
//   changes — the rest of the app stays the same.
//
// ANDROID EQUIVALENT:
//   Like a Kotlin data class:
//     data class UserModel(
//       val token: String,
//       val id: Int,
//       val email: String,
//       val name: String,
//       val code: String,
//       val companiesBranches: List<CompanyBranches> = emptyList()
//     )
//
// WHY @freezed?
//   @freezed generates:
//   1. Immutability — all fields are final, can't be changed after creation.
//      (Like Kotlin data class with val, not var)
//   2. copyWith() — creates a new object with some fields changed.
//      (Like Kotlin's .copy() method)
//   3. == and hashCode — two UserModels with same data are equal.
//   4. toString() — prints all fields for debugging.
//   5. fromJson/toJson — JSON serialization (via json_serializable).
//
// ALTERNATIVE APPROACHES:
//   - Write all this by hand (boring, error-prone, 100+ lines)
//   - Use json_serializable alone (no copyWith, no immutability guarantee)
//   - Use built_value (older, more verbose)
//   - @freezed is the standard in Flutter — most projects use it.
//
// IMPORTANT — Domain models vs DTOs:
//   - DTO (Data Transfer Object) = matches the API response exactly.
//     Lives in data/remote/dto/. Has nullable fields (API might omit them).
//   - Domain Model = what the app actually needs. Lives in domain/model/.
//     Has required fields with sensible defaults. Clean, validated.
//   - A MAPPER converts DTO → Domain Model (null → default, String → int, etc.)
//
// WHO CREATES ME:
//   The login mapper (LoginResponseDtoMapper) converts the API DTO into me.
//
// WHO USES ME:
//   LoginViewModel (to check login success), BranchSelectionViewModel
//   (to get the list of branches), HomeShell (for logout).
// ═══════════════════════════════════════════════════════════════════

// 'import' brings in code from other packages.
// freezed_annotation provides the @freezed, @Default, etc. annotations.
import 'package:freezed_annotation/freezed_annotation.dart';

// 'part' = tells Dart that another file is an extension of THIS file.
// The .freezed.dart file contains the generated immutable class code.
// The .g.dart file contains the generated fromJson/toJson code.
// These are created by running: dart run build_runner build
// You NEVER edit .freezed.dart or .g.dart files — they're auto-generated.
part 'user_model.freezed.dart';
part 'user_model.g.dart';

// '@freezed' = a code generation annotation. When you run build_runner,
// it reads this annotation and generates the _$UserModel class with
// copyWith, ==, hashCode, toString, fromJson, toJson.
@freezed
class UserModel with _$UserModel {
  // 'const factory' = a constructor that creates an immutable object.
  // 'factory' = Dart's way of saying "this constructor might return
  //   a different type" (here it returns _UserModel, the generated class).
  // 'const' = the object CAN be created at compile time if all args are const.
  //
  // 'required' = must be provided when creating a UserModel.
  // '@Default([])' = if not provided, defaults to empty list.
  //
  // In Kotlin this would be:
  //   data class UserModel(
  //     val token: String,          // required
  //     val id: Int,                // required
  //     val email: String,          // required
  //     val name: String,           // required
  //     val code: String,           // required
  //     val companiesBranches: List<CompanyBranches> = emptyList()  // optional with default
  //   )
  const factory UserModel({
    required String token,
    required int id,
    required String email,
    required String name,
    required String code,
    @Default([]) List<CompanyBranches> companiesBranches,
  }) = _UserModel;

  // 'factory UserModel.fromJson(...)' = creates a UserModel from a JSON Map.
  // The actual implementation is in user_model.g.dart (generated).
  // This is needed to restore the session from secure storage
  // (we save it as JSON, then parse it back into a UserModel).
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

// A company that has multiple branches (e.g., Al Mokhtabar company with
// branches in Cairo, Alex, etc.)
@freezed
class CompanyBranches with _$CompanyBranches {
  const factory CompanyBranches({
    required int companyID,
    @Default([]) List<BranchItem> branchesList,
  }) = _CompanyBranches;

  factory CompanyBranches.fromJson(Map<String, dynamic> json) =>
      _$CompanyBranchesFromJson(json);
}

// A single branch (e.g., "Nasr City 1" with id 263).
// The driver selects one branch after login to work with.
@freezed
class BranchItem with _$BranchItem {
  const factory BranchItem({
    required int id,
    required String name,
  }) = _BranchItem;

  factory BranchItem.fromJson(Map<String, dynamic> json) =>
      _$BranchItemFromJson(json);
}
