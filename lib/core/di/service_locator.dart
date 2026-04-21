import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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
import 'package:social_app/presentations/post/bloc/post_bloc.dart';

import 'package:social_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:social_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:social_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:social_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:social_app/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:social_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:social_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:social_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:social_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:social_app/presentations/auth/bloc/auth_bloc.dart';

import '../locale/locale_manager.dart';
import '../network/network.dart';
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

  // HTTP Client
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // Connectivity
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

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

  // ============================================================================
  // Data Sources
  // ============================================================================

  // Auth Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl()),
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

  // ============================================================================
  // Use Cases
  // ============================================================================

  // Auth Use Cases
  sl.registerFactory(() => LoginUseCase(sl()));
  sl.registerFactory(() => RegisterUseCase(sl()));
  sl.registerFactory(() => LogoutUseCase(sl()));
  sl.registerFactory(() => GetCurrentUserUseCase(sl()));
  sl.registerFactory(() => CheckAuthStatusUseCase(sl()));

  // Post Use Cases
  sl.registerFactory(() => CreatePostUsecase(sl()));
  sl.registerFactory(() => GetPostUsecase(sl()));
  sl.registerFactory(() => GetPostsByUserUsecase(sl()));
  sl.registerFactory(() => UpdatePostUsecase(sl()));
  sl.registerFactory(() => DeletePostUsecase(sl()));
  sl.registerFactory(() => GetHomePostUsecase(sl()));

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

  // Post BLoC
  sl.registerLazySingleton(
    () => PostBloc(
      createPostUsecase: sl(),
      getHomePostUsecase: sl(),
      getPostUsecase: sl(),
      getPostsByUserUsecase: sl(),
      updatePostUsecase: sl(),
      deletePostUsecase: sl(),
    ),
  );
}

/// Reset all dependencies (useful for testing)
Future<void> resetDependencies() async {
  await sl.reset();
}
