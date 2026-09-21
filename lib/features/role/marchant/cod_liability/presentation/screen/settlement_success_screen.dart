import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/component/app_bar/common_app_bar.dart';
import 'package:flutter_code_structure/component/button/common_button.dart';
import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';
import 'package:flutter_code_structure/utils/extensions/extension.dart';

class SettlementSuccessScreen extends StatelessWidget {
  final String amount;
  final String referenceNumber;

  const SettlementSuccessScreen({
    super.key,
    this.amount = '\$67.00',
    this.referenceNumber = 'CS-20260503-784512',
  });

  void _copyReference() {
    Clipboard.setData(ClipboardData(text: referenceNumber));
    AppSnackbar.success(
      title: 'Copied',
      message: 'Reference number copied to clipboard',
    );
  }

  void _backToNavBar() {
    Get.offAllNamed(AppRoutes.mainNavBar);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: 'Request Submitted',
        titleSize: 18,
        titleWeight: FontWeight.w600,
        onBackTap: _backToNavBar,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    28.height,

                    /// Green Check Circle
                    Container(
                      width: 120.w,
                      height: 120.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFF16A34A),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 64.sp,
                        ),
                      ),
                    ),

                    28.height,

                    /// Success Title
                    Text(
                      'Settlement Request\nSubmitted Successfully!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF16A34A),
                        height: 1.3,
                      ),
                    ),

                    14.height,

                    /// Subtitle with amount
                    Text(
                      'Your request for $amount has been\nsent to PLOMOGO',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1F2937),
                        height: 1.4,
                      ),
                    ),

                    32.height,

                    /// Status Banner
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(18.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE9FE),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status: Pending Review',
                            style: GoogleFonts.roboto(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1F2937),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            'Our team will verify and process your settlement within 24-48 hours',
                            style: GoogleFonts.roboto(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF4B5563),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    32.height,

                    /// Reference Number & Copy Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reference Number',
                              style: GoogleFonts.roboto(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF111827),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              referenceNumber,
                              style: GoogleFonts.roboto(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF4B5563),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: _copyReference,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            child: Text(
                              'Copy',
                              style: GoogleFonts.roboto(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF341280),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    24.height,
                  ],
                ),
              ),
            ),

            /// Bottom Action Button (Navigates back to Nav Bar screen)
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
                titleText: 'Back to COD Liability',
                buttonColor: const Color(0xFF2E0A66),
                borderColor: const Color(0xFF2E0A66),
                buttonRadius: 14,
                buttonHeight: 52,
                titleSize: 15,
                titleWeight: FontWeight.w600,
                onTap: _backToNavBar,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
