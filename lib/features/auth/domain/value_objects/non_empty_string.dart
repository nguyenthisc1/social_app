// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:social_app/core/domain/exceptions/generic_exception.dart';

import '../../../../core/domain/value_objects/value_object.dart';

class NonEmptyString extends ValueObject<String> {
  NonEmptyString._(super.value);

  factory NonEmptyString(
    String input, {
    required String fieldName,
  }) {
    final normalized = input.trim();

    if (normalized.isEmpty) {
      throw ArgumentNotProvidedException(
        userMessage: '$fieldName is required.',
        debugMessage:
            'NonEmptyString received an empty value for field: $fieldName.',
        metadata: {'fieldName': fieldName},
      );
    }

    return NonEmptyString._(normalized);
  }
}
