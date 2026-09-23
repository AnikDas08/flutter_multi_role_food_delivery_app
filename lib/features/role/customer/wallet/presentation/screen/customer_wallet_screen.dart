import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';

class CustomerWalletScreen extends StatelessWidget {
  const CustomerWalletScreen({super.key});

  final List<Map<String, String>> _bankOptions = const [
    {
      'name': 'BNCTL',
      'fullName': 'Banco Nacional de Comércio de Timor-Leste',
      'accountNo': '1029-3847-5610',
    },
    {
      'name': 'MANDIRI',
      'fullName': 'Bank Mandiri',
      'accountNo': '1370-0098-4421',
    },
    {
      'name': 'BRI',
      'fullName': 'Bank Rakyat Indonesia',
      'accountNo': '0206-0100-3942',
    },
    {
      'name': 'BNU',
      'fullName': 'Banco Nacional Ultramarino',
      'accountNo': '5540-1123-8874',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// 1. Top App Bar: Back Button, "My Wallet", Notification Bell with Red Dot
            _buildTopBar(context),

            /// 2. Scrollable Body matching user mockup
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.h),

                    /// "Banks Top-Up Options" Heading
                    Text(
                      'Banks Top-Up\nOptions',
                      style: GoogleFonts.roboto(
                        fontSize: 28.sp.clamp(24.0, 32.0),
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1E0A3C),
                        height: 1.18,
                        letterSpacing: -0.5,
                      ),
                    ),

                    SizedBox(height: 24.h),

                    /// "Choose Your Bank" Centered Subtitle
                    Center(
                      child: Text(
                        'Choose Your Bank',
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp.clamp(14.5, 18.0),
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                    ),

                    SizedBox(height: 18.h),

                    /// Bank Options List
                    ..._bankOptions.map(
                      (bank) => _buildBankCard(context, bank),
                    ),

                    SizedBox(height: 22.h),

                    /// Bottom Informational Text
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          'Transfer to our account and upload\nproof of payment for instant credit.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize: 13.5.sp.clamp(12.0, 15.0),
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF334155),
                            height: 1.45,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Top Bar with Centered "My Wallet"
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Center(
        child: Text(
          'My Wallet',
          style: GoogleFonts.roboto(
            fontSize: 18.sp.clamp(16.0, 20.0),
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2E0A66),
          ),
        ),
      ),
    );
  }

  /// Bank Option Card matching the mockup design
  Widget _buildBankCard(BuildContext context, Map<String, String> bank) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            Get.toNamed(AppRoutes.customerWalletActivity, arguments: bank);
          },
          borderRadius: BorderRadius.circular(14.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                /// Purple Wallet Icon
                _buildWalletIcon(),

                SizedBox(width: 16.w),

                /// Bank Name
                Expanded(
                  child: Text(
                    bank['name'] ?? '',
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp.clamp(14.5, 17.5),
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E293B),
                      letterSpacing: 0.2,
                    ),
                  ),
                ),

                /// Chevron Right Arrow
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14.sp.clamp(12.0, 16.0),
                  color: const Color(0xFF94A3B8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Custom Purple Rounded Wallet Icon matching the mockup
  Widget _buildWalletIcon() {
    return Container(
      width: 40.w.clamp(36.0, 44.0),
      height: 30.h.clamp(26.0, 34.0),
      decoration: BoxDecoration(
        color: const Color(0xFF2E0A66),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Stack(
        children: [
          /// Wallet top fold accent
          Positioned(
            top: 0,
            left: 0,
            right: 12.w,
            child: Container(
              height: 9.h,
              decoration: BoxDecoration(
                color: const Color(0xFF3B1278),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.r),
                  bottomRight: Radius.circular(6.r),
                ),
              ),
            ),
          ),

          /// Wallet clasp button (white dot)
          Positioned(
            right: 7.w,
            top: 12.h,
            child: Container(
              width: 4.5.w.clamp(3.5, 5.5),
              height: 4.5.w.clamp(3.5, 5.5),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Bank Transfer Instructions Bottom Sheet
  void _showBankTransferSheet(BuildContext context, Map<String, String> bank) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Handle bar
              Center(
                child: Container(
                  width: 44.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              /// Header
              Row(
                children: [
                  _buildWalletIcon(),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bank['name'] ?? '',
                          style: GoogleFonts.roboto(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF2E0A66),
                          ),
                        ),
                        Text(
                          bank['fullName'] ?? '',
                          style: GoogleFonts.roboto(
                            fontSize: 12.sp,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 18.h),

              /// Account Details Box
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account Number',
                      style: GoogleFonts.roboto(
                        fontSize: 12.sp,
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          bank['accountNo'] ?? '',
                          style: GoogleFonts.roboto(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1E293B),
                            letterSpacing: 1.0,
                          ),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            HapticFeedback.selectionClick();
                            Clipboard.setData(
                              ClipboardData(text: bank['accountNo'] ?? ''),
                            );
                            AppSnackbar.success(
                              title: 'Copied',
                              message:
                                  '${bank['name']} account number copied to clipboard',
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E0A66),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              'Copy',
                              style: GoogleFonts.roboto(
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Account Name: Julio Food Delivery Ltd.',
                      style: GoogleFonts.roboto(
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 18.h),

              /// Upload Proof Button
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  HapticFeedback.mediumImpact();
                  Navigator.pop(ctx);
                  AppSnackbar.success(
                    title: 'Proof Uploaded',
                    message:
                        'Thank you! Your deposit will be credited to your wallet within 5 minutes.',
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 46.h.clamp(42.0, 50.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E0A66),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Upload Proof of Payment',
                          style: GoogleFonts.roboto(
                            fontSize: 14.5.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
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
      },
    );
  }
}
