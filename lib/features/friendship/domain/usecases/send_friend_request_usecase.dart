import 'package:social_app/features/friendship/domain/entities/friendship_entity.dart';
import 'package:social_app/features/friendship/domain/repositories/friendship_repository.dart';

/// Use case for sending a friend request
class SendFriendRequestUsecase {
  final FriendshipRepository repository;

  SendFriendRequestUsecase(this.repository);

  /// Send friend request to another user
  Future<FriendshipResponseEntity> call({required String toUserId}) async {
    return await repository.sendRequest(toUserId: toUserId);
  }
}
