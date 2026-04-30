// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:social_app/core/domain/exceptions/generic_exception.dart';
import 'package:social_app/core/domain/value_objects/value_object.dart';

class MessageText extends ValueObject<String> {
  MessageText._(super.value);

  factory MessageText(String? input, {bool allowEmpty = false}) {
    final normalized = input?.trim() ?? '';

    if (normalized.length > 5000) {
      throw ArgumentInvalidException(
        userMessage: 'Message is too long.',
        debugMessage:
            'MessageText exceeded 5000 characters: ${normalized.length}',
        metadata: {'fieldName': 'messageText'},
      );
    }

    return MessageText._(normalized);
  }
}
