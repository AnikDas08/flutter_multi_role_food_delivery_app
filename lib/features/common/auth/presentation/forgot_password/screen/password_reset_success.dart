import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/component/app_bar/common_app_bar.dart';
import 'package:flutter_code_structure/component/button/common_button.dart';
import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/utils/constants/app_colors.dart';

class PasswordResetSuccessScreen extends StatelessWidget {
  const PasswordResetSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: 'Password Reset Successful',
        titleSize: 18,
        titleWeight: FontWeight.w600,
        titleColor: AppColors.primaryColor,
        onBackTap: () => Get.offAllNamed(AppRoutes.signIn),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 48.h),

              /// Green Circle with Checkmark
              Container(
                width: 110.w,
                height: 110.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF22C55E),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 58.sp,
                  ),
                ),
              ),

              SizedBox(height: 28.h),

              /// Success Title
              Text(
                'Password Reset\nSuccessful!',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF22C55E),
                  height: 1.25,
                ),
              ),

              SizedBox(height: 12.h),

              /// Description Subtitle
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  'Your password has been successfully reset. You can now log in with your new password.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6B7280),
                    height: 1.4,
                  ),
                ),
              ),

              SizedBox(height: 36.h),

              /// Back to Login Button
              CommonButton(
                titleText: 'Back to Login',
                buttonColor: AppColors.primaryColor,
                borderColor: AppColors.primaryColor,
                buttonRadius: 10,
                buttonHeight: 50,
                titleSize: 16,
                titleWeight: FontWeight.w600,
                onTap: () {
                  Get.offAllNamed(AppRoutes.signIn);
                },
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
