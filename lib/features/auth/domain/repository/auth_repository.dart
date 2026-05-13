// ═══════════════════════════════════════════════════════════════════
// FILE:     auth_repository.dart
// LAYER:    domain (Clean Architecture — the innermost layer)
// PURPOSE:  Interface that defines WHAT auth operations are available,
//           without specifying HOW they're done.
//
// PLAIN ENGLISH:
//   This is a "menu" of auth operations: login, get saved session, clear.
//   The domain layer says "I need these capabilities" but doesn't care
//   if the data comes from a REST API, GraphQL, or a local mock.
//
// ANDROID EQUIVALENT:
//   Like a Kotlin interface in the domain layer:
//     interface AuthRepository {
//       suspend fun login(loginId: String, password: String): Resource<UserModel>
//       suspend fun getSavedSession(): UserModel?
//       suspend fun clearSession()
//     }
//
// WHY AN INTERFACE IN THE DOMAIN LAYER?
//   This is the "Dependency Inversion Principle" (the D in SOLID):
//   - The domain layer DEFINES the interface (what it needs)
//   - The data layer IMPLEMENTS the interface (how it works)
//   - The domain layer NEVER imports anything from the data layer
//   - This means you can swap the entire backend without touching
//     domain or presentation code.
//
// ALTERNATIVE APPROACHES:
//   - Put the implementation directly here (simpler but tightly coupled)
//   - Use abstract class with some default methods (if some logic is shared)
//   - We keep it pure interface for maximum flexibility and testability.
//
// WHO CREATES ME:
//   Nobody — AuthRepositoryImpl implements this.
//
// WHO USES ME:
//   LoginUseCase and GetSavedSessionUseCase call these methods.
// ═══════════════════════════════════════════════════════════════════

import 'package:sensei/core/result/resource.dart';
import 'package:sensei/features/auth/domain/model/user_model.dart';

abstract class AuthRepository {
  // 'Resource<UserModel>' = a sealed class that can be:
  //   - ResourceLoading (still working...)
  //   - ResourceSuccess(data: UserModel) (login succeeded!)
  //   - ResourceError(error: DomainError) (something went wrong)
  //
  // This pattern avoids throwing exceptions. The caller just switches
  // on the result type. In Kotlin you'd use a sealed class or Result<T>.
  //
  // WHY Resource instead of throwing exceptions?
  //   - Exceptions are invisible in the function signature → easy to forget
  //   - Resource forces the caller to handle ALL cases (compiler checks)
  //   - No try/catch spaghetti in ViewModels
  Future<Resource<UserModel>> login(String loginId, String password);

  // Returns the saved user session, or null if no session exists.
  // Called on app start to check if user is already logged in.
  Future<UserModel?> getSavedSession();

  // Deletes tokens and session data (called on logout).
  Future<void> clearSession();
}
