import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/notification/application/cubit/notification_state.dart';
import 'package:social_app/features/notification/domain/usecases/get_fcm_token_usecase.dart';
import 'package:social_app/features/notification/domain/usecases/request_notification_permission_usecase.dart';
import 'package:social_app/features/notification/domain/usecases/sync_fcm_token_usecase.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final GetFcmTokenUsecase _getFcmTokenUsecase;
  final RequestNotificationPermissionUsecase _requestPermissionUsecase;
  final SyncFcmTokenUsecase _syncFcmTokenUsecase;

  NotificationCubit({
    required GetFcmTokenUsecase getFcmTokenUsecase,
    required RequestNotificationPermissionUsecase requestPermissionUsecase,
    required SyncFcmTokenUsecase syncFcmTokenUsecase,
  }) : _getFcmTokenUsecase = getFcmTokenUsecase,
       _requestPermissionUsecase = requestPermissionUsecase,
       _syncFcmTokenUsecase = syncFcmTokenUsecase,
       super(NotificationState.initial());

  Future<void> initialize(String userId) async {
    emit(state.copyWith(isLoading: true));

    try {
      final granted = await _requestPermissionUsecase();
      if (!granted) {
        emit(state.copyWith(isLoading: false, permissionGranted: false));
        return;
      }

      final token = await _getFcmTokenUsecase();
      print(token);
      if (token != null) {
        print('sycfcm token cubit');
        await _syncFcmTokenUsecase(userId: userId, token: token);
      }

      emit(
        state.copyWith(isLoading: false, permissionGranted: true, token: token),
      );

      debugPrint('${state.permissionGranted} ${state.token}');
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void clear() {
    emit(NotificationState.initial());
  }
}
