// ═══════════════════════════════════════════════════════════════════
// FILE:     login_use_case.dart
// LAYER:    domain (business logic)
// PURPOSE:  A single-purpose class that performs the "login" action.
//
// PLAIN ENGLISH:
//   A UseCase is a class with ONE job. This one's job is: "log the user in."
//   It takes credentials, calls the repository, and returns the result.
//   Right now it's thin (just delegates to repo), but it's the right place
//   to add business rules later, like:
//   - "Don't allow login if already logged in"
//   - "Validate email format before hitting the API"
//   - "Log analytics event on login attempt"
//
// ANDROID EQUIVALENT:
//   Like a Kotlin UseCase class (common in Clean Architecture):
//     class LoginUseCase(
//       private val repository: AuthRepository,
//       private val logger: AppLogger
//     ) {
//       suspend operator fun invoke(loginId: String, password: String): Resource<UserModel> {
//         return repository.login(loginId, password)
//       }
//     }
//
// WHY A SEPARATE CLASS (not just call repo directly from ViewModel)?
//   1. Single Responsibility — each class has ONE reason to change.
//   2. Testability — test business logic without a ViewModel.
//   3. Reusability — if another screen needs login, it reuses this UseCase.
//   4. Layer boundary — ViewModel depends on UseCase (domain layer),
//      NOT on Repository implementation (data layer).
//
// ALTERNATIVE APPROACHES:
//   - Call repository directly from ViewModel (simpler, fine for small apps,
//     but breaks Clean Architecture boundaries)
//   - Use a Service class with multiple methods (groups related operations,
//     but loses single-responsibility)
//   - We use one UseCase per operation — the standard Clean Architecture way.
//
// WHO CREATES ME:
//   Riverpod provider `loginUseCaseProvider` in auth_providers.dart.
//
// WHO USES ME:
//   LoginViewModel calls me when the user taps "Login".
// ═══════════════════════════════════════════════════════════════════

import 'package:sensei/core/logger/app_logger.dart';
import 'package:sensei/core/result/resource.dart';
import 'package:sensei/features/auth/domain/model/user_model.dart';
import 'package:sensei/features/auth/domain/repository/auth_repository.dart';

class LoginUseCase {
  // Constructor injection — dependencies are passed in, not created inside.
  // This is Dependency Injection (DI). In Android you'd use Hilt/Dagger.
  // In Flutter with Riverpod, providers handle the wiring.
  //
  // WHY inject (not create)?
  //   - Testable: pass a FakeAuthRepository in tests
  //   - Flexible: swap implementations without changing this class
  //   - Follows the Dependency Inversion Principle (SOLID)
  LoginUseCase({
    required AuthRepository repository,
    required AppLogger logger,
  })  : _repository = repository,
        _logger = logger;

  // Private fields. The underscore '_' makes them private in Dart.
  // 'final' = assigned once, never reassigned (like Kotlin's 'val').
  final AuthRepository _repository;
  final AppLogger _logger;

  // 'call()' is a special method name in Dart. When a class has a 'call()'
  // method, you can invoke the object like a function:
  //   loginUseCase('42696', 'password')  ← same as loginUseCase.call(...)
  //
  // This is why UseCases in Dart use 'call()' — it reads naturally.
  // In Kotlin, you'd use 'operator fun invoke(...)' for the same effect.
  Future<Resource<UserModel>> call(String loginId, String password) async {
    _logger.d('call() loginId=$loginId', useCase: 'LoginUseCase');
    final result = await _repository.login(loginId, password);
    _logger.d('call() result=${result.runtimeType}', useCase: 'LoginUseCase');
    return result;
  }
}
