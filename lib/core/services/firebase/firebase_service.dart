import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:social_app/core/services/firebase/firebase_option.dart';

class FirebaseService {
  FirebaseService._();

  static Future<FirebaseApp> initialize() async {
    await Hive.initFlutter();

    if (Firebase.apps.isNotEmpty) {
      return Firebase.app();
    }

    return Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
