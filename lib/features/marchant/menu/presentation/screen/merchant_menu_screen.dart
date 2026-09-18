import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/utils/constants/app_icons.dart';
import '../controller/merchant_menu_controller.dart';

class MerchantMenuScreen extends StatelessWidget {
  const MerchantMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<MerchantMenuController>()
        ? Get.find<MerchantMenuController>()
        : Get.put(MerchantMenuController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Menu Items',
          style: GoogleFonts.roboto(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1E293B),
          ),
        ),
      ),
      body: Column(
        children: [
          /// Top Section: Search Bar & Filter Tabs
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              top: 8.h,
              bottom: 14.h,
            ),
            child: Column(
              children: [
                /// Search Input Field
                Container(
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.r),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 1.2,
                    ),
                  ),
                  child: TextField(
                    controller: controller.searchController,
                    textAlignVertical: TextAlignVertical.center,
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      color: const Color(0xFF1E293B),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Type to Search',
                      hintStyle: GoogleFonts.roboto(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF94A3B8),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                      suffixIcon: Obx(() {
                        if (controller.searchQuery.value.isNotEmpty) {
                          return GestureDetector(
                            onTap: () {
                              controller.searchController.clear();
                              controller.searchQuery.value = '';
                            },
                            child: const Icon(
                              Icons.close_rounded,
                              size: 18,
                              color: Color(0xFF94A3B8),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                    ),
                  ),
                ),

                SizedBox(height: 14.h),

                /// Category Filter Pills Row
                Obx(() {
                  final activeFilter = controller.selectedFilter.value;
                  return Row(
                    children: [
                      _buildFilterPill(
                        label: 'All (${controller.totalCount})',
                        isActive: activeFilter == MenuFilter.all,
                        onTap: () => controller.selectFilter(MenuFilter.all),
                      ),
                      SizedBox(width: 10.w),
                      _buildFilterPill(
                        label: 'Available (${controller.availableCount})',
                        isActive: activeFilter == MenuFilter.available,
                        onTap: () =>
                            controller.selectFilter(MenuFilter.available),
                      ),
                      SizedBox(width: 10.w),
                      _buildFilterPill(
                        label: 'Unavailable (${controller.unavailableCount})',
                        isActive: activeFilter == MenuFilter.unavailable,
                        onTap: () =>
                            controller.selectFilter(MenuFilter.unavailable),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),

          /// Menu Items List
          Expanded(
            child: Obx(() {
              final items = controller.filteredItems;

              if (items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.restaurant_menu_rounded,
                        size: 48.sp,
                        color: const Color(0xFFCBD5E1),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'No menu items found',
                        style: GoogleFonts.roboto(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  top: 14.h,
                  bottom: 80.h,
                ),
                itemCount: items.length,
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _buildMenuItemCard(context, controller, item);
                },
              );
            }),
          ),
        ],
      ),

      /// Floating Action Button (+)
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: SizedBox(
          width: 52.w,
          height: 52.w,
          child: FloatingActionButton(
            onPressed: controller.addNewItem,
            backgroundColor: const Color(0xFF2E0A66),
            elevation: 4,
            shape: const CircleBorder(),
            child: Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: 28.sp,
            ),
          ),
        ),
      ),
    );
  }

  /// Filter Tab Pill Widget
  Widget _buildFilterPill({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF2E0A66) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 12.sp,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  /// Individual Menu Item Card
  Widget _buildMenuItemCard(
    BuildContext context,
    MerchantMenuController controller,
    MerchantMenuItemModel item,
  ) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => controller.editItem(item),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: const Color(0xFFF1F5F9),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Food Thumbnail Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: item.imageUrl.startsWith('http')
                  ? CachedNetworkImage(
                      imageUrl: item.imageUrl,
                      width: 68.w,
                      height: 68.w,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        width: 68.w,
                        height: 68.w,
                        color: const Color(0xFFF1F5F9),
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        width: 68.w,
                        height: 68.w,
                        color: const Color(0xFFF1F5F9),
                        child: const Icon(
                          Icons.fastfood_rounded,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    )
                  : (File(item.imageUrl).existsSync()
                      ? Image.file(
                          File(item.imageUrl),
                          width: 68.w,
                          height: 68.w,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 68.w,
                          height: 68.w,
                          color: const Color(0xFFF1F5F9),
                          child: const Icon(
                            Icons.fastfood_rounded,
                            color: Color(0xFF94A3B8),
                          ),
                        )),
            ),

            SizedBox(width: 12.w),

          /// Item Information: Title, Price, Status Pill
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                Text(
                  item.title,
                  style: GoogleFonts.roboto(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E293B),
                  ),
                ),

                SizedBox(height: 3.h),

                /// Price
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E293B),
                  ),
                ),

                SizedBox(height: 6.h),

                /// Availability Status Pill
                Obx(() {
                  final isAvail = item.isAvailable.value;
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: isAvail
                          ? const Color(0xFFFAF5FF)
                          : const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isAvail
                            ? const Color(0xFFEDE9FE)
                            : const Color(0xFFFEE2E2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6.w,
                          height: 6.w,
                          decoration: BoxDecoration(
                            color: isAvail
                                ? const Color(0xFF6D28D9)
                                : const Color(0xFFEF4444),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          isAvail ? 'Available' : 'Unavailable',
                          style: GoogleFonts.roboto(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: isAvail
                                ? const Color(0xFF6D28D9)
                                : const Color(0xFFDC2626),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),

          SizedBox(width: 10.w),

          /// Actions: Edit Button + Toggle Switch (Top) and Item No Pill (Bottom)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Top Row: Edit Pen Icon + Availability Toggle Switch
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => controller.editItem(item),
                    child: Padding(
                      padding: EdgeInsets.all(6.w),
                      child: SvgPicture.asset(
                        AppIcons.editIcon,
                        width: 20.w,
                        height: 20.w,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF64748B),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),

                  /// Custom Pill Toggle Switch
                  Obx(() {
                    final isAvail = item.isAvailable.value;
                    return GestureDetector(
                      onTap: () => controller.toggleAvailability(item),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 42.w,
                        height: 24.h,
                        padding: EdgeInsets.all(2.5.w),
                        decoration: BoxDecoration(
                          color: isAvail
                              ? const Color(0xFF2E0A66)
                              : const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: AnimatedAlign(
                          duration: const Duration(milliseconds: 200),
                          alignment: isAvail
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            width: 19.w,
                            height: 19.w,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 3,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),

              SizedBox(height: 18.h),

              /// Bottom: Item No Pill
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 3.h,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E8FF),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  item.itemNumber,
                  style: GoogleFonts.roboto(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF7C3AED),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      )
    );
  }
}
