import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:social_app/features/notification/data/datasources/remote/notification_remote_data_source.dart';
import 'package:social_app/features/notification/domain/notification_exceptions.dart'
    show NotificationPermissionException, NotificationSyncException, NotificationTokenException;

class NotificationFirebaseDataSource implements NotificationRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseMessaging _firebaseMessaging;

  const NotificationFirebaseDataSource({
    required FirebaseFirestore firestore,
    required FirebaseMessaging firebaseMessaging,
  }) : _firestore = firestore,
       _firebaseMessaging = firebaseMessaging;

  @override
  Future<String?> getDeviceToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      throw NotificationTokenException(
        debugMessage: 'Failed to retrieve FCM device token: $e',
        cause: e,
      );
    }
  }

  @override
  Future<bool> requestPermission() async {
    try {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      await Future.delayed(const Duration(seconds: 1));

      await _firebaseMessaging.getAPNSToken();
      await _firebaseMessaging.getToken();

      return settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
    } catch (e) {
      throw NotificationPermissionException(
        debugMessage: 'Failed to request notification permission: $e',
        cause: e,
      );
    }
  }

  @override
  Future<void> syncDeviceToken({
    required String userId,
    required String token,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'fcmToken': token,
        'fcmUpdatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw NotificationSyncException(
        debugMessage: 'Failed to sync FCM token for userId=$userId: $e',
        cause: e,
      );
    }
  }
}
