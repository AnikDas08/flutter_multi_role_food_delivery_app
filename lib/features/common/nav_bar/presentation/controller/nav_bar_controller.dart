import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../services/storage/storage_services.dart';
import '../../../../marchant/dashboard/presentation/screen/merchant_dashboard_screen.dart';
import '../../../../marchant/drivers/presentation/screen/merchant_drivers_screen.dart';
import '../../../../marchant/menu/presentation/screen/merchant_menu_screen.dart';
import '../../../../marchant/orders/presentation/screen/merchant_orders_screen.dart';
import '../../../../profile/presentation/screen/profile_screen.dart';
import '../../../../../utils/constants/app_icons.dart';

class NavItemData {
  final String label;
  final String iconPath;

  const NavItemData({
    required this.label,
    required this.iconPath,
  });
}

class NavBarController extends GetxController {
  static NavBarController get instance => Get.find<NavBarController>();

  final RxInt currentIndex = 0.obs;
  final RxString userRole = ''.obs;

  @override
  void onInit() {
    super.onInit();
    refreshRole();
  }

  void refreshRole() {
    userRole.value = LocalStorage.myRole.trim().toLowerCase();
  }

  String get currentRole {
    final role = userRole.value.isNotEmpty
        ? userRole.value
        : LocalStorage.myRole.trim().toLowerCase();
    if (role == 'driver') return 'driver';
    if (role == 'merchant' || role == 'marchant') return 'merchant';
    return 'customer';
  }

  bool get isMerchant => currentRole == 'merchant';
  bool get isDriver => currentRole == 'driver';
  bool get isCustomer => currentRole == 'customer';

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  List<NavItemData> get navItems {
    if (isMerchant) {
      return const [
        NavItemData(label: 'Dashboard', iconPath: AppIcons.homeIcon),
        NavItemData(label: 'Orders', iconPath: AppIcons.orderIcon),
        NavItemData(label: 'Menu', iconPath: AppIcons.menuIcon),
        NavItemData(label: 'Drivers', iconPath: AppIcons.driverIcon),
        NavItemData(label: 'Profile', iconPath: AppIcons.profileIcon),
      ];
    } else if (isDriver) {
      return const [
        NavItemData(label: 'Dashboard', iconPath: AppIcons.homeIcon),
        NavItemData(label: 'Orders', iconPath: AppIcons.orderIcon),
        NavItemData(label: 'Profile', iconPath: AppIcons.profileIcon),
      ];
    } else {
      return const [
        NavItemData(label: 'Home', iconPath: AppIcons.homeIcon),
        NavItemData(label: 'Orders', iconPath: AppIcons.orderIcon),
        NavItemData(label: 'Profile', iconPath: AppIcons.profileIcon),
      ];
    }
  }

  List<Widget> get screens {
    if (isMerchant) {
      return const [
        MerchantDashboardScreen(),
        MerchantOrdersScreen(),
        MerchantMenuScreen(),
        MerchantDriversScreen(),
        ProfileScreen(),
      ];
    } else if (isDriver) {
      return const [
        MerchantDashboardScreen(),
        MerchantOrdersScreen(),
        ProfileScreen(),
      ];
    } else {
      return const [
        MerchantDashboardScreen(),
        MerchantOrdersScreen(),
        ProfileScreen(),
      ];
    }
  }
}
