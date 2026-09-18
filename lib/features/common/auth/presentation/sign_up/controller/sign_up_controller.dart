import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/features/common/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_code_structure/features/common/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_code_structure/features/common/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_code_structure/services/storage/storage_services.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';
import 'package:flutter_code_structure/utils/helpers/other_helper.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/countries.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find<SignUpController>();

  final AuthRepository _authRepository;

  SignUpController({AuthRepository? authRepository})
      : _authRepository = authRepository ??
            AuthRepositoryImpl(
              remoteDataSource: AuthRemoteDataSourceImpl(),
            );

  bool isLoading = false;
  bool isLoadingVerify = false;
  String selectRole = 'Customer';
  String countryCode = '+880';
  String? image;
  String? driverProfileImage;
  String? drivingLicenseImage;
  String? drivingLicenseFrontImage;
  String? drivingLicenseBackImage;
  String? selfieImage;
  String? vehicleRegistrationImage;
  String? restaurantLicenseImage;
  String signUpToken = '';
  Timer? _timer;
  int _seconds = 0;

  bool get isDriver =>
      (selectRole.isNotEmpty ? selectRole : LocalStorage.myRole).toLowerCase() ==
      'driver';

  bool get isMerchant {
    final r = (selectRole.isNotEmpty ? selectRole : LocalStorage.myRole).toLowerCase();
    return r == 'merchant' || r == 'marchant';
  }

  Future<void> pickDocument({
    required String type,
    ImageSource source = ImageSource.gallery,
  }) async {
    final picked = await OtherHelper.pickImage(source: source);
    if (picked != null) {
      switch (type) {
        case 'profile':
          driverProfileImage = picked;
          image = picked;
          break;
        case 'license_front':
          drivingLicenseFrontImage = picked;
          drivingLicenseImage = picked;
          break;
        case 'license_back':
          drivingLicenseBackImage = picked;
          break;
        case 'license':
          drivingLicenseFrontImage = picked;
          drivingLicenseImage = picked;
          break;
        case 'selfie':
          selfieImage = picked;
          break;
        case 'vehicle':
          vehicleRegistrationImage = picked;
          break;
        case 'restaurant_license':
          restaurantLicenseImage = picked;
          break;
      }
      update();
    }
  }

  void removeDocument(String type) {
    switch (type) {
      case 'profile':
        driverProfileImage = null;
        image = null;
        break;
      case 'license_front':
        drivingLicenseFrontImage = null;
        drivingLicenseImage = null;
        break;
      case 'license_back':
        drivingLicenseBackImage = null;
        break;
      case 'license':
        drivingLicenseFrontImage = null;
        drivingLicenseImage = null;
        break;
      case 'selfie':
        selfieImage = null;
        break;
      case 'vehicle':
        vehicleRegistrationImage = null;
        break;
      case 'restaurant_license':
        restaurantLicenseImage = null;
        break;
    }
    update();
  }

  TextEditingController _nameController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _otpController = TextEditingController();
  TextEditingController _businessNameController = TextEditingController();
  TextEditingController _businessEmailController = TextEditingController();
  TextEditingController _businessAddressController = TextEditingController();

  TextEditingController get nameController {
    try {
      _nameController.text;
    } catch (_) {
      _nameController = TextEditingController();
    }
    return _nameController;
  }

  TextEditingController get firstNameController {
    try {
      _firstNameController.text;
    } catch (_) {
      _firstNameController = TextEditingController();
    }
    return _firstNameController;
  }

  TextEditingController get lastNameController {
    try {
      _lastNameController.text;
    } catch (_) {
      _lastNameController = TextEditingController();
    }
    return _lastNameController;
  }

  TextEditingController get emailController {
    try {
      _emailController.text;
    } catch (_) {
      _emailController = TextEditingController();
    }
    return _emailController;
  }

  TextEditingController get passwordController {
    try {
      _passwordController.text;
    } catch (_) {
      _passwordController = TextEditingController();
    }
    return _passwordController;
  }

  TextEditingController get confirmPasswordController {
    try {
      _confirmPasswordController.text;
    } catch (_) {
      _confirmPasswordController = TextEditingController();
    }
    return _confirmPasswordController;
  }

  TextEditingController get numberController {
    try {
      _numberController.text;
    } catch (_) {
      _numberController = TextEditingController();
    }
    return _numberController;
  }

  TextEditingController get otpController {
    try {
      _otpController.text;
    } catch (_) {
      _otpController = TextEditingController();
    }
    return _otpController;
  }

  TextEditingController get businessNameController {
    try {
      _businessNameController.text;
    } catch (_) {
      _businessNameController = TextEditingController();
    }
    return _businessNameController;
  }

  TextEditingController get businessEmailController {
    try {
      _businessEmailController.text;
    } catch (_) {
      _businessEmailController = TextEditingController();
    }
    return _businessEmailController;
  }

  TextEditingController get businessAddressController {
    try {
      _businessAddressController.text;
    } catch (_) {
      _businessAddressController = TextEditingController();
    }
    return _businessAddressController;
  }

  final RxBool termsAccepted = false.obs;

  late final Rx<Country> selectedCountry = countries.firstWhere(
    (c) => c.code == 'US',
    orElse: () => countries.first,
  ).obs;

  @override
  void onInit() {
    super.onInit();
    if (LocalStorage.myRole.isNotEmpty) {
      selectRole = LocalStorage.myRole;
    }
  }

  void setSelectedCountry(Country country) {
    selectedCountry.value = country;
    countryCode = country.dialCode;
    update();
  }

  String get time {
    final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void onCountryChange(Country value) {
    countryCode = value.dialCode;
    selectedCountry.value = value;
    update();
  }

  void setSelectedRole(String value) {
    selectRole = value;
    LocalStorage.setRole(value);
    update();
  }

  Future<void> openGallery() async {
    image = await OtherHelper.pickImage();
    update();
  }

  Future<void> signUpUser() async {
    if (isLoading) return;
    if (!termsAccepted.value) {
      AppSnackbar.error(
        title: 'Agreement Required',
        message: 'Please accept the Terms of Service & Privacy Policy Agreement',
      );
      return;
    }
    try {
      isLoading = true;
      update();

      final fullName = businessNameController.text.isNotEmpty
          ? businessNameController.text.trim()
          : nameController.text.isNotEmpty
              ? nameController.text.trim()
              : '${firstNameController.text.trim()} ${lastNameController.text.trim()}'.trim();

      final email = businessEmailController.text.isNotEmpty
          ? businessEmailController.text.trim()
          : emailController.text.trim();

      _authRepository.signUp(
        name: fullName,
        email: email,
        password: passwordController.text.trim(),
      ).catchError((_) {});

      Get.toNamed(AppRoutes.verifyUser);
    } catch (_) {
      Get.toNamed(AppRoutes.verifyUser);
    } finally {
      isLoading = false;
      update();
    }
  }

  static const int _otpDurationSeconds = 180; // 3 minutes

  int get remainingSeconds => _seconds;

  String get timeFormatted {
    final minutes = _seconds ~/ 60;
    final seconds = _seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  bool get canResendOtp => _seconds == 0;

  String get roleTitle {
    final r = (selectRole.isNotEmpty ? selectRole : LocalStorage.myRole).toLowerCase();
    if (r == 'driver') {
      return 'PLOMOGO Driver';
    } else if (r == 'merchant' || r == 'marchant') {
      return 'PLOMOGO Marchant';
    } else {
      return 'PLOMOGO Customer';
    }
  }

  String get signUpDescription {
    final r = (selectRole.isNotEmpty ? selectRole : LocalStorage.myRole).toLowerCase();
    if (r == 'driver') {
      return 'Create a driver account or log in to\nexplore about our app';
    } else if (r == 'merchant' || r == 'marchant') {
      return 'Create a merchant account or log in to\nexplore about our app';
    } else {
      return 'Create a customer account or log in to\nexplore about our app';
    }
  }

  void startTimer() {
    _timer?.cancel();
    _seconds = _otpDurationSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        timer.cancel();
        update();
        return;
      }
      _seconds--;
      update();
    });
    update();
  }

  Future<void> resendOtp() async {
    if (!canResendOtp) return;
    startTimer();
    AppSnackbar.success(
      title: 'Code Sent',
      message: 'A new 6-digit verification code has been sent.',
    );
  }

  Future<void> verifyOtp() async {
    isLoadingVerify = true;
    update();
    try {
      Get.offAllNamed(AppRoutes.signIn);
    } finally {
      isLoadingVerify = false;
      update();
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
