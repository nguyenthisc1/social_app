import 'package:social_app/features/friendship/domain/repositories/friendship_repository.dart';

/// Use case for getting friend IDs
class GetFriendIdsUsecase {
  final FriendshipRepository repository;

  GetFriendIdsUsecase(this.repository);

  /// Get list of friend IDs
  Future<List<String>> call() async {
    return await repository.getFriendIds();
  }
}
