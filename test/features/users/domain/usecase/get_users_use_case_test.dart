// ═══════════════════════════════════════════════════════════════════
// FILE:     get_users_use_case_test.dart
// LAYER:    test (unit test for GetUsersUseCase)
// PURPOSE:  Verifies that the use case correctly delegates to the
//           repository and passes through the Resource stream.
//
// PLAIN ENGLISH:
//   We create a fake (mock) repository that returns pre-defined data.
//   Then we call the UseCase and verify it returns exactly what the
//   repository emitted — proving the UseCase is wired correctly.
// ═══════════════════════════════════════════════════════════════════

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sensei/core/domain/domain_error.dart';
import 'package:sensei/core/logger/app_logger.dart';
import 'package:sensei/core/result/resource.dart';
import 'package:sensei/features/users/domain/model/user.dart';
import 'package:sensei/features/users/domain/repository/users_repository.dart';
import 'package:sensei/features/users/domain/usecase/get_users_use_case.dart';

// Create mock classes using mocktail.
class MockUsersRepository extends Mock implements UsersRepository {}

class MockAppLogger extends Mock implements AppLogger {}

void main() {
  late GetUsersUseCase useCase;
  late MockUsersRepository mockRepository;
  late MockAppLogger mockLogger;

  setUp(() {
    mockRepository = MockUsersRepository();
    mockLogger = MockAppLogger();
    useCase = GetUsersUseCase(
      repository: mockRepository,
      logger: mockLogger,
    );
  });

  group('GetUsersUseCase', () {
    final testUsers = [
      const User(id: 1, name: 'Alice', email: 'a@b.com', phone: '111'),
      const User(id: 2, name: 'Bob', email: 'b@c.com', phone: '222'),
    ];

    test('emits loading then success when repository succeeds', () {
      // Arrange: mock the repository to emit loading → success.
      when(() => mockRepository.getUsers()).thenAnswer(
        (_) => Stream.fromIterable([
          Resource.loading(),
          Resource.success(testUsers),
        ]),
      );

      // Act & Assert: the UseCase stream matches the repository stream.
      expect(
        useCase.call(),
        emitsInOrder([
          isA<ResourceLoading<List<User>>>(),
          isA<ResourceSuccess<List<User>>>(),
        ]),
      );
    });

    test('emits loading then error when repository fails', () {
      when(() => mockRepository.getUsers()).thenAnswer(
        (_) => Stream.fromIterable([
          Resource.loading(),
          Resource.error(const NetworkError()),
        ]),
      );

      expect(
        useCase.call(),
        emitsInOrder([
          isA<ResourceLoading<List<User>>>(),
          isA<ResourceError<List<User>>>(),
        ]),
      );
    });
  });
}
