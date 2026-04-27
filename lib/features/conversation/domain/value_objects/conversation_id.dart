// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:social_app/core/domain/exceptions/generic_exception.dart';
import 'package:social_app/core/domain/value_objects/value_object.dart';

class ConversationId extends ValueObject<String> {
  ConversationId._(super.value);

  factory ConversationId(String input) {
    final normalized = input.trim();

    if (normalized.isEmpty) {
      throw ArgumentNotProvidedException(
        userMessage: 'Conversation is invalid.',
        debugMessage: 'ConversationId received an empty value.',
        metadata: {'fieldName': 'conversationId'},
      );
    }

    return ConversationId._(normalized);
  }
}
