import 'package:social_app/core/network/network_info.dart';
import 'package:social_app/features/conversation/data/datasources/conversation_local_data_source.dart';
import 'package:social_app/features/conversation/data/datasources/conversation_remote_data_source.dart';
import 'package:social_app/features/conversation/data/mappers/conversation_mapper.dart';
import 'package:social_app/features/conversation/domain/entites/conversation_entity.dart';
import 'package:social_app/features/conversation/domain/repositories/conversation_repository.dart';

class ConversationRepositoryImpl implements ConversationRepository {
  final ConversationRemoteDataSource _remoteDataSource;
  final ConversationLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  const ConversationRepositoryImpl({
    required ConversationRemoteDataSource remoteDataSource,
    required ConversationLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo;

  @override
  Future<ConversationEntity> createConversation(List<String> memberIds) async {
    final model = await _remoteDataSource.createConversation(memberIds);

    return ConversationMapper.toEntity(model);
  }

  @override
  Future<List<ConversationEntity>> getConversations(
    String currentUserId,
  ) async {
    final models = await _remoteDataSource.getConversations(currentUserId);

    return models.map(ConversationMapper.toEntity).toList();
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
