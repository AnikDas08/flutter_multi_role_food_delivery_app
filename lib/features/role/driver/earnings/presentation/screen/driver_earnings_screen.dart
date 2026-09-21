import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/utils/constants/app_icons.dart';
import '../controller/driver_earnings_controller.dart';
import '../widgets/driver_balance_card.dart';
import '../widgets/driver_cod_liability_card.dart';
import '../widgets/driver_this_month_card.dart';

class DriverEarningsScreen extends StatelessWidget {
  const DriverEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<DriverEarningsController>()
        ? Get.find<DriverEarningsController>()
        : Get.put(DriverEarningsController());

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFD),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// 1. Top Header: Centered "Earnings" + Notification Bell on Right
              _buildHeader(),

              SizedBox(height: 20.h),

              /// 2. Total Balance & Available for withdrawal Card
              DriverBalanceCard(controller: controller),

              SizedBox(height: 16.h),

              /// 3. "Withdraw Funds" Button
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: () => controller.onWithdrawFunds(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E0A66),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Withdraw Funds',
                    style: GoogleFonts.roboto(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 14.h),

              /// 4. Subtitle
              Text(
                'Withdraw to your linked bank account\ninstantly or collect at office.',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF64748B),
                  height: 1.45,
                ),
              ),

              SizedBox(height: 24.h),

              /// 5. COD Liability Card
              DriverCodLiabilityCard(controller: controller),

              SizedBox(height: 16.h),

              /// 6. This Month Stats Card
              DriverThisMonthCard(controller: controller),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  /// Top Header with Title and Notification Bell
  Widget _buildHeader() {
    return SizedBox(
      height: 44.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// Centered Title
          Text(
            'Earnings',
            style: GoogleFonts.roboto(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2E0A66),
              letterSpacing: -0.3,
            ),
          ),

          /// Right-aligned Notification Bell
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.notifications),
              child: Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFFE5E7EB),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      AppIcons.notificationIcon,
                      width: 24.w,
                      height: 24.h,
                      fit: BoxFit.contain,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF2E0A66),
                        BlendMode.srcIn,
                      ),
                    ),
                    Positioned(
                      top: 10.h,
                      right: 11.w,
                      child: Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEF4444),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
