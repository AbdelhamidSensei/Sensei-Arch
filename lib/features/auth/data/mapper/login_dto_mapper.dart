// ═══════════════════════════════════════════════════════════════════
// FILE:     login_dto_mapper.dart
// LAYER:    data/mapper
// PURPOSE:  Converts the raw API DTO into a clean domain model.
//
// PLAIN ENGLISH:
//   The API gives us messy data (nullable fields, id as String, etc.).
//   This mapper converts it into a clean UserModel where:
//   - null → empty string or 0
//   - String id → int id
//   - Nested DTOs → clean domain objects
//
//   It's like a translator between "server language" and "app language".
//
// ANDROID EQUIVALENT:
//   Like a Kotlin extension function:
//     fun LoginResponseDto.toDomain(): UserModel {
//       return UserModel(
//         token = this.token ?: "",
//         id = this.id?.toIntOrNull() ?: 0,
//         ...
//       )
//     }
//
// WHY A SEPARATE MAPPER (not convert inside the model)?
//   - Domain model stays pure (no knowledge of DTOs)
//   - Easy to test: give it a DTO, check the output
//   - If the API changes, only the mapper changes
//   - The model's fromJson is for LOCAL serialization (session store),
//     NOT for API responses. They might have different formats.
//
// ALTERNATIVE APPROACHES:
//   - Put conversion logic inside the DTO class (couples DTO to domain)
//   - Put conversion inside the repository (gets messy with big responses)
//   - Use AutoMapper-style libraries (they exist but not common in Dart)
//   - Extension method on DTO is the standard Dart/Flutter approach.
//
// WHO CREATES ME:
//   Nobody "creates" an extension — it attaches methods to an existing class.
//
// WHO USES ME:
//   AuthRepositoryImpl calls `response.toDomain()` after API success.
// ═══════════════════════════════════════════════════════════════════

import 'package:sensei/features/auth/data/remote/dto/login_response_dto.dart';
import 'package:sensei/features/auth/domain/model/user_model.dart';

// 'extension' = adds methods to an existing class without modifying it.
// Like Kotlin extension functions: fun LoginResponseDto.toDomain(): UserModel
//
// After this extension, any LoginResponseDto object has a .toDomain() method.
// This is Dart's way of keeping the DTO class clean while adding conversion logic.
extension LoginResponseDtoMapper on LoginResponseDto {
  /// Converts this API DTO into a clean domain [UserModel].
  ///
  /// Handles:
  /// - null token → empty string
  /// - String id → int (via int.tryParse, defaults to 0 if not a number)
  /// - null fields → empty strings
  /// - Nested DTO lists → domain model lists
  UserModel toDomain() {
    return UserModel(
      token: token ?? '',
      // 'int.tryParse' = safe parsing. Returns null if the string isn't a number.
      // Like Kotlin's "1008299".toIntOrNull() ?: 0
      // We need this because the API returns id as "1008299" (string), not 1008299 (int).
      id: int.tryParse(id ?? '') ?? 0,
      email: email ?? '',
      name: name ?? '',
      code: code ?? '',
      // '.map()' = transforms each item in the list (like Kotlin's .map { })
      // '.toList()' = converts the lazy Iterable back to a List
      companiesBranches: companiesBranches
          .map((cb) => CompanyBranches(
                companyID: cb.companyID ?? 0,
                branchesList: cb.branchesList
                    .map((b) => BranchItem(
                          id: b.id ?? 0,
                          name: b.name ?? '',
                        ))
                    .toList(),
              ))
          .toList(),
    );
  }
}
