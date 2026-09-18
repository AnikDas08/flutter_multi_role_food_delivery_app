import 'package:get/get.dart';

import 'package:flutter_code_structure/features/common/auth/presentation/change_password/screen/change_password_screen.dart';
import 'package:flutter_code_structure/features/common/auth/presentation/forgot_password/screen/create_password.dart';
import 'package:flutter_code_structure/features/common/auth/presentation/forgot_password/screen/forgot_password.dart';
import 'package:flutter_code_structure/features/common/auth/presentation/forgot_password/screen/password_reset_success.dart';
import 'package:flutter_code_structure/features/common/auth/presentation/forgot_password/screen/verify_screen.dart';
import 'package:flutter_code_structure/features/common/auth/presentation/sign_in/screen/sign_in_screen.dart';
import 'package:flutter_code_structure/features/common/auth/presentation/sign_up/screen/sign_up_screen.dart';
import 'package:flutter_code_structure/features/common/auth/presentation/sign_up/screen/verify_user.dart';
import 'package:flutter_code_structure/features/message/presentation/chat_list/screen/chat_screen.dart';
import 'package:flutter_code_structure/features/message/presentation/message_details/screen/message_screen.dart';
import '../../features/notifications/presentation/screen/notifications_screen.dart';
import 'package:flutter_code_structure/features/common/onboarding_screen/onboarding_screen.dart';
import '../../features/profile/presentation/screen/edit_profile.dart';
import '../../features/profile/presentation/screen/profile_screen.dart';
import 'package:flutter_code_structure/features/common/role_selection/screen/role_selection_screen.dart';
import 'package:flutter_code_structure/features/common/splash/splash_screen.dart';
import 'package:flutter_code_structure/features/common/nav_bar/presentation/screen/main_nav_bar_screen.dart';
import 'package:flutter_code_structure/features/marchant/dashboard/presentation/screen/merchant_dashboard_screen.dart';
import 'package:flutter_code_structure/features/marchant/cod_liability/presentation/screen/cod_liability_screen.dart';
import 'package:flutter_code_structure/features/marchant/cod_liability/presentation/screen/request_settlement_screen.dart';
import 'package:flutter_code_structure/features/marchant/cod_liability/presentation/screen/settlement_success_screen.dart';
import 'package:flutter_code_structure/features/marchant/orders/presentation/screen/merchant_order_details_screen.dart';
import 'package:flutter_code_structure/features/marchant/orders/presentation/screen/driver_tracking_screen.dart';
import 'package:flutter_code_structure/features/marchant/menu/presentation/screen/add_edit_menu_screen.dart';
import 'package:flutter_code_structure/features/marchant/drivers/presentation/screen/merchant_drivers_screen.dart';

class AppRoutes {
  static const String test = '/test_screen.dart';
  static const String splash = '/';
  static const String onboarding = '/onboarding_screen.dart';
  static const String roleSelection = '/role_selection_screen.dart';
  static const String mainNavBar = '/main_nav_bar_screen.dart';
  static const String merchantDashboard = '/merchant_dashboard_screen.dart';
  static const String codLiability = '/cod_liability_screen.dart';
  static const String requestSettlement = '/request_settlement_screen.dart';
  static const String settlementSuccess = '/settlement_success_screen.dart';
  static const String merchantOrderDetails = '/merchant_order_details_screen.dart';
  static const String driverTracking = '/driver_tracking_screen.dart';
  static const String addEditMenu = '/add_edit_menu_screen.dart';
  static const String merchantDrivers = '/merchant_drivers_screen.dart';
  static const String signUp = '/sign_up_screen.dart';
  static const String verifyUser = '/verify_user.dart';
  static const String signIn = '/sign_in_screen.dart';
  static const String forgotPassword = '/forgot_password.dart';
  static const String verifyEmail = '/verify_screen.dart';
  static const String createPassword = '/create_password.dart';
  static const String changePassword = '/change_password_screen.dart';
  static const String notifications = '/notifications_screen.dart';
  static const String chat = '/chat_screen.dart';
  static const String message = '/message_screen.dart';
  static const String profile = '/profile_screen.dart';
  static const String editProfile = '/edit_profile.dart';
  static const String privacyPolicy = '/privacy_policy_screen.dart';
  static const String termsOfServices = '/terms_of_services_screen.dart';
  static const String setting = '/setting_screen.dart';
  static const String resetPasswordSuccess = '/password_reset_success.dart';

  static List<GetPage<String>> routes = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: onboarding, page: () => const OnboardingScreen()),
    GetPage(name: roleSelection, page: () => const RoleSelectionScreen()),
    GetPage(name: signUp, page: () => SignUpScreen()),
    GetPage(name: verifyUser, page: () => const VerifyUser()),
    GetPage(name: signIn, page: () => SignInScreen()),
    GetPage(name: forgotPassword, page: () => ForgotPasswordScreen()),
    GetPage(name: verifyEmail, page: () => VerifyScreen()),
    GetPage(name: createPassword, page: () => CreatePassword()),
    GetPage(name: resetPasswordSuccess, page: () => const PasswordResetSuccessScreen()),
    GetPage(name: changePassword, page: () => ChangePasswordScreen()),
    GetPage(name: notifications, page: () => const NotificationScreen()),
    GetPage(name: chat, page: () => const ChatListScreen()),
    GetPage(name: message, page: () => const MessageScreen()),
    GetPage(name: profile, page: () => const ProfileScreen()),
    GetPage(name: editProfile, page: () => EditProfile()),
    GetPage(name: mainNavBar, page: () => const MainNavBarScreen()),
    GetPage(name: merchantDashboard, page: () => const MerchantDashboardScreen()),
    GetPage(name: codLiability, page: () => const CodLiabilityScreen()),
    GetPage(name: requestSettlement, page: () => const RequestSettlementScreen()),
    GetPage(name: settlementSuccess, page: () => const SettlementSuccessScreen()),
    GetPage(name: merchantOrderDetails, page: () => const MerchantOrderDetailsScreen()),
    GetPage(name: driverTracking, page: () => const DriverTrackingScreen()),
    GetPage(name: addEditMenu, page: () => const AddEditMenuScreen()),
    GetPage(name: merchantDrivers, page: () => const MerchantDriversScreen()),
  ];
}
