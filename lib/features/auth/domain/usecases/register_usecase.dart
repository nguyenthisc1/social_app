import 'package:social_app/core/domain/exceptions/generic_exception.dart';
import 'package:social_app/core/domain/usecases/usecases.dart';
import 'package:social_app/features/auth/domain/auth_types.dart';
import 'package:social_app/features/auth/domain/value_objects/email_address.dart';
import 'package:social_app/features/auth/domain/value_objects/non_empty_string.dart';

import '../../../user/domain/entites/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for user registration
class RegisterUseCase extends UseCase<UserEntity, RegisterCommand> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<UserEntity> call(RegisterCommand params) {
    final validatedEmail = EmailAddress(params.email);
    final validatedUsername = NonEmptyString(
      params.username,
      fieldName: 'Username',
    );
    final validatedPassword = NonEmptyString(
      params.password,
      fieldName: 'Password',
    );

    if (validatedPassword.value.length < 6) {
      throw ArgumentInvalidException(
        userMessage: 'Password must be at least 6 characters.',
        debugMessage:
            'RegisterUseCase received a password shorter than 6 characters.',
        metadata: {'fieldName': 'password'},
      );
    }

    return repository.register(
      email: validatedEmail.value,
      username: validatedUsername.value,
      password: validatedPassword.value,
    );
  }
}
