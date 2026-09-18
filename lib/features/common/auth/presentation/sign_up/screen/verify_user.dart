import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:flutter_code_structure/component/app_bar/common_app_bar.dart';
import 'package:flutter_code_structure/component/button/common_button.dart';
import 'package:flutter_code_structure/utils/constants/app_colors.dart';
import '../controller/sign_up_controller.dart';

class VerifyUser extends StatefulWidget {
  const VerifyUser({super.key});

  @override
  State<VerifyUser> createState() => _VerifyUserState();
}

class _VerifyUserState extends State<VerifyUser> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _pinController;

  @override
  void initState() {
    super.initState();
    _pinController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final ctrl = Get.isRegistered<SignUpController>()
            ? Get.find<SignUpController>()
            : Get.put(SignUpController());
        ctrl.startTimer();
      }
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(
        title: 'Enter Reset Code',
        titleSize: 18,
        titleWeight: FontWeight.w600,
        titleColor: AppColors.primaryColor,
      ),
      body: GetBuilder<SignUpController>(
        init: Get.isRegistered<SignUpController>()
            ? Get.find<SignUpController>()
            : Get.put(SignUpController()),
        builder: (controller) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 24.h),

                    /// Brand Role Title (e.g. PLOMOGO Driver)
                    Text(
                      controller.roleTitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    /// Subtitle
                    Text(
                      'Enter the 6-digit code we sent to your\nemail or phone number',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF6B7280),
                        height: 1.4,
                      ),
                    ),

                    SizedBox(height: 36.h),

                    /// 6-digit Pin Code Field (Square boxes)
                    PinCodeTextField(
                      appContext: context,
                      length: 6,
                      controller: _pinController,
                      cursorColor: AppColors.primaryColor,
                      autoFocus: true,
                      keyboardType: TextInputType.number,
                      animationType: AnimationType.fade,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      textStyle: GoogleFonts.roboto(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(10.r),
                        fieldHeight: 50.w,
                        fieldWidth: 50.w,
                        borderWidth: 1.2,
                        activeColor: const Color(0xFFE5E7EB),
                        inactiveColor: const Color(0xFFE5E7EB),
                        selectedColor: AppColors.primaryColor,
                        activeFillColor: Colors.white,
                        inactiveFillColor: Colors.white,
                        selectedFillColor: Colors.white,
                      ),
                      enableActiveFill: true,
                      onChanged: (value) {
                        controller.otpController.text = value;
                      },
                      validator: (value) {
                        if (value != null && value.length == 6) {
                          return null;
                        }
                        return 'Enter 6-digit code';
                      },
                    ),

                    SizedBox(height: 20.h),

                    /// Resend Code Timer (3 minutes, clickable when 00:00)
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.roboto(
                          fontSize: 13.sp,
                          color: const Color(0xFF6B7280),
                        ),
                        children: [
                          if (controller.remainingSeconds > 0) ...[
                            TextSpan(
                              text: 'Resend code in ${controller.timeFormatted} ',
                            ),
                            TextSpan(
                              text: 'Resend Code',
                              style: TextStyle(
                                color: const Color(0xFF9CA3AF),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ] else ...[
                            const TextSpan(
                              text: "Didn't receive code? ",
                            ),
                            TextSpan(
                              text: 'Resend Code',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.primaryColor,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  controller.resendOtp();
                                },
                            ),
                          ],
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    /// Action Button
                    CommonButton(
                      titleText: 'Verify',
                      buttonColor: AppColors.primaryColor,
                      borderColor: AppColors.primaryColor,
                      buttonRadius: 10,
                      buttonHeight: 50,
                      titleSize: 16,
                      titleWeight: FontWeight.w600,
                      isLoading: controller.isLoadingVerify,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          controller.otpController.text = _pinController.text;
                          controller.verifyOtp();
                        }
                      },
                    ),

                    SizedBox(height: 24.h),

                    /// Notice Text
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        "Didn't receive the code? Please check your spam or junk folder. If you still can't find it, try requesting a new code.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6B7280),
                          height: 1.4,
                        ),
                      ),
                    ),

                    SizedBox(height: 36.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
