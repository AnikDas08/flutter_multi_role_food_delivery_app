import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../services/storage/storage_services.dart';
import 'package:flutter_code_structure/features/role/marchant/dashboard/presentation/screen/merchant_dashboard_screen.dart';
import 'package:flutter_code_structure/features/role/marchant/drivers/presentation/screen/merchant_drivers_screen.dart';
import 'package:flutter_code_structure/features/role/marchant/menu/presentation/screen/merchant_menu_screen.dart';
import 'package:flutter_code_structure/features/role/marchant/orders/presentation/screen/merchant_orders_screen.dart';
import 'package:flutter_code_structure/features/role/marchant/profile/presentation/screen/merchant_profile_screen.dart';
import '../../../../profile/presentation/screen/profile_screen.dart';
import 'package:flutter_code_structure/features/role/driver/dashboard/presentation/screen/driver_dashboard_screen.dart';
import 'package:flutter_code_structure/features/role/driver/orders/presentation/screen/driver_orders_screen.dart';
import 'package:flutter_code_structure/features/role/driver/earnings/presentation/screen/driver_earnings_screen.dart';
import 'package:flutter_code_structure/features/role/driver/profile/presentation/screen/driver_profile_screen.dart';
import '../../../../../utils/constants/app_icons.dart';

import 'package:flutter_code_structure/features/role/customer/cart/presentation/screen/customer_cart_screen.dart';
import 'package:flutter_code_structure/features/role/customer/dashboard/presentation/screen/customer_dashboard_screen.dart';
import 'package:flutter_code_structure/features/role/customer/orders/presentation/screen/customer_orders_screen.dart';
import 'package:flutter_code_structure/features/role/customer/profile/presentation/screen/customer_profile_screen.dart';
import 'package:flutter_code_structure/features/role/customer/wallet/presentation/screen/customer_wallet_screen.dart';

class NavItemData {
  final String label;
  final String? iconPath;
  final IconData? iconData;

  const NavItemData({
    required this.label,
    this.iconPath,
    this.iconData,
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
        NavItemData(label: 'Orders', iconPath: AppIcons.boxOrderIcon),
        NavItemData(label: 'Earnings', iconPath: AppIcons.walletIcon),
        NavItemData(label: 'Profile', iconPath: AppIcons.profileIcon),
      ];
    } else {
      return const [
        NavItemData(label: 'Home', iconPath: AppIcons.homeIcon),
        NavItemData(label: 'Wallet', iconPath: AppIcons.walletIcon),
        NavItemData(label: 'Orders', iconPath: AppIcons.boxOrderIcon),
        NavItemData(label: 'My Cart', iconData: Icons.shopping_cart_outlined),
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
        MerchantProfileScreen(),
      ];
    } else if (isDriver) {
      return const [
        DriverDashboardScreen(),
        DriverOrdersScreen(),
        DriverEarningsScreen(),
        DriverProfileScreen(),
      ];
    } else {
      return const [
        CustomerDashboardScreen(),
        CustomerWalletScreen(),
        CustomerOrdersScreen(),
        CustomerCartScreen(),
        CustomerProfileScreen(),
      ];
    }
  }
}
