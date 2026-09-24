import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/config/route/app_routes.dart';
import '../controller/merchant_drivers_controller.dart';

class MerchantDriversScreen extends StatelessWidget {
  const MerchantDriversScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<MerchantDriversController>()
        ? Get.find<MerchantDriversController>()
        : Get.put(MerchantDriversController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 12.h),

            /// Header Title: "Driver List" Centered (with back button if opened as separate page)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (Navigator.of(context).canPop())
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          width: 36.w,
                          height: 36.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                              width: 1,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 16,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                      ),
                    ),
                  Center(
                    child: Text(
                      'Driver List',
                      style: GoogleFonts.roboto(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2E0A66),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12.h),

            /// Filter Dropdown Pill (Right-aligned)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Align(
                alignment: Alignment.centerRight,
                child: _buildFilterDropdownPill(context, controller),
              ),
            ),

            SizedBox(height: 12.h),

            /// Driver Cards List
            Expanded(
              child: Obx(() {
                final drivers = controller.filteredDrivers;
                if (drivers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline_rounded,
                          size: 48.sp,
                          color: const Color(0xFF94A3B8),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'No drivers found',
                          style: GoogleFonts.roboto(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
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
                    top: 4.h,
                    bottom: 20.h,
                  ),
                  itemCount: drivers.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final driver = drivers[index];
                    return _buildDriverCard(controller, driver);
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: SizedBox(
          width: 52.w,
          height: 52.w,
          child: FloatingActionButton(
            onPressed: () => Get.toNamed(AppRoutes.merchantAddDriver),
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

  /// Status Filter Dropdown Pill Widget
  Widget _buildFilterDropdownPill(
    BuildContext context,
    MerchantDriversController controller,
  ) {
    return GestureDetector(
      onTap: () => _showFilterBottomSheet(context, controller),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => Text(
                  controller.filterLabel,
                  style: GoogleFonts.roboto(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF475569),
                  ),
                )),
            SizedBox(width: 4.w),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18.sp,
              color: const Color(0xFF64748B),
            ),
          ],
        ),
      ),
    );
  }

  /// Driver Card Widget
  Widget _buildDriverCard(
    MerchantDriversController controller,
    DriverModel driver,
  ) {
    final isAvailable = driver.isAvailable;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          /// Circular Driver Avatar Image
          ClipOval(
            child: driver.imageUrl.startsWith('http')
                ? CachedNetworkImage(
                    imageUrl: driver.imageUrl,
                    width: 52.w,
                    height: 52.w,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      width: 52.w,
                      height: 52.w,
                      color: const Color(0xFFF1F5F9),
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (_, __, ___) => _buildAvatarFallback(driver),
                  )
                : (File(driver.imageUrl).existsSync()
                    ? Image.file(
                        File(driver.imageUrl),
                        width: 52.w,
                        height: 52.w,
                        fit: BoxFit.cover,
                      )
                    : _buildAvatarFallback(driver)),
          ),

          SizedBox(width: 12.w),

          /// Driver Name and Phone Number
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  driver.name,
                  style: GoogleFonts.roboto(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E293B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 3.h),
                Text(
                  driver.phone,
                  style: GoogleFonts.roboto(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 8.w),

          /// Right Side: Status Indicator + Assign Button
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Status Indicator Dot & Label
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7.w,
                    height: 7.w,
                    decoration: BoxDecoration(
                      color: isAvailable
                          ? const Color(0xFF22C55E)
                          : const Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    isAvailable ? 'Available' : 'Offline',
                    style: GoogleFonts.roboto(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: isAvailable
                          ? const Color(0xFF22C55E)
                          : const Color(0xFFEF4444),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10.h),

              /// Assign Button
              Obx(() {
                final isAssigned = driver.isAssigned.value;

                return GestureDetector(
                  onTap: () => controller.assignDriver(driver),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      horizontal: 22.w,
                      vertical: 7.h,
                    ),
                    decoration: BoxDecoration(
                      color: isAvailable
                          ? (isAssigned
                              ? const Color(0xFF16A34A)
                              : const Color(0xFF2E0A66))
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: isAvailable
                          ? [
                              BoxShadow(
                                color: (isAssigned
                                        ? const Color(0xFF16A34A)
                                        : const Color(0xFF2E0A66))
                                    .withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      isAssigned ? 'Assigned' : 'Assign',
                      style: GoogleFonts.roboto(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: isAvailable
                            ? Colors.white
                            : const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  /// Bottom Sheet to filter driver status
  void _showFilterBottomSheet(
    BuildContext context,
    MerchantDriversController controller,
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
                  'Filter by Status',
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                SizedBox(height: 12.h),
                _buildFilterOption(
                  context,
                  controller,
                  label: 'All Status',
                  filter: DriverStatusFilter.all,
                ),
                _buildFilterOption(
                  context,
                  controller,
                  label: 'Available',
                  filter: DriverStatusFilter.available,
                ),
                _buildFilterOption(
                  context,
                  controller,
                  label: 'Offline',
                  filter: DriverStatusFilter.offline,
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(
    BuildContext context,
    MerchantDriversController controller, {
    required String label,
    required DriverStatusFilter filter,
  }) {
    return Obx(() {
      final isSelected = controller.selectedFilter.value == filter;

      return Container(
        margin: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF3E8FF) : const Color(0xFFF8FAFC),
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
            label,
            style: GoogleFonts.roboto(
              fontSize: 15.sp,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
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
            controller.setFilter(filter);
            Navigator.pop(context);
          },
        ),
      );
    });
  }

  Widget _buildAvatarFallback(DriverModel driver) {
    return Container(
      width: 52.w,
      height: 52.w,
      color: const Color(0xFFEDE9FE),
      child: Center(
        child: Text(
          driver.name.isNotEmpty ? driver.name[0].toUpperCase() : 'D',
          style: GoogleFonts.roboto(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF6D28D9),
          ),
        ),
      ),
    );
  }
}
