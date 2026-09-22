import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/utils/constants/app_images.dart';
import '../controller/customer_dashboard_controller.dart';

class PopularRestaurantCard extends StatelessWidget {
  final CustomerRestaurant restaurant;
  final CustomerDashboardController controller;
  final VoidCallback? onTap;

  final double? width;
  final double? imageHeight;
  final bool isVertical;

  const PopularRestaurantCard({
    super.key,
    required this.restaurant,
    required this.controller,
    this.onTap,
    this.width = 255,
    this.imageHeight,
    this.isVertical = false,
  });

  @override
  Widget build(BuildContext context) {
    final double fixedImgHeight = (imageHeight ?? (isVertical ? 170 : 136)).h;

    final imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: SizedBox(
        height: fixedImgHeight,
        width: double.infinity,
        child: Stack(
          children: [
            SizedBox(
              height: fixedImgHeight,
              width: double.infinity,
              child: restaurant.imageUrl.startsWith('assets/')
                  ? Image.asset(
                      restaurant.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        AppImages.chezBurgers,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.network(
                      restaurant.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        AppImages.chezBurgers,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),

            /// Bottom-left Rating Pill
            Positioned(
              left: 8.w,
              bottom: 8.h,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 7.w,
                  vertical: 3.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: 14.sp,
                      color: const Color(0xFFF59E0B),
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      restaurant.rating.toString(),
                      style: GoogleFonts.roboto(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// Bottom-right Heart Button
            Positioned(
              right: 8.w,
              bottom: 8.h,
              child: Obx(
                () => InkWell(
                  onTap: () =>
                      controller.toggleRestaurantFavorite(restaurant.id),
                  child: Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      restaurant.isFavorite.value
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 16.sp,
                      color: restaurant.isFavorite.value
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF2E0A66),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Widget detailsContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          isVertical ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
      children: [
        /// 2. Name & Starting Price Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                restaurant.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.roboto(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2E0A66),
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              'Starting \$${restaurant.startingPrice.toStringAsFixed(0)}',
              style: GoogleFonts.roboto(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2E0A66),
              ),
            ),
          ],
        ),

        SizedBox(height: 2.5.h),

        /// 3. Description (tightly grouped)
        Text(
          restaurant.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.roboto(
            fontSize: 9.sp,
            color: const Color(0xFF64748B),
            height: 1.25,
          ),
        ),

        SizedBox(height: 5.h),

        /// 4. Delivery & Location Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.local_shipping_rounded,
              size: 13.sp,
              color: const Color(0xFF2E0A66),
            ),
            SizedBox(width: 4.w),
            Text(
              restaurant.deliveryType,
              style: GoogleFonts.roboto(
                fontSize: 9.5.sp,
                color: const Color(0xFF64748B),
              ),
            ),
            SizedBox(width: 10.w),
            Icon(
              Icons.location_on_rounded,
              size: 13.sp,
              color: const Color(0xFF2E0A66),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                restaurant.location,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.roboto(
                  fontSize: 9.5.sp,
                  color: const Color(0xFF64748B),
                ),
              ),
            ),
          ],
        ),
      ],
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isVertical ? null : width?.w,
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
        padding: EdgeInsets.all(8.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 1. Image with exact identical height
            imageWidget,

            SizedBox(height: isVertical ? 8.h : 6.h),

            /// 2. Information Details
            if (isVertical)
              detailsContent
            else
              Expanded(child: detailsContent),
          ],
        ),
      ),
    );
  }
}
