import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/services/storage/storage_services.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';
import 'package:flutter_code_structure/utils/helpers/permission_helper.dart';
import 'driver_profile_controller.dart';

class DriverEditProfileController extends GetxController {
  final fullNameController = TextEditingController(text: 'Jane Doe');
  final emailController = TextEditingController(text: 'example@gamil.com');
  final phoneController = TextEditingController(text: '0123456789');
  final addressController = TextEditingController();

  final RxString dob = ''.obs;
  final RxString selectedGender = 'Male'.obs;
  final List<String> genderOptions = ['Male', 'Female', 'Other'];

  final RxString selectedCountryCode = 'USA'.obs;
  final RxString selectedCountryFlag = '🇺🇸'.obs;

  final Rxn<File> profileImage = Rxn<File>();
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    _loadInitialUserData();
  }

  void _loadInitialUserData() {
    final user = LocalStorage.user;
    if (user != null && user.name.isNotEmpty) {
      fullNameController.text = user.name;
    } else if (LocalStorage.myName.isNotEmpty) {
      fullNameController.text = LocalStorage.myName;
    }

    if (user != null && user.email.isNotEmpty) {
      emailController.text = user.email;
    } else if (LocalStorage.myEmail.isNotEmpty) {
      emailController.text = LocalStorage.myEmail;
    }
  }

  Future<void> pickProfilePhoto({BuildContext? context}) async {
    final hasPerm =
        await AppPermissionHelper.requestPhotosPermission(context: context);
    if (!hasPerm) return;

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        profileImage.value = File(image.path);
        AppSnackbar.success(
          title: 'Photo Selected',
          message: 'Profile photo updated successfully',
        );
      }
    } catch (e) {
      AppSnackbar.error(
        title: 'Notice',
        message: 'Could not select photo: $e',
      );
    }
  }

  Future<void> selectDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1995, 1, 1),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2E0A66),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      dob.value = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  void onSaveChanges() {
    final name = fullNameController.text.trim();
    if (name.isEmpty) {
      AppSnackbar.error(
        title: 'Validation Error',
        message: 'Full Name cannot be empty',
      );
      return;
    }

    // Update LocalStorage if available
    if (LocalStorage.myName != name) {
      LocalStorage.myName = name;
    }
    if (LocalStorage.myEmail != emailController.text.trim() &&
        emailController.text.trim().isNotEmpty) {
      LocalStorage.myEmail = emailController.text.trim();
    }

    // Update DriverProfileController if registered
    if (Get.isRegistered<DriverProfileController>()) {
      final profileCtrl = Get.find<DriverProfileController>();
      profileCtrl.driverName.value = name;
      if (emailController.text.trim().isNotEmpty) {
        profileCtrl.email.value = emailController.text.trim();
      }
      if (phoneController.text.trim().isNotEmpty) {
        profileCtrl.phone.value = phoneController.text.trim();
      }
    }

    AppSnackbar.success(
      title: 'Profile Updated',
      message: 'Your profile changes have been saved successfully',
    );
    Get.back();
  }

  void onResetPassword() {
    Get.toNamed(AppRoutes.changePassword);
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
