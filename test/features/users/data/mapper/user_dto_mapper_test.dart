// ═══════════════════════════════════════════════════════════════════
// FILE:     user_dto_mapper_test.dart
// LAYER:    test (unit test for the DTO → domain mapper)
// PURPOSE:  Verifies that UserDto maps correctly to the User domain model.
//
// PLAIN ENGLISH:
//   This test creates fake UserDto objects (as if they came from the API)
//   and checks that .toDomain() produces the correct User objects.
//   If someone accidentally changes the mapper, these tests catch it.
// ═══════════════════════════════════════════════════════════════════

import 'package:flutter_test/flutter_test.dart';
import 'package:sensei/features/users/data/mapper/user_dto_mapper.dart';
import 'package:sensei/features/users/data/remote/dto/user_dto.dart';
import 'package:sensei/features/users/domain/model/user.dart';

void main() {
  group('UserDtoMapper', () {
    test('toDomain() converts a single UserDto to User correctly', () {
      // Arrange: create a DTO as if parsed from JSON.
      const dto = UserDto(
        id: 1,
        name: 'Leanne Graham',
        email: 'Sincere@april.biz',
        phone: '1-770-736-8031 x56442',
      );

      // Act: convert to domain model.
      final user = dto.toDomain();

      // Assert: all fields transferred correctly.
      expect(user, isA<User>());
      expect(user.id, equals(1));
      expect(user.name, equals('Leanne Graham'));
      expect(user.email, equals('Sincere@april.biz'));
      expect(user.phone, equals('1-770-736-8031 x56442'));
    });

    test('List<UserDto>.toDomain() converts a list of DTOs', () {
      // Arrange
      const dtos = [
        UserDto(id: 1, name: 'Alice', email: 'a@b.com', phone: '111'),
        UserDto(id: 2, name: 'Bob', email: 'b@c.com', phone: '222'),
      ];

      // Act
      final users = dtos.toDomain();

      // Assert
      expect(users, hasLength(2));
      expect(users[0].name, equals('Alice'));
      expect(users[1].name, equals('Bob'));
    });

    test('toDomain() handles empty strings gracefully', () {
      const dto = UserDto(id: 99, name: '', email: '', phone: '');
      final user = dto.toDomain();

      expect(user.id, equals(99));
      expect(user.name, isEmpty);
      expect(user.email, isEmpty);
      expect(user.phone, isEmpty);
    });
  });
}
