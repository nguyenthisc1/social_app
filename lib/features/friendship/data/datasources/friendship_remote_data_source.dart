import 'package:social_app/core/core.dart';
import 'package:social_app/features/friendship/data/models/friendship_model.dart';

abstract class FriendshipRemoteDataSource {
  /// Send a friend request
  Future<FriendshipResponseModel> sendRequest({required String toUserId});

  /// Accept a friend request
  Future<FriendshipResponseModel> acceptRequest({required String requestId});

  /// Reject a friend request
  Future<FriendshipResponseModel> rejectRequest({required String requestId});

  /// Get pending friend requests
  Future<List<FriendRequestModel>> getPendingRequests();

  /// Get sent friend requests
  Future<List<FriendRequestModel>> getSentRequests();

  /// Get friends list
  Future<List<FriendModel>> getFriends();

  /// Get user's friends list
  Future<List<FriendModel>> getUserFriends({required String userId});

  /// Check friendship status
  Future<FriendshipStatusModel> isFriend({
    required String userAId,
    required String userBId,
  });

  /// Get friend IDs
  Future<List<String>> getFriendIds();
}

class FriendshipRemoteDataSourceImpl implements FriendshipRemoteDataSource {
  final ApiClient apiClient;

  FriendshipRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<FriendshipResponseModel> sendRequest({
    required String toUserId,
  }) async {
    final response = await apiClient.request(
      method: 'POST',
      endpoint: ApiEndpoints.sendFriendRequest,
      body: {'toUserId': toUserId},
    );

    return FriendshipResponseModel.fromJson(response);
  }

  @override
  Future<FriendshipResponseModel> acceptRequest({
    required String requestId,
  }) async {
    final response = await apiClient.request(
      method: 'POST',
      endpoint: '${ApiEndpoints.acceptFriendRequest}/$requestId',
    );

    return FriendshipResponseModel.fromJson(response);
  }

  @override
  Future<FriendshipResponseModel> rejectRequest({
    required String requestId,
  }) async {
    final response = await apiClient.request(
      method: 'POST',
      endpoint: '${ApiEndpoints.rejectFriendRequest}/$requestId',
    );

    return FriendshipResponseModel.fromJson(response);
  }

  @override
  Future<List<FriendRequestModel>> getPendingRequests() async {
    final response = await apiClient.request(
      method: 'GET',
      endpoint: ApiEndpoints.pendingRequests,
    );

    final data = response['data'] ?? [];
    if (data is List) {
      return data
          .map(
            (json) => FriendRequestModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    }

    return [];
  }

  @override
  Future<List<FriendRequestModel>> getSentRequests() async {
    final response = await apiClient.request(
      method: 'GET',
      endpoint: ApiEndpoints.sentRequests,
    );

    final data = response['data'] ?? [];
    if (data is List) {
      return data
          .map(
            (json) => FriendRequestModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    }

    return [];
  }

  @override
  Future<List<FriendModel>> getFriends() async {
    final response = await apiClient.request(
      method: 'GET',
      endpoint: ApiEndpoints.friends,
    );

    final data = response['data'] ?? [];
    if (data is List) {
      return data
          .map((json) => FriendModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    return [];
  }

  @override
  Future<List<FriendModel>> getUserFriends({required String userId}) async {
    final response = await apiClient.request(
      method: 'GET',
      endpoint: '${ApiEndpoints.userFriends}/$userId',
    );

    final data = response['data'] ?? [];
    if (data is List) {
      return data
          .map((json) => FriendModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    return [];
  }

  @override
  Future<FriendshipStatusModel> isFriend({
    required String userAId,
    required String userBId,
  }) async {
    final response = await apiClient.request(
      method: 'GET',
      endpoint: ApiEndpoints.checkFriendship,
      query: {'userAId': userAId, 'userBId': userBId},
    );

    return FriendshipStatusModel.fromJson(response);
  }

  @override
  Future<List<String>> getFriendIds() async {
    final response = await apiClient.request(
      method: 'GET',
      endpoint: ApiEndpoints.friendIds,
    );

    final data = response['data'] ?? [];
    if (data is List) {
      return data.map((id) => id.toString()).toList();
    }

    return [];
  }
}
