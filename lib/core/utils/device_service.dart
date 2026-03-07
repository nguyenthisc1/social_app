import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:unique_device_identifier/unique_device_identifier.dart';

class DeviceService {
  static const _webStorageKey = 'device_id';

  static String? _cachedWebDeviceId;

  // ==============================
  // PUBLIC API
  // ==============================

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

  /// WEB ONLY: reset device id (vd logout toàn bộ session web)
  // static Future<void> resetWebDeviceId() async {
  //   if (!kIsWeb) return;

  //   _cachedWebDeviceId = null;
  //   html.window.localStorage.remove(_webStorageKey);
  // }

  // ==============================
  // MOBILE
  // ==============================

  static Future<String?> _getMobileDeviceId() async {
    final id = await UniqueDeviceIdentifier.getUniqueIdentifier();
    if (id == null || id.isEmpty) return null;

    return _hash(id);
  }

  // ==============================
  // WEB
  // ==============================

  // static Future<String> _getWebDeviceId() async {
  //   // cache trong memory để tránh đọc localStorage nhiều lần
  //   if (_cachedWebDeviceId != null) return _cachedWebDeviceId!;

  //   String? storedId = html.window.localStorage[_webStorageKey];

  //   if (storedId == null || storedId.isEmpty) {
  //     storedId = _generateRandomId();
  //     html.window.localStorage[_webStorageKey] = storedId;
  //   }

  //   _cachedWebDeviceId = _hash(storedId);
  //   return _cachedWebDeviceId!;
  // }

  // ==============================
  // UTILITIES
  // ==============================

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
