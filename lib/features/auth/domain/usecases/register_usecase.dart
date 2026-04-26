import 'package:social_app/core/domain/exceptions/generic_exception.dart';
import 'package:social_app/core/domain/value_objects/value_objects.dart';
import 'package:social_app/features/auth/domain/value_objects/email_address.dart';
import 'package:social_app/features/auth/domain/value_objects/non_empty_string.dart';

import '../../../user/domain/entites/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for user registration
class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<UserEntity> call({
    required String email,
    required String username,
    required String password,
  }) {
    final validatedEmail = EmailAddress(email);
    final validatedUsername = NonEmptyString(username, fieldName: 'Username');
    final validatedPassword = NonEmptyString(password, fieldName: 'Password');

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
