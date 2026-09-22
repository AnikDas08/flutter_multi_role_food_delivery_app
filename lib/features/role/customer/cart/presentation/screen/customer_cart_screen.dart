import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/utils/app_snackbar.dart';

class CartItemModel {
  final String id;
  final String title;
  final String restaurant;
  final double price;
  final String imageUrl;
  final RxInt quantity;

  CartItemModel({
    required this.id,
    required this.title,
    required this.restaurant,
    required this.price,
    required this.imageUrl,
    int initialQuantity = 1,
  }) : quantity = initialQuantity.obs;
}

class CustomerCartScreen extends StatefulWidget {
  const CustomerCartScreen({super.key});

  @override
  State<CustomerCartScreen> createState() => _CustomerCartScreenState();
}

class _CustomerCartScreenState extends State<CustomerCartScreen> {
  final RxList<CartItemModel> _items = <CartItemModel>[
    CartItemModel(
      id: 'cart_1',
      title: 'Beef Pizza',
      restaurant: 'Chez Panisse Cafe',
      price: 12.99,
      imageUrl:
          'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500&q=80',
      initialQuantity: 2,
    ),
    CartItemModel(
      id: 'cart_2',
      title: 'Smoked Burger',
      restaurant: 'Chez Panisse Cafe',
      price: 9.50,
      imageUrl:
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500&q=80',
      initialQuantity: 1,
    ),
  ].obs;

  final TextEditingController _promoController = TextEditingController();
  final RxDouble _discount = 0.0.obs;

  double get _subtotal {
    return _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity.value));
  }

  double get _deliveryFee => _items.isEmpty ? 0.0 : 2.50;

  double get _total => (_subtotal + _deliveryFee - _discount.value).clamp(0.0, double.infinity);

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _applyPromo() {
    final code = _promoController.text.trim().toUpperCase();
    if (code == 'PLOMO20' || code == 'SAVE20') {
      _discount.value = _subtotal * 0.20;
      AppSnackbar.success(
        title: 'Promo Applied',
        message: '20% discount applied to your cart!',
      );
    } else if (code.isNotEmpty) {
      AppSnackbar.error(
        title: 'Invalid Code',
        message: 'Try using code PLOMO20 for 20% off.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          if (_items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 64.sp,
                    color: const Color(0xFFCBD5E1),
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    'Your Cart is Empty',
                    style: GoogleFonts.roboto(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF334155),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Add delicious food and grocery items to your cart!',
                    style: GoogleFonts.roboto(
                      fontSize: 13.sp,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Cart',
                      style: GoogleFonts.roboto(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2E0A66),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _items.clear();
                        AppSnackbar.info(
                          title: 'Cart Cleared',
                          message: 'All items removed from cart.',
                        );
                      },
                      child: Text(
                        'Clear All',
                        style: GoogleFonts.roboto(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFEF4444),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// Items List & details
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  children: [
                    ...List.generate(_items.length, (index) {
                      final item = _items[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: const Color(0xFFF1F5F9)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Image.network(
                                item.imageUrl,
                                width: 70.w,
                                height: 70.h,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 70.w,
                                  height: 70.h,
                                  color: const Color(0xFFF1F5F9),
                                  child: Icon(Icons.fastfood_rounded,
                                      color: const Color(0xFF94A3B8)),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: GoogleFonts.roboto(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1E293B),
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    item.restaurant,
                                    style: GoogleFonts.roboto(
                                      fontSize: 11.sp,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    '\$${item.price.toStringAsFixed(2)}',
                                    style: GoogleFonts.roboto(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF4C1D95),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// Quantity Selector
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (item.quantity.value > 1) {
                                        item.quantity.value--;
                                      } else {
                                        _items.removeAt(index);
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(4.r),
                                      child: Icon(
                                        item.quantity.value > 1
                                            ? Icons.remove_rounded
                                            : Icons.delete_outline_rounded,
                                        size: 16.sp,
                                        color: item.quantity.value > 1
                                            ? const Color(0xFF475569)
                                            : const Color(0xFFEF4444),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                                    child: Text(
                                      '${item.quantity.value}',
                                      style: GoogleFonts.roboto(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF1E293B),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => item.quantity.value++,
                                    child: Padding(
                                      padding: EdgeInsets.all(4.r),
                                      child: Icon(
                                        Icons.add_rounded,
                                        size: 16.sp,
                                        color: const Color(0xFF4C1D95),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    SizedBox(height: 8.h),

                    /// Promo Code Input
                    Container(
                      height: 46.h,
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAF5FF),
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: const Color(0xFFE9D5FF)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.local_offer_outlined,
                              size: 18.sp, color: const Color(0xFF7C3AED)),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: TextField(
                              controller: _promoController,
                              textAlignVertical: TextAlignVertical.center,
                              style: GoogleFonts.roboto(
                                fontSize: 13.sp,
                                color: const Color(0xFF1E293B),
                              ),
                              decoration: InputDecoration(
                                isCollapsed: true,
                                hintText: 'Enter Promo Code (e.g. PLOMO20)',
                                hintStyle: GoogleFonts.roboto(
                                  fontSize: 12.sp,
                                  color: const Color(0xFF94A3B8),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: _applyPromo,
                            child: Text(
                              'Apply',
                              style: GoogleFonts.roboto(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF4C1D95),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16.h),

                    /// Delivery Address Card
                    Container(
                      padding: EdgeInsets.all(14.r),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDE9FE),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Icon(
                              Icons.location_on_rounded,
                              size: 20.sp,
                              color: const Color(0xFF6D28D9),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Delivery Address',
                                  style: GoogleFonts.roboto(
                                    fontSize: 11.sp,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                                Text(
                                  'New York, D-Block, Apt 4B',
                                  style: GoogleFonts.roboto(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1E293B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: const Color(0xFF94A3B8),
                            size: 20.sp,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16.h),

                    /// Cost Breakdown
                    Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                      ),
                      child: Column(
                        children: [
                          _buildCostRow('Subtotal', '\$${_subtotal.toStringAsFixed(2)}'),
                          SizedBox(height: 8.h),
                          _buildCostRow('Delivery Fee', '\$${_deliveryFee.toStringAsFixed(2)}'),
                          if (_discount.value > 0) ...[
                            SizedBox(height: 8.h),
                            _buildCostRow(
                              'Discount',
                              '-\$${_discount.value.toStringAsFixed(2)}',
                              valueColor: const Color(0xFF16A34A),
                            ),
                          ],
                          SizedBox(height: 10.h),
                          const Divider(height: 1, color: Color(0xFFE2E8F0)),
                          SizedBox(height: 10.h),
                          _buildCostRow(
                            'Total',
                            '\$${_total.toStringAsFixed(2)}',
                            isTotal: true,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),
                  ],
                ),
              ),

              /// Checkout Bar
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () {
                      AppSnackbar.success(
                        title: 'Order Placed!',
                        message: 'Your order has been placed successfully.',
                      );
                      _items.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4C1D95),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Proceed to Checkout  •  \$${_total.toStringAsFixed(2)}',
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
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

  Widget _buildCostRow(
    String label,
    String value, {
    bool isTotal = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: isTotal ? 14.sp : 12.sp,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal ? const Color(0xFF1E293B) : const Color(0xFF64748B),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: isTotal ? 16.sp : 12.sp,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
            color: valueColor ??
                (isTotal ? const Color(0xFF4C1D95) : const Color(0xFF1E293B)),
          ),
        ),
      ],
    );
  }
}
