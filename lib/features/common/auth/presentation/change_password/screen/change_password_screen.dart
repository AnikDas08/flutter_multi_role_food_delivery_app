import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/utils/app_snackbar.dart';
import '../controller/change_password_controller.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChangePasswordController>(
      init: Get.isRegistered<ChangePasswordController>()
          ? Get.find<ChangePasswordController>()
          : Get.put(ChangePasswordController()),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                /// 1. Top Custom App Bar
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: Row(
                    children: [
                      /// Circular Back Button
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

                      /// Centered Title
                      Expanded(
                        child: Center(
                          child: Text(
                            'Change Password',
                            style: GoogleFonts.roboto(
                              fontSize: 17.5.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF4C1D95),
                            ),
                          ),
                        ),
                      ),

                      /// Balanced right spacer
                      SizedBox(width: 40.w),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 12.h),

                          /// 2. Instruction Subtitle
                          Text(
                            'Enter your Old Password and Confirm your\nNew Password to Regain Access',
                            style: GoogleFonts.roboto(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF334155),
                              height: 1.45,
                            ),
                          ),

                          SizedBox(height: 24.h),

                          /// 3. Old Password Field
                          Text(
                            'Old Password',
                            style: GoogleFonts.roboto(
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF374151),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            height: 48.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                                width: 1.2,
                              ),
                            ),
                            child: TextFormField(
                              controller: controller.currentPasswordController,
                              obscureText: _obscureOldPassword,
                              style: GoogleFonts.roboto(
                                fontSize: 13.5.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF1E293B),
                              ),
                              decoration: InputDecoration(
                                hintText: '••••••••',
                                hintStyle: GoogleFonts.roboto(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF94A3B8),
                                  letterSpacing: 2,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 14.w,
                                  vertical: 12.h,
                                ),
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureOldPassword =
                                          !_obscureOldPassword;
                                    });
                                  },
                                  icon: Icon(
                                    _obscureOldPassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 20.sp,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 20.h),

                          /// 4. New Password Field
                          Text(
                            'New Password',
                            style: GoogleFonts.roboto(
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF374151),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            height: 48.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                                width: 1.2,
                              ),
                            ),
                            child: TextFormField(
                              controller: controller.newPasswordController,
                              obscureText: _obscureNewPassword,
                              style: GoogleFonts.roboto(
                                fontSize: 13.5.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF1E293B),
                              ),
                              decoration: InputDecoration(
                                hintText: '••••••••',
                                hintStyle: GoogleFonts.roboto(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF94A3B8),
                                  letterSpacing: 2,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 14.w,
                                  vertical: 12.h,
                                ),
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureNewPassword =
                                          !_obscureNewPassword;
                                    });
                                  },
                                  icon: Icon(
                                    _obscureNewPassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 20.sp,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 20.h),

                          /// 5. Confirm New Password Field
                          Text(
                            'Confirm New Password',
                            style: GoogleFonts.roboto(
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF374151),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            height: 48.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                                width: 1.2,
                              ),
                            ),
                            child: TextFormField(
                              controller: controller.confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              style: GoogleFonts.roboto(
                                fontSize: 13.5.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF1E293B),
                              ),
                              decoration: InputDecoration(
                                hintText: '••••••••',
                                hintStyle: GoogleFonts.roboto(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF94A3B8),
                                  letterSpacing: 2,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 14.w,
                                  vertical: 12.h,
                                ),
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 20.sp,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 28.h),

                          /// 6. Bottom Action Button: Change Password
                          SizedBox(
                            width: double.infinity,
                            height: 50.h,
                            child: ElevatedButton(
                              onPressed: () {
                                final oldPass = controller
                                    .currentPasswordController.text
                                    .trim();
                                final newPass = controller
                                    .newPasswordController.text
                                    .trim();
                                final confirmPass = controller
                                    .confirmPasswordController.text
                                    .trim();

                                if (oldPass.isEmpty) {
                                  AppSnackbar.error(
                                    title: 'Validation Error',
                                    message: 'Please enter your old password',
                                  );
                                  return;
                                }

                                if (newPass.isEmpty) {
                                  AppSnackbar.error(
                                    title: 'Validation Error',
                                    message: 'Please enter your new password',
                                  );
                                  return;
                                }

                                if (newPass.length < 6) {
                                  AppSnackbar.error(
                                    title: 'Weak Password',
                                    message:
                                        'Password must be at least 6 characters',
                                  );
                                  return;
                                }

                                if (newPass != confirmPass) {
                                  AppSnackbar.error(
                                    title: 'Mismatch',
                                    message: 'Passwords do not match',
                                  );
                                  return;
                                }

                                controller.changePassword();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E0A66),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.r),
                                ),
                              ),
                              child: Text(
                                'Reset Password',
                                style: GoogleFonts.roboto(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
