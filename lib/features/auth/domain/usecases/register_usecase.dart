import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for user registration
class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, User>> call({
    required String email,
    required String username,
    required String password,
  }) async {
    return await repository.register(
      email: email,
      username: username,
      password: password,
    );
  }
}

