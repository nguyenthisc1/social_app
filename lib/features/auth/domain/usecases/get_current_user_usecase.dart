import 'package:social_app/core/domain/usecases/usecases.dart';

import '../../../user/domain/entites/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case to get current authenticated user
class GetCurrentUserUseCase extends UseCase<UserEntity, NoParams> {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  @override
  Future<UserEntity> call(NoParams params) => repository.getCurrentUser();
}
