import '../../../user/domain/entites/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for user registration
class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<UserEntity> call({
    required String email,
    required String username,
    required String password,
  }) => repository.register(
    email: email,
    username: username,
    password: password,
  );
}
