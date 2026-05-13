// ═══════════════════════════════════════════════════════════════════
// FILE:     login_response_dto.dart
// LAYER:    data/remote/dto (Data Transfer Object)
// PURPOSE:  Exactly mirrors the JSON structure returned by the login API.
//
// PLAIN ENGLISH:
//   A DTO is a "dumb container" that matches the API response field-by-field.
//   Every field is nullable because the server might not send it.
//   We NEVER use DTOs in the UI or business logic — we convert them
//   to domain models (UserModel) via a mapper first.
//
// ANDROID EQUIVALENT:
//   Like a Kotlin data class used with Gson/Moshi:
//     data class LoginResponseDto(
//       val token: String?,
//       val id: String?,        // ← API sends id as STRING, not Int!
//       val name: String?,
//       val email: String?,
//       val code: String?,
//       val companiesBranches: List<CompanyBranchesDto> = emptyList()
//     )
//
// IMPORTANT — WHY ALL FIELDS ARE NULLABLE:
//   The server might return different shapes depending on success/failure:
//   Success: { "token": "...", "id": "1008299", "name": "Essam", ... }
//   Failure: { "statusCode": 0, "msg": "Invalid credentials" }
//   By making everything nullable, JSON parsing NEVER crashes.
//   The mapper handles null → default value conversion.
//
// IMPORTANT — id IS A STRING:
//   The API returns "id": "1008299" (a string), not "id": 1008299 (an int).
//   This is common with older .NET APIs. The DTO matches the API exactly.
//   The mapper converts it: int.tryParse("1008299") → 1008299.
//
// IMPORTANT — FLAT RESPONSE (no wrapper):
//   Some APIs wrap responses: { "data": {...}, "status": 1, "message": "ok" }
//   This API returns data FLAT at the root level: { "token": "...", "id": "..." }
//   We discovered this by comparing Postman output with our DTO structure.
//   Always check the REAL API response, not just documentation!
//
// WHO CREATES ME:
//   AuthApi.login() calls LoginResponseDto.fromJson(response.data).
//
// WHO USES ME:
//   AuthRepositoryImpl receives me and converts me to UserModel via mapper.
// ═══════════════════════════════════════════════════════════════════

import 'package:freezed_annotation/freezed_annotation.dart';

// These 'part' directives link to auto-generated files.
// .freezed.dart = immutability, copyWith, ==, toString
// .g.dart = fromJson/toJson serialization
// Run `dart run build_runner build` to generate/update them.
part 'login_response_dto.freezed.dart';
part 'login_response_dto.g.dart';

@freezed
class LoginResponseDto with _$LoginResponseDto {
  const factory LoginResponseDto({
    // ── Success fields (present when login succeeds) ──
    String? token,          // JWT token for authenticating future API calls
    String? id,             // User ID — STRING from API, converted to int in mapper
    String? name,           // User's display name
    String? email,          // User's email (often null for this API)
    String? code,           // User's login code (same as LoginID)
    @Default([]) List<CompanyBranchesDto> companiesBranches, // Branch list

    // ── Error fields (present when login fails) ──
    int? statusCode,        // Server's custom status code (not HTTP status)
    String? msg,            // Error message from server
  }) = _LoginResponseDto;

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDtoFromJson(json);
}

// Represents one company with its list of branches.
// Example: companyID=10 (Al Mokhtabar) with 200+ branches across Egypt.
@freezed
class CompanyBranchesDto with _$CompanyBranchesDto {
  const factory CompanyBranchesDto({
    int? companyID,
    @Default([]) List<BranchItemDto> branchesList,
  }) = _CompanyBranchesDto;

  factory CompanyBranchesDto.fromJson(Map<String, dynamic> json) =>
      _$CompanyBranchesDtoFromJson(json);
}

// A single branch — id + name.
// The user picks one branch after login to specify where they're working.
@freezed
class BranchItemDto with _$BranchItemDto {
  const factory BranchItemDto({
    int? id,
    String? name,
  }) = _BranchItemDto;

  factory BranchItemDto.fromJson(Map<String, dynamic> json) =>
      _$BranchItemDtoFromJson(json);
}
