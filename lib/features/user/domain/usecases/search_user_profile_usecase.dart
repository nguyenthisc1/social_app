import 'package:social_app/features/user/domain/entites/user_entity.dart';
import 'package:social_app/features/user/domain/repositories/user_repository.dart';

class SearchUserProfileUsecase {
  final UserRepository _userRepository;

  const SearchUserProfileUsecase(this._userRepository);

  Future<List<UserEntity>> call(String search) async {
    return await _userRepository.searchUser(search);
  }
}
