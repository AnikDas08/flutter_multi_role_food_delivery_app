import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/customer_dashboard_controller.dart';
import '../widgets/plomo_shop_card.dart';
import '../widgets/popular_restaurant_card.dart';

class PopularRestaurantsScreen extends StatefulWidget {
  final String? title;
  final bool isShop;

  const PopularRestaurantsScreen({
    super.key,
    this.title,
    this.isShop = false,
  });

  @override
  State<PopularRestaurantsScreen> createState() =>
      _PopularRestaurantsScreenState();
}

class _PopularRestaurantsScreenState extends State<PopularRestaurantsScreen> {
  late final CustomerDashboardController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<CustomerDashboardController>()
        ? Get.find<CustomerDashboardController>()
        : Get.put(CustomerDashboardController());
  }

  bool get _isShop {
    if (widget.isShop) return true;
    final args = Get.arguments;
    if (args is Map && args['isShop'] == true) return true;
    return false;
  }

  String get _displayTitle {
    if (widget.title != null && widget.title!.isNotEmpty) {
      return widget.title!;
    }
    final args = Get.arguments;
    if (args is Map && args['title'] != null) {
      return args['title'].toString();
    }
    return _isShop ? 'PlomoShop' : 'Popular Restaurants';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFC),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 8.h),

            /// App Bar
            _buildAppBar(),

            SizedBox(height: 8.h),

            /// List of Restaurants / Shops
            Expanded(
              child: Obx(() {
                if (_isShop) {
                  final shops = controller.plomoShops;
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    itemCount: shops.length,
                    separatorBuilder: (_, index) => SizedBox(height: 16.h),
                    itemBuilder: (context, index) {
                      final shop = shops[index];
                      return PlomoShopCard(
                        shop: shop,
                        controller: controller,
                        isVertical: true,
                        width: null,
                        imageHeight: 170,
                      );
                    },
                  );
                }

                final restaurants = controller.popularRestaurants;
                return ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  itemCount: restaurants.length,
                  separatorBuilder: (_, index) => SizedBox(height: 16.h),
                  itemBuilder: (context, index) {
                    final rest = restaurants[index];
                    return PopularRestaurantCard(
                      restaurant: rest,
                      controller: controller,
                      isVertical: true,
                      width: null,
                      imageHeight: 170,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  /// App Bar matching screenshot
  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          /// Circular Back Button
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: const Color(0xFFF1F5F9)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16.sp,
                color: const Color(0xFF2E0A66),
              ),
            ),
          ),

          /// Title
          Expanded(
            child: Center(
              child: Text(
                _displayTitle,
                style: GoogleFonts.roboto(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2E0A66),
                ),
              ),
            ),
          ),

          /// Spacer to balance the back button
          SizedBox(width: 40.w),
        ],
      ),
    );
  }
}
