import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/component/app_bar/common_app_bar.dart';
import 'package:flutter_code_structure/component/button/common_button.dart';
import 'package:flutter_code_structure/component/text/common_text.dart';
import 'package:flutter_code_structure/component/text_field/common_text_field.dart';
import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';
import 'package:flutter_code_structure/utils/constants/app_colors.dart';
import 'package:flutter_code_structure/utils/extensions/extension.dart';
import 'package:flutter_code_structure/utils/helpers/validation.dart';
import '../controller/sign_up_controller.dart';
import 'already_account_rich_text.dart';
import 'country_picker_bottom_sheet.dart';
import 'document_upload_card.dart';
import 'profile_image_picker_widget.dart';

class MerchantSignUpView extends StatelessWidget {
  MerchantSignUpView({super.key, required this.controller});

  final SignUpController controller;
  final _formKey = GlobalKey<FormState>();

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(
        title: 'Create an Account',
        titleSize: 30,
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// Header Subtitle (Matching Customer style)
                CommonText(
                  text: controller.signUpDescription,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF6B7280),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  top: 4,
                  bottom: 16,
                ),

                /// Centered Circular Profile Image Picker (Matching Customer & Driver)
                ProfileImagePickerWidget(
                  controller: controller,
                  sheetTitle: 'Merchant Profile Photo',
                ),

                SizedBox(height: 12.h),

                /// Business Name Field
                _buildFieldLabel('Business Name'),
                CommonTextField(
                  controller: controller.businessNameController,
                  hintText: 'Enter restaurant name',
                  borderColor: const Color(0xFFE5E7EB),
                  validator: AppValidation.required,
                ),

                /// Business Email Field (Required)
                _buildFieldLabel('Business Email'),
                CommonTextField(
                  controller: controller.businessEmailController,
                  hintText: 'business@restaurant.com',
                  keyboardType: TextInputType.emailAddress,
                  borderColor: const Color(0xFFE5E7EB),
                  validator: AppValidation.email,
                ),

                /// Phone Number Field (with Country Picker matching Customer Side)
                _buildFieldLabel('Phone Number'),
                CommonTextField(
                  controller: controller.numberController,
                  hintText: '0123456789',
                  keyboardType: TextInputType.phone,
                  borderColor: const Color(0xFFE5E7EB),
                  validator: AppValidation.required,
                  prefixIconConstraints: BoxConstraints(
                    minWidth: 88.w,
                    maxHeight: 46.h,
                  ),
                  prefixIcon: Obx(() {
                    final country = controller.selectedCountry.value;
                    return Padding(
                      padding: EdgeInsets.only(
                        left: 8.w,
                        right: 8.w,
                        top: 4.h,
                        bottom: 4.h,
                      ),
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
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 6.h,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  country.flag,
                                  style: TextStyle(fontSize: 16.sp),
                                ),
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

                /// Business Address Field
                _buildFieldLabel('Business Address'),
                CommonTextField(
                  controller: controller.businessAddressController,
                  hintText: 'Enter complete business address',
                  borderColor: const Color(0xFFE5E7EB),
                  validator: AppValidation.required,
                ),

                /// Set Password Field
                _buildFieldLabel('Set Password'),
                CommonTextField(
                  controller: controller.passwordController,
                  hintText: '*******',
                  isPassword: true,
                  borderColor: const Color(0xFFE5E7EB),
                  validator: AppValidation.password,
                ),

                /// Confirm Password Field
                _buildFieldLabel('Confirm Password'),
                CommonTextField(
                  controller: controller.confirmPasswordController,
                  hintText: '*******',
                  isPassword: true,
                  borderColor: const Color(0xFFE5E7EB),
                  validator: (value) => AppValidation.confirmPassword(
                    value,
                    controller.passwordController,
                  ),
                ),

                SizedBox(height: 12.h),

                /// Text Title for Restaurant License (Explicit user requirement)
                _buildFieldLabel('Restaurant License'),
                GetBuilder<SignUpController>(
                  builder: (_) => DocumentUploadCard(
                    label: '',
                    title: 'Upload Restaurant License',
                    subtitle: 'PNG, JPG or PDF up to 5MB',
                    buttonText: 'Choose File',
                    icon: Icons.cloud_upload_rounded,
                    imagePath: controller.restaurantLicenseImage,
                    onPickImage: (source) {
                      controller.pickDocument(
                        type: 'restaurant_license',
                        source: source,
                      );
                    },
                    onRemove: () {
                      controller.removeDocument('restaurant_license');
                    },
                  ),
                ),

                SizedBox(height: 18.h),

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
                          side: const BorderSide(
                            color: Color(0xFF9CA3AF),
                            width: 1.5,
                          ),
                          onChanged: (val) {
                            controller.termsAccepted.value = val ?? false;
                          },
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            style: GoogleFonts.roboto(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF4B5563),
                              height: 1.4,
                            ),
                            children: [
                              const TextSpan(text: 'I agree to the '),
                              TextSpan(
                                text: 'Terms of Service',
                                style: const TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.toNamed(AppRoutes.termsOfServices);
                                  },
                              ),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: const TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.toNamed(AppRoutes.privacyPolicy);
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                24.height,

                /// Submit Application Button
                CommonButton(
                  titleText: 'Submit Application',
                  titleSize: 16,
                  titleWeight: FontWeight.w600,
                  buttonRadius: 10,
                  isLoading: controller.isLoading,
                  onTap: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    if (!controller.termsAccepted.value) {
                      AppSnackbar.error(
                        title: 'Agreement Required',
                        message:
                            'Please confirm that you agree to the Terms of Service and Privacy Policy.',
                      );
                      return;
                    }
                    controller.signUpUser();
                  },
                ),

                24.height,

                /// Already have an account? Sign In
                const Center(
                  child: AlreadyAccountRichText(),
                ),

                32.height,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
