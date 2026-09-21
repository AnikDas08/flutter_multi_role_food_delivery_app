import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/component/app_bar/common_app_bar.dart';
import '../controller/driver_withdraw_funds_controller.dart';
import '../widgets/driver_available_withdrawal_card.dart';
import '../widgets/driver_withdrawal_method_card.dart';

class DriverWithdrawFundsScreen extends StatelessWidget {
  const DriverWithdrawFundsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<DriverWithdrawFundsController>()
        ? Get.find<DriverWithdrawFundsController>()
        : Get.put(DriverWithdrawFundsController());

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFD),
      appBar: CommonAppBar(
        title: 'Withdraw Funds',
        titleColor: const Color(0xFF2E0A66),
        titleSize: 18.sp,
        titleWeight: FontWeight.w700,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 1. Available for withdrawal Card
                  Obx(
                    () => DriverAvailableWithdrawalCard(
                      amount: controller.availableBalance.value,
                    ),
                  ),

                  SizedBox(height: 20.h),

                  /// 2. Amount Input Section
                  Text(
                    'Amount',
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: controller.amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (val) {
                        controller.selectedChipIndex.value = -1;
                      },
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1E293B),
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 13.h,
                        ),
                        hintText: '\$0.00 USD',
                        hintStyle: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 18.h),

                  /// 3. Quick Amount Chip Section
                  Text(
                    'Quick Amount Chip',
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: List.generate(
                      controller.quickChips.length,
                      (index) {
                        return Obx(() {
                          final isSelected =
                              controller.selectedChipIndex.value == index;
                          return GestureDetector(
                            onTap: () => controller.selectChip(index),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 7.h,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFA855F7)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFA855F7)
                                      : const Color(0xFFE2E8F0),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                controller.quickChips[index],
                                style: GoogleFonts.roboto(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF1E293B),
                                ),
                              ),
                            ),
                          );
                        });
                      },
                    ),
                  ),

                  SizedBox(height: 22.h),

                  /// 4. Withdrawal Method 1: Bank Account
                  Obx(
                    () => DriverWithdrawalMethodCard(
                      icon: Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.account_balance_rounded,
                          color: const Color(0xFF10B981),
                          size: 18.sp,
                        ),
                      ),
                      title: 'Withdraw to Bank Account',
                      subtitle: 'Linked Bank Account',
                      note: 'Instant transfer (1-2 business days)',
                      isSelected: controller.selectedMethod.value ==
                          DriverWithdrawalMethod.bankAccount,
                      onTap: () => controller
                          .selectMethod(DriverWithdrawalMethod.bankAccount),
                    ),
                  ),

                  SizedBox(height: 12.h),

                  /// 5. Withdrawal Method 2: Collect at Office
                  Obx(
                    () => DriverWithdrawalMethodCard(
                      icon: Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.apartment_rounded,
                          color: const Color(0xFF64748B),
                          size: 18.sp,
                        ),
                      ),
                      title: 'Collect at Office',
                      subtitle: 'Dili Office',
                      note: 'Same day pickup',
                      isSelected: controller.selectedMethod.value ==
                          DriverWithdrawalMethod.office,
                      onTap: () => controller
                          .selectMethod(DriverWithdrawalMethod.office),
                    ),
                  ),

                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),

          /// 6. Continue Button at bottom
          Padding(
            padding: EdgeInsets.fromLTRB(18.w, 8.h, 18.w, 20.h),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: () => controller.onContinue(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E0A66),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: GoogleFonts.roboto(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
