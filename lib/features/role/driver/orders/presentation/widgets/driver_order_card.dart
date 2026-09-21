import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/config/route/app_routes.dart';
import '../controller/driver_orders_controller.dart';

class DriverOrderCard extends StatelessWidget {
  final DriverOrdersController controller;
  final DriverOrderItem order;

  const DriverOrderCard({
    super.key,
    required this.controller,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.driverOrderDetails, arguments: order),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(16.w),
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
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Top Row: Order ID + Status Badge, Time + Today
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Left: Order # and Status Badge
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      order.orderNumber,
                      style: GoogleFonts.roboto(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Obx(() => _buildStatusBadge(order.status.value)),
                  ],
                ),

                /// Right: Time and Today
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      order.time,
                      style: GoogleFonts.roboto(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      order.date,
                      style: GoogleFonts.roboto(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 8.h),

            /// Customer Name
            Text(
              order.customerName,
              style: GoogleFonts.roboto(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF475569),
              ),
            ),

            SizedBox(height: 3.h),

            /// Items count and Price
            Text(
              '${order.itemCount} ${order.itemCount == 1 ? 'item' : 'items'} • \$${order.totalAmount.toStringAsFixed(2)}',
              style: GoogleFonts.roboto(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF64748B),
              ),
            ),

            SizedBox(height: 14.h),

            /// Bottom Row: Action Button + Customer Avatar
            Row(
              children: [
                /// Action Button
                Expanded(
                  child: Obx(() => _buildActionButton(controller, order)),
                ),

                SizedBox(width: 14.w),

                /// Customer Circular Avatar
                _buildAvatar(order),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Status Badge (New, In Transit, Completed)
  Widget _buildStatusBadge(DriverOrderStatus status) {
    Color bg;
    Color text;
    String label;

    switch (status) {
      case DriverOrderStatus.newOrder:
        bg = const Color(0xFFF3E8FF);
        text = const Color(0xFF7E22CE);
        label = 'New';
        break;
      case DriverOrderStatus.inTransit:
        bg = const Color(0xFFFEF3C7);
        text = const Color(0xFFD97706);
        label = 'In Transit';
        break;
      case DriverOrderStatus.completed:
        bg = const Color(0xFFDCFCE7);
        text = const Color(0xFF16A34A);
        label = 'Completed';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        label,
        style: GoogleFonts.roboto(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: text,
        ),
      ),
    );
  }

  /// Action Button: Start Processing (Purple), Picked Up (Peach/Orange), or Completed (Green check)
  Widget _buildActionButton(
    DriverOrdersController controller,
    DriverOrderItem order,
  ) {
    switch (order.status.value) {
      case DriverOrderStatus.newOrder:
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => controller.handleAction(order),
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              height: 44.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF2E0A66),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                'Start Processing',
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );

      case DriverOrderStatus.inTransit:
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => controller.handleAction(order),
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              height: 44.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                'Picked Up',
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFEA580C),
                ),
              ),
            ),
          ),
        );

      case DriverOrderStatus.completed:
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => controller.handleAction(order),
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              height: 44.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFE6F7F0),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_rounded,
                    color: const Color(0xFF059669),
                    size: 18.sp,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'Completed',
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF059669),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
    }
  }

  /// Circular Avatar with CachedNetworkImage and initials fallback
  Widget _buildAvatar(DriverOrderItem order) {
    return Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1.5,
        ),
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: order.customerAvatar,
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(
            color: const Color(0xFFF1F5F9),
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          errorWidget: (_, __, ___) => Container(
            color: const Color(0xFFEDE9FE),
            child: Center(
              child: Text(
                order.customerName.isNotEmpty ? order.customerName[0] : 'U',
                style: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2E0A66),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
