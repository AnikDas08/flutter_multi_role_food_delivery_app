import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/component/app_bar/common_app_bar.dart';
import 'package:flutter_code_structure/component/button/common_button.dart';
import 'package:flutter_code_structure/utils/constants/app_colors.dart';
import 'package:flutter_code_structure/utils/extensions/extension.dart';
import '../controller/request_settlement_controller.dart';

class RequestSettlementScreen extends StatelessWidget {
  const RequestSettlementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<RequestSettlementController>()
        ? Get.find<RequestSettlementController>()
        : Get.put(RequestSettlementController());

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(
        title: 'Request for Settlement',
        titleSize: 18,
        titleWeight: FontWeight.w600,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    16.height,

                    /// Large Amount
                    Center(
                      child: Text(
                        controller.amount,
                        style: GoogleFonts.roboto(
                          fontSize: 42.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0F172A),
                          letterSpacing: -1,
                        ),
                      ),
                    ),

                    SizedBox(height: 6.h),

                    /// Subtitle
                    Center(
                      child: Text(
                        'Exclude delivery fees',
                        style: GoogleFonts.roboto(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF4B5563),
                        ),
                      ),
                    ),

                    24.height,

                    /// Explanation Text
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Text(
                        'You are requesting settlement for unpaid COD orders totaling ${controller.amount}. PLOMOGO will review and process your request within 24-48 hours.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF4B5563),
                          height: 1.45,
                        ),
                      ),
                    ),

                    32.height,

                    /// Payout Method Title
                    Text(
                      'Payout Method',
                      style: GoogleFonts.roboto(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF111827),
                      ),
                    ),

                    16.height,

                    /// Payout Method Cards Row
                    Obx(() {
                      final selected = controller.selectedMethod.value;
                      final isBank = selected == PayoutMethod.bankTransfer;
                      final isOffice = selected == PayoutMethod.office;

                      return IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            /// Bank Transfer Card
                            Expanded(
                              child: _buildMethodCard(
                                isSelected: isBank,
                                title: 'Bank Transfer',
                                line1: 'Transfer to your linked bank account',
                                line2: 'Instant confirmation after processing',
                                onTap: () => controller
                                    .setMethod(PayoutMethod.bankTransfer),
                              ),
                            ),

                            SizedBox(width: 14.w),

                            /// Collect at Office Card
                            Expanded(
                              child: _buildMethodCard(
                                isSelected: isOffice,
                                title: 'Collect at\nPLOMOGO\nOffice',
                                line1: 'Pay in cash at Dili Office',
                                line2: 'Rua Presidente Nicolau Lobato,\nDili',
                                onTap: () =>
                                    controller.setMethod(PayoutMethod.office),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    30.height,
                  ],
                ),
              ),
            ),

            /// Bottom Action Button
            Container(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 14.h,
                bottom: bottomPadding > 0 ? bottomPadding + 8.h : 20.h,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: CommonButton(
                titleText: 'Submit Payout Request',
                buttonColor: const Color(0xFF2E0A66),
                borderColor: const Color(0xFF2E0A66),
                buttonRadius: 14,
                buttonHeight: 52,
                titleSize: 15,
                titleWeight: FontWeight.w600,
                onTap: controller.submitPayoutRequest,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodCard({
    required bool isSelected,
    required String title,
    required String line1,
    required String line2,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF341280)
                : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF341280).withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Radio Indicator
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF341280)
                      : const Color(0xFFCBD5E1),
                  width: 2.5,
                ),
                color: isSelected ? Colors.white : const Color(0xFFE2E8F0),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF341280),
                        ),
                      ),
                    )
                  : null,
            ),

            SizedBox(height: 14.h),

            /// Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF111827),
                height: 1.25,
              ),
            ),

            SizedBox(height: 12.h),

            /// Line 1
            Text(
              line1,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF6B7280),
                height: 1.3,
              ),
            ),

            SizedBox(height: 10.h),

            /// Line 2
            Text(
              line2,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF6B7280),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
