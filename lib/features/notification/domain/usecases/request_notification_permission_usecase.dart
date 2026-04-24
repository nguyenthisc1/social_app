import 'package:social_app/features/notification/domain/repositories/notification_repository.dart';

class RequestNotificationPermissionUsecase {
  final NotificationRepository _notificationRepository;

  const RequestNotificationPermissionUsecase(this._notificationRepository);

  Future<bool> call() async {
    return _notificationRepository.requestPermission();
  }
}
