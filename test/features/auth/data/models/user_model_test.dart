import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:social_app/features/auth/data/models/user_model.dart';
import 'package:social_app/features/auth/domain/entities/user.dart';
import 'package:social_app/features/auth/domain/mappers/user_mapper.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tUserModel = UserModel(
    id: 'user123',
    username: 'testuser',
    email: 'test@example.com',
    avatarUrl: 'https://example.com/avatar.jpg',
    bio: 'This is a test bio',
    friends: const ['user456', 'user789'],
    following: const ['user456', 'user789', 'user101'],
    followers: const ['user111', 'user222'],
    isActive: true,
    createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
    updatedAt: DateTime.parse('2024-01-02T00:00:00.000Z'),
  );

  group('UserModel', () {
    test('should be a subclass of Equatable', () {
      expect(tUserModel, isA<UserModel>());
    });

    test('should support value equality', () {
      final tUserModel2 = UserModel(
        id: 'user123',
        username: 'testuser',
        email: 'test@example.com',
        avatarUrl: 'https://example.com/avatar.jpg',
        bio: 'This is a test bio',
        friends: const ['user456', 'user789'],
        following: const ['user456', 'user789', 'user101'],
        followers: const ['user111', 'user222'],
        isActive: true,
        createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2024-01-02T00:00:00.000Z'),
      );

      expect(tUserModel, equals(tUserModel2));
    });

    group('fromJson', () {
      test('should return a valid model from JSON', () {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(
          fixture('auth/user.json'),
        );

        // act
        final result = UserModel.fromJson(jsonMap);

        // assert
        expect(result, tUserModel);
      });

      test('should handle nullable fields and defaults', () {
        // arrange
        final Map<String, dynamic> jsonMap = {
          '_id': 'user123',
          'username': 'testuser',
          'email': 'test@example.com',
          'createdAt': '2024-01-01T00:00:00.000Z',
          'updatedAt': '2024-01-02T00:00:00.000Z',
        };

        // act
        final result = UserModel.fromJson(jsonMap);

        // assert
        expect(result.id, 'user123');
        expect(result.avatarUrl, null);
        expect(result.bio, null);
        expect(result.friends, isEmpty);
        expect(result.following, isEmpty);
        expect(result.followers, isEmpty);
        expect(result.isActive, false);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        // act
        final result = tUserModel.toJson();

        // assert
        final expectedMap = {
          '_id': 'user123',
          'username': 'testuser',
          'email': 'test@example.com',
          'avatarUrl': 'https://example.com/avatar.jpg',
          'bio': 'This is a test bio',
          'friends': ['user456', 'user789'],
          'following': ['user456', 'user789', 'user101'],
          'followers': ['user111', 'user222'],
          'isActive': true,
          'createdAt': '2024-01-01T00:00:00.000Z',
          'updatedAt': '2024-01-02T00:00:00.000Z',
        };
        expect(result, expectedMap);
      });
    });

    group('copyWith', () {
      test('should return new instance with updated values', () {
        // act
        final result = tUserModel.copyWith(bio: 'Updated bio', isActive: false);

        // assert
        expect(result.id, tUserModel.id);
        expect(result.username, tUserModel.username);
        expect(result.bio, 'Updated bio');
        expect(result.isActive, false);
      });
    });
  });

  group('UserMapper', () {
    test('should convert UserModel to User entity', () {
      // act
      final result = UserMapper.fromModel(tUserModel);

      // assert
      expect(result, isA<User>());
      expect(result.id, tUserModel.id);
      expect(result.email, tUserModel.email);
      expect(result.username, tUserModel.username);
    });

    test('should convert User entity to UserModel', () {
      // arrange
      final tUser = User(
        id: 'user123',
        username: 'testuser',
        email: 'test@example.com',
        createdAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2024-01-01T00:00:00.000Z'),
      );

      // act
      final result = UserMapper.toModel(tUser);

      // assert
      expect(result, isA<UserModel>());
      expect(result.id, tUser.id);
      expect(result.email, tUser.email);
    });
  });
}
