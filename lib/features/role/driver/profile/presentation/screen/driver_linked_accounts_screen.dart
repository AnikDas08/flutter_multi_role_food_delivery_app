import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/config/route/app_routes.dart';
import '../controller/driver_linked_accounts_controller.dart';
import 'account_verification_screen.dart';

class DriverLinkedAccountsScreen extends StatelessWidget {
  const DriverLinkedAccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DriverLinkedAccountsController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// 1. Custom Top App Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(
                children: [
                  /// Circular White Back Button
                  GestureDetector(
                    onTap: () => Get.back(),
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
                        'Linked Accounts',
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

            /// 2. Instruction Subtitle
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              child: Text(
                'Manage your saved bank accounts for\nwithdrawals',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF334155),
                  height: 1.45,
                ),
              ),
            ),

            SizedBox(height: 6.h),

            /// 3. List of Linked Bank Accounts
            Expanded(
              child: Obx(
                () => controller.accounts.isEmpty
                    ? _buildEmptyState(context, controller)
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 10.h,
                        ),
                        itemCount: controller.accounts.length,
                        separatorBuilder: (context, index) => SizedBox(height: 14.h),
                        itemBuilder: (context, index) {
                          final account = controller.accounts[index];
                          final isSelected =
                              controller.selectedAccountId.value == account.id;

                          return _buildAccountCard(
                            context: context,
                            controller: controller,
                            account: account,
                            isSelected: isSelected,
                          );
                        },
                      ),
              ),
            ),

            /// 4. Bottom Action Button: + Add New Bank Account
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 16.h),
              child: SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () => Get.toNamed(AppRoutes.addBankAccount),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E0A66),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_rounded,
                          color: Colors.white, size: 20.sp),
                      SizedBox(width: 8.w),
                      Text(
                        'Add New Bank Account',
                        style: GoogleFonts.roboto(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
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
      ),
    );
  }

  /// Single Bank Account Card Matching Screenshot Design
  Widget _buildAccountCard({
    required BuildContext context,
    required DriverLinkedAccountsController controller,
    required DriverBankAccount account,
    required bool isSelected,
  }) {
    final textColor = isSelected ? Colors.white : const Color(0xFF1E293B);
    final subtitleColor = isSelected
        ? Colors.white.withValues(alpha: 0.72)
        : const Color(0xFF64748B);

    return GestureDetector(
      onTap: () {
        controller.selectAccount(account.id);
        Get.to(
          () => AccountVerificationScreen(
            bankName: account.bankName,
            accountName: account.accountHolder,
            accountNumber: account.fullAccountNumber,
            accountType: account.accountType,
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2E0A66) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2E0A66)
                : const Color(0xFFF1F5F9),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFF2E0A66).withValues(alpha: 0.18)
                  : Colors.black.withValues(alpha: 0.03),
              blurRadius: isSelected ? 12 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Top Row: Bank Logo, Bank Name, Location, Delete Button
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Bank Logo Widget
                _buildBankLogo(account.bankName),

                SizedBox(width: 12.w),

                /// Bank Name & Country
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.bankName,
                        style: GoogleFonts.roboto(
                          fontSize: 15.5.sp,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        account.country,
                        style: GoogleFonts.roboto(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w400,
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),

                /// Delete Trash Button (Peach Circle + Red Trash Can)
                GestureDetector(
                  onTap: () => controller.removeAccount(account.id),
                  child: Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFEE2E2),
                    ),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: const Color(0xFFEF4444),
                      size: 19.sp,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            /// Middle: Account Holder Name
            Text(
              account.accountHolder,
              style: GoogleFonts.roboto(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),

            SizedBox(height: 8.h),

            /// Bottom Row: Account Number, Account Type, Status Badge
            Row(
              children: [
                /// Account Number
                Text(
                  account.accountNumber,
                  style: GoogleFonts.roboto(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),

                SizedBox(width: 14.w),

                /// Account Type (Savings / Current)
                Text(
                  account.accountType,
                  style: GoogleFonts.roboto(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: subtitleColor,
                  ),
                ),

                const Spacer(),

                /// Verification Status Badge
                account.isVerified
                    ? Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Verified',
                              style: GoogleFonts.roboto(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 13.sp,
                            ),
                          ],
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFA855F7),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          'Pending Verification',
                          style: GoogleFonts.roboto(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Specialized Bank Logo Widget matching real Timor-Leste Banks
  Widget _buildBankLogo(String bankName) {
    final lower = bankName.toLowerCase();

    if (lower.contains('bnu')) {
      return Container(
        width: 44.w,
        height: 44.w,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'BNU',
                style: GoogleFonts.roboto(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1E3A8A),
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                width: 20.w,
                height: 2.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFDC2626),
                  borderRadius: BorderRadius.circular(1.r),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (lower.contains('mandiri')) {
      return Container(
        width: 44.w,
        height: 44.w,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Container(
                    width: 10.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                'mandiri',
                style: GoogleFonts.roboto(
                  fontSize: 8.5.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (lower.contains('bnctl')) {
      return Container(
        width: 44.w,
        height: 44.w,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'BNCTL',
                style: GoogleFonts.roboto(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0284C7),
                  letterSpacing: 0.2,
                ),
              ),
              Container(
                width: 22.w,
                height: 2.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B),
                  borderRadius: BorderRadius.circular(1.r),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: Icon(
        Icons.account_balance_rounded,
        color: const Color(0xFF2E0A66),
        size: 22.sp,
      ),
    );
  }

  /// Empty state if all accounts removed
  Widget _buildEmptyState(
      BuildContext context, DriverLinkedAccountsController controller) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72.w,
              height: 72.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF1F5F9),
              ),
              child: Icon(
                Icons.account_balance_outlined,
                color: const Color(0xFF94A3B8),
                size: 36.sp,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'No Linked Accounts',
              style: GoogleFonts.roboto(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E293B),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Add your bank account to receive withdrawals smoothly.',
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 13.sp,
                color: const Color(0xFF64748B),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
