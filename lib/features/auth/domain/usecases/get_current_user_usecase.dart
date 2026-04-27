import '../../../user/domain/entites/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case to get current authenticated user
class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<UserEntity> call() => repository.getCurrentUser();
}
