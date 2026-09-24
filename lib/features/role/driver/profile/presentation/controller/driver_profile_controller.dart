import 'package:get/get.dart';
import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/component/pop_up/common_pop_menu.dart';
import 'package:flutter_code_structure/services/storage/storage_services.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';

class DriverProfileController extends GetxController {
  final RxBool isOnline = true.obs;

  final RxString driverName = 'Michael Rodriguez'.obs;
  final RxString driverId = 'D384728'.obs;
  final RxDouble rating = 4.9.obs;
  final RxInt ridesCount = 324.obs;

  final RxString phone = '+1 (555) 123-4567'.obs;
  final RxString email = 'michael.rodriguez@email.com'.obs;

  final RxString totalRides = '324'.obs;
  final RxString acceptanceRate = '98%'.obs;
  final RxString onTimeRate = '99%'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadProfileData();
  }

  void _loadProfileData() {
    final user = LocalStorage.user;
    if (user != null && user.name.isNotEmpty) {
      driverName.value = user.name;
    } else if (LocalStorage.myName.isNotEmpty) {
      driverName.value = LocalStorage.myName;
    }

    if (user != null && user.email.isNotEmpty) {
      email.value = user.email;
    } else if (LocalStorage.myEmail.isNotEmpty) {
      email.value = LocalStorage.myEmail;
    }
  }

  void toggleAvailability(bool value) {
    isOnline.value = value;
    AppSnackbar.success(
      title: value ? 'You are Online' : 'You are Offline',
      message: value
          ? 'You will now receive ride and order requests'
          : 'You will not receive new order requests while offline',
    );
  }

  void onEditProfile() {
    Get.toNamed(AppRoutes.driverEditProfile);
  }

  void onBankDetails() {
    Get.toNamed(AppRoutes.driverLinkedAccounts);
  }

  void onAccountDetails() {
    Get.toNamed(AppRoutes.driverLinkedAccounts);
  }

  void onChangePassword() {
    Get.toNamed(AppRoutes.changePassword);
  }

  void onSupportCenter() {
    Get.toNamed(AppRoutes.contactSupport);
  }

  void onDeleteAccount() {
    showDeleteAccountPopUp();
  }

  void onLogout() {
    logOutPopUp();
  }
}
