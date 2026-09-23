import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../constants/app_colors.dart';

class AppPermissionHelper {
  AppPermissionHelper._();

  /// Requests camera permission on both Android and iOS.
  /// Returns true if granted or limited, false otherwise.
  static Future<bool> requestCameraPermission({
    BuildContext? context,
  }) async {
    final status = await Permission.camera.status;

    if (status.isGranted || status.isLimited) {
      return true;
    }

    final result = await Permission.camera.request();

    if (result.isGranted || result.isLimited) {
      return true;
    }

    if (result.isPermanentlyDenied) {
      _showPermissionDeniedDialog(
        title: 'Camera Permission Required',
        message:
            'Camera permission is required to take photos. Please enable it in your device settings.',
      );
      return false;
    }

    return false;
  }

  /// Requests photos/storage permission on both Android and iOS.
  /// Returns true if granted or limited, false otherwise.
  static Future<bool> requestPhotosPermission({
    BuildContext? context,
  }) async {
    // iOS and Android 13+ use Permission.photos
    if (Platform.isIOS) {
      final status = await Permission.photos.status;
      if (status.isGranted || status.isLimited) return true;

      final result = await Permission.photos.request();
      if (result.isGranted || result.isLimited) return true;

      if (result.isPermanentlyDenied) {
        _showPermissionDeniedDialog(
          title: 'Photo Library Permission Required',
          message:
              'Photo library permission is required to select photos. Please enable it in your device settings.',
        );
        return false;
      }
      return false;
    }

    // Android
    PermissionStatus status = await Permission.photos.status;
    if (status.isGranted || status.isLimited) return true;

    // Fallback for older Android versions (SDK <= 32)
    final storageStatus = await Permission.storage.status;
    if (storageStatus.isGranted) return true;

    // Try photos first (Android 13+), then storage
    status = await Permission.photos.request();
    if (status.isGranted || status.isLimited) return true;

    final storageResult = await Permission.storage.request();
    if (storageResult.isGranted) return true;

    if (status.isPermanentlyDenied || storageResult.isPermanentlyDenied) {
      _showPermissionDeniedDialog(
        title: 'Storage Permission Required',
        message:
            'Storage permission is required to select photos. Please enable it in your device settings.',
      );
      return false;
    }

    return false;
  }

  static void _showPermissionDeniedDialog({
    required String title,
    required String message,
  }) {
    Get.dialog(
      AlertDialog(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        content: Text(
          message,
          style: const TextStyle(fontSize: 13, color: Color(0xFF475569)),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              elevation: 0,
            ),
            child: const Text(
              'Open Settings',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
