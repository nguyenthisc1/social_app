// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:social_app/core/domain/exceptions/generic_exception.dart';
import 'package:social_app/core/domain/value_objects/value_object.dart';

class Username extends ValueObject<String> {
  Username._(super.value);

  factory Username(String input) {
    final normalized = input.trim();

    if (normalized.isEmpty) {
      throw ArgumentNotProvidedException(
        userMessage: 'Username is required.',
        debugMessage: 'Username received an empty value.',
        metadata: {'fieldName': 'username'},
      );
    }

    if (normalized.length < 3 || normalized.length > 30) {
      throw ArgumentInvalidException(
        userMessage: 'Username must be between 3 and 30 characters.',
        debugMessage:
            'Username length out of range: ${normalized.length} characters.',
        metadata: {'fieldName': 'username'},
      );
    }

    return Username._(normalized);
  }
}
