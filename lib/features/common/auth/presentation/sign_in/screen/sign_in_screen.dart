import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/component/app_bar/common_app_bar.dart';
import 'package:flutter_code_structure/component/button/common_button.dart';
import 'package:flutter_code_structure/component/image/common_image.dart';
import 'package:flutter_code_structure/component/text_field/common_text_field.dart';
import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/utils/constants/app_colors.dart';
import 'package:flutter_code_structure/utils/constants/app_icons.dart';
import 'package:flutter_code_structure/utils/helpers/validation.dart';
import '../controller/sign_in_controller.dart';
import '../widgets/do_not_account.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignInController>(
      initState: (_) {
        Get.find<SignInController>().initRole();
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CommonAppBar(
            onBackTap: () {
              if (Navigator.canPop(context)) {
                Get.back();
              } else {
                Get.offNamed(AppRoutes.roleSelection);
              }
            },
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 12.h),

                    /// Header: Dynamic Role Title
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

                    SizedBox(height: 8.h),

                    /// Header: Dynamic Role Subtitle
                    Obx(
                      () => Text(
                        controller.roleSubtitle,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ),

                    SizedBox(height: 28.h),

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
                    CommonTextField(
                      controller: controller.emailController,
                      hintText: 'Loisbecket@gmail.com',
                      keyboardType: TextInputType.emailAddress,
                      borderColor: const Color(0xFFE5E7EB),
                      validator: AppValidation.email,
                    ),

                    SizedBox(height: 16.h),

                    /// Password Field Label
                    Text(
                      'Password',
                      style: GoogleFonts.roboto(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF4B5563),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    CommonTextField(
                      controller: controller.passwordController,
                      isPassword: true,
                      hintText: '*******',
                      borderColor: const Color(0xFFE5E7EB),
                      validator: AppValidation.password,
                    ),

                    SizedBox(height: 14.h),

                    /// Remember Me & Forgot Password Row
                    Row(
                      children: [
                        Obx(
                          () => SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: Checkbox(
                              value: controller.rememberMe.value,
                              activeColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              side: const BorderSide(
                                color: Color(0xFF9CA3AF),
                                width: 1.5,
                              ),
                              onChanged: (val) {
                                controller.rememberMe.value = val ?? false;
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Remember me',
                          style: GoogleFonts.roboto(
                            fontSize: 13.sp,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Get.toNamed(AppRoutes.forgotPassword),
                          child: Text(
                            'Forgot Password?',
                            style: GoogleFonts.roboto(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24.h),

                    /// Login Button
                    CommonButton(
                      titleText: 'Login',
                      buttonColor: AppColors.primaryColor,
                      borderColor: AppColors.primaryColor,
                      buttonRadius: 10,
                      buttonHeight: 50,
                      titleSize: 16,
                      titleWeight: FontWeight.w600,
                      isLoading: controller.isLoading,
                      onTap: () {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        controller.signInUser();
                      },
                    ),

                    SizedBox(height: 24.h),

                    /// Or Login Divider
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(color: Color(0xFFE5E7EB), thickness: 1),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          child: Text(
                            'or Login',
                            style: GoogleFonts.roboto(
                              fontSize: 13.sp,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(color: Color(0xFFE5E7EB), thickness: 1),
                        ),
                      ],
                    ),

                    SizedBox(height: 22.h),

                    /// Continue with Facebook
                    Container(
                      width: double.infinity,
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10.r),
                          onTap: () {
                            // Facebook login placeholder
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CommonImage(
                                imageSrc: AppIcons.facebookIcon,
                                width: 22,
                                height: 22,
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                'Continue with Facebook',
                                style: GoogleFonts.roboto(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1F2937),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 12.h),

                    /// Continue with Apple
                    Container(
                      width: double.infinity,
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10.r),
                          onTap: () {
                            // Apple login placeholder
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CommonImage(
                                imageSrc: AppIcons.appleIcon,
                                width: 22,
                                height: 22,
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                'Continue with Apple',
                                style: GoogleFonts.roboto(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1F2937),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 32.h),

                    /// Don't have an account? Create a Account
                    const Center(child: DoNotHaveAccount()),

                    SizedBox(height: 24.h),
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
