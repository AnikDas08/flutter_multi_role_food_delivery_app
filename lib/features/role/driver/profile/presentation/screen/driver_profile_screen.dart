import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/services.dart';
import 'package:flutter_code_structure/features/common/nav_bar/presentation/controller/nav_bar_controller.dart';
import '../controller/driver_profile_controller.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DriverProfileController());

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            /// 1. Top Bar: Circular Back Button, Centered "My Profile", Right Spacer
            _buildTopBar(context),

            /// 2. Scrollable Body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Profile Header on Left Side (Matching Customer style)
                    _buildProfileHeader(controller),

                    SizedBox(height: 20.h),

                    /// 4. Availability Status Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xFFF1F5F9),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Availability Status',
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'Toggle to go online/offline',
                      style: GoogleFonts.roboto(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Row(
                      children: [
                        Obx(
                          () => Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: controller.isOnline.value
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFF94A3B8),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Obx(
                          () => Text(
                            controller.isOnline.value ? 'Online' : 'Offline',
                            style: GoogleFonts.roboto(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Obx(
                          () => CupertinoSwitch(
                            value: controller.isOnline.value,
                            activeTrackColor: const Color(0xFF10B981),
                            onChanged: controller.toggleAvailability,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 22.h),

              /// 5. Contact Information Section
              Text(
                'Contact Information',
                style: GoogleFonts.roboto(
                  fontSize: 14.5.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E293B),
                ),
              ),

              SizedBox(height: 12.h),

              /// Bank Details Card
              _buildNavCard(
                icon: Icons.account_balance_outlined,
                title: 'Bank Details',
                onTap: controller.onBankDetails,
              ),

              SizedBox(height: 10.h),

              /// Change Password Card
              _buildNavCard(
                icon: Icons.lock_outline_rounded,
                title: 'Change Password',
                onTap: controller.onChangePassword,
              ),

              SizedBox(height: 10.h),

              /// Phone Number Card
              _buildInfoCard(
                icon: Icons.phone_rounded,
                label: 'Phone Number',
                valueObx: controller.phone,
              ),

              SizedBox(height: 10.h),

              /// Email Address Card
              _buildInfoCard(
                icon: Icons.mail_outline_rounded,
                label: 'Email Address',
                valueObx: controller.email,
              ),

              SizedBox(height: 22.h),

              /// 6. Quick Stats Section
              Text(
                'Quick Stats',
                style: GoogleFonts.roboto(
                  fontSize: 14.5.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E293B),
                ),
              ),

              SizedBox(height: 12.h),

              /// Row 1: Total Rides & Acceptance Rate
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      valueObx: controller.totalRides,
                      label: 'Total Rides',
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildStatCard(
                      valueObx: controller.acceptanceRate,
                      label: 'Acceptance Rate',
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              /// Row 2: On-Time Rate (Left-aligned)
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      valueObx: controller.onTimeRate,
                      label: 'On-Time Rate',
                    ),
                  ),
                  SizedBox(width: 12.w),
                  const Expanded(child: SizedBox.shrink()),
                ],
              ),

              SizedBox(height: 24.h),

              /// 7. Support Center Button
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: controller.onSupportCenter,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 13.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: const Color(0xFFF1F5F9),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.headset_mic_outlined,
                        color: const Color(0xFF4C1D95),
                        size: 18.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Support Center',
                        style: GoogleFonts.roboto(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF4C1D95),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              /// 8. Delete Account Button
              GestureDetector(
                onTap: controller.onDeleteAccount,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 13.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F2),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: const Color(0xFFFECDD3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete_outline_rounded,
                        color: const Color(0xFFE11D48),
                        size: 18.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Delete Account',
                        style: GoogleFonts.roboto(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFE11D48),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              /// 9. Logout Button
              GestureDetector(
                onTap: controller.onLogout,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 13.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout_rounded,
                        color: const Color(0xFFEF4444),
                        size: 18.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Logout',
                        style: GoogleFonts.roboto(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFEF4444),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
          ],
        ),
      ),
    );
  }

  /// Top Bar: Back button, "My Profile", balanced spacer
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

          /// Right spacer to keep title centered
          SizedBox(width: 42.w.clamp(38.0, 46.0)),
        ],
      ),
    );
  }

  /// Profile Header Row: Avatar on Left Side, Driver Name, ID, Rating/Rides, Edit Profile Button
  Widget _buildProfileHeader(DriverProfileController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// Circular Avatar with Online Badge on the Left
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 68.w.clamp(60.0, 76.0),
              height: 68.w.clamp(60.0, 76.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                  width: 1.5,
                ),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?fit=crop&w=300&q=80',
                  ),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
            Obx(
              () => controller.isOnline.value
                  ? Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 18.w,
                        height: 18.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2.w,
                          ),
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 11.sp,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),

        SizedBox(width: 14.w),

        /// Name, ID, Rating/Rides, and Edit Profile Button (All on the Left)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Text(
                  controller.driverName.value,
                  style: GoogleFonts.roboto(
                    fontSize: 17.5.sp.clamp(16.0, 19.5),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E293B),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Obx(
                () => Text(
                  'Driver ID: ${controller.driverId.value}',
                  style: GoogleFonts.roboto(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star_rounded,
                    color: const Color(0xFFF59E0B),
                    size: 15.sp,
                  ),
                  SizedBox(width: 3.w),
                  Obx(
                    () => Text(
                      controller.rating.value.toStringAsFixed(1),
                      style: GoogleFonts.roboto(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF4C1D95),
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Obx(
                    () => Text(
                      '(${controller.ridesCount.value} rides)',
                      style: GoogleFonts.roboto(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),

              /// "Edit Profile" Dark Purple Pill Button
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: controller.onEditProfile,
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

        /// Online Status Badge (Matching Customer Profile's right badge)
        Obx(() {
          final isOnline = controller.isOnline.value;
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: isOnline ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isOnline ? const Color(0xFFA7F3D0) : const Color(0xFFFECDD3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    color: isOnline ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  isOnline ? 'Online' : 'Offline',
                  style: GoogleFonts.roboto(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w600,
                    color: isOnline ? const Color(0xFF047857) : const Color(0xFFB91C1C),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildNavCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: const Color(0xFFF1F5F9),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF6B21A8),
              size: 20.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.roboto(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: const Color(0xFFA855F7),
              size: 22.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required RxString valueObx,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF3E8FF),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF6B21A8),
              size: 18.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.roboto(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF64748B),
                  ),
                ),
                SizedBox(height: 2.h),
                Obx(
                  () => Text(
                    valueObx.value,
                    style: GoogleFonts.roboto(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required RxString valueObx,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Obx(
            () => Text(
              valueObx.value,
              style: GoogleFonts.roboto(
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1E293B),
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}
