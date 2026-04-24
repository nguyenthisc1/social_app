import 'package:social_app/features/notification/domain/repositories/notification_repository.dart';

class SyncFcmTokenUsecase {
  final NotificationRepository _notificationRepository;

  const SyncFcmTokenUsecase(this._notificationRepository);

  Future<void> call({required String userId, required String token}) async {
    return _notificationRepository.syncDeviceToken(userId, token);
  }
}
