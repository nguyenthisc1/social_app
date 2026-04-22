import 'package:dartz/dartz.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/features/friendship/domain/entities/friendship_entity.dart';
import 'package:social_app/features/friendship/domain/repositories/friendship_repository.dart';

/// Use case for accepting a friend request
class AcceptFriendRequestUsecase {
  final FriendshipRepository repository;

  AcceptFriendRequestUsecase(this.repository);

  /// Accept a friend request
  Future<Either<Failure, FriendshipResponseEntity>> call({
    required String requestId,
  }) async {
    return await repository.acceptRequest(requestId: requestId);
  }
}
