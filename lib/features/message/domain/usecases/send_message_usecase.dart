import 'package:social_app/core/domain/exceptions/generic_exception.dart';
import 'package:social_app/core/domain/usecases/usecases.dart';
import 'package:social_app/features/conversation/domain/value_objects/conversation_id.dart';
import 'package:social_app/features/message/domain/entites/message_entity.dart';
import 'package:social_app/features/message/domain/message_types.dart';
import 'package:social_app/features/message/domain/repositories/message_repository.dart';
import 'package:social_app/features/message/domain/value_objects/message_text.dart';
import 'package:social_app/features/user/domain/value_objects/value_objects.dart';

class SendMessageUsecase extends UseCase<MessageEntity, SendMessageCommand> {
  final MessageRepository _messageRepository;

  const SendMessageUsecase(this._messageRepository);

  @override
  Future<MessageEntity> call(SendMessageCommand params) {
    final validatedConversationId = ConversationId(params.conversationId);
    final validatedCurrentUserId = UserId(params.currentUserId);
    final hasMedia = params.message.mediaUrl?.trim().isNotEmpty == true;
    final validatedText = MessageText(
      params.message.text ?? '',
      allowEmpty: hasMedia,
    );

    if (!hasMedia && validatedText.value.isEmpty) {
      throw ArgumentNotProvidedException(
        userMessage: 'Message content is required.',
        debugMessage:
            'SendMessageUsecase received neither text nor media content.',
        metadata: {'fieldName': 'message'},
      );
    }

    return _messageRepository.sendMessage(
      conversationId: validatedConversationId.value,
      message: params.message,
      currentUserId: validatedCurrentUserId.value,
    );
  }
}
