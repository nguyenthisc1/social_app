import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';
import '../../../user/domain/entites/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case to get current authenticated user
class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call() async {
    return await repository.getCurrentUser();
  }
}

