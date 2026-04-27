import 'dart:async';

import 'package:social_app/features/message/data/datasources/local/message_local_data_source.dart';
import 'package:social_app/features/message/data/datasources/remote/message_remote_data_source.dart';
import 'package:social_app/features/message/data/mappers/message_mapper.dart';
import 'package:social_app/features/message/domain/entites/message_entity.dart';
import 'package:social_app/features/message/domain/repositories/message_repository.dart';

class MessageRepositoryImpl implements MessageRepository {
  const MessageRepositoryImpl({
    required MessageLocalDataSource localDataSource,
    required MessageRemoteDataSource remoteDataSource,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

  final MessageLocalDataSource _localDataSource;
  final MessageRemoteDataSource _remoteDataSource;

  @override
  Future<List<MessageEntity>> getMessagesByConversation(
    String conversationId,
  ) async {
    try {
      final models = await _remoteDataSource.getMessagesByConversation(
        conversationId,
      );
      await _localDataSource.cacheMessages(conversationId, models);
      return models.map(MessageMapper.toEntity).toList();
    } catch (_) {
      final cachedModels = await _localDataSource.getCachedMessages(
        conversationId,
      );
      return cachedModels.map(MessageMapper.toEntity).toList();
    }
  }

  @override
  Future<MessageEntity> sendMessage({
    required String conversationId,
    required MessageEntity message,
    required String currentUserId,
  }) async {
    final model = await _remoteDataSource.sendMessage(
      conversationId: conversationId,
      message: message,
      currentUserId: currentUserId,
    );
    await _localDataSource.upsertMessage(conversationId, model);

    return MessageMapper.toEntity((model));
  }

  @override
  Stream<List<MessageEntity>> watchMessagesByConversation(
    String conversationId,
  ) async* {
    final cachedModels = await _localDataSource.getCachedMessages(
      conversationId,
    );
    if (cachedModels.isNotEmpty) {
      yield cachedModels.map(MessageMapper.toEntity).toList();
    }

    await for (final models in _remoteDataSource.watchMessagesByConversation(
      conversationId,
    )) {
      await _localDataSource.cacheMessages(conversationId, models);
      yield models.map(MessageMapper.toEntity).toList();
    }
  }
}
