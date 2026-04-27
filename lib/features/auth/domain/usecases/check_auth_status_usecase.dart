import 'package:social_app/core/domain/usecases/usecases.dart';

import '../repositories/auth_repository.dart';

/// Use case to check if user is authenticated
class CheckAuthStatusUseCase extends UseCase<bool, NoParams> {
  final AuthRepository repository;

  CheckAuthStatusUseCase(this.repository);

  @override
  Future<bool> call(NoParams params) => repository.isAuthenticated();
}
