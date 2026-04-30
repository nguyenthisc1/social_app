import 'package:mockito/annotations.dart';
import 'package:social_app/app/internet_connection/network_info.dart';
import 'package:social_app/core/data/http/api_client.dart';
import 'package:social_app/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:social_app/features/auth/data/datasources/remote/auth_firebase_remote_data_souce.dart';
import 'package:social_app/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:social_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:social_app/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:social_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:social_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:social_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:social_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:social_app/features/comment/data/datasources/comment_remote_data_source.dart';
import 'package:social_app/features/comment/domain/repositories/comment_repository.dart';
import 'package:social_app/features/conversation/data/datasources/local/conversation_local_data_source.dart';
import 'package:social_app/features/conversation/data/datasources/remote/conversation_remote_data_source.dart';
import 'package:social_app/features/conversation/domain/repositories/conversation_repository.dart';
import 'package:social_app/features/conversation/domain/usecases/create_conversation_usecase.dart';
import 'package:social_app/features/conversation/domain/usecases/get_conversation_usecase.dart';
import 'package:social_app/features/conversation/domain/usecases/get_conversations_usecase.dart';
import 'package:social_app/features/conversation/domain/usecases/update_conversation_usecase.dart';
import 'package:social_app/features/conversation/domain/usecases/watch_conversations_usecase.dart';
import 'package:social_app/features/friendship/data/datasources/friendship_remote_data_source.dart';
import 'package:social_app/features/friendship/domain/repositories/friendship_repository.dart';
import 'package:social_app/features/post/data/datasources/post_local_data_source.dart';
import 'package:social_app/features/post/data/datasources/post_remote_data_source.dart';
import 'package:social_app/features/post/domain/repositories/post_repository.dart';
import 'package:social_app/features/reaction/data/datasources/reaction_remote_data_source.dart';
import 'package:social_app/features/reaction/domain/repositories/reaction_repository.dart';

@GenerateMocks([
  // Core
  ApiClient,
  NetworkInfo,

  // Auth
  AuthRepository,
  AuthRemoteDataSource,
  AuthLocalDataSource,
  AuthFirebaseRemoteDataSource,
  LoginUseCase,
  RegisterUseCase,
  LogoutUseCase,
  GetCurrentUserUseCase,
  CheckAuthStatusUseCase,

  // Post
  PostRepository,
  PostRemoteDataSource,
  PostLocalDataSource,

  // Comment
  CommentRepository,
  CommentRemoteDataSource,

  // Conversation
  ConversationRepository,
  ConversationRemoteDataSource,
  ConversationLocalDataSource,
  GetConversationUsecase,
  GetConversationsUsecase,
  CreateConversationUsecase,
  UpdateConversationsUsecase,
  WatchConversationsUsecase,

  // Reaction
  ReactionRepository,
  ReactionRemoteDataSource,

  // Friendship
  FriendshipRepository,
  FriendshipRemoteDataSource,
])
void main() {}
