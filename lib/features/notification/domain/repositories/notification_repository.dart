abstract interface class NotificationRepository {
  Future<bool> requestPermission();
  Future<String?> getDeviceToken();
  Future<void> syncDeviceToken(String userId, String token);
}
