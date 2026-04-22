import 'package:dartz/dartz.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/features/friendship/domain/entities/friendship_entity.dart';
import 'package:social_app/features/friendship/domain/repositories/friendship_repository.dart';

/// Use case for checking if two users are friends
class CheckFriendshipStatusUsecase {
  final FriendshipRepository repository;

  CheckFriendshipStatusUsecase(this.repository);

  /// Check if two users are friends
  Future<Either<Failure, FriendshipStatusEntity>> call({
    required String userAId,
    required String userBId,
  }) async {
    return await repository.isFriend(userAId: userAId, userBId: userBId);
  }
}
