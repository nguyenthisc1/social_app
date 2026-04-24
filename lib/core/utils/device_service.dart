import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:unique_device_identifier/unique_device_identifier.dart';

class DeviceService {
  static Future<String?> getDeviceId() async {
    try {
      if (kIsWeb) {
        return _generateRandomId();
      } else {
        return await _getMobileDeviceId();
      }
    } catch (_) {
      return null;
    }
  }

  static String getPlatform() {
    if (kIsWeb) return "web";
    if (Platform.isAndroid) return "android";
    if (Platform.isIOS) return "ios";
    if (Platform.isMacOS) return "macos";
    if (Platform.isWindows) return "windows";
    if (Platform.isLinux) return "linux";
    return "unknown";
  }

  static Future<String?> _getMobileDeviceId() async {
    final id = await UniqueDeviceIdentifier.getUniqueIdentifier();
    if (id == null || id.isEmpty) return null;

    return _hash(id);
  }

  static String _hash(String value) {
    final bytes = utf8.encode(value);
    return sha256.convert(bytes).toString();
  }

  static String _generateRandomId({int length = 40}) {
    final random = Random.secure();
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

    return List.generate(
      length,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
  }
}
