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

import 'package:intl_phone_field/countries.dart';

class SignUpAllField extends StatelessWidget {
  const SignUpAllField({super.key, required this.controller});

  final SignUpController controller;

  void _showCountryPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredCountries = searchQuery.isEmpty
                ? countries
                : countries.where((c) {
                    final q = searchQuery.toLowerCase();
                    return c.name.toLowerCase().contains(q) ||
                        c.dialCode.contains(q) ||
                        c.code.toLowerCase().contains(q);
                  }).toList();

            return Container(
              height: 0.78.sh,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    /// Drag handle
                    Container(
                      width: 44.w,
                      height: 4.h,
                      margin: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),

                    /// Header
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Select Country',
                            style: GoogleFonts.roboto(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.black,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded, color: Color(0xFF6B7280)),
                            onPressed: () => Navigator.of(bottomSheetContext).pop(),
                          ),
                        ],
                      ),
                    ),

                    /// Search field
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      child: TextField(
                        onChanged: (val) {
                          setModalState(() {
                            searchQuery = val.trim();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search country or dial code...',
                          hintStyle: GoogleFonts.roboto(
                            fontSize: 14.sp,
                            color: const Color(0xFF9CA3AF),
                          ),
                          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF9CA3AF)),
                          filled: true,
                          fillColor: const Color(0xFFF3F4F6),
                          contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),

                    const Divider(height: 1, color: Color(0xFFE5E7EB)),

                    /// Countries list
                    Expanded(
                      child: filteredCountries.isEmpty
                          ? Center(
                              child: Text(
                                'No country found',
                                style: GoogleFonts.roboto(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF9CA3AF),
                                ),
                              ),
                            )
                          : ListView.separated(
                              itemCount: filteredCountries.length,
                              separatorBuilder: (_, __) => const Divider(
                                height: 1,
                                indent: 56,
                                color: Color(0xFFF3F4F6),
                              ),
                              itemBuilder: (context, index) {
                                final country = filteredCountries[index];
                                final isSelected =
                                    controller.selectedCountry.value.code == country.code;
                                return InkWell(
                                  onTap: () {
                                    controller.setSelectedCountry(country);
                                    Navigator.of(bottomSheetContext).pop();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20.w,
                                      vertical: 12.h,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          country.flag,
                                          style: TextStyle(fontSize: 22.sp),
                                        ),
                                        SizedBox(width: 14.w),
                                        Expanded(
                                          child: Text(
                                            country.name,
                                            style: GoogleFonts.roboto(
                                              fontSize: 14.sp,
                                              fontWeight: isSelected
                                                  ? FontWeight.w700
                                                  : FontWeight.w400,
                                              color: isSelected
                                                  ? AppColors.primaryColor
                                                  : const Color(0xFF1F2937),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '+${country.dialCode}',
                                          style: GoogleFonts.roboto(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF6B7280),
                                          ),
                                        ),
                                        if (isSelected) ...[
                                          SizedBox(width: 8.w),
                                          const Icon(
                                            Icons.check_circle_rounded,
                                            color: AppColors.primaryColor,
                                            size: 18,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
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
