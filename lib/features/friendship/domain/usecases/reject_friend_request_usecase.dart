import 'package:dartz/dartz.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/features/friendship/domain/entities/friendship_entity.dart';
import 'package:social_app/features/friendship/domain/repositories/friendship_repository.dart';

/// Use case for rejecting a friend request
class RejectFriendRequestUsecase {
  final FriendshipRepository repository;

  RejectFriendRequestUsecase({required this.repository});

  /// Reject a friend request
  Future<Either<Failure, FriendshipResponseEntity>> call({
    required String requestId,
  }) async {
    return await repository.rejectRequest(requestId: requestId);
  }
}
