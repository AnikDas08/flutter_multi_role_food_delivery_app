import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/component/app_bar/common_app_bar.dart';
import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/features/role/driver/earnings/presentation/controller/driver_withdraw_funds_controller.dart';
import 'package:flutter_code_structure/features/role/driver/earnings/presentation/screen/withdrawal_success_screen.dart';

class ConfirmWithdrawalScreen extends StatelessWidget {
  final String amount;
  final DriverWithdrawalMethod method;

  const ConfirmWithdrawalScreen({
    super.key,
    this.amount = '\$2,847',
    this.method = DriverWithdrawalMethod.bankAccount,
  });

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final displayAmount = args?['amount'] as String? ?? amount;
    final displayMethod =
        args?['method'] as DriverWithdrawalMethod? ?? method;
    final isOffice = displayMethod == DriverWithdrawalMethod.office;

    // Clean amount string to extract only the $value for display in button
    final buttonAmount = displayAmount.replaceAll(' USD', '').trim();

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFD),
      appBar: CommonAppBar(
        title: 'Confirm Withdrawal',
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
              /// 1. Top Card: Amount and Subtitle
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
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
                    Text(
                      buttonAmount,
                      style: GoogleFonts.roboto(
                        fontSize: 38.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2E0A66),
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      isOffice
                          ? 'Will be collected at Dili Office.'
                          : 'Will be sent to your linked bank account.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              /// 2. Account Details Card
              GestureDetector(
                onTap: isOffice
                    ? null
                    : () => Get.toNamed(AppRoutes.accountVerification),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: isOffice
                        ? [
                            _buildDetailItem('Pickup Location', 'Dili Office'),
                            SizedBox(height: 18.h),
                            _buildDetailItem(
                              'Address',
                              'Avenida Nicolau Lobato, Dili, Timor-Leste',
                            ),
                            SizedBox(height: 18.h),
                            _buildDetailItem('Pickup Window', 'Same day pickup (9 AM - 5 PM)'),
                            SizedBox(height: 18.h),
                            _buildDetailItem('Required ID', 'Driver ID / National ID Card'),
                          ]
                        : [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildDetailItem('Bank', 'BNU'),
                                GestureDetector(
                                  onTap: () =>
                                      Get.toNamed(AppRoutes.driverLinkedAccounts),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F3FF),
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Text(
                                      'Change',
                                      style: GoogleFonts.roboto(
                                        fontSize: 11.5.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF4C1D95),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 18.h),
                            _buildDetailItem('Account Name', 'Cabonaro Unipessoal Lda'),
                            SizedBox(height: 18.h),
                            _buildDetailItem('Account Number', '99887766554433'),
                            SizedBox(height: 18.h),
                            _buildDetailItem('Account Type', 'Savings'),
                            SizedBox(height: 18.h),
                            _buildDetailItem(
                              'Processing Time',
                              'Instant transfer (1-2 business days)',
                            ),
                          ],
                  ),
                ),
              ),

              SizedBox(height: 32.h),

              /// 3. Confirm & Withdraw Button
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(
                      () => WithdrawalSuccessScreen(
                        amount: buttonAmount,
                        method: displayMethod,
                        referenceNumber: '#WD-20260422-784512',
                      ),
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
                    'Confirm & Withdraw $buttonAmount',
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

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF64748B),
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }
}
