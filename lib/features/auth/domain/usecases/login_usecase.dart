import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';
import '../../../user/domain/entites/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for user login
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) async {
    return await repository.login(
      email: email,
      password: password,
    );
  }
}

