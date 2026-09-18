import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/features/common/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_code_structure/features/common/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_code_structure/features/common/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_code_structure/services/storage/storage_services.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';
import 'package:flutter_code_structure/utils/enum/enum.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  final AuthRepository _authRepository;

  ForgetPasswordController({AuthRepository? authRepository})
      : _authRepository = authRepository ??
            AuthRepositoryImpl(
              remoteDataSource: AuthRemoteDataSourceImpl(),
            );

  final RxString role = 'Customer'.obs;

  @override
  void onInit() {
    super.onInit();
    initRole();
    setValue();
  }

  void initRole() {
    final argsRole =
        (Get.arguments != null && Get.arguments is Map) ? Get.arguments['role'] : null;
    final savedRole = argsRole ?? LocalStorage.myRole;
    if (savedRole != null && savedRole.toString().isNotEmpty) {
      setRole(savedRole.toString());
    } else {
      setRole('customer');
    }
  }

  void setRole(String newRole) {
    final r = newRole.trim().toLowerCase();
    if (r == 'driver') {
      role.value = 'Driver';
    } else if (r == 'merchant' || r == 'marchant') {
      role.value = 'Marchant';
    } else {
      role.value = 'Customer';
    }
  }

  String get roleTitle => 'PLOMOGO ${role.value}';

  String get roleSubtitle {
    final r = role.value.toLowerCase();
    if (r == 'driver') {
      return 'Welcome back! Sign in to start accepting orders';
    } else if (r == 'marchant' || r == 'merchant') {
      return 'Welcome back! Sign in to manage your orders';
    } else {
      return 'Welcome back! Sign in to continue';
    }
  }

  static ForgetPasswordController get instance =>
      Get.find<ForgetPasswordController>();

  void setValue() {
    if (kDebugMode) return;
    emailController.text = 'developernaimul00@gmail.com';
    otpController.text = '123456';
    passwordController.text = 'hello123';
    confirmPasswordController.text = 'hello123';
  }

  bool isLoading = false;
  ForgetPasswordStep currentStep = ForgetPasswordStep.email;
  String forgetPasswordToken = '';
  static const int _otpDurationSeconds = 180;
  int remainingSeconds = 0;
  Timer? _timer;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _otpController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  TextEditingController get emailController {
    try {
      _emailController.text;
    } catch (_) {
      _emailController = TextEditingController();
    }
    return _emailController;
  }

  TextEditingController get otpController {
    try {
      _otpController.text;
    } catch (_) {
      _otpController = TextEditingController();
    }
    return _otpController;
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

  bool get canResendOtp => remainingSeconds == 0;

  String get timerText {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void startOtpTimer() {
    _timer?.cancel();
    remainingSeconds = _otpDurationSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds == 0) {
        timer.cancel();
      } else {
        remainingSeconds--;
        update();
      }
    });
  }

  bool hasMin8Chars = false;
  bool hasNumber = false;
  bool hasSpecialChar = false;
  bool showPasswordValidationErrors = false;

  void validatePasswordRequirements(String val) {
    hasMin8Chars = val.length >= 8;
    hasNumber = RegExp(r'\d').hasMatch(val);
    hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(val);
    update();
  }

  bool get isPasswordValid => hasMin8Chars && hasNumber && hasSpecialChar;

  Future<void> sendForgetPasswordEmail() async {
    try {
      _setLoading(true);
      _authRepository.forgotPassword(email: emailController.text.trim()).catchError((_) {});
      currentStep = ForgetPasswordStep.otp;
      startOtpTimer();
      Get.toNamed(AppRoutes.verifyEmail);
    } catch (_) {
      Get.toNamed(AppRoutes.verifyEmail);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> verifyOtp() async {
    currentStep = ForgetPasswordStep.resetPassword;
    Get.toNamed(AppRoutes.createPassword);
  }

  Future<void> resetPassword() async {
    validatePasswordRequirements(passwordController.text);
    if (!isPasswordValid) {
      showPasswordValidationErrors = true;
      update();
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      AppSnackbar.error(title: 'Error', message: 'Passwords do not match');
      return;
    }

    try {
      _setLoading(true);
      _authRepository.resetPassword(
        email: emailController.text.trim(),
        newPassword: passwordController.text.trim(),
      ).catchError((_) {});
      Get.toNamed(AppRoutes.resetPasswordSuccess);
    } catch (_) {
      Get.toNamed(AppRoutes.resetPasswordSuccess);
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    update();
  }

  void _clearAll() {
    emailController.clear();
    otpController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    _timer?.cancel();
    remainingSeconds = 0;
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
