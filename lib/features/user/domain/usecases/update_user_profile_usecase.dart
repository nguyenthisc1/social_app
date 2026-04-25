import 'package:social_app/features/user/domain/entites/user_entity.dart';
import 'package:social_app/features/user/domain/repositories/user_repository.dart';

class UpdateUserProfileUsecase {
  final UserRepository _userRepository;

  const UpdateUserProfileUsecase(this._userRepository);

  Future<UserEntity> call(UserEntity user) async {
    return await _userRepository.updateUserProfile(user);
  }
}
