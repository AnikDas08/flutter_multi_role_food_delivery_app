import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_code_structure/component/app_bar/common_app_bar.dart';
import 'package:flutter_code_structure/component/text_field/common_text_field.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';
import 'package:flutter_code_structure/utils/extensions/extension.dart';
import '../controller/merchant_drivers_controller.dart';

class MerchantAddDriverScreen extends StatefulWidget {
  const MerchantAddDriverScreen({super.key});

  @override
  State<MerchantAddDriverScreen> createState() =>
      _MerchantAddDriverScreenState();
}

class _MerchantAddDriverScreenState extends State<MerchantAddDriverScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _vehicleController = TextEditingController();

  final RxBool _isAvailable = true.obs;
  final Rx<String?> _selectedImagePath = Rx<String?>(null);
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _vehicleController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (file != null) {
        _selectedImagePath.value = file.path;
      }
    } catch (e) {
      AppSnackbar.error(
        title: 'Image Error',
        message: 'Failed to select image: $e',
      );
    }
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      AppSnackbar.error(
        title: 'Required Field',
        message: 'Please enter driver full name',
      );
      return;
    }

    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      AppSnackbar.error(
        title: 'Required Field',
        message: 'Please enter driver phone number',
      );
      return;
    }

    final email = _emailController.text.trim();
    final vehicle = _vehicleController.text.trim();

    final controller = Get.isRegistered<MerchantDriversController>()
        ? Get.find<MerchantDriversController>()
        : Get.put(MerchantDriversController());

    controller.addDriver(
      name: name,
      phone: phone,
      email: email,
      vehicle: vehicle,
      imagePath: _selectedImagePath.value,
      isAvailable: _isAvailable.value,
    );

    Get.back();

    AppSnackbar.success(
      title: 'Driver Added',
      message: '$name has been added to the driver list successfully',
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(
        title: 'Add Driver',
        titleSize: 18,
        titleWeight: FontWeight.w700,
        titleColor: Color(0xFF1E293B),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 1. Driver Photo Upload (Avatar with Camera Badge)
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    Obx(() {
                      final path = _selectedImagePath.value;
                      return Container(
                        width: 96.w,
                        height: 96.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFF1F5F9),
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),
                            width: 2,
                          ),
                          image: (path != null && File(path).existsSync())
                              ? DecorationImage(
                                  image: FileImage(File(path)),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: (path == null || !File(path).existsSync())
                            ? Icon(
                                Icons.person_rounded,
                                size: 52.sp,
                                color: const Color(0xFF94A3B8),
                              )
                            : null,
                      );
                    }),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF2E0A66),
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.white,
                          size: 16.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 8.h),
            Center(
              child: Text(
                'Upload Driver Photo',
                style: GoogleFonts.roboto(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
            ),

            24.height,

            /// 2. Driver Full Name *
            _buildLabel('Driver Name *'),
            SizedBox(height: 6.h),
            CommonTextField(
              controller: _nameController,
              hintText: 'Enter driver full name',
              borderColor: const Color(0xFFE5E7EB),
            ),

            14.height,

            /// 3. Phone Number *
            _buildLabel('Phone Number *'),
            SizedBox(height: 6.h),
            CommonTextField(
              controller: _phoneController,
              hintText: '+1 (555) 000-0000',
              keyboardType: TextInputType.phone,
              borderColor: const Color(0xFFE5E7EB),
            ),

            14.height,

            /// 4. Email Address
            _buildLabel('Email Address'),
            SizedBox(height: 6.h),
            CommonTextField(
              controller: _emailController,
              hintText: 'driver@email.com',
              keyboardType: TextInputType.emailAddress,
              borderColor: const Color(0xFFE5E7EB),
            ),

            14.height,

            /// 5. Vehicle / Plate Details
            _buildLabel('Vehicle / Plate Details'),
            SizedBox(height: 6.h),
            CommonTextField(
              controller: _vehicleController,
              hintText: 'e.g. Motorcycle - B 1234 XYZ',
              borderColor: const Color(0xFFE5E7EB),
            ),

            16.height,

            /// 6. Driver Status Selector (Available / Offline)
            _buildLabel('Initial Status'),
            SizedBox(height: 8.h),
            Obx(() {
              final isAvail = _isAvailable.value;
              return Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _isAvailable.value = true,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: isAvail
                              ? const Color(0xFFECFDF5)
                              : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: isAvail
                                ? const Color(0xFF10B981)
                                : const Color(0xFFE2E8F0),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 8.w,
                              height: 8.w,
                              decoration: const BoxDecoration(
                                color: Color(0xFF10B981),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Available',
                              style: GoogleFonts.roboto(
                                fontSize: 14.sp,
                                fontWeight: isAvail
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isAvail
                                    ? const Color(0xFF047857)
                                    : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _isAvailable.value = false,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: !isAvail
                              ? const Color(0xFFFEF2F2)
                              : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: !isAvail
                                ? const Color(0xFFEF4444)
                                : const Color(0xFFE2E8F0),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 8.w,
                              height: 8.w,
                              decoration: const BoxDecoration(
                                color: Color(0xFFEF4444),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Offline',
                              style: GoogleFonts.roboto(
                                fontSize: 14.sp,
                                fontWeight: !isAvail
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: !isAvail
                                    ? const Color(0xFFB91C1C)
                                    : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),

            24.height,
          ],
        ),
      ),

      /// Bottom Submit Button
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          top: 12.h,
          bottom: bottomPadding > 0 ? bottomPadding + 6.h : 18.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();
            _submit();
          },
          child: Container(
            height: 52.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF2E0A66),
              borderRadius: BorderRadius.circular(26.r),
            ),
            child: Center(
              child: Text(
                'Add Driver',
                style: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.roboto(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1E293B),
      ),
    );
  }
}
