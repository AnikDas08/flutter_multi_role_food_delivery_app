import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/component/app_bar/common_app_bar.dart';
import 'package:flutter_code_structure/component/text_field/common_text_field.dart';
import 'package:flutter_code_structure/features/common/auth/presentation/sign_up/widgets/dashed_border_container.dart';
import 'package:flutter_code_structure/utils/extensions/extension.dart';
import '../controller/add_edit_menu_controller.dart';
import '../controller/merchant_menu_controller.dart';

class AddEditMenuScreen extends StatefulWidget {
  const AddEditMenuScreen({super.key});

  @override
  State<AddEditMenuScreen> createState() => _AddEditMenuScreenState();
}

class _AddEditMenuScreenState extends State<AddEditMenuScreen> {
  late final AddEditMenuController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<AddEditMenuController>()
        ? Get.find<AddEditMenuController>()
        : Get.put(AddEditMenuController());

    final args = Get.arguments;
    controller.initializeWithItem(args is MerchantMenuItemModel ? args : null);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(
        title: 'Add or Edit Menu',
        titleSize: 18,
        titleWeight: FontWeight.w700,
        titleColor: Color(0xFF1E293B),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 1. Item Name
            _buildLabel('Item Name'),
            SizedBox(height: 6.h),
            CommonTextField(
              controller: controller.itemNameController,
              hintText: 'Type item name',
              borderColor: const Color(0xFFE5E7EB),
            ),

            14.height,

            /// 2. Item No
            _buildLabel('Item No'),
            SizedBox(height: 6.h),
            CommonTextField(
              controller: controller.itemNoController,
              hintText: 'Type item No here..',
              borderColor: const Color(0xFFE5E7EB),
            ),

            14.height,

            /// 3. Price
            _buildLabel('Price'),
            SizedBox(height: 6.h),
            CommonTextField(
              controller: controller.priceController,
              hintText: '\$0.00',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              borderColor: const Color(0xFFE5E7EB),
            ),

            14.height,

            /// 4. Category
            _buildLabel('Category'),
            SizedBox(height: 6.h),
            _buildCategorySelector(context, controller),

            14.height,

            /// 5. Quantity Limit
            _buildLabel('Quantity Limit'),
            SizedBox(height: 6.h),
            CommonTextField(
              controller: controller.quantityLimitController,
              hintText: 'No Limit',
              borderColor: const Color(0xFFE5E7EB),
            ),

            14.height,

            /// 6. Item Description
            _buildLabel('Item Description'),
            SizedBox(height: 6.h),
            CommonTextField(
              controller: controller.itemDescriptionController,
              hintText: 'Type item description',
              maxLines: 4,
              borderColor: const Color(0xFFE5E7EB),
            ),

            20.height,

            /// 7. Upload Food Picture *
            _buildImageUploadCard(controller),

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
          onTap: controller.submit,
          child: Container(
            height: 52.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF2E0A66),
              borderRadius: BorderRadius.circular(26.r),
            ),
            child: Center(
              child: Text(
                'Submit',
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

  /// Field Label Widget
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

  /// Category Selector Dropdown Field matching CommonTextField
  Widget _buildCategorySelector(
    BuildContext context,
    AddEditMenuController controller,
  ) {
    return GestureDetector(
      onTap: () => _showCategoryPicker(context, controller),
      child: Container(
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() {
              final cat = controller.selectedCategory.value;
              return Text(
                cat ?? 'Select category',
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: cat != null
                      ? const Color(0xFF1E293B)
                      : const Color(0xFF9CA3AF),
                ),
              );
            }),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF6B7280),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  /// Bottom Sheet to pick category (Plomobites or PlomoShop)
  void _showCategoryPicker(
    BuildContext context,
    AddEditMenuController controller,
  ) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: Colors.white,
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  'Select Category',
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                SizedBox(height: 12.h),
                ...controller.categories.map((cat) {
                  return Obx(() {
                    final isSelected =
                        controller.selectedCategory.value == cat;
                    return Container(
                      margin: EdgeInsets.only(bottom: 8.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFF3E8FF)
                            : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF7C3AED)
                              : const Color(0xFFE2E8F0),
                          width: 1.2,
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          cat,
                          style: GoogleFonts.roboto(
                            fontSize: 15.sp,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected
                                ? const Color(0xFF2E0A66)
                                : const Color(0xFF334155),
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(
                                Icons.check_circle_rounded,
                                color: Color(0xFF7C3AED),
                              )
                            : const Icon(
                                Icons.radio_button_unchecked_rounded,
                                color: Color(0xFFCBD5E1),
                              ),
                        onTap: () {
                          controller.selectedCategory.value = cat;
                          Navigator.pop(context);
                        },
                      ),
                    );
                  });
                }),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Upload Picture Dashed Card
  Widget _buildImageUploadCard(AddEditMenuController controller) {
    return DashedBorderContainer(
      borderRadius: 14.r,
      dash: 5,
      gap: 4,
      strokeWidth: 1.2,
      color: const Color(0xFFCBD5E1),
      backgroundColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 22.h),
      child: Center(
        child: Obx(() {
          final localPath = controller.selectedImagePath.value;
          final existingUrl = controller.existingImageUrl.value;

          if (localPath != null && File(localPath).existsSync()) {
            return Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Image.file(
                    File(localPath),
                    width: 120.w,
                    height: 90.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 12.h),
                GestureDetector(
                  onTap: controller.pickImage,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 7.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E0A66),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      'Change Picture',
                      style: GoogleFonts.roboto(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (existingUrl != null && existingUrl.isNotEmpty) {
            final isNetwork = existingUrl.startsWith('http');
            return Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: isNetwork
                      ? CachedNetworkImage(
                          imageUrl: existingUrl,
                          width: 120.w,
                          height: 90.h,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          errorWidget: (_, __, ___) => const Icon(
                            Icons.fastfood_rounded,
                            size: 32,
                            color: Color(0xFF94A3B8),
                          ),
                        )
                      : (File(existingUrl).existsSync()
                          ? Image.file(
                              File(existingUrl),
                              width: 120.w,
                              height: 90.h,
                              fit: BoxFit.cover,
                            )
                          : const Icon(
                              Icons.fastfood_rounded,
                              size: 32,
                              color: Color(0xFF94A3B8),
                            )),
                ),
                SizedBox(height: 12.h),
                GestureDetector(
                  onTap: controller.pickImage,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 7.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E0A66),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      'Change Picture',
                      style: GoogleFonts.roboto(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Cloud Upload Icon
              Container(
                width: 46.w,
                height: 46.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.cloud_upload_rounded,
                    size: 26.sp,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ),

              SizedBox(height: 10.h),

              Text(
                'Upload Food Picture *',
                style: GoogleFonts.roboto(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E293B),
                ),
              ),

              SizedBox(height: 4.h),

              Text(
                'PNG, JPG up to 5MB',
                style: GoogleFonts.roboto(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF94A3B8),
                ),
              ),

              SizedBox(height: 14.h),

              /// Choose File Button
              GestureDetector(
                onTap: controller.pickImage,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E0A66),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'Choose File',
                    style: GoogleFonts.roboto(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
