import 'package:social_app/core/domain/usecases/usecases.dart';
import 'package:social_app/features/user/domain/entites/user_entity.dart';
import 'package:social_app/features/user/domain/repositories/user_repository.dart';
import 'package:social_app/features/user/domain/user_types.dart';
import 'package:social_app/features/user/domain/value_objects/value_objects.dart';

class GetUserByIdUsecase extends UseCase<UserEntity?, GetUserByIdQuery> {
  final UserRepository _userRepository;

  const GetUserByIdUsecase(this._userRepository);

  @override
  Future<UserEntity?> call(GetUserByIdQuery params) async {
    final validatedId = UserId(params.id);
    return await _userRepository.getUserById(validatedId.value);
  }
}
