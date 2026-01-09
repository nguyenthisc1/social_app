import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_app/core/network/api_client.dart';
import 'package:social_app/core/network/network_info.dart';
import 'package:social_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:social_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:social_app/features/auth/domain/repositories/auth_repository.dart';

@GenerateMocks([
  // Core
  http.Client,
  Connectivity,
  NetworkInfo,
  ApiClient,
  SharedPreferences,
  
  // Auth
  AuthRemoteDataSource,
  AuthLocalDataSource,
  AuthRepository,
])
void main() {}

