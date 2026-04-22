import 'package:social_app/core/core.dart';
import 'package:social_app/features/message/data/datasources/message_remote_data_source.dart';
import 'package:social_app/features/message/data/mappers/message_mapper.dart';
import 'package:social_app/features/message/domain/entites/message_entity.dart';
import 'package:social_app/features/message/domain/repositories/message_repository.dart';

class MessageRepositoryImpl implements MessageRepository {
  const MessageRepositoryImpl({
    required MessageRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  final MessageRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  @override
  Future<List<MessageEntity>> getMessagesByConversation(
    String conversationId,
  ) async {
    final models = await _remoteDataSource.getMessagesByConversation(
      conversationId,
    );

    return models.map(MessageMapper.toEntity).toList();
  }

  @override
  Future<MessageEntity> sendMessage({
    required String conversationId,
    required String text,
    required String currentUserId,
  }) async {
    final model = await _remoteDataSource.sendMessage(
      conversationId: conversationId,
      text: text,
      currentUserId: currentUserId,
    );

    return MessageMapper.toEntity((model));
  }
}
