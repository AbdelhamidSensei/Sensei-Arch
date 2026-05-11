// ═══════════════════════════════════════════════════════════════════
// FILE:     users_repository_impl_test.dart
// LAYER:    test (unit test for UsersRepositoryImpl)
// PURPOSE:  Verifies the repository coordinates API and DAO correctly,
//           emitting cache-first then network data.
//
// PLAIN ENGLISH:
//   We fake both the API (network) and DAO (database) to test the
//   repository's orchestration logic: does it emit loading, then
//   cache, then fresh data? Does it handle errors correctly?
// ═══════════════════════════════════════════════════════════════════

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sensei/core/logger/app_logger.dart';
import 'package:sensei/core/result/resource.dart';
import 'package:sensei/features/users/data/local/dao/users_dao.dart';
import 'package:sensei/features/users/data/local/database/app_database.dart';
import 'package:sensei/features/users/data/remote/api/users_api.dart';
import 'package:sensei/features/users/data/remote/dto/user_dto.dart';
import 'package:sensei/features/users/data/repository/users_repository_impl.dart';
import 'package:sensei/features/users/domain/model/user.dart';

class MockUsersApi extends Mock implements UsersApi {}

class MockUsersDao extends Mock implements UsersDao {}

class MockAppLogger extends Mock implements AppLogger {}

void main() {
  late UsersRepositoryImpl repository;
  late MockUsersApi mockApi;
  late MockUsersDao mockDao;
  late MockAppLogger mockLogger;

  final testDtos = [
    const UserDto(id: 1, name: 'Alice', email: 'a@b.com', phone: '111'),
    const UserDto(id: 2, name: 'Bob', email: 'b@c.com', phone: '222'),
  ];

  setUp(() {
    mockApi = MockUsersApi();
    mockDao = MockUsersDao();
    mockLogger = MockAppLogger();
    repository = UsersRepositoryImpl(
      api: mockApi,
      dao: mockDao,
      logger: mockLogger,
    );
  });

  group('UsersRepositoryImpl.getUsers', () {
    test('emits loading → success when API succeeds and cache is empty', () async {
      // Arrange: empty cache, successful API.
      when(() => mockDao.getAllUsers()).thenAnswer((_) async => []);
      when(() => mockApi.getUsers()).thenAnswer((_) async => testDtos);
      when(() => mockDao.insertUsers(any())).thenAnswer((_) async {});

      // Act & Assert
      final emissions = await repository.getUsers().toList();

      expect(emissions[0], isA<ResourceLoading<List<User>>>());
      // Since cache is empty, next should be success from network.
      expect(emissions[1], isA<ResourceSuccess<List<User>>>());

      final successData = (emissions[1] as ResourceSuccess<List<User>>).data;
      expect(successData, hasLength(2));
      expect(successData[0].name, equals('Alice'));
    });

    test('emits loading → cache → network when cache has data', () async {
      // Arrange: cache has data, API also succeeds.
      final cachedData = [
        UsersTableData(id: 1, name: 'CachedAlice', email: 'a@b.com', phone: '111'),
      ];
      when(() => mockDao.getAllUsers()).thenAnswer((_) async => cachedData);
      when(() => mockApi.getUsers()).thenAnswer((_) async => testDtos);
      when(() => mockDao.insertUsers(any())).thenAnswer((_) async {});

      // Act
      final emissions = await repository.getUsers().toList();

      // Assert: loading → cache success → network success
      expect(emissions[0], isA<ResourceLoading<List<User>>>());
      expect(emissions[1], isA<ResourceSuccess<List<User>>>());
      expect(
        (emissions[1] as ResourceSuccess<List<User>>).data[0].name,
        equals('CachedAlice'),
      );
      expect(emissions[2], isA<ResourceSuccess<List<User>>>());
      expect(
        (emissions[2] as ResourceSuccess<List<User>>).data[0].name,
        equals('Alice'),
      );
    });
  });
}
