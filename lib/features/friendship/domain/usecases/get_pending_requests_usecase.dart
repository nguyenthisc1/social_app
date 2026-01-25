import 'package:dartz/dartz.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/features/friendship/domain/entities/friendship_entity.dart';
import 'package:social_app/features/friendship/domain/repositories/friendship_repository.dart';

/// Use case for getting pending friend requests
class GetPendingRequestsUsecase {
  final FriendshipRepository repository;

  GetPendingRequestsUsecase({required this.repository});

  /// Get all pending friend requests received by current user
  Future<Either<Failure, List<FriendRequestEntity>>> call() async {
    return await repository.getPendingRequests();
  }
}
