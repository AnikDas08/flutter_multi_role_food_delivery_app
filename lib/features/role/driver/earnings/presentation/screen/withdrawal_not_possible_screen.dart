import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/component/app_bar/common_app_bar.dart';
import 'package:flutter_code_structure/config/route/app_routes.dart';

class WithdrawalNotPossibleScreen extends StatelessWidget {
  final String availableBalance;

  const WithdrawalNotPossibleScreen({
    super.key,
    this.availableBalance = '\$0.00',
  });

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final displayBalance = args?['amount'] as String? ?? availableBalance;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: 'Withdrawal Not Possible',
        titleColor: const Color(0xFF2E0A66),
        titleSize: 18.sp,
        titleWeight: FontWeight.w700,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16.h),

              /// Large Red Warning Icon
              Icon(
                Icons.warning_rounded,
                size: 88.sp,
                color: const Color(0xFFEF4444),
              ),

              SizedBox(height: 18.h),

              /// "Insufficient Balance" Title in Red
              Text(
                'Insufficient Balance',
                style: GoogleFonts.roboto(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFEF4444),
                ),
              ),

              SizedBox(height: 6.h),

              /// Big "$0.00" Amount in Red
              Text(
                displayBalance,
                style: GoogleFonts.roboto(
                  fontSize: 38.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFEF4444),
                  letterSpacing: -0.5,
                ),
              ),

              SizedBox(height: 28.h),

              /// Heading Message
              Text(
                'You currently have \$0 available\nto withdraw.',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E293B),
                  height: 1.35,
                ),
              ),

              SizedBox(height: 10.h),

              /// Subtitle Message
              Text(
                'Complete more deliveries to earn and\nunlock withdrawals.',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF64748B),
                  height: 1.45,
                ),
              ),

              SizedBox(height: 28.h),

              /// Balance and Reference Information Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xFFF1F5F9),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  children: [
                    /// Current Available Balance Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Current Available Balance:',
                          style: GoogleFonts.roboto(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        Text(
                          displayBalance,
                          style: GoogleFonts.roboto(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 14.h),

                    /// Transaction Reference Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Transaction Reference:',
                          style: GoogleFonts.roboto(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        Text(
                          'N/A',
                          style: GoogleFonts.roboto(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32.h),

              /// Deep Purple Pill Button: "Back to Earnings"
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: () {
                    Get.until((route) =>
                        route.settings.name == AppRoutes.mainNavBar ||
                        route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E0A66),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                  ),
                  child: Text(
                    'Back to Earnings',
                    style: GoogleFonts.roboto(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
