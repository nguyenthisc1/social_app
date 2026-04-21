import 'package:social_app/features/user/domain/entites/user.dart';
import 'package:social_app/features/user/domain/repositories/user_repository.dart';

class GetUserProfileUsecase {
  final UserRepository _userRepository;

  const GetUserProfileUsecase(this._userRepository);

  Future<User?> call(String id) async {
    return await _userRepository.getUserById(id);
  }
}
