import 'package:mockito/annotations.dart';
import 'package:social_app/core/network/api_client.dart';
import 'package:social_app/core/network/network_info.dart';
import 'package:social_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:social_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:social_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:social_app/features/comment/data/datasources/comment_remote_data_source.dart';
import 'package:social_app/features/comment/domain/repositories/comment_repository.dart';
import 'package:social_app/features/post/data/datasources/post_local_data_source.dart';
import 'package:social_app/features/post/data/datasources/post_remote_data_source.dart';
import 'package:social_app/features/post/domain/repositories/post_repository.dart';

@GenerateMocks([
  // Core
  ApiClient,
  NetworkInfo,
  
  // Auth
  AuthRepository,
  AuthRemoteDataSource,
  AuthLocalDataSource,
  
  // Post
  PostRepository,
  PostRemoteDataSource,
  PostLocalDataSource,
  
  // Comment
  CommentRepository,
  CommentRemoteDataSource,
])
void main() {}
