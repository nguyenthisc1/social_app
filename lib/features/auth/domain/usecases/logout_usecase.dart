import 'package:social_app/core/domain/usecases/usecases.dart';

import '../repositories/auth_repository.dart';

/// Use case for user logout
class LogoutUseCase extends UseCase<void, NoParams> {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<void> call(NoParams params) => repository.logout();
}
