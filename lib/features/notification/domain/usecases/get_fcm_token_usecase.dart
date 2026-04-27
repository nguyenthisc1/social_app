import 'package:social_app/features/notification/domain/repositories/notification_repository.dart';

class GetFcmTokenUsecase {
  final NotificationRepository _notificationRepository;

  const GetFcmTokenUsecase(this._notificationRepository);

  Future<String?> call() async {
    return _notificationRepository.getDeviceToken();
  }
}
