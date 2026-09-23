import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';
import 'package:flutter_code_structure/utils/constants/app_images.dart';

class CustomerOrderDetailsScreen extends StatefulWidget {
  const CustomerOrderDetailsScreen({super.key});

  @override
  State<CustomerOrderDetailsScreen> createState() =>
      _CustomerOrderDetailsScreenState();
}

class _CustomerOrderDetailsScreenState
    extends State<CustomerOrderDetailsScreen> {
  late final Map<String, dynamic> _order;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      _order = args;
    } else {
      // Default fallback order matching the mockup
      _order = {
        'restaurant': 'Burger House',
        'orderId': 'Order: #12345',
        'orderNumber': '12345',
        'date': '18 Sep, 7:30',
        'rating': '4.8',
        'imageUrl': AppImages.doubleBurger,
        'items': [
          {'name': '1x Burger Combo', 'price': '\$8.99'},
          {'name': '1x Fries', 'price': '\$3.00'},
        ],
        'subtotal': '\$11.99',
        'deliveryFee': '\$2.00',
        'distance': '1.2M',
        'total': '\$13.99',
        'merchantName': 'The Burger king',
        'merchantStatus': 'Order in Progress',
        'deliveryMan': {
          'name': 'Lucas Nathan',
          'rating': '4.7',
          'phone': '017218897766',
          'image': AppImages.profile,
        },
        'address': '4140 Parker Rd. Allentown, New Mexico 31134',
        'instructions':
            "Please ring the doorbell twice and leave the order at the door. I'll be waiting upstairs. Extra napkins would be appreciated. Thank you!",
      };
    }
  }

  void _onCancelOrder() {
    HapticFeedback.mediumImpact();
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 58.w,
                height: 58.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEF2F2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: const Color(0xFFEF4444),
                    size: 32.sp,
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              Text(
                'Cancel Order?',
                style: GoogleFonts.roboto(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2E0A66),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Are you sure you want to cancel this order? This action cannot be undone.',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 13.sp,
                  color: const Color(0xFF64748B),
                  height: 1.4,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(
                        'Keep Order',
                        style: GoogleFonts.roboto(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back(); // close dialog
                        AppSnackbar.error(
                          title: 'Order Cancelled',
                          message: 'Your order has been cancelled.',
                        );
                        Get.back(); // return to orders list
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.r),
                        ),
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(
                        'Yes, Cancel',
                        style: GoogleFonts.roboto(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w600,
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
      ),
    );
  }

  void _onNeedHelp() {
    HapticFeedback.lightImpact();
    Get.toNamed(AppRoutes.contactSupport);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580),
            child: Column(
              children: [
                /// 1. Top Bar: Back button, Centered Title, Notification Bell with red dot
                _buildTopBar(),

                /// 2. Scrollable Order Details Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Main Restaurant / Order Banner Card
                        _buildMainOrderCard(),

                        SizedBox(height: 16.h),

                        /// Order Summary Section
                        _buildOrderSummarySection(),

                        SizedBox(height: 18.h),

                        /// Merchant Shop Card (with Chat icon)
                        _buildMerchantShopSection(),

                        SizedBox(height: 14.h),

                        /// "Live Track" Button
                        _buildLiveTrackButton(),

                        SizedBox(height: 20.h),

                        /// "Your order is being processed" Timeline Stepper
                        _buildTrackingTimelineSection(),

                        SizedBox(height: 18.h),

                        /// Special Instructions
                        _buildSpecialInstructionsSection(),

                        SizedBox(height: 18.h),

                        /// Delivery Address
                        _buildDeliveryAddressSection(),

                        SizedBox(height: 16.h),

                        /// Cancel Order Button (Red)
                        _buildCancelOrderButton(),

                        SizedBox(height: 10.h),

                        /// Need Help? Button (Outline, NO chat icon per user instruction)
                        _buildNeedHelpButton(),

                        SizedBox(height: 20.h),

                        /// Assign Delivery Man Section (with Chat icon)
                        _buildAssignDeliveryManSection(),

                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 1. Top Bar: Circular Back button, "Order Details" Title, Circular Notification Bell with Red Dot
  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Row(
        children: [
          /// Back Button
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Get.back(),
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
                'Order Details',
                style: GoogleFonts.roboto(
                  fontSize: 18.sp.clamp(16.0, 22.0),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2E0A66),
                ),
              ),
            ),
          ),

          /// Balanced Spacer on Right (Notification icon removed per request)
          SizedBox(width: 42.w.clamp(38.0, 46.0)),
        ],
      ),
    );
  }

  /// 2. Main Order Header Card: Food image, Burger House, Order ID / Date
  Widget _buildMainOrderCard() {
    final restaurant = _order['restaurant'] ?? 'Burger House';
    final orderId = _order['orderId'] ?? 'Order: #12345';
    final date = _order['date'] ?? '18 Sep, 7:30';
    final imageUrl = _order['imageUrl'] ?? AppImages.doubleBurger;

    return Container(
      padding: EdgeInsets.all(12.r),
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
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Image.asset(
              imageUrl,
              width: 54.w,
              height: 54.w,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 54.w,
                height: 54.w,
                color: const Color(0xFFF1F5F9),
                child: Icon(Icons.fastfood,
                    size: 28.sp, color: const Color(0xFF94A3B8)),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant,
                  style: GoogleFonts.roboto(
                    fontSize: 15.5.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2E0A66),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  '$orderId / $date',
                  style: GoogleFonts.roboto(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 3. Order Summary Section ("Order Summer" in mockup)
  Widget _buildOrderSummarySection() {
    final List items = _order['items'] as List? ?? [
      {'name': '1x Burger Combo', 'price': '\$8.99'},
      {'name': '1x Fries', 'price': '\$3.00'},
    ];
    final subtotal = _order['subtotal'] ?? '\$11.99';
    final deliveryFee = _order['deliveryFee'] ?? '\$2.00';
    final distance = _order['distance'] ?? '1.2M';
    final total = _order['total'] ?? '\$13.99';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Summary',
          style: GoogleFonts.roboto(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2E0A66),
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.all(14.r),
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
          child: Column(
            children: [
              /// Order Items
              ...items.map((it) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        it['name'] ?? '',
                        style: GoogleFonts.roboto(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      Text(
                        it['price'] ?? '',
                        style: GoogleFonts.roboto(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2E0A66),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              SizedBox(height: 4.h),

              /// Subtotal
              _buildSummaryRow('Subtotal', subtotal),
              SizedBox(height: 6.h),

              /// Delivery fee
              _buildSummaryRow('Delivery fee', deliveryFee),
              SizedBox(height: 6.h),

              /// Distance
              _buildSummaryRow('Distance', distance),

              SizedBox(height: 10.h),
              const Divider(color: Color(0xFFF1F5F9), height: 1),
              SizedBox(height: 10.h),

              /// Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: GoogleFonts.roboto(
                      fontSize: 14.5.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2E0A66),
                    ),
                  ),
                  Text(
                    total,
                    style: GoogleFonts.roboto(
                      fontSize: 16.5.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF2E0A66),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 13.5.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF64748B),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 13.5.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2E0A66),
          ),
        ),
      ],
    );
  }

  /// 4. Merchant Shop Section with Chat Icon Button
  Widget _buildMerchantShopSection() {
    final merchantName = _order['merchantName'] ?? 'The Burger king';
    final merchantStatus = _order['merchantStatus'] ?? 'Order in Progress';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Merchant Shop',
          style: GoogleFonts.roboto(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2E0A66),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
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
            children: [
              /// Burger King Logo
              const _BurgerKingAvatar(size: 42),

              SizedBox(width: 12.w),

              /// Merchant Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      merchantName,
                      style: GoogleFonts.roboto(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2E0A66),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      merchantStatus,
                      style: GoogleFonts.roboto(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF8E8E93),
                      ),
                    ),
                  ],
                ),
              ),

              /// Chat Button with Merchant
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  HapticFeedback.lightImpact();
                  Get.toNamed(
                    AppRoutes.message,
                    arguments: {
                      'orderId': _order['orderNumber'] ?? '12345',
                      'restaurant': merchantName,
                      'status': merchantStatus,
                      'isMerchant': true,
                    },
                  );
                },
                child: Container(
                  width: 38.w,
                  height: 38.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E8FF),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.chat_bubble_rounded,
                      color: const Color(0xFF2E0A66),
                      size: 19.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 5. Live Track Button
  Widget _buildLiveTrackButton() {
    return SizedBox(
      width: double.infinity,
      height: 48.h.clamp(44.0, 54.0),
      child: ElevatedButton(
        onPressed: () {
          HapticFeedback.mediumImpact();
          Get.toNamed(
            AppRoutes.customerLiveTracking,
            arguments: {
              'driverName': 'Driver Julio',
              'eta': '12 mins',
              'orderId': _order['orderNumber'] ?? '#12345',
              'restaurant': _order['restaurant'] ?? 'Burger House',
            },
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E0A66),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26.r),
          ),
          elevation: 1,
          shadowColor: const Color(0x332E0A66),
        ),
        child: Text(
          'Live Track',
          style: GoogleFonts.roboto(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// 6. "Your order is being processed" Stepper / Timeline Card
  Widget _buildTrackingTimelineSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your order is being processed',
          style: GoogleFonts.roboto(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2E0A66),
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          width: 22.w,
          height: 22.w,
          decoration: const BoxDecoration(
            color: Color(0xFF22C55E),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 15.sp,
            ),
          ),
        ),
        SizedBox(height: 12.h),

        /// Tracking Stepper Card
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
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
          child: Column(
            children: [
              _buildTimelineStep(
                title: 'In Process',
                subtitle: 'Your order is being processed',
                trailingText: '11:32 am',
                isCompleted: true,
                isCurrent: false,
                iconData: Icons.check,
                isLast: false,
              ),
              _buildTimelineStep(
                title: 'Cooking',
                subtitle: 'Your order is getting ready',
                trailingText: '11:57 am',
                isCompleted: true,
                isCurrent: true,
                iconData: Icons.check,
                isLast: false,
              ),
              _buildTimelineStep(
                title: 'Ready for Pickup',
                subtitle: 'Your order has been picked up by driver',
                trailingText: '• • •',
                isCompleted: false,
                isCurrent: false,
                iconData: Icons.two_wheeler_rounded,
                isLast: false,
              ),
              _buildTimelineStep(
                title: 'Arrived',
                subtitle: "Your order is already on it's way",
                trailingText: '• • •',
                isCompleted: false,
                isCurrent: false,
                iconData: Icons.two_wheeler_rounded,
                isLast: false,
              ),
              _buildTimelineStep(
                title: 'Please look for PLOMOGO Drive',
                subtitle: 'Open you door!',
                trailingText: '• • •',
                isCompleted: false,
                isCurrent: false,
                iconData: Icons.inventory_2_outlined,
                badgeText: 'ETA: Arriving in 12 mins',
                isLast: false,
              ),
              _buildTimelineStep(
                title: 'Delivered',
                subtitle: 'Entered Your COD PIN',
                trailingText: '• • •',
                isCompleted: false,
                isCurrent: false,
                iconData: Icons.task_outlined,
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineStep({
    required String title,
    required String subtitle,
    required String trailingText,
    required bool isCompleted,
    required bool isCurrent,
    required IconData iconData,
    String? badgeText,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Left column: Icon Box + Vertical Line
          Column(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? const Color(0xFFD946EF)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Icon(
                    iconData,
                    color: isCompleted ? Colors.white : const Color(0xFF94A3B8),
                    size: 18.sp,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1.5,
                    margin: EdgeInsets.symmetric(vertical: 4.h),
                    color: const Color(0xFFE2E8F0),
                  ),
                ),
            ],
          ),

          SizedBox(width: 12.w),

          /// Center & Right content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.roboto(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2E0A66),
                          ),
                        ),
                      ),
                      Text(
                        trailingText,
                        style: GoogleFonts.roboto(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.roboto(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  if (badgeText != null) ...[
                    SizedBox(height: 6.h),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        badgeText,
                        style: GoogleFonts.roboto(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF475569),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 7. Special Instructions Card
  Widget _buildSpecialInstructionsSection() {
    final instructions = _order['instructions'] ??
        "Please ring the doorbell twice and leave the order at the door. I'll be waiting upstairs. Extra napkins would be appreciated. Thank you!";

    return Container(
      padding: EdgeInsets.all(14.r),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.description_rounded,
                size: 18.sp,
                color: const Color(0xFF2E0A66),
              ),
              SizedBox(width: 8.w),
              Text(
                'Special Instructions',
                style: GoogleFonts.roboto(
                  fontSize: 14.5.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2E0A66),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            '"$instructions"',
            style: GoogleFonts.roboto(
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF64748B),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  /// 8. Delivery Address Section
  Widget _buildDeliveryAddressSection() {
    final address = _order['address'] ??
        '4140 Parker Rd. Allentown, New Mexico 31134';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Delivery Address',
          style: GoogleFonts.roboto(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2E0A66),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
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
          child: Text(
            address,
            style: GoogleFonts.roboto(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF64748B),
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }

  /// 9A. Cancel Order Button (Red solid)
  Widget _buildCancelOrderButton() {
    return SizedBox(
      width: double.infinity,
      height: 48.h.clamp(44.0, 54.0),
      child: ElevatedButton(
        onPressed: _onCancelOrder,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEF4444),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26.r),
          ),
          elevation: 1,
          shadowColor: const Color(0x33EF4444),
        ),
        child: Text(
          'Cancel Order',
          style: GoogleFonts.roboto(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// 9B. Need Help? Button (Outline, NO chat icon per user instruction)
  Widget _buildNeedHelpButton() {
    return SizedBox(
      width: double.infinity,
      height: 48.h.clamp(44.0, 54.0),
      child: OutlinedButton(
        onPressed: _onNeedHelp,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF2E0A66), width: 1.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26.r),
          ),
          backgroundColor: Colors.white,
        ),
        child: Text(
          'Need Help?',
          style: GoogleFonts.roboto(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2E0A66),
          ),
        ),
      ),
    );
  }

  /// 10. Assign Delivery Man Section with Chat Icon Button
  Widget _buildAssignDeliveryManSection() {
    final Map<String, dynamic> deliveryMan =
        _order['deliveryMan'] as Map<String, dynamic>? ?? {
          'name': 'Lucas Nathan',
          'rating': '4.7',
          'phone': '017218897766',
          'image': AppImages.profile,
        };

    final driverName = deliveryMan['name'] ?? 'Lucas Nathan';
    final driverRating = deliveryMan['rating'] ?? '4.7';
    final driverPhone = deliveryMan['phone'] ?? '017218897766';
    final driverImage = deliveryMan['image'] ?? AppImages.profile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Assign Delivery Man',
          style: GoogleFonts.roboto(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2E0A66),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
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
            children: [
              /// Driver Avatar with bike badge
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24.r),
                    child: Image.asset(
                      driverImage,
                      width: 46.w,
                      height: 46.w,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 46.w,
                        height: 46.w,
                        color: const Color(0xFFF1F5F9),
                        child: Icon(Icons.person,
                            size: 26.sp, color: const Color(0xFF94A3B8)),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 18.w,
                      height: 18.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFF8B5CF6),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.two_wheeler_rounded,
                          color: Colors.white,
                          size: 11.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(width: 12.w),

              /// Driver Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driverName,
                      style: GoogleFonts.roboto(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2E0A66),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: const Color(0xFFFFB800),
                          size: 15.sp,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          driverRating,
                          style: GoogleFonts.roboto(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      driverPhone,
                      style: GoogleFonts.roboto(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),

              /// Chat Button with Driver
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  HapticFeedback.lightImpact();
                  Get.toNamed(
                    AppRoutes.message,
                    arguments: {
                      'orderId': _order['orderNumber'] ?? '12345',
                      'restaurant': '$driverName (Driver)',
                      'status': 'Out for Delivery',
                      'isMerchant': false,
                    },
                  );
                },
                child: Container(
                  width: 38.w,
                  height: 38.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E8FF),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.chat_bubble_rounded,
                      color: const Color(0xFF2E0A66),
                      size: 19.sp,
                    ),
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

/// Custom Vector Emblem for Burger King Matching the Design Accurately
class _BurgerKingAvatar extends StatelessWidget {
  final double size;
  const _BurgerKingAvatar({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// Blue Crescent Arc on Left
            Positioned(
              left: -size * 0.12,
              top: -size * 0.08,
              bottom: -size * 0.08,
              width: size * 1.05,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF005DAA),
                    width: size * 0.085,
                  ),
                ),
              ),
            ),

            /// White Center Ring
            Container(
              width: size * 0.82,
              height: size * 0.82,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),

            /// Burger Buns and Red Text
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Top Bun (Golden Orange)
                Container(
                  width: size * 0.52,
                  height: size * 0.13,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF47920),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(size * 0.13),
                    ),
                  ),
                ),

                SizedBox(height: size * 0.02),

                /// Centered Stacked Red Text: "BURGER KING"
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'BURGER',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: (size * 0.12).clamp(4.0, 10.0),
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFFD62300),
                        height: 0.9,
                        letterSpacing: -0.2,
                      ),
                    ),
                    Text(
                      'KING',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: (size * 0.12).clamp(4.0, 10.0),
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFFD62300),
                        height: 0.9,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: size * 0.02),

                /// Bottom Bun (Golden Orange)
                Container(
                  width: size * 0.52,
                  height: size * 0.11,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF47920),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(size * 0.11),
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
