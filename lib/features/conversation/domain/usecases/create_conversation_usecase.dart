import 'package:social_app/core/domain/usecases/usecases.dart';
import 'package:social_app/features/conversation/domain/conversation_params.dart';
import 'package:social_app/features/conversation/domain/entites/conversation_entity.dart';
import 'package:social_app/features/conversation/domain/repositories/conversation_repository.dart';
import 'package:social_app/features/conversation/domain/value_objects/participant_ids.dart';

class CreateConversationUsecase
    extends UseCase<ConversationEntity, CreateConversationParams> {
  final ConversationRepository _conversationRepository;

  const CreateConversationUsecase(this._conversationRepository);

  @override
  Future<ConversationEntity> call(CreateConversationParams params) {
    final validatedParticipants = ParticipantIds(params.participantIds);

    return _conversationRepository.createConversation(
      validatedParticipants.value,
    );
  }
}
