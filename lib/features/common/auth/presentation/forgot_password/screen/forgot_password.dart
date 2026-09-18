import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/component/app_bar/common_app_bar.dart';
import 'package:flutter_code_structure/component/button/common_button.dart';
import 'package:flutter_code_structure/component/text_field/common_text_field.dart';
import 'package:flutter_code_structure/features/common/auth/presentation/sign_in/widgets/do_not_account.dart';
import 'package:flutter_code_structure/utils/constants/app_colors.dart';
import 'package:flutter_code_structure/utils/helpers/validation.dart';
import '../controller/forget_password_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgetPasswordController>(
      init: Get.isRegistered<ForgetPasswordController>()
          ? Get.find<ForgetPasswordController>()
          : Get.put(ForgetPasswordController()),
      initState: (_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final ctrl = Get.isRegistered<ForgetPasswordController>()
              ? Get.find<ForgetPasswordController>()
              : Get.put(ForgetPasswordController());
          ctrl.initRole();
        });
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: const CommonAppBar(
            title: 'Forget Password',
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

                    /// Header: Dynamic Role Title (e.g. PLOMOGO Driver)
                    Obx(
                      () => Text(
                        controller.roleTitle,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),

                    SizedBox(height: 36.h),

                    /// Forgot your password?
                    Text(
                      'Forgot your password?',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                    ),

                    SizedBox(height: 8.h),

                    /// Instruction subtitle
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        "No worries! Enter your registered email and we'll send you a reset link.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6B7280),
                          height: 1.4,
                        ),
                      ),
                    ),

                    SizedBox(height: 32.h),

                    /// Email Field Label
                    Text(
                      'Email',
                      style: GoogleFonts.roboto(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF4B5563),
                      ),
                    ),
                    SizedBox(height: 6.h),

                    /// Input Field
                    CommonTextField(
                      controller: controller.emailController,
                      hintText: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      borderColor: const Color(0xFFE5E7EB),
                      validator: AppValidation.email,
                    ),

                    SizedBox(height: 24.h),

                    /// Action Button
                    CommonButton(
                      titleText: 'Forgot password',
                      buttonColor: AppColors.primaryColor,
                      borderColor: AppColors.primaryColor,
                      buttonRadius: 10,
                      buttonHeight: 50,
                      titleSize: 16,
                      titleWeight: FontWeight.w600,
                      isLoading: controller.isLoading,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          controller.sendForgetPasswordEmail();
                        }
                      },
                    ),

                    SizedBox(height: 16.h),

                    /// Subtitle beneath button
                    Obx(
                      () => Text(
                        controller.roleSubtitle,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ),

                    SizedBox(height: 120.h),
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
