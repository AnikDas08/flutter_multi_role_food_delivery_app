import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';
import 'package:flutter_code_structure/utils/helpers/permission_helper.dart';

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _detailsController = TextEditingController();

  final List<File> _selectedDocuments = [];
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromGallery() async {
    HapticFeedback.lightImpact();

    final hasPerm =
        await AppPermissionHelper.requestPhotosPermission(context: context);
    if (!hasPerm) return;

    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        imageQuality: 80,
      );

      if (pickedFiles.isNotEmpty) {
        setState(() {
          for (final xFile in pickedFiles) {
            _selectedDocuments.add(File(xFile.path));
          }
        });
        AppSnackbar.success(
          title: 'Document Added',
          message: '${pickedFiles.length} image(s) attached successfully',
        );
      } else {
        // Fallback for devices where multi-image is canceled or not supported
        final XFile? singleFile = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
        );
        if (singleFile != null) {
          setState(() {
            _selectedDocuments.add(File(singleFile.path));
          });
          AppSnackbar.success(
            title: 'Document Added',
            message: 'Image attached successfully',
          );
        }
      }
    } catch (e) {
      AppSnackbar.error(
        title: 'Notice',
        message: 'Could not select photo: $e',
      );
    }
  }

  void _onSubmit() {
    HapticFeedback.lightImpact();
    final title = _titleController.text.trim();
    final details = _detailsController.text.trim();

    if (title.isEmpty) {
      AppSnackbar.error(
        title: 'Validation Error',
        message: 'Please enter the issue title',
      );
      return;
    }

    if (details.isEmpty) {
      AppSnackbar.error(
        title: 'Validation Error',
        message: 'Please provide issue details',
      );
      return;
    }

    setState(() => _isSubmitting = true);

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _isSubmitting = false);
        AppSnackbar.success(
          title: 'Message Sent',
          message:
              'Thank you! Your ticket has been submitted. Our support team will reach out shortly.',
        );
        Get.back();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// 1. Top Bar
            _buildTopBar(context),

            /// 2. Scrollable Body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 540),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 6.h),

                          /// Information Banner Card
                          _buildSupportBanner(),

                          SizedBox(height: 22.h),

                          /// Issue Title Field
                          _buildFieldLabel('Issue Title'),
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
                            child: TextField(
                              controller: _titleController,
                              style: GoogleFonts.roboto(
                                fontSize: 13.5.sp.clamp(12.0, 15.0),
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF1E293B),
                              ),
                              decoration: InputDecoration(
                                hintText: 'e.g. Order Delay, Missing Items, Refund',
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

                          SizedBox(height: 18.h),

                          /// Details Field
                          _buildFieldLabel('Details'),
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
                              controller: _detailsController,
                              minLines: 4,
                              maxLines: 6,
                              style: GoogleFonts.roboto(
                                fontSize: 13.5.sp.clamp(12.0, 15.0),
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF1E293B),
                              ),
                              decoration: InputDecoration(
                                hintText:
                                    'Please describe the issue you are facing in detail so we can help you promptly...',
                                hintStyle: GoogleFonts.roboto(
                                  fontSize: 13.sp.clamp(12.0, 14.0),
                                  color: const Color(0xFF94A3B8),
                                  height: 1.4,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 14.w,
                                  vertical: 12.h,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),

                          SizedBox(height: 18.h),

                          /// Issue Documents Field (Gallery Photos)
                          _buildFieldLabel('Issue Documents (Attach Photos)'),
                          SizedBox(height: 4.h),
                          Text(
                            'Attach screenshots, receipts, or photos of the order to help us resolve the issue faster.',
                            style: GoogleFonts.roboto(
                              fontSize: 12.sp.clamp(11.0, 13.0),
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                          SizedBox(height: 10.h),

                          /// Upload Container Button
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: _pickImageFromGallery,
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 18.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: const Color(0xFFCBD5E1),
                                  width: 1.2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 44.w,
                                    height: 44.w,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFF3E8FF),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.add_photo_alternate_outlined,
                                      color: const Color(0xFF7C3AED),
                                      size: 24.sp,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'Tap to select images from Gallery',
                                    style: GoogleFonts.roboto(
                                      fontSize: 13.sp.clamp(12.0, 14.5),
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF2E0A66),
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Text(
                                    'Supported: JPG, PNG, JPEG',
                                    style: GoogleFonts.roboto(
                                      fontSize: 11.5.sp.clamp(10.5, 12.5),
                                      color: const Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          /// Attached Images Thumbnails
                          if (_selectedDocuments.isNotEmpty) ...[
                            SizedBox(height: 12.h),
                            SizedBox(
                              height: 84.h,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemCount: _selectedDocuments.length,
                                separatorBuilder: (_, __) =>
                                    SizedBox(width: 10.w),
                                itemBuilder: (context, index) {
                                  final file = _selectedDocuments[index];
                                  return Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        width: 84.w,
                                        height: 84.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          border: Border.all(
                                            color: const Color(0xFFE2E8F0),
                                            width: 1.2,
                                          ),
                                          image: DecorationImage(
                                            image: FileImage(file),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: -6,
                                        right: -6,
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            HapticFeedback.lightImpact();
                                            setState(() {
                                              _selectedDocuments.removeAt(index);
                                            });
                                          },
                                          child: Container(
                                            width: 22.w,
                                            height: 22.w,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFEF4444),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.close_rounded,
                                              size: 14.sp,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],

                          SizedBox(height: 28.h),

                          /// Submit Button
                          SizedBox(
                            width: double.infinity,
                            height: 50.h,
                            child: ElevatedButton(
                              onPressed: _isSubmitting ? null : _onSubmit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E0A66),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.r),
                                ),
                              ),
                              child: _isSubmitting
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                            Colors.white),
                                      ),
                                    )
                                  : Text(
                                      'Send Message',
                                      style: GoogleFonts.roboto(
                                        fontSize: 15.sp.clamp(14.0, 17.0),
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),

                          SizedBox(
                              height: bottomPadding > 0
                                  ? bottomPadding + 10.h
                                  : 24.h),
                        ],
                      ),
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

  /// Top Bar with Circular Back button, centered title, balanced spacer
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

          /// Centered Title
          Expanded(
            child: Center(
              child: Text(
                'Contact & Support',
                style: GoogleFonts.roboto(
                  fontSize: 18.sp.clamp(16.0, 22.0),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2E0A66),
                ),
              ),
            ),
          ),

          /// Balanced spacer to keep title centered (no notification bell)
          SizedBox(width: 42.w.clamp(38.0, 46.0)),
        ],
      ),
    );
  }

  /// Support Details Banner
  Widget _buildSupportBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF5FF),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: const Color(0xFFF3E8FF),
          width: 1.2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: const Color(0xFF2E0A66),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.support_agent_rounded,
              color: Colors.white,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'We are here to help!',
                  style: GoogleFonts.roboto(
                    fontSize: 15.sp.clamp(14.0, 16.5),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2E0A66),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'If you need anything or have encountered any issue, send us a message below. Our support team is online 24/7 to resolve your concern.',
                  style: GoogleFonts.roboto(
                    fontSize: 12.5.sp.clamp(11.5, 14.0),
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF64748B),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.roboto(
        fontSize: 13.sp.clamp(12.0, 14.5),
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1E293B),
      ),
    );
  }
}
