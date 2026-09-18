import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/component/text_field/common_text_field.dart';
import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/utils/constants/app_colors.dart';
import 'package:flutter_code_structure/utils/helpers/validation.dart';
import '../controller/sign_up_controller.dart';
import 'country_picker_bottom_sheet.dart';

class SignUpAllField extends StatelessWidget {
  const SignUpAllField({super.key, required this.controller});

  final SignUpController controller;

  void _showCountryPicker(BuildContext context) {
    CountryPickerBottomSheet.show(
      context,
      selectedCountry: controller.selectedCountry.value,
      onSelectCountry: controller.setSelectedCountry,
    );
  }

  Widget _buildFieldLabel(String label, {bool isRequired = true}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h, top: 12.h),
      child: RichText(
        text: TextSpan(
          text: label,
          style: GoogleFonts.roboto(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF4B5563),
          ),
          children: isRequired
              ? [
                  TextSpan(
                    text: ' *',
                    style: GoogleFonts.roboto(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                      fontSize: 13.sp,
                    ),
                  ),
                ]
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// First Name & Last Name Row
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel('First Name'),
                  CommonTextField(
                    hintText: 'Lois',
                    controller: controller.firstNameController,
                    borderColor: const Color(0xFFE5E7EB),
                    validator: AppValidation.required,
                  ),
                ],
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel('Last Name'),
                  CommonTextField(
                    hintText: 'Becket',
                    controller: controller.lastNameController,
                    borderColor: const Color(0xFFE5E7EB),
                    validator: AppValidation.required,
                  ),
                ],
              ),
            ),
          ],
        ),

        /// Email Address
        _buildFieldLabel('Email Address'),
        CommonTextField(
          controller: controller.emailController,
          hintText: 'example@gamil.com',
          keyboardType: TextInputType.emailAddress,
          borderColor: const Color(0xFFE5E7EB),
          validator: AppValidation.email,
        ),

        /// Phone (optional)
        _buildFieldLabel('Phone (optional)', isRequired: false),
        CommonTextField(
          controller: controller.numberController,
          hintText: '0123456789',
          keyboardType: TextInputType.phone,
          borderColor: const Color(0xFFE5E7EB),
          prefixIconConstraints: BoxConstraints(
            minWidth: 88.w,
            maxHeight: 46.h,
          ),
          prefixIcon: Obx(() {
            final country = controller.selectedCountry.value;
            return Padding(
              padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 4.h, bottom: 4.h),
              child: Material(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8.r),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8.r),
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    _showCountryPicker(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(country.flag, style: TextStyle(fontSize: 16.sp)),
                        SizedBox(width: 4.w),
                        Text(
                          country.code,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF374151),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 18.sp,
                          color: const Color(0xFF6B7280),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),

        /// Set Password
        _buildFieldLabel('Set Password'),
        CommonTextField(
          controller: controller.passwordController,
          isPassword: true,
          hintText: '*******',
          borderColor: const Color(0xFFE5E7EB),
          validator: AppValidation.password,
        ),

        /// Confirm Password
        _buildFieldLabel('Confirm Password'),
        CommonTextField(
          controller: controller.confirmPasswordController,
          isPassword: true,
          hintText: '*******',
          borderColor: const Color(0xFFE5E7EB),
          validator: (value) => AppValidation.confirmPassword(
            value,
            controller.passwordController,
          ),
        ),

        SizedBox(height: 14.h),

        /// Terms of Service & Privacy Policy Checkbox
        Obx(
          () => Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 24.w,
                height: 24.h,
                child: Checkbox(
                  value: controller.termsAccepted.value,
                  activeColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  onChanged: (val) {
                    controller.termsAccepted.value = val ?? false;
                  },
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.roboto(
                      fontSize: 12.sp,
                      color: const Color(0xFF6B7280),
                    ),
                    children: [
                      TextSpan(
                        text: 'Terms of Service',
                        style: const TextStyle(
                          color: Color(0xFFF59E0B),
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFFF59E0B),
                          fontWeight: FontWeight.w500,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.toNamed(AppRoutes.termsOfServices);
                          },
                      ),
                      const TextSpan(text: ' & '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: const TextStyle(
                          color: Color(0xFFF59E0B),
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFFF59E0B),
                          fontWeight: FontWeight.w500,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.toNamed(AppRoutes.privacyPolicy);
                          },
                      ),
                      const TextSpan(text: ' Agreement'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
