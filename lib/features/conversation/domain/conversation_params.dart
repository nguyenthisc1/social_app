import 'package:equatable/equatable.dart';

class CreateConversationParams extends Equatable {
  final List<String> participantIds;

  const CreateConversationParams({required this.participantIds});

  @override
  List<Object?> get props => [participantIds];
}
