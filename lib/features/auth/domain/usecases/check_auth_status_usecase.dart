import '../repositories/auth_repository.dart';

/// Use case to check if user is authenticated
class CheckAuthStatusUseCase {
  final AuthRepository repository;

  CheckAuthStatusUseCase(this.repository);

  Future<bool> call() async {
    return await repository.isAuthenticated();
  }
}

