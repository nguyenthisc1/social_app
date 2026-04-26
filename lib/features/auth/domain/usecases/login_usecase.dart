import 'package:social_app/core/domain/usecases/usecases.dart';
import 'package:social_app/features/auth/domain/auth_types.dart';
import 'package:social_app/features/auth/domain/value_objects/email_address.dart';
import 'package:social_app/features/auth/domain/value_objects/non_empty_string.dart';

import '../../../user/domain/entites/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for user login
class LoginUseCase extends UseCase<UserEntity, LoginCommand> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<UserEntity> call(LoginCommand params) {
    final validatedEmail = EmailAddress(params.email);
    final validatedPassword = NonEmptyString(
      params.password,
      fieldName: 'Password',
    );

    return repository.login(
      email: validatedEmail.value,
      password: validatedPassword.value,
    );
  }
}
