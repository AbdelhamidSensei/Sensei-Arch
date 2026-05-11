// ═══════════════════════════════════════════════════════════════════
// FILE:     users_list_view_model_test.dart
// LAYER:    test (unit test for UsersListViewModel)
// PURPOSE:  Verifies that the ViewModel correctly maps Resource emissions
//           to UiState transitions.
//
// PLAIN ENGLISH:
//   We create a fake UseCase that emits a known sequence (loading → success).
//   Then we verify the ViewModel's state transitions match what we expect:
//   isLoading=true → isLoading=false + users populated.
// ═══════════════════════════════════════════════════════════════════

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sensei/core/domain/domain_error.dart';
import 'package:sensei/core/logger/app_logger.dart';
import 'package:sensei/core/result/resource.dart';
import 'package:sensei/features/users/domain/model/user.dart';
import 'package:sensei/features/users/domain/usecase/get_users_use_case.dart';
import 'package:sensei/features/users/presentation/list/users_list_view_model.dart';

class MockGetUsersUseCase extends Mock implements GetUsersUseCase {}

class MockAppLogger extends Mock implements AppLogger {}

void main() {
  late UsersListViewModel viewModel;
  late MockGetUsersUseCase mockUseCase;
  late MockAppLogger mockLogger;

  final testUsers = [
    const User(id: 1, name: 'Alice', email: 'a@b.com', phone: '111'),
    const User(id: 2, name: 'Bob', email: 'b@c.com', phone: '222'),
  ];

  setUp(() {
    mockUseCase = MockGetUsersUseCase();
    mockLogger = MockAppLogger();
  });

  tearDown(() {
    viewModel.dispose();
  });

  test('initial state is loading, then updates to success with users', () async {
    // Arrange: UseCase emits loading → success.
    when(() => mockUseCase.call()).thenAnswer(
      (_) => Stream.fromIterable([
        Resource.loading(),
        Resource.success(testUsers),
      ]),
    );

    // Act: create the ViewModel (it auto-loads in constructor).
    viewModel = UsersListViewModel(
      getUsersUseCase: mockUseCase,
      logger: mockLogger,
    );

    // Give the stream time to emit all values.
    await Future<void>.delayed(const Duration(milliseconds: 50));

    // Assert: final state should have users and not be loading.
    expect(viewModel.state.isLoading, isFalse);
    expect(viewModel.state.users, equals(testUsers));
    expect(viewModel.state.errorMessage, isNull);
  });

  test('emits error state when UseCase emits error', () async {
    when(() => mockUseCase.call()).thenAnswer(
      (_) => Stream.fromIterable([
        Resource.loading(),
        Resource.error(const NetworkError()),
      ]),
    );

    viewModel = UsersListViewModel(
      getUsersUseCase: mockUseCase,
      logger: mockLogger,
    );

    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(viewModel.state.isLoading, isFalse);
    expect(viewModel.state.errorMessage, isNotNull);
    expect(viewModel.state.users, isEmpty);
  });

  test('refresh() re-invokes the UseCase', () async {
    var callCount = 0;
    when(() => mockUseCase.call()).thenAnswer((_) {
      callCount++;
      return Stream.fromIterable([Resource.success(testUsers)]);
    });

    viewModel = UsersListViewModel(
      getUsersUseCase: mockUseCase,
      logger: mockLogger,
    );

    await Future<void>.delayed(const Duration(milliseconds: 50));
    viewModel.refresh();
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(callCount, equals(2));
  });
}
