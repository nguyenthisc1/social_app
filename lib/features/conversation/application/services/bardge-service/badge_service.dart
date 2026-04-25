import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:social_app/features/conversation/domain/conversation_exeptions.dart';

abstract interface class BadgeService {
  Future<void> updateCount(int count);
  Future<void> clear();
}

class AppIconBadgeService implements BadgeService {
  @override
  Future<void> clear() async {
    try {
      await FlutterAppBadger.removeBadge();
    } catch (e) {
      throw ConversationExeptions(message: e.toString());
    }
  }

  @override
  Future<void> updateCount(int count) async {
    final check = await FlutterAppBadger.isAppBadgeSupported();

    try {
      if (count <= 0) {
        await clear();
        return;
      }

      await FlutterAppBadger.updateBadgeCount(count);
    } catch (e) {
      throw ConversationExeptions(message: e.toString());
    }
  }
}
