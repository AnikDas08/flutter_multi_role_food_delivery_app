import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/component/app_bar/common_app_bar.dart';
import 'package:flutter_code_structure/component/button/common_button.dart';
import 'package:flutter_code_structure/utils/constants/app_colors.dart';
import 'package:flutter_code_structure/utils/extensions/extension.dart';
import '../controller/merchant_order_details_controller.dart';

class MerchantOrderDetailsScreen extends StatelessWidget {
  const MerchantOrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<MerchantOrderDetailsController>()
        ? Get.find<MerchantOrderDetailsController>()
        : Get.put(MerchantOrderDetailsController());

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: CommonAppBar(
        title: 'Order Details ${controller.orderId}',
        titleSize: 18,
        titleWeight: FontWeight.w700,
        titleColor: const Color(0xFF341280),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          children: [
            /// 1. Order Status Stepper Card
            Obx(() => _buildStatusStepperCard(controller)),

            14.height,

            /// 2. Driver Info Card
            _buildDriverCard(controller),

            14.height,

            /// 3. Ordered Food Items & Summary Card
            _buildItemsSummaryCard(controller),

            14.height,

            /// 4. Special Instructions Card
            _buildSpecialInstructionCard(),

            14.height,

            /// 5. Customer Details Card
            _buildCustomerDetailsCard(controller),

            14.height,

            /// 6. Payment Method Card
            _buildPaymentMethodCard(),

            20.height,
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
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
        child: Obx(() {
          final isReady = controller.currentStatus.value ==
              OrderStepStatus.readyForPickup;
          return GestureDetector(
            onTap: isReady ? null : controller.markReadyForPickup,
            child: Container(
              height: 52.h,
              decoration: BoxDecoration(
                color: isReady
                    ? const Color(0xFF16A34A)
                    : const Color(0xFF2E0A66),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Center(
                child: Text(
                  isReady
                      ? '✓  Ready for Pickup'
                      : '✓  Mark as Ready for Pickup',
                  style: GoogleFonts.roboto(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  /// 1. Order Status Progress Stepper
  Widget _buildStatusStepperCard(MerchantOrderDetailsController controller) {
    final isReady =
        controller.currentStatus.value == OrderStepStatus.readyForPickup;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          /// Stepper Labels Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'In Process',
                style: GoogleFonts.roboto(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF341280),
                ),
              ),
              Text(
                'Cooking',
                style: GoogleFonts.roboto(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF341280),
                ),
              ),
              Text(
                'Ready For Pickup',
                style: GoogleFonts.roboto(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF341280),
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          /// Stepper Track Row
          Row(
            children: [
              /// Dot 1 (In Process - Completed)
              Container(
                width: 20.w,
                height: 20.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF8B5CF6),
                  shape: BoxShape.circle,
                ),
              ),

              /// Line 1
              Expanded(
                child: Container(
                  height: 4.h,
                  color: const Color(0xFF8B5CF6),
                ),
              ),

              /// Dot 2 (Cooking - Active/Completed)
              Container(
                width: 20.w,
                height: 20.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF8B5CF6),
                  shape: BoxShape.circle,
                ),
              ),

              /// Line 2
              Expanded(
                child: Container(
                  height: 4.h,
                  color: isReady
                      ? const Color(0xFF8B5CF6)
                      : const Color(0xFFD8B4FE),
                ),
              ),

              /// Dot 3 (Ready for Pickup)
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: isReady ? const Color(0xFF8B5CF6) : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF8B5CF6),
                    width: 3,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 2. Driver Info Card
  Widget _buildDriverCard(MerchantOrderDetailsController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          /// Driver Info Header Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46.w,
                height: 46.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFE5E7EB),
                    width: 1.5,
                  ),
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    errorWidget: (_, __, ___) =>
                        const Icon(Icons.person, color: Color(0xFF9CA3AF)),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Driver: Alex Rivera',
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      children: [
                        Text(
                          '4.8',
                          style: GoogleFonts.roboto(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF4B5563),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Icon(
                          Icons.star_rounded,
                          color: const Color(0xFFF59E0B),
                          size: 16.sp,
                        ),
                        SizedBox(width: 4.w),
                        Flexible(
                          child: Text(
                            '(238 delivers) • Honda Cultic (Blue)',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.roboto(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                'EST: 12 min',
                style: GoogleFonts.roboto(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF111827),
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          /// Driver Action Buttons Row
          Row(
            children: [
              /// See Driver's Location
              Expanded(
                child: GestureDetector(
                  onTap: controller.seeDriverLocation,
                  child: Container(
                    height: 40.h,
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E0A66),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: const BoxDecoration(
                            color: Colors.white24,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.my_location_rounded,
                            color: Colors.white,
                            size: 14.sp,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Flexible(
                          child: Text(
                            "See Driver's Location",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.roboto(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(width: 10.w),

              /// Message Button
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: controller.messageDriver,
                  child: Container(
                    height: 40.h,
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D9488),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_rounded,
                          color: Colors.white,
                          size: 15.sp,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Message',
                          style: GoogleFonts.roboto(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 3. Ordered Food Items & Summary Card
  Widget _buildItemsSummaryCard(MerchantOrderDetailsController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          /// Food Items List
          ...controller.items.map((item) {
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                children: [
                  /// Burger Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: CachedNetworkImage(
                      imageUrl: item.imageUrl,
                      width: 62.w,
                      height: 52.h,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          Container(color: const Color(0xFFF1F5F9)),
                      errorWidget: (_, __, ___) => Container(
                        color: const Color(0xFFF1F5F9),
                        child: const Icon(Icons.fastfood_rounded),
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  /// Quantity Pill
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      '${item.quantity}x',
                      style: GoogleFonts.roboto(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF475569),
                      ),
                    ),
                  ),

                  SizedBox(width: 10.w),

                  /// Title
                  Expanded(
                    child: Text(
                      item.title,
                      style: GoogleFonts.roboto(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                  ),

                  /// Price
                  Text(
                    item.price,
                    style: GoogleFonts.roboto(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
            );
          }),

          const Divider(color: Color(0xFFF1F5F9), thickness: 1),

          SizedBox(height: 6.h),

          /// Delivery Fee Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delivery Fee:',
                style: GoogleFonts.roboto(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E293B),
                ),
              ),
              Text(
                controller.deliveryFee,
                style: GoogleFonts.roboto(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          /// Total Amount Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total:',
                style: GoogleFonts.roboto(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
              Text(
                controller.totalAmount,
                style: GoogleFonts.roboto(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 4. Special Instructions Card
  Widget _buildSpecialInstructionCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 22.w,
                height: 22.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF9333EA),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: Colors.white,
                    size: 15.sp,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'Especial Instruction',
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            'Please add more salts for the food with chili as well as more sugar for the drink',
            style: GoogleFonts.roboto(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF4B5563),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  /// 5. Customer Details Card
  Widget _buildCustomerDetailsCard(MerchantOrderDetailsController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          Text(
            'Customer Details',
            style: GoogleFonts.roboto(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111827),
            ),
          ),

          SizedBox(height: 12.h),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Customer Avatar
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
                    imageUrl:
                        'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150',
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                    errorWidget: (_, __, ___) =>
                        const Icon(Icons.person, color: Color(0xFF9CA3AF)),
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              /// Customer Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer:',
                      style: GoogleFonts.roboto(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    Text(
                      'Sarah Johnson',
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF111827),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Text(
                          '4.8',
                          style: GoogleFonts.roboto(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF4B5563),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Icon(
                          Icons.star_rounded,
                          color: const Color(0xFFF59E0B),
                          size: 15.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '(15 Orders)',
                          style: GoogleFonts.roboto(
                            fontSize: 11.sp,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Delivery Address: 123 Maple Avenue,\nSpring Field, IL 62704',
                      style: GoogleFonts.roboto(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF6B7280),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),

              /// Customer Message Button
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: controller.messageCustomer,
                child: Container(
                  height: 32.h,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D9488),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.chat_bubble_rounded,
                        size: 13.sp,
                        color: Colors.white,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        'Message',
                        style: GoogleFonts.roboto(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 6. Payment Method Card
  Widget _buildPaymentMethodCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method',
            style: GoogleFonts.roboto(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111827),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              /// Gradient Card Icon
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF8B5CF6),
                      Color(0xFF3B82F6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Icon(
                    Icons.credit_card_rounded,
                    color: Colors.white,
                    size: 22.sp,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Credit/Debit Card: xxxxxxxxxxxxxxxxxx',
                    style: GoogleFonts.roboto(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Paid Via Credit/Debit Card',
                    style: GoogleFonts.roboto(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
