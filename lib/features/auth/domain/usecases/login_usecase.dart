import 'package:social_app/features/auth/domain/value_objects/email_address.dart';
import 'package:social_app/features/auth/domain/value_objects/non_empty_string.dart';

import '../../../user/domain/entites/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for user login
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserEntity> call({required String email, required String password}) {
    final validatedEmail = EmailAddress(email);
    final validatedPassword = NonEmptyString(password, fieldName: 'Password');

    return repository.login(
      email: validatedEmail.value,
      password: validatedPassword.value,
    );
  }
}
