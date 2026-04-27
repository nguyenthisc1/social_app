abstract interface class NotificationRemoteDataSource {
  Future<bool> requestPermission();
  Future<String?> getDeviceToken();
  Future<void> syncDeviceToken({required String userId, required String token});
}
