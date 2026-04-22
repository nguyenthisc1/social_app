import 'package:dartz/dartz.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/features/friendship/domain/entities/friendship_entity.dart';
import 'package:social_app/features/friendship/domain/repositories/friendship_repository.dart';

/// Use case for getting a specific user's friends list
class GetUserFriendsUsecase {
  final FriendshipRepository repository;

  GetUserFriendsUsecase(this.repository);

  /// Get friends list for a specific user
  Future<Either<Failure, List<FriendEntity>>> call({
    required String userId,
  }) async {
    return await repository.getUserFriends(userId: userId);
  }
}
