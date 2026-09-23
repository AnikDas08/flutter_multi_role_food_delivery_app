import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/services/storage/storage_services.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';

class MerchantEditProfileScreen extends StatefulWidget {
  const MerchantEditProfileScreen({super.key});

  @override
  State<MerchantEditProfileScreen> createState() =>
      _MerchantEditProfileScreenState();
}

class _MerchantEditProfileScreenState extends State<MerchantEditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _websiteController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Alex Johnson');
    _emailController =
        TextEditingController(text: 'alex@thecoffeecorner.com');
    _phoneController = TextEditingController(text: '+1 (555) 123-4567');
    _websiteController =
        TextEditingController(text: 'www.thecoffeecorner.com');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  void _onSave() {
    HapticFeedback.lightImpact();
    AppSnackbar.success(
      title: 'Profile Updated',
      message: 'Your profile changes have been saved successfully.',
    );
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// 1. Top Bar: Circular Back Button & Title
            _buildTopBar(),

            /// 2. Scrollable Body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 540),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Avatar with edit pen & "CHANGE PHOTO"
                        Center(
                          child: Column(
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    width: 104.w.clamp(90.0, 115.0),
                                    height: 104.w.clamp(90.0, 115.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFFF1F5F9),
                                        width: 2,
                                      ),
                                      image: const DecorationImage(
                                        image: NetworkImage(
                                          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?fit=crop&w=300&q=80',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 2.h,
                                    right: 2.w,
                                    child: GestureDetector(
                                      onTap: () {
                                        AppSnackbar.info(
                                          title: 'Change Photo',
                                          message: 'Select image from gallery',
                                        );
                                      },
                                      child: Container(
                                        width: 30.w,
                                        height: 30.w,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF2E0A66),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.edit_rounded,
                                            color: Colors.white,
                                            size: 15.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              GestureDetector(
                                onTap: () {
                                  AppSnackbar.info(
                                    title: 'Change Photo',
                                    message: 'Select image from gallery',
                                  );
                                },
                                child: Text(
                                  'CHANGE PHOTO',
                                  style: GoogleFonts.roboto(
                                    fontSize: 12.5.sp,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.4,
                                    color: const Color(0xFF2E0A66),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 24.h),

                        /// Section Title: Personal Information
                        Text(
                          'Personal Information',
                          style: GoogleFonts.roboto(
                            fontSize: 15.5.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2E0A66),
                          ),
                        ),

                        SizedBox(height: 16.h),

                        /// 1. Full Name
                        _buildLabel('Full Name'),
                        SizedBox(height: 6.h),
                        _buildTextField(_nameController),

                        SizedBox(height: 14.h),

                        /// 2. Email Address
                        _buildLabel('Email Address'),
                        SizedBox(height: 6.h),
                        _buildTextField(_emailController,
                            keyboardType: TextInputType.emailAddress),

                        SizedBox(height: 14.h),

                        /// 3. Phone (optional)
                        _buildLabel('Phone (optional)'),
                        SizedBox(height: 6.h),
                        _buildPhoneField(),

                        SizedBox(height: 14.h),

                        /// 4. Website (Optional)
                        _buildLabel('Website (Optional)'),
                        SizedBox(height: 6.h),
                        _buildTextField(_websiteController,
                            keyboardType: TextInputType.url),

                        SizedBox(height: 32.h),

                        /// Save Changes Button
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _onSave,
                          child: Container(
                            width: double.infinity,
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E0A66),
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                            child: Center(
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
                        ),

                        SizedBox(height: bottomPadding > 0 ? bottomPadding : 16.h),
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

  /// Top Bar with Circular Back Button and Centered Title
  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Get.back(),
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
          SizedBox(width: 42.w.clamp(38.0, 46.0)),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.roboto(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF64748B),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.1),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.roboto(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1E293B),
          ),
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.1),
      ),
      child: Row(
        children: [
          /// USA Flag & dropdown pill
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            margin: EdgeInsets.only(left: 4.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🇺🇸', style: TextStyle(fontSize: 18)),
                SizedBox(width: 5.w),
                Text(
                  'USA',
                  style: GoogleFonts.roboto(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF475569),
                  ),
                ),
                SizedBox(width: 3.w),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 16.sp,
                  color: const Color(0xFF64748B),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: GoogleFonts.roboto(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1E293B),
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 6.w,
                  vertical: 12.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
