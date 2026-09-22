import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/utils/app_snackbar.dart';

class CustomerOrdersScreen extends StatefulWidget {
  const CustomerOrdersScreen({super.key});

  @override
  State<CustomerOrdersScreen> createState() => _CustomerOrdersScreenState();
}

class _CustomerOrdersScreenState extends State<CustomerOrdersScreen> {
  int _selectedTabIndex = 0;

  final List<Map<String, dynamic>> _activeOrders = [
    {
      'id': 'ORD-9821',
      'restaurant': 'Chez Panisse Cafe',
      'imageUrl':
          'https://images.unsplash.com/photo-1550547660-d9450f859349?w=600&q=80',
      'items': '2x Beef Pizza, 1x Coke (500ml)',
      'total': '\$28.50',
      'status': 'On the way',
      'statusColor': const Color(0xFF2563EB),
      'statusBg': const Color(0xFFEFF6FF),
      'estimatedTime': '15-20 min',
      'date': 'Today, 1:45 PM',
    },
    {
      'id': 'ORD-9815',
      'restaurant': 'Wanderlust Bazaar',
      'imageUrl':
          'https://images.unsplash.com/photo-1542838132-92c53300491e?w=600&q=80',
      'items': 'Fresh Organic Veggie Basket, 2L Milk',
      'total': '\$16.20',
      'status': 'Preparing',
      'statusColor': const Color(0xFFD97706),
      'statusBg': const Color(0xFFFFFBEB),
      'estimatedTime': '30-40 min',
      'date': 'Today, 12:30 PM',
    },
  ];

  final List<Map<String, dynamic>> _pastOrders = [
    {
      'id': 'ORD-9742',
      'restaurant': 'Chez Panisse Cafe',
      'imageUrl':
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=600&q=80',
      'items': '1x Beef Pizza, 1x Garlic Bread',
      'total': '\$19.99',
      'status': 'Delivered',
      'statusColor': const Color(0xFF16A34A),
      'statusBg': const Color(0xFFF0FDF4),
      'date': '21 Sep 2026, 8:15 PM',
    },
    {
      'id': 'ORD-9610',
      'restaurant': 'Grill & Chill Diner',
      'imageUrl':
          'https://images.unsplash.com/photo-1544025162-d76694265947?w=600&q=80',
      'items': '2x Smoked Beef Burger, French Fries',
      'total': '\$24.00',
      'status': 'Delivered',
      'statusColor': const Color(0xFF16A34A),
      'statusBg': const Color(0xFFF0FDF4),
      'date': '19 Sep 2026, 7:00 PM',
    },
    {
      'id': 'ORD-9502',
      'restaurant': 'Daily Shop',
      'imageUrl':
          'https://images.unsplash.com/photo-1488459716781-31db52582fe9?w=600&q=80',
      'items': 'Grocery Essentials Pack',
      'total': '\$32.50',
      'status': 'Delivered',
      'statusColor': const Color(0xFF16A34A),
      'statusBg': const Color(0xFFF0FDF4),
      'date': '16 Sep 2026, 11:20 AM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Top Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Text(
                'My Orders',
                style: GoogleFonts.roboto(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2E0A66),
                ),
              ),
            ),

            /// Tab bar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTabIndex = 0),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        decoration: BoxDecoration(
                          color: _selectedTabIndex == 0
                              ? const Color(0xFF4C1D95)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Active Orders',
                          style: GoogleFonts.roboto(
                            fontSize: 13.sp,
                            fontWeight: _selectedTabIndex == 0
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: _selectedTabIndex == 0
                                ? Colors.white
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTabIndex = 1),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        decoration: BoxDecoration(
                          color: _selectedTabIndex == 1
                              ? const Color(0xFF4C1D95)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Past Orders',
                          style: GoogleFonts.roboto(
                            fontSize: 13.sp,
                            fontWeight: _selectedTabIndex == 1
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: _selectedTabIndex == 1
                                ? Colors.white
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12.h),

            /// Orders List
            Expanded(
              child: _selectedTabIndex == 0
                  ? _buildOrdersList(_activeOrders, isActive: true)
                  : _buildOrdersList(_pastOrders, isActive: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList(List<Map<String, dynamic>> orders, {required bool isActive}) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 56.sp,
              color: const Color(0xFFCBD5E1),
            ),
            SizedBox(height: 12.h),
            Text(
              'No orders yet',
              style: GoogleFonts.roboto(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF475569),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Browse food & groceries and place your order!',
              style: GoogleFonts.roboto(
                fontSize: 12.sp,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      itemCount: orders.length,
      separatorBuilder: (_, __) => SizedBox(height: 14.h),
      itemBuilder: (context, index) {
        final order = orders[index];
        return Container(
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFFF1F5F9)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Order ID and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order['id'] as String,
                    style: GoogleFonts.roboto(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: order['statusBg'] as Color,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      order['status'] as String,
                      style: GoogleFonts.roboto(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: order['statusColor'] as Color,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              /// Image and Info
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.network(
                      order['imageUrl'] as String,
                      width: 64.w,
                      height: 64.h,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 64.w,
                        height: 64.h,
                        color: const Color(0xFFF1F5F9),
                        child: Icon(
                          Icons.fastfood_rounded,
                          size: 28.sp,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order['restaurant'] as String,
                          style: GoogleFonts.roboto(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          order['items'] as String,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                            fontSize: 12.sp,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          order['date'] as String,
                          style: GoogleFonts.roboto(
                            fontSize: 11.sp,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              SizedBox(height: 10.h),

              /// Price & Action button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Price',
                        style: GoogleFonts.roboto(
                          fontSize: 11.sp,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                      Text(
                        order['total'] as String,
                        style: GoogleFonts.roboto(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF4C1D95),
                        ),
                      ),
                    ],
                  ),
                  isActive
                      ? ElevatedButton.icon(
                          onPressed: () {
                            AppSnackbar.info(
                              title: 'Live Tracking',
                              message:
                                  'Tracking driver for order ${order['id']} (ETA: ${order['estimatedTime']})',
                            );
                          },
                          icon: Icon(
                            Icons.navigation_outlined,
                            size: 14.sp,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Track Order',
                            style: GoogleFonts.roboto(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4C1D95),
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 8.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            elevation: 0,
                          ),
                        )
                      : OutlinedButton(
                          onPressed: () {
                            AppSnackbar.success(
                              title: 'Re-ordered',
                              message:
                                  'Items from ${order['restaurant']} re-added to your cart.',
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFF4C1D95),
                              width: 1,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          child: Text(
                            'Re-Order',
                            style: GoogleFonts.roboto(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF4C1D95),
                            ),
                          ),
                        ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
