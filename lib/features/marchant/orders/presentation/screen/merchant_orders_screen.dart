import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/utils/constants/app_colors.dart';
import 'package:flutter_code_structure/utils/extensions/extension.dart';
import '../controller/merchant_orders_controller.dart';

class MerchantOrdersScreen extends StatelessWidget {
  const MerchantOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<MerchantOrdersController>()
        ? Get.find<MerchantOrdersController>()
        : Get.put(MerchantOrdersController());

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Orders',
          style: GoogleFonts.roboto(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF111827),
          ),
        ),
      ),
      body: Obx(
        () => ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          itemCount: controller.orders.length,
          separatorBuilder: (_, __) => SizedBox(height: 14.h),
          itemBuilder: (context, index) {
            final order = controller.orders[index];
            return _buildOrderCard(context, controller, order);
          },
        ),
      ),
    );
  }

  Widget _buildOrderCard(
    BuildContext context,
    MerchantOrdersController controller,
    MerchantOrderModel order,
  ) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.merchantOrderDetails),
      child: Container(
        padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top Row: Order ID + Status Pill & Time + Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    order.orderId,
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  _buildStatusPill(order.statusType, order.statusLabel),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    order.time,
                    style: GoogleFonts.roboto(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    order.date,
                    style: GoogleFonts.roboto(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 6.h),

          /// Middle: Customer Name & Items summary
          Text(
            order.customerName,
            style: GoogleFonts.roboto(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF4B5563),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            '${order.itemCount} item${order.itemCount > 1 ? 's' : ''} • ${order.totalPrice}',
            style: GoogleFonts.roboto(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF6B7280),
            ),
          ),

          SizedBox(height: 14.h),

          /// Bottom: Action Button / Status Display + Customer Avatar
          Row(
            children: [
              Expanded(
                child: _buildActionButton(context, controller, order),
              ),
              SizedBox(width: 14.w),
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFE5E7EB),
                    width: 1.5,
                  ),
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: order.avatarUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    errorWidget: (_, __, ___) => const Icon(
                      Icons.person,
                      color: Color(0xFF9CA3AF),
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

  Widget _buildStatusPill(OrderStatusType type, String label) {
    Color bg;
    Color text;

    switch (type) {
      case OrderStatusType.newOrder:
        bg = const Color(0xFFF3E8FF);
        text = const Color(0xFF7E22CE);
        break;
      case OrderStatusType.inTransit:
        bg = const Color(0xFFFEF3C7);
        text = const Color(0xFFD97706);
        break;
      case OrderStatusType.completed:
        bg = const Color(0xFFDCFCE7);
        text = const Color(0xFF16A34A);
        break;
      case OrderStatusType.assignDriver:
        bg = const Color(0xFFF1F5F9);
        text = const Color(0xFF64748B);
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

  Widget _buildActionButton(
    BuildContext context,
    MerchantOrdersController controller,
    MerchantOrderModel order,
  ) {
    switch (order.statusType) {
      case OrderStatusType.newOrder:
        return GestureDetector(
          onTap: () => controller.startProcessing(order.orderId),
          child: Container(
            height: 44.h,
            decoration: BoxDecoration(
              color: const Color(0xFF2E0A66),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
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

      case OrderStatusType.inTransit:
        return Container(
          height: 44.h,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7ED),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Center(
            child: Text(
              'In Transit',
              style: GoogleFonts.roboto(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFEA580C),
              ),
            ),
          ),
        );

      case OrderStatusType.completed:
        return Container(
          height: 44.h,
          decoration: BoxDecoration(
            color: const Color(0xFFECFDF5),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_rounded,
                color: const Color(0xFF10B981),
                size: 18.sp,
              ),
              SizedBox(width: 6.w),
              Text(
                'Completed',
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),
        );

      case OrderStatusType.assignDriver:
        return InkWell(
          onTap: () => controller.assignDriver(order.orderId),
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            height: 44.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Assign Driver',
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF334155),
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.delivery_dining_rounded,
                  size: 20.sp,
                  color: const Color(0xFF334155),
                ),
              ],
            ),
          ),
        );
    }
  }
}
