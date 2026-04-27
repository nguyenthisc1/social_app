import 'package:social_app/features/user/domain/entites/user_entity.dart';
import 'package:social_app/features/user/domain/repositories/user_repository.dart';

class GetUsersByIdsUsecase {
  final UserRepository _userRepository;

  const GetUsersByIdsUsecase(this._userRepository);

  Future<List<UserEntity>> call(List<String> ids) async {
    return _userRepository.getUsersByIds(ids);
  }
}
