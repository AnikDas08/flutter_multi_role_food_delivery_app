import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/utils/app_snackbar.dart';

class CustomerWalletScreen extends StatelessWidget {
  const CustomerWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Row(
                children: [
                  Text(
                    'My Wallet',
                    style: GoogleFonts.roboto(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2E0A66),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF5FF),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: const Color(0xFFE9D5FF),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.history_rounded,
                            size: 16.sp, color: const Color(0xFF4C1D95)),
                        SizedBox(width: 4.w),
                        Text(
                          'History',
                          style: GoogleFonts.roboto(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF4C1D95),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Balance Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(22.w),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2E0A66), Color(0xFF4C1D95)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2E0A66)
                                .withValues(alpha: 0.25),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Available Balance',
                                style: GoogleFonts.roboto(
                                  fontSize: 13.sp,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                              Icon(
                                Icons.account_balance_wallet_rounded,
                                color: Colors.white.withValues(alpha: 0.9),
                                size: 24.sp,
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            '\$24.50',
                            style: GoogleFonts.roboto(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 18.h),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    AppSnackbar.success(
                                      title: 'Top Up',
                                      message: 'Top-up gateway opening...',
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.h),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_rounded,
                                          color: const Color(0xFF2E0A66),
                                          size: 18.sp),
                                      SizedBox(width: 6.w),
                                      Text(
                                        'Top Up',
                                        style: GoogleFonts.roboto(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF2E0A66),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    AppSnackbar.success(
                                      title: 'Send Money',
                                      message: 'Transfer feature ready',
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: Colors.white,
                                      width: 1.2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.h),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.send_rounded,
                                          color: Colors.white, size: 16.sp),
                                      SizedBox(width: 6.w),
                                      Text(
                                        'Transfer',
                                        style: GoogleFonts.roboto(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    /// Recent Transactions
                    Text(
                      'Recent Transactions',
                      style: GoogleFonts.roboto(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E293B),
                      ),
                    ),

                    SizedBox(height: 12.h),

                    _buildTransactionTile(
                      title: 'Chez Panisse Cafe',
                      subtitle: 'Order #ORD-78421 • Food',
                      amount: '-\$15.20',
                      isDeduction: true,
                      date: 'Today, 1:45 PM',
                    ),
                    SizedBox(height: 10.h),
                    _buildTransactionTile(
                      title: 'Wallet Top Up',
                      subtitle: 'Via BNU Bank Transfer',
                      amount: '+\$30.00',
                      isDeduction: false,
                      date: 'Yesterday, 6:10 PM',
                    ),
                    SizedBox(height: 10.h),
                    _buildTransactionTile(
                      title: 'Wanderlust Bazaar',
                      subtitle: 'Order #ORD-66231 • Grocery',
                      amount: '-\$9.70',
                      isDeduction: true,
                      date: '19 Sep 2026',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionTile({
    required String title,
    required String subtitle,
    required String amount,
    required bool isDeduction,
    required String date,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: isDeduction
                  ? const Color(0xFFFEE2E2)
                  : const Color(0xFFDCFCE7),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isDeduction
                  ? Icons.arrow_outward_rounded
                  : Icons.arrow_downward_rounded,
              color: isDeduction
                  ? const Color(0xFFEF4444)
                  : const Color(0xFF16A34A),
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  subtitle,
                  style: GoogleFonts.roboto(
                    fontSize: 11.5.sp,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: GoogleFonts.roboto(
                  fontSize: 14.5.sp,
                  fontWeight: FontWeight.w700,
                  color: isDeduction
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF16A34A),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                date,
                style: GoogleFonts.roboto(
                  fontSize: 10.5.sp,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
