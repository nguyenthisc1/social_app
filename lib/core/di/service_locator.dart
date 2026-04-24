import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_app/features/auth/application/bloc/auth_bloc.dart';
import 'package:social_app/features/auth/data/datasources/auth_firebase_data_source.dart';
import 'package:social_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:social_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:social_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:social_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:social_app/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:social_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:social_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:social_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:social_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:social_app/features/conversation/application/cubit/conversation_cubit.dart';
import 'package:social_app/features/conversation/application/cubit/conversation_detail_cubit.dart';
import 'package:social_app/features/conversation/application/services/bardge-service/badge_service.dart';
import 'package:social_app/features/conversation/data/datasources/remote/firebase/conversation_firebase_data_source_impl.dart';
import 'package:social_app/features/conversation/data/datasources/local/conversation_local_data_source.dart';
import 'package:social_app/features/conversation/data/datasources/local/hive/conversation_hive_local_data_source.dart';
import 'package:social_app/features/conversation/data/datasources/remote/conversation_remote_data_source.dart';
import 'package:social_app/features/conversation/data/repositories/conversation_repository_impl.dart';
import 'package:social_app/features/conversation/domain/repositories/conversation_repository.dart';
import 'package:social_app/features/conversation/domain/usecases/create_conversation_usecase.dart';
import 'package:social_app/features/conversation/domain/usecases/get_conversation_usecase.dart';
import 'package:social_app/features/conversation/domain/usecases/get_conversations_usecase.dart';
import 'package:social_app/features/conversation/domain/usecases/update_conversation_usecase.dart';
import 'package:social_app/features/message/application/cubit/meesage_cubit.dart';
import 'package:social_app/features/message/data/datasources/message_firebase_data_source.dart';
import 'package:social_app/features/message/data/datasources/message_remote_data_source.dart';
import 'package:social_app/features/message/data/repositories/message_repository_impl.dart';
import 'package:social_app/features/message/domain/repositories/message_repository.dart';
import 'package:social_app/features/message/domain/usecases/get_messages_by_conversation_usecase.dart';
import 'package:social_app/features/message/domain/usecases/send_message_usecase.dart';
import 'package:social_app/features/message/domain/usecases/watch_messages_by_conversation_usecase.dart';
import 'package:social_app/features/notification/application/cubit/notification_cubit.dart';
import 'package:social_app/features/notification/data/datasources/notification_firebase_data_source_impl.dart';
import 'package:social_app/features/notification/data/datasources/notification_remote_data_source.dart';
import 'package:social_app/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:social_app/features/notification/domain/repositories/notification_repository.dart';
import 'package:social_app/features/notification/domain/usecases/get_fcm_token_usecase.dart';
import 'package:social_app/features/notification/domain/usecases/request_notification_permission_usecase.dart';
import 'package:social_app/features/notification/domain/usecases/sync_fcm_token_usecase.dart';
import 'package:social_app/features/post/data/datasources/post_local_data_source.dart';
import 'package:social_app/features/post/data/datasources/post_remote_data_source.dart';
import 'package:social_app/features/post/data/repositories/post_repository_impl.dart';
import 'package:social_app/features/post/domain/repositories/post_repository.dart';
import 'package:social_app/features/post/domain/usecases/create_post_usecase.dart';
import 'package:social_app/features/post/domain/usecases/delete_post_usecase.dart';
import 'package:social_app/features/post/domain/usecases/get_home_post_usecase.dart';
import 'package:social_app/features/post/domain/usecases/get_post_usecase.dart';
import 'package:social_app/features/post/domain/usecases/get_posts_by_user_usecase.dart';
import 'package:social_app/features/post/domain/usecases/update_post_usecase.dart';
import 'package:social_app/features/user/application/cubit/user_cubit.dart';
import 'package:social_app/features/user/data/datasources/user_firebase_data_source.dart';
import 'package:social_app/features/user/data/datasources/user_remote_data_source.dart';
import 'package:social_app/features/user/data/repositories/user_repository_impl.dart';
import 'package:social_app/features/user/domain/repositories/user_repository.dart';
import 'package:social_app/features/user/domain/usecases/get_user_by_id_usecase.dart';
import 'package:social_app/features/user/domain/usecases/get_user_profile_usecase.dart';
import 'package:social_app/features/user/domain/usecases/search_user_profile_usecase.dart';
import 'package:social_app/features/user/domain/usecases/update_user_profile_usecase.dart';
import 'package:social_app/presentations/post/bloc/post_bloc.dart';

import '../locale/locale_manager.dart';
import '../network/network.dart';
import '../services/firebase/firebase_seed_service.dart';
import '../theme/theme.dart';
import '../utils/constants.dart';

/// Service locator instance
final sl = GetIt.instance;

/// Initialize all dependencies
Future<void> initializeDependencies() async {
  // ============================================================================
  // External Dependencies
  // ============================================================================

  // Shared Preferences - Must be initialized first
  final sharedPreferences = await SharedPreferences.getInstance();

  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Hive
  // sl.registerLazySingleton<Hive>()
  final appDocumentDirectory = await path_provider
      .getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  // No need to inject Hive as a singleton.

  // HTTP Client
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // Connectivity
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  // Firebase
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
  sl.registerLazySingleton<FirebaseMessaging>(() => FirebaseMessaging.instance);

  // ============================================================================
  // Core Dependencies
  // ============================================================================

  // Network Info
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: sl()),
  );

  // API Client
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(
      httpClient: sl<http.Client>(),
      networkInfo: sl(),
      baseUrl: AppConstants.apiBaseUrl,
      tokenProvider: sl(),
    ),
  );

  // Theme Manager
  sl.registerLazySingleton<ThemeManager>(() => ThemeManager(sl()));

  // Locale Manager
  sl.registerLazySingleton<LocaleManager>(() => LocaleManager(sl()));

  // Firebase Seed Service
  sl.registerLazySingleton<FirebaseSeedService>(
    () => FirebaseSeedService(firestore: sl<FirebaseFirestore>()),
  );

  sl.registerLazySingleton<BadgeService>(() => AppIconBadgeService());

  // ============================================================================
  // Data Sources
  // ============================================================================

  // Auth Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthFirebaseDataSource(
      firebaseAuth: sl<FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
    ),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Post Data Sources
  sl.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSourceImpl(apiClient: sl()),
  );

  sl.registerLazySingleton<PostLocalDataSource>(
    () => PostLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // User
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserFirebaseDataSource(
      firebaseAuth: sl<FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
    ),
  );

  // Conversation Data Sources
  sl.registerLazySingleton<ConversationRemoteDataSource>(
    () =>
        ConversationFirebaseDataSourceImpl(firestore: sl<FirebaseFirestore>()),
  );

  sl.registerLazySingleton<ConversationLocalDataSource>(
    () => ConversationHiveLocalDataSource(),
  );

  // Message Data Sources
  sl.registerLazySingleton<MessageRemoteDataSource>(
    () => MessageFirebaseDataSource(firestore: sl<FirebaseFirestore>()),
  );

  // Notification
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationFirebaseDataSource(
      firestore: sl<FirebaseFirestore>(),
      firebaseMessaging: sl<FirebaseMessaging>(),
    ),
  );

  // ============================================================================
  // Repositories
  // ============================================================================

  // Auth Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Post Repository
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(networkInfo: sl(), remote: sl(), local: sl()),
  );

  // User Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: sl()),
  );

  // Conversation Repository
  sl.registerLazySingleton<ConversationRepository>(
    () => ConversationRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Message Repository
  sl.registerLazySingleton<MessageRepository>(
    () => MessageRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Notification
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(remoteDataSource: sl()),
  );

  // ============================================================================
  // Use Cases
  // ============================================================================

  // Auth Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));

  // Post Use Cases
  sl.registerLazySingleton(() => CreatePostUsecase(sl()));
  sl.registerLazySingleton(() => GetPostUsecase(sl()));
  sl.registerLazySingleton(() => GetPostsByUserUsecase(sl()));
  sl.registerLazySingleton(() => UpdatePostUsecase(sl()));
  sl.registerLazySingleton(() => DeletePostUsecase(sl()));
  sl.registerLazySingleton(() => GetHomePostUsecase(sl()));

  // User Use Cases
  sl.registerLazySingleton(() => GetUserProfileUsecase(sl<UserRepository>()));
  sl.registerLazySingleton(() => GetUserByIdUsecase(sl<UserRepository>()));
  sl.registerLazySingleton(
    () => SearchUserProfileUsecase(sl<UserRepository>()),
  );
  sl.registerLazySingleton(
    () => UpdateUserProfileUsecase(sl<UserRepository>()),
  );

  // Conversation Use Cases
  sl.registerLazySingleton(() => GetConversationUsecase(sl()));
  sl.registerLazySingleton(() => GetConversationsUsecase(sl()));
  sl.registerLazySingleton(() => CreateConversationUsecase(sl()));
  sl.registerLazySingleton(() => UpdateConversationsUsecase(sl()));

  // Message Use Cases
  sl.registerLazySingleton(() => GetMessagesByConversationUsecase(sl()));
  sl.registerLazySingleton(() => SendMessageUsecase(sl()));
  sl.registerLazySingleton(() => WatchMessagesByConversationUseCase(sl()));

  // Notification Use Cases
  sl.registerLazySingleton(() => GetFcmTokenUsecase(sl()));
  sl.registerLazySingleton(() => RequestNotificationPermissionUsecase(sl()));
  sl.registerLazySingleton(() => SyncFcmTokenUsecase(sl()));

  // ============================================================================
  // State Management (BLoC/Cubit/Provider)
  // ============================================================================

  // Auth BLoC
  sl.registerLazySingleton(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
      checkAuthStatusUseCase: sl(),
    ),
  );

  // User Cubit
  sl.registerFactory(
    () => UserCubit(
      getUserByIdUsecase: sl(),
      getUserProfileUsecase: sl(),
      searchUserProfileUsecase: sl(),
      updateUserProfileUsecase: sl(),
    ),
  );

  // Post BLoC
  sl.registerFactory(
    () => PostBloc(
      createPostUsecase: sl(),
      getHomePostUsecase: sl(),
      getPostUsecase: sl(),
      getPostsByUserUsecase: sl(),
      updatePostUsecase: sl(),
      deletePostUsecase: sl(),
    ),
  );

  // Conversations Cubit
  sl.registerFactory(
    () => ConversationCubit(
      getConversationUsecase: sl(),
      getConversationsUsecase: sl(),
      createConversationUsecase: sl(),
      updateConversationsUsecase: sl(),
    ),
  );

  sl.registerFactory(
    () => ConversationDetailCubit(
      getConversationUsecase: sl(),
      updateConversationsUsecase: sl(),
    ),
  );

  // Message Cubit
  sl.registerFactory(
    () => MessageCubit(
      getMessagesByConversationUsecase: sl(),
      watchMessagesByConversationUseCase: sl(),
      sendMessageUsecase: sl(),
    ),
  );

  // Notification Cubit
  sl.registerFactory(
    () => NotificationCubit(
      getFcmTokenUsecase: sl(),
      requestPermissionUsecase: sl(),
      syncFcmTokenUsecase: sl(),
    ),
  );
}

/// Reset all dependencies (useful for testing)
Future<void> resetDependencies() async {
  await sl.reset();
}
