import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/component/pop_up/common_pop_menu.dart';
import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/features/common/nav_bar/presentation/controller/nav_bar_controller.dart';
import 'package:flutter_code_structure/features/role/customer/profile/presentation/widgets/rate_app_bottom_sheet.dart';
import 'package:flutter_code_structure/services/storage/storage_services.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';

class MerchantProfileScreen extends StatefulWidget {
  const MerchantProfileScreen({super.key});

  @override
  State<MerchantProfileScreen> createState() => _MerchantProfileScreenState();
}

class _MerchantProfileScreenState extends State<MerchantProfileScreen> {
  bool _notificationEnabled = true;

  void _onBackPress() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      try {
        final navCtrl = Get.find<NavBarController>();
        navCtrl.changeIndex(0);
      } catch (_) {
        Get.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// 1. Top Bar: Back Button & Centered "My Profile"
            _buildTopBar(),

            /// 2. Scrollable Profile Body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  top: 14.h,
                  bottom: bottomPadding > 0 ? bottomPadding + 20.h : 24.h,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 540),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Profile Header: Avatar, Name, Merchant ID, Edit Profile (NO taka badge)
                        _buildProfileHeader(),

                        SizedBox(height: 24.h),

                        /// Section 1: Personal Info
                        _buildSectionHeader('Personal Info'),
                        SizedBox(height: 10.h),
                        _buildCardItem(
                          icon: Icons.lock_outline_rounded,
                          title: 'Change Password',
                          onTap: () => Get.toNamed(AppRoutes.changePassword),
                        ),
                        SizedBox(height: 10.h),
                        _buildCardItem(
                          icon: Icons.lock_outline_rounded,
                          title: 'Business Info',
                          onTap: () => Get.toNamed(AppRoutes.merchantBusinessInfo),
                        ),
                        SizedBox(height: 10.h),
                        _buildCardItem(
                          icon: Icons.lock_outline_rounded,
                          title: 'Rate the App',
                          onTap: () => showRateAppBottomSheet(context),
                        ),

                        SizedBox(height: 22.h),

                        /// Section 2: Preferences
                        _buildSectionHeader('Preferences'),
                        SizedBox(height: 10.h),
                        _buildNotificationCard(),

                        SizedBox(height: 22.h),

                        /// Section 3: More
                        _buildSectionHeader('More'),
                        SizedBox(height: 10.h),
                        _buildCardItem(
                          icon: Icons.assignment_outlined,
                          title: 'Privacy Policy',
                          onTap: () => Get.toNamed(AppRoutes.privacyPolicy),
                        ),
                        SizedBox(height: 10.h),
                        _buildCardItem(
                          icon: Icons.assignment_outlined,
                          title: 'App Version 1.2.3',
                          onTap: () {
                            AppSnackbar.info(
                              title: 'App Version',
                              message: 'You are using the latest version (1.2.3)',
                            );
                          },
                        ),
                        SizedBox(height: 10.h),
                        _buildCardItem(
                          icon: Icons.logout_rounded,
                          iconColor: const Color(0xFFEF4444),
                          title: 'Logout',
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

  /// 1. Top Bar: Circular Back Button, Centered Title
  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _onBackPress,
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
          SizedBox(width: 42.w.clamp(38.0, 46.0)),
        ],
      ),
    );
  }

  /// 2. Profile Header: Avatar, Name, Merchant ID, Edit Profile (without money/taka badge)
  Widget _buildProfileHeader() {
    final user = LocalStorage.user;
    final displayName = (user != null && user.name.isNotEmpty)
        ? user.name
        : (LocalStorage.myName.isNotEmpty ? LocalStorage.myName : 'Alex Johnson');

    return Row(
      children: [
        /// Circular Profile Avatar
        Container(
          width: 82.w.clamp(74.0, 90.0),
          height: 82.w.clamp(74.0, 90.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFF1F5F9), width: 2),
            image: const DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?fit=crop&w=300&q=80',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),

        SizedBox(width: 16.w),

        /// Name, ID, and Edit Profile Button
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayName,
                style: GoogleFonts.roboto(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2E0A66),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Merchant ID: #MER789012',
                style: GoogleFonts.roboto(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF475569),
                ),
              ),
              SizedBox(height: 10.h),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  HapticFeedback.lightImpact();
                  Get.toNamed(AppRoutes.merchantEditProfile);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 7.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E0A66),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Text(
                    'Edit Profile',
                    style: GoogleFonts.roboto(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Section Header
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.roboto(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF64748B),
      ),
    );
  }

  /// Generic Profile Menu Card
  Widget _buildCardItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        height: 52.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.1),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20.sp,
              color: iconColor ?? const Color(0xFF7C3AED),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 22.sp,
              color: const Color(0xFFD946EF),
            ),
          ],
        ),
      ),
    );
  }

  /// Notification Preferences Card with Cupertino Switch
  Widget _buildNotificationCard() {
    return Container(
      height: 52.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: 20.sp,
            color: const Color(0xFF7C3AED),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              'Notification',
              style: GoogleFonts.roboto(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1E293B),
              ),
            ),
          ),
          Transform.scale(
            scale: 0.82,
            child: CupertinoSwitch(
              value: _notificationEnabled,
              activeColor: const Color(0xFF2E0A66),
              onChanged: (val) {
                setState(() => _notificationEnabled = val);
                AppSnackbar.success(
                  title: 'Notification',
                  message: val
                      ? 'Notifications enabled'
                      : 'Notifications disabled',
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showBusinessInfoModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Business Information',
                  style: GoogleFonts.roboto(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2E0A66),
                  ),
                ),
                SizedBox(height: 12.h),
                _buildInfoRow('Store Name', 'Burger King #402'),
                _buildInfoRow('Registration No.', 'REG-839210-BK'),
                _buildInfoRow('Address', '124 Market Street, Suite 400'),
                _buildInfoRow('Contact', '+1 (555) 392-1049'),
                SizedBox(height: 14.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 13.sp,
              color: const Color(0xFF64748B),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.roboto(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}
