// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:social_app/core/domain/exceptions/generic_exception.dart';
import 'package:social_app/core/domain/value_objects/value_object.dart';

class MessageId extends ValueObject<String> {
  MessageId._(super.value);

  factory MessageId(String input) {
    final normalized = input.trim();

    if (normalized.isEmpty) {
      throw ArgumentNotProvidedException(
        userMessage: 'Message is invalid.',
        debugMessage: 'MessageId received an empty value.',
        metadata: {'fieldName': 'messageId'},
      );
    }

    return MessageId._(normalized);
  }
}
