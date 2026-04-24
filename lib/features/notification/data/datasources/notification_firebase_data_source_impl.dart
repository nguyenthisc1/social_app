import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:social_app/features/notification/data/datasources/notification_remote_data_source.dart';
import 'package:social_app/features/notification/domain/notification_exeptions.dart';

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
      NotificationExeptions(message: e.toString());
      return null;
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

      final apnsToken = await _firebaseMessaging.getAPNSToken();
      print('APNS token: $apnsToken');
      print(settings.authorizationStatus);
      final token = await _firebaseMessaging.getToken();
      print(' token: $token');
      return settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
    } catch (e) {
      NotificationExeptions(message: e.toString());
      return false;
    }
  }

  @override
  Future<void> syncDeviceToken({
    required String userId,
    required String token,
  }) async {
    try {
      print('fcmtoken');
      await _firestore.collection('users').doc(userId).update({
        'fcmToken': token,
        'fcmUpdatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      NotificationExeptions(message: e.toString());
      return;
    }
  }
}
