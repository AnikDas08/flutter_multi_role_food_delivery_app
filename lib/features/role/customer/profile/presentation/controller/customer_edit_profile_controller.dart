import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/countries.dart';

import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/features/common/auth/presentation/sign_up/widgets/country_picker_bottom_sheet.dart';
import 'package:flutter_code_structure/services/storage/storage_services.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';
import 'package:flutter_code_structure/utils/helpers/permission_helper.dart';

class CustomerEditProfileController extends GetxController {
  final fullNameController = TextEditingController(text: 'Jane Doe');
  final emailController = TextEditingController(text: 'example@gamil.com');
  final phoneController = TextEditingController(text: '0123456789');
  final addressController = TextEditingController();

  final RxString dob = ''.obs;
  final RxString selectedGender = 'Mane'.obs;
  final List<String> genderOptions = ['Mane', 'Male', 'Female', 'Other'];

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

  void pickCountry(BuildContext context) {
    HapticFeedback.lightImpact();
    Country currentCountry = countries.firstWhere(
      (c) => c.code == 'US',
      orElse: () => countries.first,
    );

    CountryPickerBottomSheet.show(
      context,
      selectedCountry: currentCountry,
      onSelectCountry: (Country country) {
        selectedCountryFlag.value = country.flag;
        selectedCountryCode.value = country.code == 'US' ? 'USA' : country.code;
      },
    );
  }

  Future<void> pickProfilePhoto({BuildContext? context}) async {
    HapticFeedback.lightImpact();

    if (context != null) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (bottomSheetContext) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Change Profile Photo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E0A66),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined, color: Color(0xFF2E0A66)),
                  title: const Text('Take a Photo'),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                    _pickFromSource(ImageSource.camera, context: context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined, color: Color(0xFF2E0A66)),
                  title: const Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                    _pickFromSource(ImageSource.gallery, context: context);
                  },
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      _pickFromSource(ImageSource.gallery);
    }
  }

  Future<void> _pickFromSource(ImageSource source, {BuildContext? context}) async {
    if (source == ImageSource.camera) {
      final hasPerm = await AppPermissionHelper.requestCameraPermission(context: context);
      if (!hasPerm) return;
    } else {
      final hasPerm = await AppPermissionHelper.requestPhotosPermission(context: context);
      if (!hasPerm) return;
    }

    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 85,
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
    HapticFeedback.lightImpact();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1998, 5, 20),
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
    HapticFeedback.lightImpact();
    final name = fullNameController.text.trim();
    if (name.isEmpty) {
      AppSnackbar.error(
        title: 'Validation Error',
        message: 'Full Name cannot be empty',
      );
      return;
    }

    _saveProfileDataLocally();

    AppSnackbar.success(
      title: 'Profile Updated',
      message: 'Your profile changes have been saved successfully',
    );
    Get.back();
  }

  void onResetPassword() {
    HapticFeedback.lightImpact();
    // Save any pending profile details
    _saveProfileDataLocally();
    Get.toNamed(AppRoutes.changePassword);
  }

  void _saveProfileDataLocally() {
    final name = fullNameController.text.trim();
    if (name.isNotEmpty) {
      LocalStorage.myName = name;
    }
    final email = emailController.text.trim();
    if (email.isNotEmpty) {
      LocalStorage.myEmail = email;
    }
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
