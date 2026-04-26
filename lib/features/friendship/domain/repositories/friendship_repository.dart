import 'package:dartz/dartz.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/features/friendship/domain/entities/friendship_entity.dart';

abstract class FriendshipRepository {
  /// Send a friend request to another user
  Future<FriendshipResponseEntity> sendRequest({required String toUserId});

  /// Accept a friend request
  Future<FriendshipResponseEntity> acceptRequest({required String requestId});

  /// Reject a friend request
  Future<FriendshipResponseEntity> rejectRequest({required String requestId});

  /// Get pending friend requests (received)
  Future<List<FriendRequestEntity>> getPendingRequests();

  /// Get sent friend requests
  Future<List<FriendRequestEntity>> getSentRequests();

  /// Get friends list for current user
  Future<List<FriendEntity>> getFriends();

  /// Get friends list for a specific user
  Future<List<FriendEntity>> getUserFriends({required String userId});

  /// Check if two users are friends
  Future<FriendshipStatusEntity> isFriend({
    required String userAId,
    required String userBId,
  });

  /// Get friend IDs
  Future<List<String>> getFriendIds();
}
