import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/features/common/nav_bar/presentation/controller/nav_bar_controller.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';
import 'package:flutter_code_structure/utils/constants/app_images.dart';

class CustomerOrdersScreen extends StatefulWidget {
  const CustomerOrdersScreen({super.key});

  @override
  State<CustomerOrdersScreen> createState() => _CustomerOrdersScreenState();
}

class _CustomerOrdersScreenState extends State<CustomerOrdersScreen> {
  int _selectedTabIndex = 0;

  /// Active orders: Populated with active order so user can view proper order details
  final List<Map<String, dynamic>> _activeOrders = [
    {
      'restaurant': 'Burger House',
      'orderId': 'Order: #12345',
      'orderNumber': '12345',
      'date': '18 Sep, 7:30',
      'rating': '4.8',
      'description':
          '1x Burger Combo, 1x Fries with crispy chicken and special sauce...',
      'price': '\$13.99',
      'estTime': '12 min',
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
    },
    {
      'restaurant': 'Chez Panisse Cafe',
      'orderId': 'Order: #0394',
      'orderNumber': '0394',
      'date': '19 Mar, 12:45',
      'rating': '4.8',
      'description':
          'A hearty, meaty delight loaded with flavor meaty delight loaded...',
      'price': '\$12.99',
      'estTime': '15 min',
      'imageUrl': AppImages.chezBurgers,
      'items': [
        {'name': '1x Double Cheeseburger', 'price': '\$10.99'},
        {'name': '1x Soft Drink', 'price': '\$2.00'},
      ],
      'subtotal': '\$10.99',
      'deliveryFee': '\$2.00',
      'distance': '1.5M',
      'total': '\$12.99',
      'merchantName': 'Chez Panisse Cafe',
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
    },
  ];

  /// Completed orders matching the mockup (with "Reorder" button & date)
  final List<Map<String, dynamic>> _completedOrders = [
    {
      'restaurant': 'Chez Panisse Cafe',
      'orderId': 'Order#0394',
      'rating': '4.8',
      'description':
          'A hearty, meaty delight loaded with flavor meaty delight loaded...',
      'price': '\$12.99',
      'date': '19 Mar 2026',
      'imageUrl': AppImages.chezBurgers,
    },
    {
      'restaurant': 'Chez Panisse Cafe',
      'orderId': 'Order#0394',
      'rating': '4.8',
      'description':
          'A hearty, meaty delight loaded with flavor meaty delight loaded...',
      'price': '\$12.99',
      'date': '19 Mar 2026',
      'imageUrl': AppImages.chezBurgers,
    },
    {
      'restaurant': 'Chez Panisse Cafe',
      'orderId': 'Order#0394',
      'rating': '4.8',
      'description':
          'A hearty, meaty delight loaded with flavor meaty delight loaded...',
      'price': '\$12.99',
      'date': '19 Mar 2026',
      'imageUrl': AppImages.chezBurgers,
    },
    {
      'restaurant': 'Chez Panisse Cafe',
      'orderId': 'Order#0394',
      'rating': '4.8',
      'description':
          'A hearty, meaty delight loaded with flavor meaty delight loaded...',
      'price': '\$12.99',
      'date': '19 Mar 2026',
      'imageUrl': AppImages.chezBurgers,
    },
  ];

  /// Cancelled orders matching the mockup (with pizza image & "Cancelled" outline badge)
  final List<Map<String, dynamic>> _cancelledOrders = [
    {
      'restaurant': 'Chez Panisse Cafe',
      'rating': '4.8',
      'description':
          'A hearty, meaty delight loaded with flavor meaty delight loaded...',
      'price': '\$12.99',
      'imageUrl': AppImages.beefPizza,
    },
    {
      'restaurant': 'Chez Panisse Cafe',
      'rating': '4.8',
      'description':
          'A hearty, meaty delight loaded with flavor meaty delight loaded...',
      'price': '\$12.99',
      'imageUrl': AppImages.beefPizza,
    },
    {
      'restaurant': 'Chez Panisse Cafe',
      'rating': '4.8',
      'description':
          'A hearty, meaty delight loaded with flavor meaty delight loaded...',
      'price': '\$12.99',
      'imageUrl': AppImages.beefPizza,
    },
    {
      'restaurant': 'Chez Panisse Cafe',
      'rating': '4.8',
      'description':
          'A hearty, meaty delight loaded with flavor meaty delight loaded...',
      'price': '\$12.99',
      'imageUrl': AppImages.beefPizza,
    },
  ];

  List<Map<String, dynamic>> get _currentOrders {
    switch (_selectedTabIndex) {
      case 0:
        return _activeOrders;
      case 1:
        return _completedOrders;
      case 2:
        return _cancelledOrders;
      default:
        return _activeOrders;
    }
  }

  void _onBackPress() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      try {
        final navCtrl = Get.find<NavBarController>();
        navCtrl.changeIndex(0);
      } catch (_) {
        Get.back();
      }
    }
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
                /// 1. Top Bar: Back button on left, "Orders" title centered, NO notification icon
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                  child: Row(
                    children: [
                      /// Back Button (circular outline)
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _onBackPress,
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

                      /// Centered "Orders" Title
                      Expanded(
                        child: Center(
                          child: Text(
                            'Orders',
                            style: GoogleFonts.roboto(
                              fontSize: 18.sp.clamp(16.0, 22.0),
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF2E0A66),
                            ),
                          ),
                        ),
                      ),

                      /// Balanced spacer on right (No notification icon)
                      SizedBox(width: 42.w.clamp(38.0, 46.0)),
                    ],
                  ),
                ),

                SizedBox(height: 6.h),

                /// 2. Tabs: Active, Completed, Cancelled
                _buildTabBar(),

                SizedBox(height: 8.h),

                /// 3. Content: Empty State or Orders List
                Expanded(
                  child: _currentOrders.isEmpty
                      ? _buildEmptyState()
                      : _buildOrdersList(_currentOrders),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Custom tab bar with solid purple indicator and subtle baseline
  Widget _buildTabBar() {
    final tabs = ['Active', 'Completed', 'Cancelled'];

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        /// Continuous bottom baseline
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 1.5.h,
            color: const Color(0xFFF1F5F9),
          ),
        ),

        /// Tabs Row
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: List.generate(tabs.length, (index) {
              final isSelected = _selectedTabIndex == index;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      _selectedTabIndex = index;
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: Text(
                          tabs[index],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize: 15.sp,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected
                                ? const Color(0xFF4C1D95)
                                : const Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 2.5.h,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF5B21B6)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  /// Empty state matching the mockup with order_empty.png illustration
  Widget _buildEmptyState() {
    String subtitle;
    switch (_selectedTabIndex) {
      case 0:
        subtitle = 'You do not have an active order at this time';
        break;
      case 1:
        subtitle = 'You do not have a completed order at this time';
        break;
      case 2:
        subtitle = 'You do not have a cancelled order at this time';
        break;
      default:
        subtitle = 'You do not have an active order at this time';
    }

    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 16.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.orderEmpty,
              width: 180.w.clamp(140.0, 220.0),
              height: 180.w.clamp(140.0, 220.0),
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(
                Icons.inbox_outlined,
                size: 80.sp,
                color: const Color(0xFFCBD5E1),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'There are on orders!',
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 20.sp.clamp(18.0, 24.0),
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2E0A66),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 13.sp.clamp(12.0, 16.0),
                fontWeight: FontWeight.w400,
                color: const Color(0xFF5B21B6),
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  /// Orders list view
  Widget _buildOrdersList(List<Map<String, dynamic>> orders) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      itemCount: orders.length,
      separatorBuilder: (_, __) => SizedBox(height: 14.h),
      itemBuilder: (context, index) {
        final order = orders[index];
        if (_selectedTabIndex == 1) {
          return _buildCompletedCard(order);
        } else if (_selectedTabIndex == 2) {
          return _buildCancelledCard(order);
        } else {
          return _buildActiveCard(order);
        }
      },
    );
  }

  /// Active card layout
  Widget _buildActiveCard(Map<String, dynamic> order) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.lightImpact();
        Get.toNamed(
          AppRoutes.customerOrderDetails,
          arguments: order,
        );
      },
      child: Container(
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
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: _buildOrderImage(order['imageUrl'] as String),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        order['restaurant'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2E0A66),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: const Color(0xFFFFB800),
                          size: 18.sp,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          order['rating'] as String,
                          style: GoogleFonts.roboto(
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2E0A66),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  order['orderId'] ?? 'Order#0394',
                  style: GoogleFonts.roboto(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  order['description'] as String,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.roboto(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF94A3B8),
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Text(
                      order['price'] as String,
                      style: GoogleFonts.roboto(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF2E0A66),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Est:${order['estTime'] ?? '15 min'}',
                      style: GoogleFonts.roboto(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      )
    );
  }

  /// Completed card layout with "Reorder" button and date
  Widget _buildCompletedCard(Map<String, dynamic> order) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.lightImpact();
        Get.toNamed(
          AppRoutes.customerOrderDetails,
          arguments: order,
        );
      },
      child: Container(
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
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: _buildOrderImage(order['imageUrl'] as String),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        order['restaurant'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2E0A66),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: const Color(0xFFFFB800),
                          size: 18.sp,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          order['rating'] as String,
                          style: GoogleFonts.roboto(
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2E0A66),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  order['orderId'] ?? 'Order#0394',
                  style: GoogleFonts.roboto(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  order['description'] as String,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.roboto(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF94A3B8),
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Text(
                      order['price'] as String,
                      style: GoogleFonts.roboto(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF2E0A66),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      order['date'] ?? '19 Mar 2026',
                      style: GoogleFonts.roboto(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        AppSnackbar.success(
                          title: 'Re-ordered',
                          message:
                              'Items from ${order['restaurant']} re-added to your cart.',
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E0A66),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          'Reorder',
                          style: GoogleFonts.roboto(
                            fontSize: 11.5.sp,
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
        ],
      ),
    ),
    );
  }

  /// Cancelled card layout with pizza image and red outline "Cancelled" badge
  Widget _buildCancelledCard(Map<String, dynamic> order) {
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
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: _buildOrderImage(order['imageUrl'] as String),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        order['restaurant'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2E0A66),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: const Color(0xFFFFB800),
                          size: 18.sp,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          order['rating'] as String,
                          style: GoogleFonts.roboto(
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2E0A66),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                Text(
                  order['description'] as String,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.roboto(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF94A3B8),
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order['price'] as String,
                      style: GoogleFonts.roboto(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF2E0A66),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: const Color(0xFFFF6464),
                          width: 1.2,
                        ),
                      ),
                      child: Text(
                        'Cancelled',
                        style: GoogleFonts.roboto(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFFF6464),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds image supporting asset and fallback safely
  Widget _buildOrderImage(String imagePath) {
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        width: 88.w,
        height: 88.w,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallbackImage(),
      );
    }
    return Image.asset(
      imagePath,
      width: 88.w,
      height: 88.w,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _fallbackImage(),
    );
  }

  Widget _fallbackImage() {
    return Container(
      width: 88.w,
      height: 88.w,
      color: const Color(0xFFF1F5F9),
      child: Icon(
        Icons.restaurant_rounded,
        size: 32.sp,
        color: const Color(0xFFCBD5E1),
      ),
    );
  }
}
