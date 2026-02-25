import 'dart:async';
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:io' show Platform;

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:unique_device_identifier/unique_device_identifier.dart';
// Removed: import 'package:uuid/uuid.dart';
import 'dart:math';

class DeviceService {
  static bool isAndroid() {
    if (kIsWeb) return false;
    return Platform.isAndroid;
  }

  static bool isIOS() {
    if (kIsWeb) return false;
    return Platform.isIOS;
  }

  static String getDevicePlatform() {
    if (kIsWeb) {
      return "web";
    }
    if (Platform.isAndroid) {
      return "android";
    } else if (Platform.isIOS) {
      return "ios";
    } else if (Platform.isLinux) {
      return "linux";
    } else if (Platform.isMacOS) {
      return "macos";
    } else if (Platform.isWindows) {
      return "windows";
    } else if (Platform.isFuchsia) {
      return "fuchsia";
    }
    return "unknown";
  }

  /// Returns a unique device identifier as a [Future<String?>].
  /// The identifier is hashed for privacy and to maintain consistency.
  static Future<String?> getDeviceId() async {
    try {
      if (!kIsWeb) {
        final id = await UniqueDeviceIdentifier.getUniqueIdentifier();
        if (id != null && id.isNotEmpty) {
          return _hashString(id);
        }
        return null;
      } else {
        // On web, generate a random string and hash it for device id.
        // Since 'package:uuid' cannot be imported, use a random fallback.
        final String randomId = _generateRandomId();
        return _hashString(randomId);
      }
    } catch (e) {
      // Optionally log error here
      return null;
    }
  }

  /// Returns an SHA256 hash of the input [value].
  static String _hashString(String value) {
    final bytes = utf8.encode(value);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Generates a pseudo-unique random string (UUID fallback for web).
  static String _generateRandomId({int length = 36}) {
    final Random random = Random.secure();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(
      length,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }
}
