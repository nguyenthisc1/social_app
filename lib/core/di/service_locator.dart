import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      client: sl(),
      networkInfo: sl(),
      baseUrl: AppConstants.apiBaseUrl,
    ),
  );

  // Theme Manager
  sl.registerLazySingleton<ThemeManager>(
    () => ThemeManager(sl()),
  );

  // ============================================================================
  // Data Sources
  // ============================================================================
  // Register your remote and local data sources here
  // Example:
  // sl.registerLazySingleton<UserRemoteDataSource>(
  //   () => UserRemoteDataSourceImpl(apiClient: sl()),
  // );
  //
  // sl.registerLazySingleton<UserLocalDataSource>(
  //   () => UserLocalDataSourceImpl(sharedPreferences: sl()),
  // );

  // ============================================================================
  // Repositories
  // ============================================================================
  // Register your repositories here
  // Example:
  // sl.registerLazySingleton<UserRepository>(
  //   () => UserRepositoryImpl(
  //     remoteDataSource: sl(),
  //     localDataSource: sl(),
  //     networkInfo: sl(),
  //   ),
  // );

  // ============================================================================
  // Use Cases
  // ============================================================================
  // Register your use cases here
  // Example:
  // sl.registerLazySingleton(() => GetUserProfile(sl()));
  // sl.registerLazySingleton(() => UpdateUserProfile(sl()));

  // ============================================================================
  // State Management (BLoC/Cubit/Provider)
  // ============================================================================
  // Register your state management here
  // Example with BLoC:
  // sl.registerFactory(
  //   () => AuthBloc(
  //     loginUseCase: sl(),
  //     logoutUseCase: sl(),
  //   ),
  // );
  //
  // Example with Provider/ChangeNotifier:
  // sl.registerFactory(() => PostProvider(repository: sl()));
}

/// Reset all dependencies (useful for testing)
Future<void> resetDependencies() async {
  await sl.reset();
}

