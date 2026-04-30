// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:social_app/core/domain/exceptions/generic_exception.dart';
import 'package:social_app/core/domain/value_objects/value_object.dart';

class ConversationName extends ValueObject<String> {
  ConversationName._(super.value);

  factory ConversationName(String input, {bool allowEmpty = false}) {
    final normalized = input.trim();

    if (normalized.isEmpty) {
      if (allowEmpty) {
        return ConversationName._('');
      }

      throw ArgumentNotProvidedException(
        userMessage: 'Conversation name is required.',
        debugMessage: 'ConversationName received an empty value.',
        metadata: {'fieldName': 'conversationName'},
      );
    }

    if (normalized.length > 100) {
      throw ArgumentInvalidException(
        userMessage: 'Conversation name is too long.',
        debugMessage:
            'ConversationName exceeded 100 characters: ${normalized.length}',
        metadata: {'fieldName': 'conversationName'},
      );
    }

    return ConversationName._(normalized);
  }
}
