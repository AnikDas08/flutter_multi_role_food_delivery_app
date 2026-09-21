import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/utils/app_snackbar.dart';
import '../controller/driver_linked_accounts_controller.dart';
import 'account_verification_screen.dart';

class AddBankAccountScreen extends StatefulWidget {
  const AddBankAccountScreen({super.key});

  @override
  State<AddBankAccountScreen> createState() => _AddBankAccountScreenState();
}

class _AddBankAccountScreenState extends State<AddBankAccountScreen> {
  String _selectedBank = 'BNU';
  String _selectedAccountType = 'Savings'; // 'Savings' or 'Current'

  final TextEditingController _nameController =
      TextEditingController(text: 'Jane Doe');
  final TextEditingController _numberController =
      TextEditingController(text: '012345677893t6o8it');

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  void _onSaveAccount() {
    final holder = _nameController.text.trim();
    final number = _numberController.text.trim();

    if (holder.isEmpty) {
      AppSnackbar.error(
        title: 'Validation Error',
        message: 'Please enter account holder name',
      );
      return;
    }

    if (number.isEmpty) {
      AppSnackbar.error(
        title: 'Validation Error',
        message: 'Please enter account number',
      );
      return;
    }

    if (Get.isRegistered<DriverLinkedAccountsController>()) {
      Get.find<DriverLinkedAccountsController>().addNewAccount(
        bankName: _selectedBank,
        accountHolder: holder,
        accountNumber: number,
        accountType: _selectedAccountType,
      );
    }

    Get.to(
      () => AccountVerificationScreen(
        bankName: _selectedBank,
        accountName: holder,
        accountNumber: number,
        accountType: _selectedAccountType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                        'Add New Bank Account',
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
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4.h),

                    /// 2. Instruction Subtitle
                    Center(
                      child: Text(
                        'Choose your bank and enter your\naccount details.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF334155),
                          height: 1.45,
                        ),
                      ),
                    ),

                    SizedBox(height: 22.h),

                    /// 3. 2x2 Bank Selection Grid
                    Row(
                      children: [
                        Expanded(
                          child: _buildBankTile(
                            bankId: 'Mandiri',
                            label: 'Mandiri',
                            logoWidget: _buildMandiriLogo(),
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: _buildBankTile(
                            bankId: 'BNCTL',
                            label: 'BNCTL',
                            logoWidget: _buildBnctlLogo(),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 14.h),

                    Row(
                      children: [
                        Expanded(
                          child: _buildBankTile(
                            bankId: 'BNU',
                            label: 'BNU',
                            logoWidget: _buildBnuLogo(),
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: _buildBankTile(
                            bankId: 'BRI',
                            label: 'Timor-Leste',
                            logoWidget: _buildBriLogo(),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24.h),

                    /// 4. Account Holder Name
                    Text(
                      'Account Holder Name',
                      style: GoogleFonts.roboto(
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      height: 48.h,
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1.2,
                        ),
                      ),
                      child: TextField(
                        controller: _nameController,
                        style: GoogleFonts.roboto(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1E293B),
                        ),
                        decoration: InputDecoration(
                          hintText: 'e.g. Jane Doe',
                          hintStyle: GoogleFonts.roboto(
                            fontSize: 13.sp,
                            color: const Color(0xFF94A3B8),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                      ),
                    ),

                    SizedBox(height: 18.h),

                    /// 5. Account Number
                    Text(
                      'Account Number',
                      style: GoogleFonts.roboto(
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      height: 48.h,
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1.2,
                        ),
                      ),
                      child: TextField(
                        controller: _numberController,
                        style: GoogleFonts.roboto(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1E293B),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter account number',
                          hintStyle: GoogleFonts.roboto(
                            fontSize: 13.sp,
                            color: const Color(0xFF94A3B8),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                      ),
                    ),

                    SizedBox(height: 18.h),

                    /// 6. Account Type Segmented Switch
                    Text(
                      'Account Type',
                      style: GoogleFonts.roboto(
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      height: 46.h,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECEFF1),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        children: [
                          /// Savings Option
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() => _selectedAccountType = 'Savings');
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                decoration: BoxDecoration(
                                  color: _selectedAccountType == 'Savings'
                                      ? Colors.white
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8.r),
                                  boxShadow: _selectedAccountType == 'Savings'
                                      ? [
                                          BoxShadow(
                                            color: Colors.black
                                                .withValues(alpha: 0.05),
                                            blurRadius: 4,
                                            offset: const Offset(0, 1),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    'Savings',
                                    style: GoogleFonts.roboto(
                                      fontSize: 13.5.sp,
                                      fontWeight:
                                          _selectedAccountType == 'Savings'
                                              ? FontWeight.w600
                                              : FontWeight.w500,
                                      color: _selectedAccountType == 'Savings'
                                          ? const Color(0xFF1E293B)
                                          : const Color(0xFF64748B),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          /// Current Option
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() => _selectedAccountType = 'Current');
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                decoration: BoxDecoration(
                                  color: _selectedAccountType == 'Current'
                                      ? Colors.white
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8.r),
                                  boxShadow: _selectedAccountType == 'Current'
                                      ? [
                                          BoxShadow(
                                            color: Colors.black
                                                .withValues(alpha: 0.05),
                                            blurRadius: 4,
                                            offset: const Offset(0, 1),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    'Current',
                                    style: GoogleFonts.roboto(
                                      fontSize: 13.5.sp,
                                      fontWeight:
                                          _selectedAccountType == 'Current'
                                              ? FontWeight.w600
                                              : FontWeight.w500,
                                      color: _selectedAccountType == 'Current'
                                          ? const Color(0xFF1E293B)
                                          : const Color(0xFF64748B),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 28.h),

                    /// 7. Bottom Action Button: Save Bank Account
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: _onSaveAccount,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E0A66),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                        ),
                        child: Text(
                          'Save Bank Account',
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
          ],
        ),
      ),
    );
  }

  /// Single Bank Card Tile inside 2x2 Grid
  Widget _buildBankTile({
    required String bankId,
    required String label,
    required Widget logoWidget,
  }) {
    final isSelected = _selectedBank == bankId;

    return GestureDetector(
      onTap: () => setState(() => _selectedBank = bankId),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 115.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xFFECEFF1),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? const Color(0xFF2E0A66) : Colors.transparent,
            width: 1.8,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF2E0A66).withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(child: logoWidget),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: GoogleFonts.roboto(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Mandiri Logo
  Widget _buildMandiriLogo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 14.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(width: 3.w),
            Container(
              width: 20.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h),
        Text(
          'mandiri',
          style: GoogleFonts.roboto(
            fontSize: 15.sp,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0F172A),
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  /// BNCTL Logo
  Widget _buildBnctlLogo() {
    return Text(
      'BNCTL',
      style: GoogleFonts.roboto(
        fontSize: 20.sp,
        fontWeight: FontWeight.w900,
        color: const Color(0xFF0284C7),
        letterSpacing: 0.8,
      ),
    );
  }

  /// BNU Logo
  Widget _buildBnuLogo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'BNU',
              style: GoogleFonts.roboto(
                fontSize: 19.sp,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF831843),
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(width: 2.w),
            Icon(
              Icons.change_history_rounded,
              size: 14.sp,
              color: const Color(0xFFE11D48),
            ),
          ],
        ),
        Text(
          'Timor-Leste',
          style: GoogleFonts.roboto(
            fontSize: 9.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  /// BRI Logo
  Widget _buildBriLogo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF0284C7), width: 1.5),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            'B',
            style: GoogleFonts.roboto(
              fontSize: 14.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF0284C7),
            ),
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          'BRI',
          style: GoogleFonts.roboto(
            fontSize: 20.sp,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF00529C),
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}
