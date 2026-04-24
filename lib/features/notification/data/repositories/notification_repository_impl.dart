import 'package:social_app/features/notification/data/datasources/notification_remote_data_source.dart';
import 'package:social_app/features/notification/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;

  const NotificationRepositoryImpl({
    required NotificationRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<String?> getDeviceToken() {
    return _remoteDataSource.getDeviceToken();
  }

  @override
  Future<bool> requestPermission() {
    return _remoteDataSource.requestPermission();
  }

  @override
  Future<void> syncDeviceToken(String userId, String token) {
    return _remoteDataSource.syncDeviceToken(userId: userId, token: token);
  }
}
