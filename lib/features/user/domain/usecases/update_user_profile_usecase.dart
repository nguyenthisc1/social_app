import 'package:social_app/features/user/domain/entites/user.dart';
import 'package:social_app/features/user/domain/repositories/user_repository.dart';

class UpdateUserProfileUsecase {
  final UserRepository _userRepository;

  const UpdateUserProfileUsecase(this._userRepository);

  Future<User> call(User user) async {
    return await _userRepository.updateUserProfile(user);
  }
}
