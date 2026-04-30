import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/features/auth/data/models/auth_tokens_model.dart';
import 'package:social_app/features/user/data/models/user_model.dart';
import 'package:social_app/features/user/domain/entites/user_entity.dart';

final fakeUserEntity = UserEntity(
  id: 'u1',
  username: 'thinguyen',
  email: 'test@mail.com',
  avatarUrl: null,
  bio: null,
  friends: const [],
  following: const [],
  followers: const [],
  lastSeen: Timestamp.fromMillisecondsSinceEpoch(1710000000000),
  createdAt: Timestamp.fromMillisecondsSinceEpoch(1710000000000),
  isOnline: true,
);

final fakeUserModel = UserModel(
  id: 'u1',
  username: 'thinguyen',
  email: 'test@mail.com',
  avatarUrl: null,
  bio: null,
  friends: const [],
  following: const [],
  followers: const [],
  lastSeen: Timestamp.fromMillisecondsSinceEpoch(1710000000000),
  createdAt: Timestamp.fromMillisecondsSinceEpoch(1710000000000),
  isOnline: true,
);

final fakeAuthTokensModel = AuthTokensModel(
  accessToken: 'access-token',
  refreshToken: 'refresh-token',
  expiresAt: DateTime.now().add(const Duration(hours: 1)),
  tokenType: 'Bearer',
);

final fakeExpiredAuthTokensModel = AuthTokensModel(
  accessToken: 'expired-access-token',
  refreshToken: 'expired-refresh-token',
  expiresAt: DateTime.now().subtract(const Duration(hours: 1)),
  tokenType: 'Bearer',
);

final fakeValidAuthTokensModel = AuthTokensModel(
  accessToken: 'valid-access-token',
  refreshToken: 'valid-refresh-token',
  expiresAt: DateTime.now().add(const Duration(hours: 2)),
  tokenType: 'Bearer',
);

final fakeLoginResponseMap = {
  'user': {
    'id': 'u1',
    'username': 'thinguyen',
    'email': 'test@mail.com',
    'avatarUrl': null,
    'bio': null,
    'friends': <String>[],
    'following': <String>[],
    'followers': <String>[],
    'lastSeen': {'millisecondsSinceEpoch': 1710000000000},
    'createdAt': {'millisecondsSinceEpoch': 1710000000000},
    'isOnline': true,
  },
  'tokens': {
    'access_token': 'access-token',
    'refresh_token': 'refresh-token',
    'expires_at': DateTime.now()
        .add(const Duration(hours: 1))
        .toIso8601String(),
    'token_type': 'Bearer',
  },
};

final fakeRegisterResponseMap = {
  'user': {
    'id': 'u1',
    'username': 'thinguyen',
    'email': 'test@mail.com',
    'avatarUrl': null,
    'bio': null,
    'friends': <String>[],
    'following': <String>[],
    'followers': <String>[],
    'lastSeen': {'millisecondsSinceEpoch': 1710000000000},
    'createdAt': {'millisecondsSinceEpoch': 1710000000000},
    'isOnline': true,
  },
  'tokens': {
    'access_token': 'access-token',
    'refresh_token': 'refresh-token',
    'expires_at': DateTime.now()
        .add(const Duration(hours: 1))
        .toIso8601String(),
    'token_type': 'Bearer',
  },
};
