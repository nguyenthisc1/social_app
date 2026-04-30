// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:social_app/core/domain/exceptions/generic_exception.dart';
import 'package:social_app/core/domain/value_objects/value_object.dart';

class ParticipantIds extends ValueObject<List<String>> {
  ParticipantIds._(super.value);

  factory ParticipantIds(List<String> input) {
    final normalized = input
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();

    if (normalized.isEmpty) {
      throw ArgumentNotProvidedException(
        userMessage: 'Participants are required.',
        debugMessage: 'ParticipantIds received an empty list.',
        metadata: {'fieldName': 'participantIds'},
      );
    }

    if (normalized.length < 2) {
      throw ArgumentInvalidException(
        userMessage: 'At least 2 participants are required.',
        debugMessage:
            'ParticipantIds requires at least 2 unique ids but got ${normalized.length}.',
        metadata: {'fieldName': 'participantIds'},
      );
    }

    return ParticipantIds._(normalized);
  }
}
