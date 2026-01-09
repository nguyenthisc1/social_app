import 'package:flutter_test/flutter_test.dart';
import 'package:social_app/features/auth/domain/entities/user.dart';

void main() {
  group('User Entity', () {
    final tUser = User(
      id: 'user123',
      username: 'testuser',
      email: 'test@example.com',
      avatarUrl: 'https://example.com/avatar.jpg',
      bio: 'Test bio',
      friends: const ['user456', 'user789'],
      following: const ['user456', 'user789', 'user101'],
      followers: const ['user111', 'user222'],
      isActive: true,
      createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
      updatedAt: DateTime.parse('2024-01-02T00:00:00.000Z'),
    );

    test('should be a subclass of Equatable', () {
      expect(tUser, isA<User>());
    });

    test('should support value equality', () {
      final tUser2 = User(
        id: 'user123',
        username: 'testuser',
        email: 'test@example.com',
        avatarUrl: 'https://example.com/avatar.jpg',
        bio: 'Test bio',
        friends: const ['user456', 'user789'],
        following: const ['user456', 'user789', 'user101'],
        followers: const ['user111', 'user222'],
        isActive: true,
        createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2024-01-02T00:00:00.000Z'),
      );

      expect(tUser, equals(tUser2));
    });

    test('should have different values when properties differ', () {
      final tUser2 = User(
        id: 'user456',
        email: 'test2@example.com',
        username: 'testuser2',
        createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
      );

      expect(tUser, isNot(equals(tUser2)));
    });

    test('copyWith should return new instance with updated values', () {
      final updatedUser = tUser.copyWith(bio: 'Updated bio', isActive: false);

      expect(updatedUser.id, tUser.id);
      expect(updatedUser.email, tUser.email);
      expect(updatedUser.bio, 'Updated bio');
      expect(updatedUser.isActive, false);
    });

    test(
      'copyWith should keep original values when no parameters provided',
      () {
        final copiedUser = tUser.copyWith();

        expect(copiedUser, equals(tUser));
      },
    );
  });
}
