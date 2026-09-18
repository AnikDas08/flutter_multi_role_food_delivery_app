import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/component/app_bar/common_app_bar.dart';
import 'package:flutter_code_structure/component/button/common_button.dart';
import 'package:flutter_code_structure/component/text_field/common_text_field.dart';
import 'package:flutter_code_structure/utils/constants/app_colors.dart';
import '../controller/forget_password_controller.dart';

class CreatePassword extends StatelessWidget {
  CreatePassword({super.key});

  final _formKey = GlobalKey<FormState>();

  Widget _buildRequirementItem({
    required bool isMet,
    required bool showError,
    required String text,
  }) {
    final IconData icon;
    final Color color;

    if (isMet) {
      icon = Icons.check_circle_rounded;
      color = const Color(0xFF22C55E);
    } else if (showError) {
      icon = Icons.cancel_rounded;
      color = const Color(0xFFEF4444);
    } else {
      icon = Icons.radio_button_unchecked_rounded;
      color = const Color(0xFF9CA3AF);
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18.sp),
          SizedBox(width: 8.w),
          Text(
            text,
            style: GoogleFonts.roboto(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgetPasswordController>(
      init: Get.isRegistered<ForgetPasswordController>()
          ? Get.find<ForgetPasswordController>()
          : Get.put(ForgetPasswordController()),
      builder: (controller) {
        final hasPasswordError =
            controller.showPasswordValidationErrors && !controller.isPasswordValid;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: const CommonAppBar(
            title: 'Create New Password',
            titleSize: 18,
            titleWeight: FontWeight.w600,
            titleColor: AppColors.primaryColor,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 24.h),

                    /// Heading
                    Text(
                      'Enter your new password?',
                      style: GoogleFonts.roboto(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    /// New Password Label
                    Text(
                      'New Password',
                      style: GoogleFonts.roboto(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF4B5563),
                      ),
                    ),
                    SizedBox(height: 6.h),

                    /// New Password Field
                    CommonTextField(
                      controller: controller.passwordController,
                      isPassword: true,
                      hintText: 'Typing new password here...',
                      borderColor: hasPasswordError
                          ? const Color(0xFFEF4444)
                          : const Color(0xFFE5E7EB),
                      fillColor: hasPasswordError
                          ? const Color(0xFFFEF2F2)
                          : Colors.white,
                      onChanged: (val) {
                        controller.validatePasswordRequirements(val);
                      },
                    ),

                    SizedBox(height: 16.h),

                    /// Confirm New Password Label
                    Text(
                      'Confirm New Password',
                      style: GoogleFonts.roboto(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF4B5563),
                      ),
                    ),
                    SizedBox(height: 6.h),

                    /// Confirm New Password Field
                    CommonTextField(
                      controller: controller.confirmPasswordController,
                      isPassword: true,
                      hintText: 'Typing confirm new password here...',
                      borderColor: hasPasswordError
                          ? const Color(0xFFEF4444)
                          : const Color(0xFFE5E7EB),
                      fillColor: hasPasswordError
                          ? const Color(0xFFFEF2F2)
                          : Colors.white,
                    ),

                    SizedBox(height: 16.h),

                    /// Password Requirements checklist
                    if (controller.showPasswordValidationErrors) ...[
                      Text(
                        'Password does not meet requirements.',
                        style: GoogleFonts.roboto(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFEF4444),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      _buildRequirementItem(
                        isMet: controller.hasMin8Chars,
                        showError: controller.showPasswordValidationErrors,
                        text: 'Minimum 8 characters',
                      ),
                      _buildRequirementItem(
                        isMet: controller.hasNumber,
                        showError: controller.showPasswordValidationErrors,
                        text: 'At least 1 number',
                      ),
                      _buildRequirementItem(
                        isMet: controller.hasSpecialChar,
                        showError: controller.showPasswordValidationErrors,
                        text: 'At least 1 special character',
                      ),
                    ] else ...[
                      Text(
                        'Enter the 6-digit code we sent to your\nemail or phone number',
                        style: GoogleFonts.roboto(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6B7280),
                          height: 1.4,
                        ),
                      ),
                    ],

                    SizedBox(height: 36.h),

                    /// Reset Password Button
                    CommonButton(
                      titleText: 'Reset Password',
                      buttonColor: AppColors.primaryColor,
                      borderColor: AppColors.primaryColor,
                      buttonRadius: 10,
                      buttonHeight: 50,
                      titleSize: 16,
                      titleWeight: FontWeight.w600,
                      isLoading: controller.isLoading,
                      onTap: () {
                        controller.resetPassword();
                      },
                    ),

                    SizedBox(height: 36.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
