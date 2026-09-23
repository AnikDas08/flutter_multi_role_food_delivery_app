import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/component/pop_up/common_pop_menu.dart';
import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/features/common/nav_bar/presentation/controller/nav_bar_controller.dart';
import 'package:flutter_code_structure/services/storage/storage_services.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';
import 'package:flutter_code_structure/utils/constants/app_images.dart';
import 'package:flutter_code_structure/features/role/customer/profile/presentation/widgets/rate_app_bottom_sheet.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  bool _notificationEnabled = true;

  @override
  Widget build(BuildContext context) {
    final user = LocalStorage.user;
    final userName = (user != null && user.name.isNotEmpty)
        ? user.name
        : (LocalStorage.myName.isNotEmpty ? LocalStorage.myName : 'Jane Cooper');
    final userEmail = (user != null && user.email.isNotEmpty)
        ? user.email
        : 'jane.cooper@example.com';
    final userImage = (user != null && user.image.isNotEmpty)
        ? user.image
        : (LocalStorage.myImage.isNotEmpty ? LocalStorage.myImage : AppImages.profileImage);

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// 1. Top Bar: Circular Back Button, Centered "My Profile", Circular Notification Bell
            _buildTopBar(context),

            /// 2. Scrollable Profile Body matching customer design screenshot
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  top: 14.h,
                  bottom: bottomPadding > 0 ? bottomPadding + 16.h : 24.h,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 540),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Profile Header: Avatar, Name, Email, Edit Profile, $24.50
                        _buildProfileHeader(userName, userEmail, userImage),

                        SizedBox(height: 22.h),

                        /// Section 1: Personal Info
                        _buildSectionHeader('Personal Info'),
                        SizedBox(height: 8.h),
                        _buildMenuItem(
                          icon: Icons.lock_outline_rounded,
                          title: 'Change Password',
                          onTap: () => Get.toNamed(AppRoutes.changePassword),
                        ),
                        _buildMenuItem(
                          icon: Icons.lock_outline_rounded,
                          title: 'COD Pin Management',
                          onTap: () => Get.toNamed(AppRoutes.codPinManagement),
                        ),
                        _buildMenuItem(
                          icon: Icons.lock_outline_rounded,
                          title: '2-Factor Authentication (2FA)',
                          onTap: () {
                            AppSnackbar.info(
                              title: '2-Factor Authentication',
                              message: 'Two-Factor Authentication is currently active.',
                            );
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.shopping_bag_outlined,
                          title: 'Delivery Address',
                          onTap: () => Get.toNamed(AppRoutes.customerDeliveryAddress),
                        ),
                        _buildMenuItem(
                          icon: Icons.star_outline_rounded,
                          title: 'Rate the App',
                          onTap: () => showRateAppBottomSheet(context),
                        ),
                        _buildMenuItem(
                          icon: Icons.favorite_outline_rounded,
                          title: 'My Favorites',
                          onTap: () => Get.toNamed(AppRoutes.customerFavorites),
                        ),

                        SizedBox(height: 18.h),

                        /// Section 2: Preferences
                        _buildSectionHeader('Preferences'),
                        SizedBox(height: 8.h),
                        _buildNotificationSwitchItem(),

                        SizedBox(height: 18.h),

                        /// Section 3: Support & Help
                        _buildSectionHeader('Support & Help'),
                        SizedBox(height: 8.h),
                        _buildMenuItem(
                          icon: Icons.headset_mic_outlined,
                          title: 'Contact Support',
                          onTap: () => Get.toNamed(AppRoutes.contactSupport),
                        ),

                        SizedBox(height: 18.h),

                        /// Section 4: More
                        _buildSectionHeader('More'),
                        SizedBox(height: 8.h),
                        _buildMenuItem(
                          icon: Icons.description_outlined,
                          title: 'Privacy Policy',
                          onTap: () => Get.toNamed(AppRoutes.privacyPolicy),
                        ),
                        _buildMenuItem(
                          icon: Icons.assignment_outlined,
                          title: 'App Version 1.2.3',
                          onTap: () {
                            AppSnackbar.info(
                              title: 'App Version',
                              message: 'Julio Food Delivery v1.2.3 (Build 108)',
                            );
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.logout_rounded,
                          title: 'Logout',
                          isLogout: true,
                          onTap: () => logOutPopUp(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Top Bar: Back button, "My Profile", Notification bell with red dot
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Row(
        children: [
          /// Circular Back Button
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              HapticFeedback.lightImpact();
              if (Navigator.canPop(context)) {
                Get.back();
              } else if (Get.isRegistered<NavBarController>()) {
                Get.find<NavBarController>().changeIndex(0);
              }
            },
            child: Container(
              width: 42.w.clamp(38.0, 46.0),
              height: 42.w.clamp(38.0, 46.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                  width: 1.2,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16.sp.clamp(14.0, 18.0),
                  color: const Color(0xFF2E0A66),
                ),
              ),
            ),
          ),

          /// Centered Title
          Expanded(
            child: Center(
              child: Text(
                'My Profile',
                style: GoogleFonts.roboto(
                  fontSize: 18.sp.clamp(16.0, 22.0),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2E0A66),
                ),
              ),
            ),
          ),

          /// Right spacer to keep title centered (notification icon removed)
          SizedBox(width: 42.w.clamp(38.0, 46.0)),
        ],
      ),
    );
  }

  /// Profile Header Row: Avatar, Name, Email, "Edit Profile" pill button, "$24.50" pill badge
  Widget _buildProfileHeader(String name, String email, String image) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// Circular Avatar
        ClipOval(
          child: Image.asset(
            AppImages.profileImage,
            width: 66.w.clamp(58.0, 72.0),
            height: 66.w.clamp(58.0, 72.0),
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 66.w,
              height: 66.w,
              color: const Color(0xFFF3E8FF),
              child: const Icon(Icons.person, color: Color(0xFF7C3AED), size: 36),
            ),
          ),
        ),

        SizedBox(width: 14.w),

        /// Name, Email, and Edit Profile Button
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.roboto(
                  fontSize: 17.5.sp.clamp(16.0, 19.5),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2E0A66),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.roboto(
                  fontSize: 12.5.sp.clamp(11.5, 14.0),
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF64748B),
                ),
              ),
              SizedBox(height: 8.h),

              /// "Edit Profile" Dark Purple Pill Button
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  HapticFeedback.lightImpact();
                  Get.toNamed(AppRoutes.customerEditProfile);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E0A66),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'Edit Profile',
                    style: GoogleFonts.roboto(
                      fontSize: 11.5.sp.clamp(10.5, 13.0),
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: 8.w),

        /// "$24.50" Magenta Pill Badge
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            HapticFeedback.lightImpact();
            Get.toNamed(AppRoutes.customerWallet);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.5.h),
            decoration: BoxDecoration(
              color: const Color(0xFFD946EF),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Text(
              '\$24.50',
              style: GoogleFonts.roboto(
                fontSize: 12.5.sp.clamp(11.5, 14.0),
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Section Header
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 2.h),
      child: Text(
        title,
        style: GoogleFonts.roboto(
          fontSize: 13.sp.clamp(12.0, 14.5),
          fontWeight: FontWeight.w500,
          color: const Color(0xFF64748B),
        ),
      ),
    );
  }

  /// Menu Item Tile
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1.2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: Row(
              children: [
                /// Left Icon
                Icon(
                  icon,
                  size: 20.sp.clamp(18.0, 23.0),
                  color: isLogout
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF7C3AED),
                ),

                SizedBox(width: 14.w),

                /// Title Text
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.roboto(
                      fontSize: 13.5.sp.clamp(12.5, 15.0),
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                ),

                /// Trailing Chevron
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14.sp.clamp(12.0, 16.0),
                  color: const Color(0xFF9333EA),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Notification Switch Item
  Widget _buildNotificationSwitchItem() {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          /// Left Bell Icon
          Icon(
            Icons.notifications_none_rounded,
            size: 20.sp.clamp(18.0, 23.0),
            color: const Color(0xFF7C3AED),
          ),

          SizedBox(width: 14.w),

          /// Title Text
          Expanded(
            child: Text(
              'Notification',
              style: GoogleFonts.roboto(
                fontSize: 13.5.sp.clamp(12.5, 15.0),
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1E293B),
              ),
            ),
          ),

          /// Switch Toggle
          Switch(
            value: _notificationEnabled,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF2E0A66),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFE2E8F0),
            onChanged: (val) {
              HapticFeedback.selectionClick();
              setState(() {
                _notificationEnabled = val;
              });
            },
          ),
        ],
      ),
    );
  }
}
