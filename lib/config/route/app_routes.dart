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
import 'package:flutter_code_structure/features/role/marchant/dashboard/presentation/screen/merchant_dashboard_screen.dart';
import 'package:flutter_code_structure/features/role/marchant/cod_liability/presentation/screen/cod_liability_screen.dart';
import 'package:flutter_code_structure/features/role/marchant/cod_liability/presentation/screen/request_settlement_screen.dart';
import 'package:flutter_code_structure/features/role/marchant/cod_liability/presentation/screen/settlement_success_screen.dart';
import 'package:flutter_code_structure/features/role/marchant/orders/presentation/screen/merchant_order_details_screen.dart';
import 'package:flutter_code_structure/features/role/marchant/orders/presentation/screen/driver_tracking_screen.dart';
import 'package:flutter_code_structure/features/role/marchant/menu/presentation/screen/add_edit_menu_screen.dart';
import 'package:flutter_code_structure/features/role/marchant/drivers/presentation/screen/merchant_drivers_screen.dart';
import 'package:flutter_code_structure/features/role/marchant/drivers/presentation/screen/merchant_add_driver_screen.dart';
import 'package:flutter_code_structure/features/role/marchant/profile/presentation/screen/merchant_profile_screen.dart';
import 'package:flutter_code_structure/features/role/marchant/profile/presentation/screen/merchant_edit_profile_screen.dart';
import 'package:flutter_code_structure/features/role/marchant/profile/presentation/screen/merchant_business_info_screen.dart';
import 'package:flutter_code_structure/features/role/driver/dashboard/presentation/screen/driver_dashboard_screen.dart';
import 'package:flutter_code_structure/features/role/driver/orders/presentation/screen/driver_order_details_screen.dart';
import 'package:flutter_code_structure/features/role/driver/earnings/presentation/screen/driver_withdraw_funds_screen.dart';
import 'package:flutter_code_structure/features/role/driver/earnings/presentation/screen/withdrawal_not_possible_screen.dart';
import 'package:flutter_code_structure/features/role/driver/earnings/presentation/screen/confirm_withdrawal_screen.dart';
import 'package:flutter_code_structure/features/role/driver/earnings/presentation/screen/withdrawal_success_screen.dart';
import 'package:flutter_code_structure/features/role/driver/earnings/presentation/screen/driver_remit_cod_liability_screen.dart';
import 'package:flutter_code_structure/features/role/driver/earnings/presentation/screen/bank_transfer_detail_screen.dart';
import 'package:flutter_code_structure/features/role/driver/profile/presentation/screen/driver_profile_screen.dart';
import 'package:flutter_code_structure/features/role/driver/profile/presentation/screen/driver_edit_profile_screen.dart';
import 'package:flutter_code_structure/features/role/driver/profile/presentation/screen/driver_linked_accounts_screen.dart';
import 'package:flutter_code_structure/features/role/driver/profile/presentation/screen/add_bank_account_screen.dart';
import 'package:flutter_code_structure/features/role/driver/profile/presentation/screen/account_verification_screen.dart';
import 'package:flutter_code_structure/features/role/customer/dashboard/presentation/screen/customer_dashboard_screen.dart';
import 'package:flutter_code_structure/features/role/customer/wallet/presentation/screen/customer_wallet_screen.dart';
import 'package:flutter_code_structure/features/role/customer/wallet/presentation/screen/customer_wallet_activity_screen.dart';
import 'package:flutter_code_structure/features/role/customer/orders/presentation/screen/customer_orders_screen.dart';
import 'package:flutter_code_structure/features/role/customer/cart/presentation/screen/customer_cart_screen.dart';
import 'package:flutter_code_structure/features/role/customer/dashboard/presentation/screen/popular_items_screen.dart';
import 'package:flutter_code_structure/features/role/customer/dashboard/presentation/screen/popular_item_details_screen.dart';
import 'package:flutter_code_structure/features/role/customer/dashboard/presentation/screen/popular_restaurants_screen.dart';
import 'package:flutter_code_structure/features/role/customer/dashboard/presentation/screen/restaurant_details_screen.dart';
import 'package:flutter_code_structure/features/role/customer/dashboard/presentation/screen/search_screen.dart';
import 'package:flutter_code_structure/features/role/customer/checkout/presentation/screen/order_confirmation_screen.dart';
import 'package:flutter_code_structure/features/role/customer/orders/presentation/screen/customer_order_details_screen.dart';
import 'package:flutter_code_structure/features/role/customer/orders/presentation/screen/share_review_screen.dart';
import 'package:flutter_code_structure/features/role/customer/orders/presentation/screen/customer_live_tracking_screen.dart';
import 'package:flutter_code_structure/features/role/customer/profile/presentation/screen/customer_profile_screen.dart';
import 'package:flutter_code_structure/features/role/customer/profile/presentation/screen/customer_edit_profile_screen.dart';
import 'package:flutter_code_structure/features/role/customer/profile/presentation/screen/cod_pin_management_screen.dart';
import 'package:flutter_code_structure/features/role/customer/profile/presentation/screen/customer_delivery_address_screen.dart';
import 'package:flutter_code_structure/features/role/customer/profile/presentation/screen/customer_favorites_screen.dart';
import 'package:flutter_code_structure/features/role/customer/profile/presentation/screen/contact_support_screen.dart';
import 'package:flutter_code_structure/features/common/privacy_policy/screen/privacy_policy_screen.dart';

class AppRoutes {
  static const String test = '/test_screen.dart';
  static const String splash = '/';
  static const String shareReview = '/share_review_screen.dart';
  static const String customerLiveTracking = '/customer_live_tracking_screen.dart';
  static const String customerProfile = '/customer_profile_screen.dart';
  static const String customerEditProfile = '/customer_edit_profile_screen.dart';
  static const String codPinManagement = '/cod_pin_management_screen.dart';
  static const String customerDeliveryAddress = '/customer_delivery_address_screen.dart';
  static const String customerFavorites = '/customer_favorites_screen.dart';
  static const String contactSupport = '/contact_support_screen.dart';
  static const String customerDashboard = '/customer_dashboard_screen.dart';
  static const String customerWallet = '/customer_wallet_screen.dart';
  static const String customerWalletActivity = '/customer_wallet_activity_screen.dart';
  static const String customerOrders = '/customer_orders_screen.dart';
  static const String customerOrderDetails = '/customer_order_details_screen.dart';
  static const String customerCart = '/customer_cart_screen.dart';
  static const String orderConfirmation = '/order_confirmation_screen.dart';
  static const String popularItems = '/popular_items_screen.dart';
  static const String popularItemDetails = '/popular_item_details_screen.dart';
  static const String search = '/search_screen.dart';
  static const String popularRestaurants = '/popular_restaurants_screen.dart';
  static const String restaurantDetails = '/restaurant_details_screen.dart';
  static const String popularShops = '/popular_shops_screen.dart';
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
  static const String merchantAddDriver = '/merchant_add_driver_screen.dart';
  static const String merchantProfile = '/merchant_profile_screen.dart';
  static const String merchantEditProfile = '/merchant_edit_profile_screen.dart';
  static const String merchantBusinessInfo = '/merchant_business_info_screen.dart';
  static const String driverDashboard = '/driver_dashboard_screen.dart';
  static const String driverOrderDetails = '/driver_order_details_screen.dart';
  static const String driverWithdrawFunds = '/driver_withdraw_funds_screen.dart';
  static const String withdrawalNotPossible = '/withdrawal_not_possible_screen.dart';
  static const String confirmWithdrawal = '/confirm_withdrawal_screen.dart';
  static const String driverWithdrawalSuccess = '/withdrawal_success_screen.dart';
  static const String driverRemitCodLiability = '/driver_remit_cod_liability_screen.dart';
  static const String bankTransferDetail = '/bank_transfer_detail_screen.dart';
  static const String driverProfile = '/driver_profile_screen.dart';
  static const String driverEditProfile = '/driver_edit_profile_screen.dart';
  static const String driverLinkedAccounts = '/driver_linked_accounts_screen.dart';
  static const String addBankAccount = '/add_bank_account_screen.dart';
  static const String accountVerification = '/account_verification_screen.dart';
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
    GetPage(name: changePassword, page: () => const ChangePasswordScreen()),
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
    GetPage(name: merchantAddDriver, page: () => const MerchantAddDriverScreen()),
    GetPage(name: merchantProfile, page: () => const MerchantProfileScreen()),
    GetPage(name: merchantEditProfile, page: () => const MerchantEditProfileScreen()),
    GetPage(name: merchantBusinessInfo, page: () => const MerchantBusinessInfoScreen()),
    GetPage(name: driverDashboard, page: () => const DriverDashboardScreen()),
    GetPage(name: driverOrderDetails, page: () => const DriverOrderDetailsScreen()),
    GetPage(name: driverWithdrawFunds, page: () => const DriverWithdrawFundsScreen()),
    GetPage(name: withdrawalNotPossible, page: () => const WithdrawalNotPossibleScreen()),
    GetPage(name: confirmWithdrawal, page: () => const ConfirmWithdrawalScreen()),
    GetPage(name: driverWithdrawalSuccess, page: () => const WithdrawalSuccessScreen()),
    GetPage(name: driverRemitCodLiability, page: () => const DriverRemitCodLiabilityScreen()),
    GetPage(name: bankTransferDetail, page: () => const BankTransferDetailScreen()),
    GetPage(name: driverProfile, page: () => const DriverProfileScreen()),
    GetPage(name: driverEditProfile, page: () => const DriverEditProfileScreen()),
    GetPage(name: driverLinkedAccounts, page: () => const DriverLinkedAccountsScreen()),
    GetPage(name: addBankAccount, page: () => const AddBankAccountScreen()),
    GetPage(name: accountVerification, page: () => const AccountVerificationScreen()),
    GetPage(name: customerDashboard, page: () => const CustomerDashboardScreen()),
    GetPage(name: customerWallet, page: () => const CustomerWalletScreen()),
    GetPage(name: customerWalletActivity, page: () => const CustomerWalletActivityScreen()),
    GetPage(name: customerOrders, page: () => const CustomerOrdersScreen()),
    GetPage(name: customerOrderDetails, page: () => const CustomerOrderDetailsScreen()),
    GetPage(name: customerCart, page: () => const CustomerCartScreen()),
    GetPage(name: orderConfirmation, page: () => const OrderConfirmationScreen()),
    GetPage(name: popularItems, page: () => const PopularItemsScreen()),
    GetPage(name: popularItemDetails, page: () => const PopularItemDetailsScreen()),
    GetPage(name: popularRestaurants, page: () => const PopularRestaurantsScreen(title: 'Popular Restaurants', isShop: false)),
    GetPage(name: restaurantDetails, page: () => const RestaurantDetailsScreen()),
    GetPage(name: popularShops, page: () => const PopularRestaurantsScreen(title: 'PlomoShop', isShop: true)),
    GetPage(name: search, page: () => const SearchScreen()),
    GetPage(name: shareReview, page: () => const ShareReviewScreen()),
    GetPage(name: customerLiveTracking, page: () => const CustomerLiveTrackingScreen()),
    GetPage(name: customerProfile, page: () => const CustomerProfileScreen()),
    GetPage(name: customerEditProfile, page: () => const CustomerEditProfileScreen()),
    GetPage(name: codPinManagement, page: () => const CodPinManagementScreen()),
    GetPage(name: customerDeliveryAddress, page: () => const CustomerDeliveryAddressScreen()),
    GetPage(name: customerFavorites, page: () => const CustomerFavoritesScreen()),
    GetPage(name: contactSupport, page: () => const ContactSupportScreen()),
    GetPage(name: privacyPolicy, page: () => const PrivacyPolicyScreen()),
  ];
}
