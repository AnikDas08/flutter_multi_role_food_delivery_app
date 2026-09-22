import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/utils/constants/app_images.dart';
import '../controller/customer_dashboard_controller.dart';

class PopularItemCard extends StatelessWidget {
  final CustomerPopularItem item;
  final CustomerDashboardController controller;
  final VoidCallback? onTap;
  final double? width;
  final double? imageHeight;

  const PopularItemCard({
    super.key,
    required this.item,
    required this.controller,
    this.onTap,
    this.width = 152,
    this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () => Get.toNamed(
                AppRoutes.popularItemDetails,
                arguments: item,
              ),
      child: Container(
        width: width?.w,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: const Color(0xFFF1F5F9),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 1. Food Photo with double rounded corners
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16.r),
                bottom: Radius.circular(14.r),
              ),
              child: item.imageUrl.startsWith('http')
                  ? Image.network(
                      item.imageUrl,
                      height: (imageHeight ?? 100).h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        AppImages.beefPizza,
                        height: (imageHeight ?? 100).h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      item.imageUrl,
                      height: (imageHeight ?? 100).h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        AppImages.beefPizza,
                        height: (imageHeight ?? 100).h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),

            /// 2. Middle Information (Title, Rating, Distance, Description)
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10.w, 6.h, 10.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title + Rating
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.roboto(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF2E0A66),
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 14.sp,
                              color: const Color(0xFFF59E0B),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              item.rating.toString(),
                              style: GoogleFonts.roboto(
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF2E0A66),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 2.h),

                    /// Distance & Time
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 12.sp,
                          color: const Color(0xFF94A3B8),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            item.distanceTime,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.roboto(
                              fontSize: 9.5.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 3.h),

                    /// Description
                    Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF94A3B8),
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// 3. Bottom Row: Price on left & Plus Button on bottom-right corner
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 12.w),
                  child: Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF2E0A66),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => controller.addToCart(item),
                  child: Container(
                    width: 48.w,
                    height: 38.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E0A66),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.r),
                        bottomRight: Radius.circular(16.r),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add,
                        size: 22.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
