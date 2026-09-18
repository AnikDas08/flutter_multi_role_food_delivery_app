import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_code_structure/component/image/common_image.dart';
import 'package:flutter_code_structure/utils/constants/app_colors.dart';
import 'dashed_border_container.dart';

class DocumentUploadCard extends StatelessWidget {
  final String label;
  final String title;
  final String subtitle;
  final String buttonText;
  final IconData icon;
  final String? imagePath;
  final Function(ImageSource source) onPickImage;
  final VoidCallback onRemove;

  const DocumentUploadCard({
    super.key,
    required this.label,
    required this.title,
    required this.subtitle,
    this.buttonText = 'Upload Photo',
    required this.icon,
    required this.imagePath,
    required this.onPickImage,
    required this.onRemove,
  });

  void _showPickerSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) {
        return SafeArea(
          top: false,
          bottom: true,
          child: Padding(
            padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              top: 14.h,
              bottom: 16.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 16.h),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
                  leading: Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E8FF),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  title: Text(
                    'Take Photo',
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                  subtitle: Text(
                    'Use camera to capture document',
                    style: GoogleFonts.roboto(
                      fontSize: 12.sp,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    onPickImage(ImageSource.camera);
                  },
                ),
                SizedBox(height: 6.h),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
                  leading: Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E8FF),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: const Icon(
                      Icons.photo_library_rounded,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  title: Text(
                    'Choose from Gallery',
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                  subtitle: Text(
                    'Select photo or file from library',
                    style: GoogleFonts.roboto(
                      fontSize: 12.sp,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    onPickImage(ImageSource.gallery);
                  },
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = imagePath != null && imagePath!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Field Section Label
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF374151),
            ),
          ),
          SizedBox(height: 8.h),
        ],

        /// Dashed Card Box
        DashedBorderContainer(
          width: double.infinity,
          borderRadius: 12.r,
          backgroundColor: const Color(0xFFFAFAFA),
          color: const Color(0xFFD1D5DB),
          dash: 6,
          gap: 4,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: hasImage
              ? Column(
                  children: [
                    Stack(
                      children: [
                        CommonImage(
                          imageSrc: imagePath!,
                          height: 140,
                          width: double.infinity,
                          borderRadius: 10.r,
                          fill: BoxFit.cover,
                        ),
                        Positioned(
                          top: 8.h,
                          right: 8.w,
                          child: GestureDetector(
                            onTap: onRemove,
                            child: Container(
                              padding: EdgeInsets.all(6.w),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: const Color(0xFF22C55E),
                              size: 18.sp,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              'Document attached',
                              style: GoogleFonts.roboto(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF22C55E),
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () => _showPickerSheet(context),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Change',
                            style: GoogleFonts.roboto(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Circle Icon
                    Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF5EEFF),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          icon,
                          color: AppColors.primaryColor,
                          size: 22.sp,
                        ),
                      ),
                    ),

                    SizedBox(height: 10.h),

                    /// Title
                    Text(
                      title,
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    /// Subtitle
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF6B7280),
                      ),
                    ),

                    SizedBox(height: 14.h),

                    /// Action Pill Button
                    ElevatedButton.icon(
                      onPressed: () => _showPickerSheet(context),
                      icon: const Icon(
                        Icons.camera_alt_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                      label: Text(
                        buttonText,
                        style: GoogleFonts.roboto(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          horizontal: 22.w,
                          vertical: 9.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
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
