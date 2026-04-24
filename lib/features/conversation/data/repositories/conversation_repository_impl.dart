import 'package:social_app/features/conversation/data/datasources/local/conversation_local_data_source.dart';
import 'package:social_app/features/conversation/data/datasources/remote/conversation_remote_data_source.dart';
import 'package:social_app/features/conversation/data/mappers/conversation_mapper.dart';
import 'package:social_app/features/conversation/domain/entites/conversation_entity.dart';
import 'package:social_app/features/conversation/domain/repositories/conversation_repository.dart';

class ConversationRepositoryImpl implements ConversationRepository {
  final ConversationRemoteDataSource _remoteDataSource;
  final ConversationLocalDataSource _localDataSource;

  const ConversationRepositoryImpl({
    required ConversationRemoteDataSource remoteDataSource,
    required ConversationLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<ConversationEntity> createConversation(List<String> memberIds) async {
    final model = await _remoteDataSource.createConversation(memberIds);

    return ConversationMapper.toEntity(model);
  }

  @override
  Future<List<ConversationEntity>> getConversations(
    String currentUserId,
  ) async {
    try {
      final models = await _remoteDataSource.getConversations(currentUserId);
      await _localDataSource.cacheConversations(currentUserId, models);
      return models.map(ConversationMapper.toEntity).toList();
    } catch (_) {
      final cachedModels = await _localDataSource.getCachedConversations(
        currentUserId,
      );
      return cachedModels.map(ConversationMapper.toEntity).toList();
    }
  }

  @override
  Future<ConversationEntity?> getConversation(String id) async {
    final model = await _remoteDataSource.getConversation(id);

    if (model == null) {
      return null;
    }

    return ConversationMapper.toEntity(model);
  }

  @override
  Future<ConversationEntity> updateConversation(
    ConversationEntity conversation,
  ) async {
    final model = await _remoteDataSource.updateConversation(conversation);

    return ConversationMapper.toEntity(model);
  }
}
