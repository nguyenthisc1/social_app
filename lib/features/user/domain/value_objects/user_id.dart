// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:social_app/core/domain/exceptions/generic_exception.dart';
import 'package:social_app/core/domain/value_objects/value_object.dart';

class UserId extends ValueObject<String> {
  UserId._(super.value);

  factory UserId(String input) {
    final normalized = input.trim();

    if (normalized.isEmpty) {
      throw ArgumentNotProvidedException(
        userMessage: 'User is invalid.',
        debugMessage: 'UserId received an empty value.',
        metadata: {'fieldName': 'userId'},
      );
    }

    return UserId._(normalized);
  }
}
