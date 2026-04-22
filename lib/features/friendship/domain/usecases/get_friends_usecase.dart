import 'package:dartz/dartz.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/features/friendship/domain/entities/friendship_entity.dart';
import 'package:social_app/features/friendship/domain/repositories/friendship_repository.dart';

/// Use case for getting friends list
class GetFriendsUsecase {
  final FriendshipRepository repository;

  GetFriendsUsecase(this.repository);

  /// Get friends list for current user
  Future<Either<Failure, List<FriendEntity>>> call() async {
    return await repository.getFriends();
  }
}
