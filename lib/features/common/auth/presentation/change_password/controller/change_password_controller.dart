import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';

class ChangePasswordController extends GetxController {
  bool isLoading = false;
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  TextEditingController get currentPasswordController {
    try {
      _currentPasswordController.text;
    } catch (_) {
      _currentPasswordController = TextEditingController();
    }
    return _currentPasswordController;
  }

  TextEditingController get newPasswordController {
    try {
      _newPasswordController.text;
    } catch (_) {
      _newPasswordController = TextEditingController();
    }
    return _newPasswordController;
  }

  TextEditingController get confirmPasswordController {
    try {
      _confirmPasswordController.text;
    } catch (_) {
      _confirmPasswordController = TextEditingController();
    }
    return _confirmPasswordController;
  }

  Future<void> changePassword() async {
    if (isLoading) return;
    try {
      isLoading = true;
      update();

      AppSnackbar.success(
        title: 'Success',
        message: 'Password changed successfully.',
      );
      Get.back();
    } catch (e) {
      AppSnackbar.error(title: 'Error', message: e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }
}
