import 'package:dartz/dartz.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/features/friendship/domain/entities/friendship_entity.dart';

abstract class FriendshipRepository {
  /// Send a friend request to another user
  Future<Either<Failure, FriendshipResponseEntity>> sendRequest({
    required String toUserId,
  });

  /// Accept a friend request
  Future<Either<Failure, FriendshipResponseEntity>> acceptRequest({
    required String requestId,
  });

  /// Reject a friend request
  Future<Either<Failure, FriendshipResponseEntity>> rejectRequest({
    required String requestId,
  });

  /// Get pending friend requests (received)
  Future<Either<Failure, List<FriendRequestEntity>>> getPendingRequests();

  /// Get sent friend requests
  Future<Either<Failure, List<FriendRequestEntity>>> getSentRequests();

  /// Get friends list for current user
  Future<Either<Failure, List<FriendEntity>>> getFriends();

  /// Get friends list for a specific user
  Future<Either<Failure, List<FriendEntity>>> getUserFriends({
    required String userId,
  });

  /// Check if two users are friends
  Future<Either<Failure, FriendshipStatusEntity>> isFriend({
    required String userAId,
    required String userBId,
  });

  /// Get friend IDs
  Future<Either<Failure, List<String>>> getFriendIds();
}
