import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/features/common/nav_bar/presentation/controller/nav_bar_controller.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';
import 'package:flutter_code_structure/utils/constants/app_images.dart';

class _OrderSummaryItemData {
  final String title;
  final double price;
  final int quantity;
  final String imageUrl;

  _OrderSummaryItemData({
    required this.title,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });
}

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key});

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _instructionController = TextEditingController();
  final FocusNode _addressFocusNode = FocusNode();
  final RxBool _addressHasError = false.obs;

  final RxInt _selectedPaymentMethod = 1.obs; // 0 = Cash on Delivery, 1 = Digital Payment

  List<_OrderSummaryItemData> _items = [];
  double _subtotal = 18.99;
  double _discount = 0.0;
  double _deliveryFee = 15.0;

  double get _totalPrice => (_subtotal + _deliveryFee - _discount);

  @override
  void initState() {
    super.initState();
    _loadOrderItems();
  }

  void _loadOrderItems() {
    final args = Get.arguments;
    if (args is Map && args['items'] is List && (args['items'] as List).isNotEmpty) {
      final rawList = args['items'] as List;
      _items = rawList.map((it) {
        return _OrderSummaryItemData(
          title: it['title'] ?? 'Item',
          price: (it['price'] as num?)?.toDouble() ?? 20.16,
          quantity: (it['quantity'] as num?)?.toInt() ?? 1,
          imageUrl: it['imageUrl'] ?? AppImages.doubleBurger,
        );
      }).toList();

      _subtotal = _items.fold(0.0, (sum, it) => sum + (it.price * it.quantity));
      _deliveryFee = 15.0;
      _discount = 0.0;
    } else {
      /// Default sample items matching the mockup if opened directly
      _items = [
        _OrderSummaryItemData(
          title: 'Chicken Cheese Burger',
          price: 20.16,
          quantity: 1,
          imageUrl: AppImages.doubleBurger,
        ),
        _OrderSummaryItemData(
          title: 'Chicken Cheese Burger',
          price: 20.16,
          quantity: 1,
          imageUrl: AppImages.chezBurgers,
        ),
        _OrderSummaryItemData(
          title: 'Chicken Cheese Pizza',
          price: 20.16,
          quantity: 1,
          imageUrl: AppImages.beefPizza,
        ),
      ];
      _subtotal = 18.99;
      _discount = 0.0;
      _deliveryFee = 15.0;
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _instructionController.dispose();
    _addressFocusNode.dispose();
    super.dispose();
  }

  void _onPlaceOrder() {
    final address = _addressController.text.trim();
    if (address.isEmpty) {
      _addressHasError.value = true;
      _addressFocusNode.requestFocus();
      HapticFeedback.heavyImpact();
      AppSnackbar.error(
        title: 'Address Required',
        message: 'Please enter delivery address to place your order.',
      );
      return;
    }

    HapticFeedback.mediumImpact();
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64.w,
                height: 64.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0FDF4),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: const Color(0xFF16A34A),
                    size: 38.sp,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Order Confirmed!',
                style: GoogleFonts.roboto(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2E0A66),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Delivery to: $address\nTotal: \$${_totalPrice.toStringAsFixed(2)}',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 13.sp,
                  color: const Color(0xFF64748B),
                  height: 1.4,
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                height: 46.h,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back(); // close dialog
                    try {
                      final navCtrl = Get.find<NavBarController>();
                      navCtrl.changeIndex(2); // Go to Orders tab
                      Get.until((route) =>
                          route.settings.name == AppRoutes.mainNavBar ||
                          route.isFirst);
                    } catch (_) {
                      Get.offAllNamed(AppRoutes.customerOrders);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E0A66),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Track Order',
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
                /// 1. Top Bar: Back Button, "Order Confirmation" Centered, NO Notification Icon
                Padding(
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
                            'Order Confirmation',
                            style: GoogleFonts.roboto(
                              fontSize: 18.sp.clamp(16.0, 22.0),
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF2E0A66),
                            ),
                          ),
                        ),
                      ),

                      /// Balanced Spacer (No notification icon)
                      SizedBox(width: 42.w.clamp(38.0, 46.0)),
                    ],
                  ),
                ),

                /// 2. Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Customer Profile Card
                        _buildProfileCard(),

                        SizedBox(height: 16.h),

                        /// Delivery Address (No edit button, direct typing with hint)
                        _buildDeliveryAddressSection(),

                        SizedBox(height: 16.h),

                        /// Additional Instruction
                        _buildAdditionalInstructionSection(),

                        SizedBox(height: 18.h),

                        /// Order Summary
                        _buildOrderSummarySection(),

                        SizedBox(height: 18.h),

                        /// Payment Method Section
                        _buildPaymentMethodSection(),

                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),

                /// 3. Bottom Fixed "Place Order" Button
                Padding(
                  padding: EdgeInsets.only(
                    left: 20.w,
                    right: 20.w,
                    top: 6.h,
                    bottom: 12.h,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50.h.clamp(46.0, 56.0),
                    child: ElevatedButton(
                      onPressed: _onPlaceOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E0A66),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26.r),
                        ),
                        elevation: 1,
                        shadowColor: const Color(0x332E0A66),
                      ),
                      child: Text(
                        'Place Order',
                        style: GoogleFonts.roboto(
                          fontSize: 15.5.sp.clamp(14.0, 18.0),
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.2,
                        ),
                      ),
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

  /// Customer profile section
  Widget _buildProfileCard() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: Image.asset(
            AppImages.profile,
            width: 48.w,
            height: 48.w,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 48.w,
              height: 48.w,
              color: const Color(0xFFF1F5F9),
              child: Icon(Icons.person, size: 28.sp, color: const Color(0xFF94A3B8)),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Brooklyn Simmons',
                style: GoogleFonts.roboto(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2E0A66),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                '4517 Washington Ave. Manchester, Kentucky 39495',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
    );
  }

  /// Delivery Address Section: Direct typing with hint text, NO edit button
  Widget _buildDeliveryAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.location_on_rounded,
              size: 18.sp,
              color: const Color(0xFF2E0A66),
            ),
            SizedBox(width: 6.w),
            Text(
              'Delivery Address',
              style: GoogleFonts.roboto(
                fontSize: 14.5.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2E0A66),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Obx(
          () => Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: _addressHasError.value
                    ? const Color(0xFFEF4444)
                    : (_addressController.text.trim().isNotEmpty
                        ? const Color(0xFF2E0A66).withOpacity(0.35)
                        : const Color(0xFFF1F5F9)),
                width: _addressHasError.value ? 1.5 : 1.2,
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
              children: [
                Expanded(
                  child: TextField(
                    controller: _addressController,
                    focusNode: _addressFocusNode,
                    onChanged: (val) {
                      if (_addressHasError.value && val.trim().isNotEmpty) {
                        _addressHasError.value = false;
                      }
                      setState(() {});
                    },
                    style: GoogleFonts.roboto(
                      fontSize: 13.5.sp,
                      color: const Color(0xFF2E0A66),
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter delivery address',
                      hintStyle: GoogleFonts.roboto(
                        fontSize: 13.5.sp,
                        color: const Color(0xFF94A3B8),
                        fontWeight: FontWeight.w400,
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                  ),
                ),
                Icon(
                  Icons.check_circle_rounded,
                  color: _addressController.text.trim().isNotEmpty
                      ? const Color(0xFF2E0A66)
                      : const Color(0xFFCBD5E1),
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ),
        Obx(
          () => _addressHasError.value
              ? Padding(
                  padding: EdgeInsets.only(top: 5.h, left: 4.w),
                  child: Text(
                    'Please enter a delivery address to place your order',
                    style: GoogleFonts.roboto(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFEF4444),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  /// Additional Instruction Input Container
  Widget _buildAdditionalInstructionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.description_rounded,
              size: 18.sp,
              color: const Color(0xFF2E0A66),
            ),
            SizedBox(width: 6.w),
            Text(
              'Additional Instruction',
              style: GoogleFonts.roboto(
                fontSize: 14.5.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2E0A66),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _instructionController,
                  onChanged: (_) => setState(() {}),
                  style: GoogleFonts.roboto(
                    fontSize: 13.5.sp,
                    color: const Color(0xFF2E0A66),
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type Something',
                    hintStyle: GoogleFonts.roboto(
                      fontSize: 13.5.sp,
                      color: const Color(0xFF64748B),
                      fontWeight: FontWeight.w400,
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
              Icon(
                Icons.check_circle_rounded,
                color: _instructionController.text.trim().isNotEmpty
                    ? const Color(0xFF2E0A66)
                    : const Color(0xFFCBD5E1),
                size: 20.sp,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Order Summary Section showing 1 item (if from item details) or multiple (if from cart)
  Widget _buildOrderSummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.receipt_long_rounded,
              size: 18.sp,
              color: const Color(0xFF2E0A66),
            ),
            SizedBox(width: 6.w),
            Text(
              'Order Summary',
              style: GoogleFonts.roboto(
                fontSize: 14.5.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2E0A66),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        /// Dynamic items list
        ..._items.map((item) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _buildSummaryItem(
              imageUrl: item.imageUrl,
              title: item.title,
              price: '\$${item.price.toStringAsFixed(2)}',
              quantity: '${item.quantity}x',
            ),
          );
        }),

        SizedBox(height: 2.h),
        const Divider(color: Color(0xFFF1F5F9), height: 1),
        SizedBox(height: 12.h),

        /// Breakdown: Subtotal, Discount, Estimated delivery, Final Delivery fee
        _buildFeeRow('Subtotal', '\$${_subtotal.toStringAsFixed(2)}'),
        SizedBox(height: 6.h),
        _buildFeeRow('Discount', '\$${_discount.toStringAsFixed(0)}'),
        SizedBox(height: 6.h),
        _buildFeeRow('Estimated delivery', '30-40 min'),
        SizedBox(height: 6.h),
        _buildFeeRow('Final Delivery fee', '\$${_deliveryFee.toStringAsFixed(0)}'),

        SizedBox(height: 14.h),

        /// Total (incl.vat)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total (incl.vat)',
              style: GoogleFonts.roboto(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2E0A66),
              ),
            ),
            Text(
              '\$${_totalPrice.toStringAsFixed(2)}',
              style: GoogleFonts.roboto(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF2E0A66),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryItem({
    required String imageUrl,
    required String title,
    required String price,
    required String quantity,
  }) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: Image.asset(
            imageUrl,
            width: 48.w,
            height: 48.w,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 48.w,
              height: 48.w,
              color: const Color(0xFFF1F5F9),
              child: Icon(Icons.fastfood, size: 24.sp, color: const Color(0xFF94A3B8)),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2E0A66),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                price,
                style: GoogleFonts.roboto(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2E0A66),
                ),
              ),
            ],
          ),
        ),
        Text(
          quantity,
          style: GoogleFonts.roboto(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildFeeRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF64748B),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  /// Payment Method Section with selectable Cash on Delivery and Digital Payment
  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.account_balance_wallet_rounded,
              size: 18.sp,
              color: const Color(0xFF2E0A66),
            ),
            SizedBox(width: 6.w),
            Text(
              'Payment Method',
              style: GoogleFonts.roboto(
                fontSize: 14.5.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2E0A66),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),

        /// Cash on Delivery Card
        Obx(
          () => _buildPaymentOptionCard(
            index: 0,
            title: 'Cash on Delivery',
            icon: Icons.payments_outlined,
            iconColor: const Color(0xFF16A34A),
            isSelected: _selectedPaymentMethod.value == 0,
          ),
        ),

        SizedBox(height: 10.h),

        /// Digital Payment Card
        Obx(
          () => _buildPaymentOptionCard(
            index: 1,
            title: 'Digital Payment',
            icon: Icons.point_of_sale_rounded,
            iconColor: const Color(0xFF0D9488),
            isSelected: _selectedPaymentMethod.value == 1,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOptionCard({
    required int index,
    required String title,
    required IconData icon,
    required Color iconColor,
    required bool isSelected,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _selectedPaymentMethod.value = index;
        HapticFeedback.selectionClick();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2E0A66).withOpacity(0.3)
                : const Color(0xFFF1F5F9),
            width: 1.2,
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
          children: [
            Container(
              width: 34.w,
              height: 34.w,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: Icon(icon, color: iconColor, size: 20.sp),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ),
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFD946EF)
                      : const Color(0xFFCBD5E1),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFD946EF),
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
