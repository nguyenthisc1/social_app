import 'package:social_app/core/core.dart';
import 'package:social_app/features/friendship/data/datasources/friendship_remote_data_source.dart';
import 'package:social_app/features/friendship/domain/entities/friendship_entity.dart';
import 'package:social_app/features/friendship/domain/friendship_exceptions.dart';
import 'package:social_app/features/friendship/domain/mappers/friendship_mapper.dart';
import 'package:social_app/features/friendship/domain/repositories/friendship_repository.dart';

class FriendshipRepositoryImpl implements FriendshipRepository {
  final FriendshipRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  FriendshipRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<FriendshipResponseEntity> sendRequest({
    required String toUserId,
  }) async {
    if (!await networkInfo.isConnected) {
      throw FriendshipRequestException(
        userMessage: 'No internet connection.',
        debugMessage: 'Network offline at sendRequest.',
      );
    }
    try {
      final result = await remoteDataSource.sendRequest(toUserId: toUserId);
      return FriendshipMapper.toResponseEntity(result);
    } catch (e) {
      throw FriendshipRequestException(
        debugMessage: 'Failed to send friend request: $e',
        cause: e,
      );
    }
  }

  @override
  Future<FriendshipResponseEntity> acceptRequest({
    required String requestId,
  }) async {
    if (!await networkInfo.isConnected) {
      throw FriendshipAcceptException(
        userMessage: 'No internet connection.',
        debugMessage: 'Network offline at acceptRequest.',
      );
    }
    try {
      final result = await remoteDataSource.acceptRequest(requestId: requestId);
      return FriendshipMapper.toResponseEntity(result);
    } catch (e) {
      throw FriendshipAcceptException(
        debugMessage: 'Failed to accept friend request: $e',
        cause: e,
      );
    }
  }

  @override
  Future<FriendshipResponseEntity> rejectRequest({
    required String requestId,
  }) async {
    if (!await networkInfo.isConnected) {
      throw FriendshipRejectException(
        userMessage: 'No internet connection.',
        debugMessage: 'Network offline at rejectRequest.',
      );
    }
    try {
      final result = await remoteDataSource.rejectRequest(requestId: requestId);
      return FriendshipMapper.toResponseEntity(result);
    } catch (e) {
      throw FriendshipRejectException(
        debugMessage: 'Failed to reject friend request: $e',
        cause: e,
      );
    }
  }

  @override
  Future<List<FriendRequestEntity>> getPendingRequests() async {
    if (!await networkInfo.isConnected) {
      throw FriendshipLoadException(
        userMessage: 'No internet connection.',
        debugMessage: 'Network offline at getPendingRequests.',
      );
    }
    try {
      final result = await remoteDataSource.getPendingRequests();
      return FriendshipMapper.toRequestEntityList(result);
    } catch (e) {
      throw FriendshipLoadException(
        userMessage: 'Unable to load pending requests.',
        debugMessage: 'Failed to get pending requests: $e',
        cause: e,
      );
    }
  }

  @override
  Future<List<FriendRequestEntity>> getSentRequests() async {
    if (!await networkInfo.isConnected) {
      throw FriendshipLoadException(
        userMessage: 'No internet connection.',
        debugMessage: 'Network offline at getSentRequests.',
      );
    }
    try {
      final result = await remoteDataSource.getSentRequests();
      return FriendshipMapper.toRequestEntityList(result);
    } catch (e) {
      throw FriendshipLoadException(
        userMessage: 'Unable to load sent requests.',
        debugMessage: 'Failed to get sent requests: $e',
        cause: e,
      );
    }
  }

  @override
  Future<List<FriendEntity>> getFriends() async {
    if (!await networkInfo.isConnected) {
      throw FriendshipLoadException(
        userMessage: 'No internet connection.',
        debugMessage: 'Network offline at getFriends.',
      );
    }
    try {
      final result = await remoteDataSource.getFriends();
      return FriendshipMapper.toFriendEntityList(result);
    } catch (e) {
      throw FriendshipLoadException(
        userMessage: 'Unable to load friends.',
        debugMessage: 'Failed to get friends: $e',
        cause: e,
      );
    }
  }

  @override
  Future<List<FriendEntity>> getUserFriends({required String userId}) async {
    if (!await networkInfo.isConnected) {
      throw FriendshipLoadException(
        userMessage: 'No internet connection.',
        debugMessage: 'Network offline at getUserFriends.',
      );
    }
    try {
      final result = await remoteDataSource.getUserFriends(userId: userId);
      return FriendshipMapper.toFriendEntityList(result);
    } catch (e) {
      throw FriendshipLoadException(
        userMessage: 'Unable to load user friends.',
        debugMessage: 'Failed to get user friends for userId=$userId: $e',
        cause: e,
      );
    }
  }

  @override
  Future<FriendshipStatusEntity> isFriend({
    required String userAId,
    required String userBId,
  }) async {
    if (!await networkInfo.isConnected) {
      throw FriendshipStatusException(
        userMessage: 'No internet connection.',
        debugMessage: 'Network offline at isFriend.',
      );
    }
    try {
      final result = await remoteDataSource.isFriend(
        userAId: userAId,
        userBId: userBId,
      );
      return FriendshipMapper.toStatusEntity(result);
    } catch (e) {
      throw FriendshipStatusException(
        debugMessage: 'Failed to check friendship status: $e',
        cause: e,
      );
    }
  }

  @override
  Future<List<String>> getFriendIds() async {
    if (!await networkInfo.isConnected) {
      throw FriendshipLoadException(
        userMessage: 'No internet connection.',
        debugMessage: 'Network offline at getFriendIds.',
      );
    }
    try {
      return await remoteDataSource.getFriendIds();
    } catch (e) {
      throw FriendshipLoadException(
        userMessage: 'Unable to load friend IDs.',
        debugMessage: 'Failed to get friend IDs: $e',
        cause: e,
      );
    }
  }
}
