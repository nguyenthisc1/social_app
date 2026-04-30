import 'package:equatable/equatable.dart';
import 'package:social_app/features/message/domain/entites/message_entity.dart';

class SendMessageParams extends Equatable {
  final String conversationId;
  final MessageEntity message;
  final String currentUserId;

  const SendMessageParams({
    required this.conversationId,
    required this.message,
    required this.currentUserId,
  });

  @override
  List<Object?> get props => [conversationId, message, currentUserId];
}
