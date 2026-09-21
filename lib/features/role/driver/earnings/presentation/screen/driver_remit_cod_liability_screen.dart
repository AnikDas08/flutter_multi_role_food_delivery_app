import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/component/app_bar/common_app_bar.dart';
import 'package:flutter_code_structure/config/route/app_routes.dart';

class DriverRemitCodLiabilityScreen extends StatelessWidget {
  final String amount;

  const DriverRemitCodLiabilityScreen({
    super.key,
    this.amount = '\$67.00',
  });

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final displayAmount = args?['amount'] as String? ?? amount;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFD),
      appBar: CommonAppBar(
        title: 'Remit COD Liability',
        titleColor: const Color(0xFF2E0A66),
        titleSize: 18.sp,
        titleWeight: FontWeight.w700,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),

              /// 1. Top Header: Amount & Subtitle (Centered)
              Center(
                child: Column(
                  children: [
                    Text(
                      displayAmount,
                      style: GoogleFonts.roboto(
                        fontSize: 38.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E293B),
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Must be remetted within 30 days.',
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 28.h),

              /// 2. Section: Bank Transfer
              Text(
                'Bank Transfer',
                style: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E293B),
                ),
              ),

              SizedBox(height: 12.h),

              /// Bank Transfer Card with 3 Bank items
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
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
                    _buildBankItem(
                      bankName: 'BNCTL',
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.bankTransferDetail,
                          arguments: {
                            'bankName': 'BNCTL',
                            'amount': displayAmount,
                            'accountName': 'Cabonaro Unipessoal Lda',
                            'accountNumber': '88390045827493',
                            'referenceNumber': 'COD-20260428-67412',
                          },
                        );
                      },
                    ),
                    Divider(
                      color: const Color(0xFFF1F5F9),
                      height: 1,
                      thickness: 1,
                    ),
                    _buildBankItem(
                      bankName: 'BRI Timor-Leste',
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.bankTransferDetail,
                          arguments: {
                            'bankName': 'BRI Timor-Leste',
                            'amount': displayAmount,
                            'accountName': 'Cabonaro Unipessoal Lda',
                            'accountNumber': '58473629104829',
                            'referenceNumber': 'COD-20260428-67412',
                          },
                        );
                      },
                    ),
                    Divider(
                      color: const Color(0xFFF1F5F9),
                      height: 1,
                      thickness: 1,
                    ),
                    _buildBankItem(
                      bankName: 'Mandiri Timor-Leste',
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.bankTransferDetail,
                          arguments: {
                            'bankName': 'Mandiri Timor-Leste',
                            'amount': displayAmount,
                            'accountName': 'Cabonaro Unipessoal Lda',
                            'accountNumber': '99182736452819',
                            'referenceNumber': 'COD-20260428-67412',
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              /// 3. Section: Office Payment
              Text(
                'Office Payment',
                style: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E293B),
                ),
              ),

              SizedBox(height: 12.h),

              /// Office Payment Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
                child: Text(
                  'Pay in Cash at PLOMOGO Office Rua Presidente Nicolau Lobato, Dili',
                  style: GoogleFonts.roboto(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF1E293B),
                    height: 1.45,
                  ),
                ),
              ),

              SizedBox(height: 32.h),

              /// 4. Bottom Button: I Have Made the Payment - Submit Proof
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(
                      AppRoutes.bankTransferDetail,
                      arguments: {
                        'bankName': 'BNCTL',
                        'amount': displayAmount,
                        'accountName': 'Cabonaro Unipessoal Lda',
                        'accountNumber': '88390045827493',
                        'referenceNumber': 'COD-20260428-67412',
                      },
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
                    'I Have Made the Payment - Submit Proof',
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBankItem({
    required String bankName,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              bankName,
              style: GoogleFonts.roboto(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E293B),
              ),
            ),
            Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: const Color(0xFF2E0A66),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
