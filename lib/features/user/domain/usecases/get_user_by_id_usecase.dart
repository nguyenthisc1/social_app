import 'package:social_app/features/user/domain/entites/user_entity.dart';
import 'package:social_app/features/user/domain/repositories/user_repository.dart';

class GetUserByIdUsecase {
  final UserRepository _userRepository;

  const GetUserByIdUsecase(this._userRepository);

  Future<UserEntity?> call(String id) async {
    return await _userRepository.getUserById(id);
  }
}
