import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_code_structure/component/app_bar/common_app_bar.dart';
import 'package:flutter_code_structure/component/button/common_button.dart';
import 'package:flutter_code_structure/component/image/common_image.dart';
import 'package:flutter_code_structure/component/text/common_text.dart';
import 'package:flutter_code_structure/component/text_field/common_text_field.dart';
import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';
import 'package:flutter_code_structure/utils/constants/app_colors.dart';
import 'package:flutter_code_structure/utils/helpers/validation.dart';
import '../controller/sign_up_controller.dart';
import 'already_account_rich_text.dart';
import 'country_picker_bottom_sheet.dart';
import 'document_upload_card.dart';
import 'profile_image_picker_widget.dart';

class DriverSignUpView extends StatelessWidget {
  DriverSignUpView({super.key, required this.controller});

  final SignUpController controller;

  final _formKey = GlobalKey<FormState>();

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Text(
        label,
        style: GoogleFonts.roboto(
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF374151),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(
        title: 'Create an Account',
        titleSize: 30,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 12.h,
            bottom: bottomInset + 24.h,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// Header Subtitle
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

                /// Centered Circular Driver Photo with Label
                ProfileImagePickerWidget(
                  controller: controller,
                  sheetTitle: 'Driver Profile Photo',
                ),

                SizedBox(height: 20.h),

                /// First Name & Last Name Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('First Name'),
                          CommonTextField(
                            hintText: 'Lois',
                            controller: controller.firstNameController,
                            fillColor: const Color(0xFFF9FAFB),
                            borderColor: const Color(0xFFF3F4F6),
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
                            fillColor: const Color(0xFFF9FAFB),
                            borderColor: const Color(0xFFF3F4F6),
                            validator: AppValidation.required,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 14.h),

                /// Email Address Field
                _buildFieldLabel('Email Address'),
                CommonTextField(
                  controller: controller.emailController,
                  hintText: 'example@gamil.com',
                  keyboardType: TextInputType.emailAddress,
                  fillColor: const Color(0xFFF9FAFB),
                  borderColor: const Color(0xFFF3F4F6),
                  validator: AppValidation.email,
                ),

                SizedBox(height: 14.h),

                /// Phone Number Field (with Country Picker)
                _buildFieldLabel('Phone (optional)'),
                CommonTextField(
                  controller: controller.numberController,
                  hintText: '0123456789',
                  keyboardType: TextInputType.phone,
                  fillColor: const Color(0xFFF9FAFB),
                  borderColor: const Color(0xFFF3F4F6),
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
                            CountryPickerBottomSheet.show(
                              context,
                              selectedCountry: controller.selectedCountry.value,
                              onSelectCountry: controller.setSelectedCountry,
                            );
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

                SizedBox(height: 14.h),

                /// Password Field
                _buildFieldLabel('Password'),
                CommonTextField(
                  controller: controller.passwordController,
                  hintText: '*******',
                  isPassword: true,
                  fillColor: const Color(0xFFF9FAFB),
                  borderColor: const Color(0xFFF3F4F6),
                  validator: AppValidation.password,
                ),

                SizedBox(height: 14.h),

                /// Confirm Password Field
                _buildFieldLabel('Confirm Password'),
                CommonTextField(
                  controller: controller.confirmPasswordController,
                  hintText: '*******',
                  isPassword: true,
                  fillColor: const Color(0xFFF9FAFB),
                  borderColor: const Color(0xFFF3F4F6),
                  validator: (value) => AppValidation.confirmPassword(
                    value,
                    controller.passwordController,
                  ),
                ),

                SizedBox(height: 20.h),

                /// Document Upload 1: Driving License (Front Side)
                DocumentUploadCard(
                  label: 'Driving License (Front Side)',
                  title: 'Upload Driving License (Front)',
                  subtitle: 'Front side photo of your license',
                  buttonText: 'Upload Photo',
                  icon: Icons.credit_card_rounded,
                  imagePath: controller.drivingLicenseFrontImage ?? controller.drivingLicenseImage,
                  onPickImage: (source) {
                    controller.pickDocument(type: 'license_front', source: source);
                  },
                  onRemove: () {
                    controller.removeDocument('license_front');
                  },
                ),

                SizedBox(height: 16.h),

                /// Document Upload 2: Driving License (Back Side)
                DocumentUploadCard(
                  label: 'Driving License (Back Side)',
                  title: 'Upload Driving License (Back)',
                  subtitle: 'Back side photo of your license',
                  buttonText: 'Upload Photo',
                  icon: Icons.credit_card_rounded,
                  imagePath: controller.drivingLicenseBackImage,
                  onPickImage: (source) {
                    controller.pickDocument(type: 'license_back', source: source);
                  },
                  onRemove: () {
                    controller.removeDocument('license_back');
                  },
                ),

                SizedBox(height: 16.h),

                /// Document Upload 3: Vehicle Registration
                DocumentUploadCard(
                  label: 'Vehicle Registration',
                  title: 'Vehicle Registration',
                  subtitle: 'Upload registration certificate',
                  buttonText: 'Upload Photo',
                  icon: Icons.description_rounded,
                  imagePath: controller.vehicleRegistrationImage,
                  onPickImage: (source) {
                    controller.pickDocument(type: 'vehicle', source: source);
                  },
                  onRemove: () {
                    controller.removeDocument('vehicle');
                  },
                ),

                SizedBox(height: 20.h),

                /// Terms and Privacy Policy Checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => SizedBox(
                        width: 22.w,
                        height: 22.h,
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
                            const TextSpan(
                              text:
                                  ' . I confirm that all uploaded documents are authentic and belong to me.',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24.h),

                /// Submit Application Button
                CommonButton(
                  titleText: 'Submit Application',
                  buttonColor: AppColors.primaryColor,
                  borderColor: AppColors.primaryColor,
                  buttonRadius: 25,
                  buttonHeight: 50,
                  titleSize: 16,
                  titleWeight: FontWeight.w600,
                  isLoading: controller.isLoading,
                  onTap: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    if (!controller.termsAccepted.value) {
                      AppSnackbar.error(
                        title: 'Agreement Required',
                        message:
                            'Please confirm that you agree to the Terms and Privacy Policy.',
                      );
                      return;
                    }
                    controller.signUpUser();
                  },
                ),

                SizedBox(height: 24.h),

                /// Already have an account? Sign In
                const Center(
                  child: AlreadyAccountRichText(),
                ),

                SizedBox(height: 36.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
