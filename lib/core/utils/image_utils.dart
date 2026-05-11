import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageUtils {
  static Future<bool> requestPhotoPermission() async {
    PermissionStatus status;

    if (Platform.isAndroid) {
      final androidInfo = await _getAndroidSdkVersion();
      if (androidInfo >= 33) {
        status = await Permission.photos.request();
      } else {
        status = await Permission.storage.request();
      }
    } else {
      status = await Permission.photos.request();
    }

    return status.isGranted || status.isLimited;
  }

  static Future<int> _getAndroidSdkVersion() async {
    // permission_handler handles this internally, but for clarity:
    // On Android 13+ (API 33), use Permission.photos
    // On older, use Permission.storage
    try {
      return int.parse(Platform.operatingSystemVersion.split(' ').last);
    } catch (_) {
      return 33; // Default to newer behavior
    }
  }

  static Future<void> showPermissionDeniedDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'Please grant photo access in Settings to pick images.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}
