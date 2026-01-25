import 'package:dartz/dartz.dart';
import 'package:social_app/core/core.dart';
import 'package:social_app/features/friendship/domain/entities/friendship_entity.dart';
import 'package:social_app/features/friendship/domain/repositories/friendship_repository.dart';

/// Use case for getting sent friend requests
class GetSentRequestsUsecase {
  final FriendshipRepository repository;

  GetSentRequestsUsecase({required this.repository});

  /// Get all friend requests sent by current user
  Future<Either<Failure, List<FriendRequestEntity>>> call() async {
    return await repository.getSentRequests();
  }
}
