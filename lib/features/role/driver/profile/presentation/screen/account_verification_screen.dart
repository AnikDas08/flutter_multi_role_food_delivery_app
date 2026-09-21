import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/features/common/nav_bar/presentation/controller/nav_bar_controller.dart';

class AccountVerificationScreen extends StatelessWidget {
  final String bankName;
  final String accountName;
  final String accountNumber;
  final String accountType;

  const AccountVerificationScreen({
    super.key,
    this.bankName = 'BNU',
    this.accountName = 'Cabonaro Unipessoal Lda',
    this.accountNumber = '99887766554433',
    this.accountType = 'Savings',
  });

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final currentBank = args?['bankName'] as String? ?? bankName;
    final currentAccountName =
        args?['accountName'] as String? ?? accountName;
    final currentAccountNumber =
        args?['accountNumber'] as String? ?? accountNumber;
    final currentAccountType =
        args?['accountType'] as String? ?? accountType;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// 1. Top Custom App Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(
                children: [
                  /// Circular White Back Button
                  GestureDetector(
                    onTap: () {
                      Get.until((route) =>
                          route.settings.name ==
                              AppRoutes.driverLinkedAccounts ||
                          route.isFirst);
                    },
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0xFFF1F5F9),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.chevron_left_rounded,
                        color: const Color(0xFF4C1D95),
                        size: 24.sp,
                      ),
                    ),
                  ),

                  /// Centered Purple Title
                  Expanded(
                    child: Center(
                      child: Text(
                        'Account Verification',
                        style: GoogleFonts.roboto(
                          fontSize: 17.5.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF4C1D95),
                        ),
                      ),
                    ),
                  ),

                  /// Balanced Right Spacer
                  SizedBox(width: 40.w),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 14.h),

                    /// 2. Verification Card with Protruding Pending Badge
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 22.h,
                          ),
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
                              _buildDetailItem('Bank', currentBank),
                              SizedBox(height: 14.h),
                              _buildDetailItem('Account Name', currentAccountName),
                              SizedBox(height: 14.h),
                              _buildDetailItem(
                                  'Account Number', currentAccountNumber),
                              SizedBox(height: 14.h),
                              _buildDetailItem('Account Type', currentAccountType),
                            ],
                          ),
                        ),

                        /// Purple "Pending Verification" Pill Badge
                        Positioned(
                          top: -11.h,
                          right: 14.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 5.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFA855F7),
                              borderRadius: BorderRadius.circular(20.r),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFA855F7)
                                      .withValues(alpha: 0.35),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              'Pending Verification',
                              style: GoogleFonts.roboto(
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24.h),

                    /// 3. Informational Subtitle Text
                    Text(
                      'Your bank account has been submitted for verification. This usually takes 1-2 business days. You will receive a notification once it is approved.',
                      style: GoogleFonts.roboto(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF334155),
                        height: 1.45,
                      ),
                    ),

                    SizedBox(height: 36.h),

                    /// 4. Action Button 1: Back to Earnings
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: () {
                          if (Get.isRegistered<NavBarController>()) {
                            Get.find<NavBarController>().changeIndex(2);
                          }
                          Get.until(
                            (route) =>
                                route.isFirst ||
                                route.settings.name == AppRoutes.mainNavBar,
                          );
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

                    SizedBox(height: 14.h),

                    /// 5. Action Button 2: View All Linked Accounts
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: OutlinedButton(
                        onPressed: () {
                          Get.until((route) =>
                              route.settings.name ==
                                  AppRoutes.driverLinkedAccounts ||
                              route.isFirst);
                          if (Get.currentRoute !=
                              AppRoutes.driverLinkedAccounts) {
                            Get.offNamed(AppRoutes.driverLinkedAccounts);
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFF2E0A66),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                        ),
                        child: Text(
                          'View All Linked Accounts',
                          style: GoogleFonts.roboto(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2E0A66),
                          ),
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

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 12.5.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF64748B),
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }
}
