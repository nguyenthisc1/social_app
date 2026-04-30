// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:social_app/core/domain/exceptions/generic_exception.dart';

import '../../../../core/domain/value_objects/value_object.dart';

class EmailAddress extends ValueObject<String> {
  EmailAddress._(super.value);

  static final RegExp _emailRegex = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

  factory EmailAddress(String input) {
    final normalized = input.trim().toLowerCase();

    if (normalized.isEmpty) {
      throw ArgumentNotProvidedException(
        userMessage: 'Email is required.',
        debugMessage: 'EmailAddress received an empty value.',
      );
    }

    if (!_emailRegex.hasMatch(normalized)) {
      throw ArgumentInvalidException(
        userMessage: 'Email format is invalid.',
        debugMessage: 'EmailAddress failed validation for input: $normalized',
        metadata: {'fieldName': 'email'},
      );
    }

    return EmailAddress._(normalized);
  }
}
