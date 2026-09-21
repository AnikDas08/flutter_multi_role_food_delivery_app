import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/driver_edit_profile_controller.dart';

class DriverEditProfileScreen extends StatelessWidget {
  const DriverEditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DriverEditProfileController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// 1. Top Custom App Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
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

                  Expanded(
                    child: Center(
                      child: Text(
                        'Edit Profile',
                        style: GoogleFonts.roboto(
                          fontSize: 17.5.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF4C1D95),
                        ),
                      ),
                    ),
                  ),

                  /// Right empty spacer to keep title centered
                  SizedBox(width: 40.w),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),

                    /// 2. Profile Photo with Edit Badge & CHANGE PHOTO Label
                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () =>
                                controller.pickProfilePhoto(context: context),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Obx(() {
                                  final file = controller.profileImage.value;
                                  return Container(
                                    width: 96.w,
                                    height: 96.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: file != null
                                          ? DecorationImage(
                                              image: FileImage(file),
                                              fit: BoxFit.cover,
                                            )
                                          : const DecorationImage(
                                              image: NetworkImage(
                                                'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?fit=crop&w=300&q=80',
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.08),
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
                                    width: 28.w,
                                    height: 28.w,
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
                                      size: 14.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12.h),
                          GestureDetector(
                            onTap: () =>
                                controller.pickProfilePhoto(context: context),
                            child: Text(
                              'CHANGE PHOTO',
                              style: GoogleFonts.roboto(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF334155),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    /// 3. Personal Information Section
                    Text(
                      'Personal Information',
                      style: GoogleFonts.roboto(
                        fontSize: 15.sp,
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
                      child: Row(
                        children: [
                          /// Country Code Box
                          Container(
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
                                    style: TextStyle(fontSize: 17.sp),
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Obx(
                                  () => Text(
                                    controller.selectedCountryCode.value,
                                    style: GoogleFonts.roboto(
                                      fontSize: 12.5.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF1E293B),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 18.sp,
                                  color: const Color(0xFF64748B),
                                ),
                              ],
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
                                fontSize: 13.5.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF1E293B),
                              ),
                              decoration: InputDecoration(
                                hintText: '0123456789',
                                hintStyle: GoogleFonts.roboto(
                                  fontSize: 13.sp,
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
                    ),

                    SizedBox(height: 24.h),

                    /// 4. Additional Information Section
                    Text(
                      'Additional Information',
                      style: GoogleFonts.roboto(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF4C1D95),
                      ),
                    ),

                    SizedBox(height: 14.h),

                    /// Address
                    _buildFieldLabel('Address'),
                    SizedBox(height: 6.h),
                    Container(
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
                        maxLines: 3,
                        style: GoogleFonts.roboto(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1E293B),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter your full address',
                          hintStyle: GoogleFonts.roboto(
                            fontSize: 13.sp,
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

                    SizedBox(height: 14.h),

                    /// Date of Birth & Gender Row
                    Row(
                      children: [
                        /// Date of Birth
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('Date of Birth'),
                              SizedBox(height: 6.h),
                              GestureDetector(
                                onTap: () =>
                                    controller.selectDateOfBirth(context),
                                child: Container(
                                  height: 48.h,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 14.w),
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
                                        fontSize: 13.sp,
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
                                        fontSize: 13.5.sp,
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

                    SizedBox(height: 28.h),

                    /// 5. Bottom Action Button: Save Changes
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
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.roboto(
        fontSize: 12.sp,
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
          fontSize: 13.5.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF1E293B),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.roboto(
            fontSize: 13.sp,
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
