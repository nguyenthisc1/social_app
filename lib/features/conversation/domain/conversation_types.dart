import 'package:equatable/equatable.dart';

class CreateConversationCommand extends Equatable {
  final List<String> participantIds;

  const CreateConversationCommand({required this.participantIds});

  @override
  List<Object?> get props => [participantIds];
}
