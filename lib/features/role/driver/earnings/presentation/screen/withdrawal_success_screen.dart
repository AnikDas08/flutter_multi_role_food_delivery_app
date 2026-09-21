import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/component/app_bar/common_app_bar.dart';
import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/features/role/driver/earnings/presentation/controller/driver_withdraw_funds_controller.dart';

class WithdrawalSuccessScreen extends StatelessWidget {
  final String amount;
  final DriverWithdrawalMethod method;
  final String referenceNumber;

  const WithdrawalSuccessScreen({
    super.key,
    this.amount = '\$2,847',
    this.method = DriverWithdrawalMethod.bankAccount,
    this.referenceNumber = '#WD-20260422-784512',
  });

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final displayAmount = args?['amount'] as String? ?? amount;
    final displayMethod =
        args?['method'] as DriverWithdrawalMethod? ?? method;
    final displayRef =
        args?['referenceNumber'] as String? ?? referenceNumber;
    final isOffice = displayMethod == DriverWithdrawalMethod.office;

    final formattedAmount = displayAmount.replaceAll(' USD', '').trim();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: 'Withdrawal Successful',
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
              SizedBox(height: 12.h),

              /// 1. Green Success Checkmark Circle
              Container(
                width: 92.w,
                height: 92.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF22C55E),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 56.sp,
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              /// 2. "Withdrawal Successful!" Title in Green
              Text(
                'Withdrawal Successful!',
                style: GoogleFonts.roboto(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF22C55E),
                ),
              ),

              SizedBox(height: 8.h),

              /// 3. Amount
              Text(
                formattedAmount,
                style: GoogleFonts.roboto(
                  fontSize: 36.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E293B),
                  letterSpacing: -0.5,
                ),
              ),

              SizedBox(height: 8.h),

              /// 4. Subtitle
              Text(
                isOffice
                    ? 'Funds will be available for pickup at Dili Office'
                    : 'Funds will be transferred to your linked bank\naccount (BNU)',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF475569),
                  height: 1.4,
                ),
              ),

              SizedBox(height: 24.h),

              /// 5. Grey Info Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDEDF2),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xFFE2E2EA),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isOffice) ...[
                      _buildInfoRow(
                        icon: Icons.account_balance_outlined,
                        text: 'Bank: BNU',
                      ),
                      SizedBox(height: 12.h),
                      _buildInfoRow(
                        icon: Icons.person_outline_rounded,
                        text: 'Account Name: Cabonaro Unipessoal Lda',
                      ),
                      SizedBox(height: 12.h),
                      _buildInfoRow(
                        icon: Icons.account_balance_wallet_outlined,
                        text: 'Account Number: 99887766554433',
                      ),
                      SizedBox(height: 12.h),
                      _buildInfoRow(
                        icon: Icons.access_time_rounded,
                        text: 'Processing Time: 1-2 business days',
                      ),
                    ] else ...[
                      _buildInfoRow(
                        icon: Icons.apartment_rounded,
                        text: 'Pickup: Dili Office',
                      ),
                      SizedBox(height: 12.h),
                      _buildInfoRow(
                        icon: Icons.location_on_outlined,
                        text: 'Avenida Nicolau Lobato, Dili',
                      ),
                      SizedBox(height: 12.h),
                      _buildInfoRow(
                        icon: Icons.access_time_rounded,
                        text: 'Pickup Time: Same day pickup',
                      ),
                    ],
                    SizedBox(height: 12.h),
                    _buildInfoRow(
                      icon: Icons.receipt_long_outlined,
                      text: displayRef,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'You will receive a confirmation email shortly.',
                      style: GoogleFonts.roboto(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF3B0764),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32.h),

              /// 6. Pill-shaped Button: "Back to Earnings"
              SizedBox(
                width: double.infinity,
                height: 50.h,
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

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 18.sp,
          color: const Color(0xFF475569),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.roboto(
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1E293B),
            ),
          ),
        ),
      ],
    );
  }
}
