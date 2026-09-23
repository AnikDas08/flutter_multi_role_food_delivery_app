import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/utils/constants/app_images.dart';
import '../controller/customer_edit_profile_controller.dart';

class CustomerEditProfileScreen extends StatelessWidget {
  const CustomerEditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomerEditProfileController());
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// 1. Top Custom App Bar matching screenshot
            _buildTopBar(context),

            /// 2. Scrollable Body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 540),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8.h),

                        /// Profile Photo with Edit Badge & CHANGE PHOTO Label
                        _buildPhotoSection(context, controller),

                        SizedBox(height: 24.h),

                        /// Section 1: Personal Information
                        Text(
                          'Personal Information',
                          style: GoogleFonts.roboto(
                            fontSize: 15.sp.clamp(14.0, 17.0),
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF4C1D95),
                          ),
                        ),

                        SizedBox(height: 14.h),

                        /// Full Name
                        _buildFieldLabel('Full Name'),
                        SizedBox(height: 6.h),
                        _buildTextField(
                          controller: controller.fullNameController,
                          hintText: 'Jane Doe',
                        ),

                        SizedBox(height: 14.h),

                        /// Email Address
                        _buildFieldLabel('Email Address'),
                        SizedBox(height: 6.h),
                        _buildTextField(
                          controller: controller.emailController,
                          hintText: 'example@gamil.com',
                          keyboardType: TextInputType.emailAddress,
                        ),

                        SizedBox(height: 14.h),

                        /// Phone (optional)
                        _buildFieldLabel('Phone (optional)'),
                        SizedBox(height: 6.h),
                        _buildPhoneField(context, controller),

                        SizedBox(height: 24.h),

                        /// Section 2: Additional Information
                        Text(
                          'Additional Information',
                          style: GoogleFonts.roboto(
                            fontSize: 15.sp.clamp(14.0, 17.0),
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF4C1D95),
                          ),
                        ),

                        SizedBox(height: 14.h),

                        /// Address
                        _buildFieldLabel('Address'),
                        SizedBox(height: 6.h),
                        _buildAddressField(controller),

                        SizedBox(height: 14.h),

                        /// Date of Birth & Gender Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Date of Birth
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildFieldLabel('Date of Birth'),
                                  SizedBox(height: 6.h),
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () => controller.selectDateOfBirth(context),
                                    child: Container(
                                      height: 48.h,
                                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10.r),
                                        border: Border.all(
                                          color: const Color(0xFFE2E8F0),
                                          width: 1.2,
                                        ),
                                      ),
                                      alignment: Alignment.centerLeft,
                                      child: Obx(
                                        () => Text(
                                          controller.dob.value.isEmpty
                                              ? 'dd/mm/yyyy'
                                              : controller.dob.value,
                                          style: GoogleFonts.roboto(
                                            fontSize: 13.5.sp.clamp(12.0, 15.0),
                                            fontWeight: controller.dob.value.isEmpty
                                                ? FontWeight.w400
                                                : FontWeight.w500,
                                            color: controller.dob.value.isEmpty
                                                ? const Color(0xFF94A3B8)
                                                : const Color(0xFF1E293B),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(width: 12.w),

                            /// Gender
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildFieldLabel('Gender'),
                                  SizedBox(height: 6.h),
                                  Container(
                                    height: 48.h,
                                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.r),
                                      border: Border.all(
                                        color: const Color(0xFFE2E8F0),
                                        width: 1.2,
                                      ),
                                    ),
                                    child: Obx(
                                      () => DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: controller.selectedGender.value,
                                          isExpanded: true,
                                          icon: const Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: Color(0xFF64748B),
                                          ),
                                          style: GoogleFonts.roboto(
                                            fontSize: 13.5.sp.clamp(12.0, 15.0),
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF1E293B),
                                          ),
                                          items: controller.genderOptions
                                              .map(
                                                (g) => DropdownMenuItem(
                                                  value: g,
                                                  child: Text(g),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (val) {
                                            if (val != null) {
                                              HapticFeedback.selectionClick();
                                              controller.selectedGender.value = val;
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 32.h),

                        /// Bottom Action Button: Save Changes
                        SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: ElevatedButton(
                            onPressed: controller.onSaveChanges,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2E0A66),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.r),
                              ),
                            ),
                            child: Text(
                              'Save Changes',
                              style: GoogleFonts.roboto(
                                fontSize: 15.sp.clamp(14.0, 17.0),
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: bottomPadding > 0 ? bottomPadding + 10.h : 24.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 1. Top Custom App Bar
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Row(
        children: [
          /// Circular Back Button
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              HapticFeedback.lightImpact();
              Get.back();
            },
            child: Container(
              width: 42.w.clamp(38.0, 46.0),
              height: 42.w.clamp(38.0, 46.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                  width: 1.2,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16.sp.clamp(14.0, 18.0),
                  color: const Color(0xFF2E0A66),
                ),
              ),
            ),
          ),

          /// Centered Title: Edit Profile
          Expanded(
            child: Center(
              child: Text(
                'Edit Profile',
                style: GoogleFonts.roboto(
                  fontSize: 18.sp.clamp(16.0, 22.0),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2E0A66),
                ),
              ),
            ),
          ),

          /// Right spacer to keep title centered (notification icon removed)
          SizedBox(width: 42.w.clamp(38.0, 46.0)),
        ],
      ),
    );
  }

  /// Profile Photo with Edit Badge & CHANGE PHOTO Label
  Widget _buildPhotoSection(BuildContext context, CustomerEditProfileController controller) {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => controller.pickProfilePhoto(context: context),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Obx(() {
                  final file = controller.profileImage.value;
                  return Container(
                    width: 96.w.clamp(86.0, 108.0),
                    height: 96.w.clamp(86.0, 108.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: file != null
                          ? DecorationImage(
                              image: FileImage(file),
                              fit: BoxFit.cover,
                            )
                          : const DecorationImage(
                              image: AssetImage(AppImages.profileImage),
                              fit: BoxFit.cover,
                            ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  );
                }),
                Positioned(
                  right: 0,
                  bottom: 2.h,
                  child: Container(
                    width: 28.w.clamp(26.0, 32.0),
                    height: 28.w.clamp(26.0, 32.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E0A66),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2.w,
                      ),
                    ),
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 14.sp.clamp(12.0, 16.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: () => controller.pickProfilePhoto(context: context),
            child: Text(
              'CHANGE PHOTO',
              style: GoogleFonts.roboto(
                fontSize: 12.5.sp.clamp(11.5, 14.0),
                fontWeight: FontWeight.w700,
                color: const Color(0xFF334155),
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Phone input field with country code and flag
  Widget _buildPhoneField(BuildContext context, CustomerEditProfileController controller) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          /// Country Code Box
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => controller.pickCountry(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(9.r),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(
                    () => Text(
                      controller.selectedCountryFlag.value,
                      style: TextStyle(fontSize: 17.sp.clamp(15.0, 19.0)),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Obx(
                    () => Text(
                      controller.selectedCountryCode.value,
                      style: GoogleFonts.roboto(
                        fontSize: 12.5.sp.clamp(11.5, 14.0),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18.sp.clamp(16.0, 20.0),
                    color: const Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),

          Container(
            width: 1.w,
            height: 28.h,
            color: const Color(0xFFE2E8F0),
          ),

          /// Phone Number Input
          Expanded(
            child: TextField(
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              style: GoogleFonts.roboto(
                fontSize: 13.5.sp.clamp(12.0, 15.0),
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1E293B),
              ),
              decoration: InputDecoration(
                hintText: '0123456789',
                hintStyle: GoogleFonts.roboto(
                  fontSize: 13.sp.clamp(12.0, 14.0),
                  color: const Color(0xFF94A3B8),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 12.h,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Address multiline field
  Widget _buildAddressField(CustomerEditProfileController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.2,
        ),
      ),
      child: TextField(
        controller: controller.addressController,
        minLines: 3,
        maxLines: 4,
        style: GoogleFonts.roboto(
          fontSize: 13.5.sp.clamp(12.0, 15.0),
          fontWeight: FontWeight.w500,
          color: const Color(0xFF1E293B),
        ),
        decoration: InputDecoration(
          hintText: 'Enter your full address',
          hintStyle: GoogleFonts.roboto(
            fontSize: 13.sp.clamp(12.0, 14.0),
            color: const Color(0xFF94A3B8),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 12.h,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.roboto(
        fontSize: 12.sp.clamp(11.0, 13.5),
        fontWeight: FontWeight.w400,
        color: const Color(0xFF64748B),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.2,
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.roboto(
          fontSize: 13.5.sp.clamp(12.0, 15.0),
          fontWeight: FontWeight.w500,
          color: const Color(0xFF1E293B),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.roboto(
            fontSize: 13.sp.clamp(12.0, 14.0),
            color: const Color(0xFF94A3B8),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 12.h,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
