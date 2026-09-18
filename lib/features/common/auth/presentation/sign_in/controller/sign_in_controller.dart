import 'package:flutter/material.dart';
import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/features/common/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_code_structure/features/common/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_code_structure/features/common/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_code_structure/services/storage/storage_services.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  final AuthRepository _authRepository;

  SignInController({AuthRepository? authRepository})
      : _authRepository = authRepository ??
            AuthRepositoryImpl(
              remoteDataSource: AuthRemoteDataSourceImpl(),
            );

  bool isLoading = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

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

  final RxBool rememberMe = true.obs;
  final RxString role = 'Customer'.obs;

  @override
  void onInit() {
    super.onInit();
    initRole();
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

  Future<void> signInUser() async {
    if (isLoading) return;

    final selectedRole = role.value.trim().toLowerCase();
    await LocalStorage.setRole(selectedRole);

    Get.offAllNamed(AppRoutes.mainNavBar);
    return;

    try {
      isLoading = true;
      update();

      await _authRepository.signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      emailController.clear();
      passwordController.clear();

      LocalStorage.setRole(role.value.toLowerCase());
    } catch (e) {
      AppSnackbar.error(
        title: 'Sign In Failed',
        message: e.toString().replaceAll('Exception: ', ''),
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
