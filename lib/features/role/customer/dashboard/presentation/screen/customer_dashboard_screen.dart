import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/features/role/customer/dashboard/presentation/controller/customer_dashboard_controller.dart';
import 'package:flutter_code_structure/utils/constants/app_icons.dart';
import 'package:flutter_code_structure/utils/constants/app_images.dart';
import '../widgets/plomo_shop_card.dart';
import '../widgets/popular_item_card.dart';
import '../widgets/popular_restaurant_card.dart';

class CustomerDashboardScreen extends StatefulWidget {
  const CustomerDashboardScreen({super.key});

  @override
  State<CustomerDashboardScreen> createState() =>
      _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState extends State<CustomerDashboardScreen> {
  late final CustomerDashboardController controller;
  final PageController _bannerPageController = PageController();

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<CustomerDashboardController>()
        ? Get.find<CustomerDashboardController>()
        : Get.put(CustomerDashboardController());
  }

  @override
  void dispose() {
    _bannerPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),

              /// 1. Top Header
              _buildTopHeader(),

              SizedBox(height: 14.h),

              /// 2. Search Bar
              _buildSearchBar(),

              SizedBox(height: 16.h),

              /// 3. Promo Banner Carousel
              _buildPromoCarousel(),

              SizedBox(height: 18.h),

              /// 4. Service Category
              _buildServiceCategory(),

              SizedBox(height: 20.h),

              /// 5. Popular Items
              _buildPopularItems(),

              /// 6. Popular Restaurants (hidden when PlomoShop is selected)
              Obx(() {
                if (controller.selectedCategory.value != 'PlomoShop') {
                  return Column(
                    children: [
                      SizedBox(height: 22.h),
                      _buildPopularRestaurants(),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),

              /// 7. PlomoShop (Groceries) - shown when nothing selected or when PlomoShop is selected
              Obx(() {
                if (controller.selectedCategory.value != 'Plomobites') {
                  return Column(
                    children: [
                      SizedBox(height: 22.h),
                      _buildPlomoShop(),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),

              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  /// -------------------------------------------------------------
  /// 1. Top Header: Avatar, Name, Location, Balance Pill, Bell
  /// -------------------------------------------------------------
  Widget _buildTopHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// User Avatar
          ClipOval(
            child: Image.asset(
              AppImages.profile,
              width: 44.w,
              height: 44.w,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 44.w,
                height: 44.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFEDE9FE),
                ),
                child: Icon(Icons.person, color: const Color(0xFF6D28D9), size: 24.sp),
              ),
            ),
          ),
          SizedBox(width: 10.w),

          /// Name & Location
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () => Text(
                    controller.userName.value,
                    style: GoogleFonts.roboto(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                Obx(
                  () => Text(
                    controller.location.value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF4C1D95),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// Balance Pill Badge ($24.50) -> opens Customer Wallet
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              HapticFeedback.lightImpact();
              Get.toNamed(AppRoutes.customerWallet);
            },
            child: Obx(
              () => Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFC026D3),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  controller.balance.value,
                  style: GoogleFonts.roboto(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),

          /// Notification Bell with Red Dot
          InkWell(
            onTap: () => Get.toNamed(AppRoutes.notifications),
            borderRadius: BorderRadius.circular(22.r),
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
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    AppIcons.notificationIcon,
                    width: 20.w,
                    height: 20.w,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF4C1D95),
                      BlendMode.srcIn,
                    ),
                  ),
                  Positioned(
                    top: 8.h,
                    right: 9.w,
                    child: Container(
                      width: 7.w,
                      height: 7.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// -------------------------------------------------------------
  /// 2. Search Bar: Rounded Pill Container
  /// -------------------------------------------------------------
  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GestureDetector(
        onTap: () => Get.toNamed(AppRoutes.search),
        child: Container(
          height: 44.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              SizedBox(width: 16.w),
              Icon(
                Icons.search_rounded,
                color: const Color(0xFF94A3B8),
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Search for restaurants or dishes',
                  style: GoogleFonts.roboto(
                    fontSize: 13.sp,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ),
              Icon(
                Icons.mic_none_rounded,
                color: const Color(0xFF7C3AED),
                size: 20.sp,
              ),
              SizedBox(width: 14.w),
            ],
          ),
        ),
      ),
    );
  }

  /// -------------------------------------------------------------
  /// 3. Promo Banner Carousel
  /// -------------------------------------------------------------
  Widget _buildPromoCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 150.h,
          child: PageView(
            controller: _bannerPageController,
            onPageChanged: (index) {
              controller.currentBannerIndex.value = index;
            },
            children: [
              /// Slide 1: Purple 20% OFF with Burger
              _buildPromoCard(
                bgColor: const Color(0xFFF3E8FF),
                uptoText: 'UPTO',
                percentText: '20%',
                offText: 'OFF',
                subText: 'On your first order',
                imageWidget: _buildExplodedBurgerGraphic(),
              ),

              /// Slide 2: Mint 25% OFF
              _buildPromoCard(
                bgColor: const Color(0xFFDCFCE7),
                uptoText: 'UPTO',
                percentText: '25%',
                offText: 'OFF',
                subText: 'On your grocery basket',
                imageWidget: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400&q=80',
                    width: 110.w,
                    height: 110.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),

        /// Indicator Dots
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(2, (index) {
              final isSelected = controller.currentBannerIndex.value == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                width: isSelected ? 18.w : 6.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF3B0764)
                      : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(3.r),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildPromoCard({
    required Color bgColor,
    required String uptoText,
    required String percentText,
    String offText = 'OFF',
    required String subText,
    required Widget imageWidget,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          /// Text info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  uptoText,
                  style: GoogleFonts.roboto(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF4C1D95),
                  ),
                ),
                SizedBox(height: 1.h),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: percentText,
                        style: GoogleFonts.roboto(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF4C1D95),
                          letterSpacing: -0.5,
                        ),
                      ),
                      TextSpan(
                        text: ' $offText',
                        style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF4C1D95),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subText,
                  style: GoogleFonts.roboto(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF475569),
                  ),
                ),
              ],
            ),
          ),

          /// Image graphic
          imageWidget,
        ],
      ),
    );
  }

  /// Exploded hamburger visual illustration widget matching mockup
  Widget _buildExplodedBurgerGraphic() {
    return SizedBox(
      width: 110.w,
      height: 120.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Burger photo layered or high res image
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Image.network(
              'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&q=80',
              width: 105.w,
              height: 105.h,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.lunch_dining_rounded,
                size: 70.sp,
                color: const Color(0xFFF97316),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// -------------------------------------------------------------
  /// 4. Service Category: Plomobites & PlomoShop Side by Side
  /// -------------------------------------------------------------
  Widget _buildServiceCategory() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Service Category',
            style: GoogleFonts.roboto(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2E0A66),
            ),
          ),
          SizedBox(height: 10.h),
          Obx(() {
            final selected = controller.selectedCategory.value;
            return Row(
              children: [
                /// Plomobites Card
                _buildCategoryCard(
                  title: 'Plomobites',
                  iconPath: AppIcons.plomobites,
                  isSelected: selected == 'Plomobites',
                  onTap: () => controller.selectCategory('Plomobites'),
                ),

                SizedBox(width: 12.w),

                /// PlomoShop Card
                _buildCategoryCard(
                  title: 'PlomoShop',
                  iconPath: AppIcons.plomoshop,
                  isSelected: selected == 'PlomoShop',
                  onTap: () => controller.selectCategory('PlomoShop'),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  /// Individual Category Card matching reference design
  Widget _buildCategoryCard({
    required String title,
    required String iconPath,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF3B1278)
                  : const Color(0xFFF1F5F9),
              width: isSelected ? 1.6 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? const Color(0xFF3B1278).withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              /// Soft circular icon background
              Container(
                width: 36.w,
                height: 36.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFAF5FF),
                ),
                alignment: Alignment.center,
                child: SizedBox(
                  width: 22.w,
                  height: 22.w,
                  child: SvgPicture.asset(
                    iconPath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.roboto(
                    fontSize: 12.5.sp,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: const Color(0xFF2E0A66),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// -------------------------------------------------------------
  /// 5. Popular Items: Horizontal List with Beef Pizza Cards
  /// -------------------------------------------------------------
  Widget _buildPopularItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Section Title + See More
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Items',
                style: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2E0A66),
                ),
              ),
              InkWell(
                onTap: () => Get.toNamed(AppRoutes.popularItems),
                child: Text(
                  'See More',
                  style: GoogleFonts.roboto(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2E0A66),
                    decoration: TextDecoration.underline,
                    decorationColor: const Color(0xFF2E0A66),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 12.h),

        /// Horizontal List
        SizedBox(
          height: 222.h,
          child: Obx(
            () {
              final items = controller.currentPopularItems;
              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                separatorBuilder: (_, index) => SizedBox(width: 12.w),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return PopularItemCard(
                    item: item,
                    controller: controller,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  /// -------------------------------------------------------------
  /// 6. Popular Restaurants: Cards with Star Badge & Heart Overlay
  /// -------------------------------------------------------------
  Widget _buildPopularRestaurants() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Section Title + See More
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Restaurants',
                style: GoogleFonts.roboto(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2E0A66),
                ),
              ),
              InkWell(
                onTap: () => Get.toNamed(AppRoutes.popularRestaurants),
                child: Text(
                  'See More',
                  style: GoogleFonts.roboto(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2E0A66),
                    decoration: TextDecoration.underline,
                    decorationColor: const Color(0xFF2E0A66),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 10.h),

        /// Horizontal List
        SizedBox(
          height: 240.h,
          child: Obx(
            () => ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              itemCount: controller.popularRestaurants.length,
              separatorBuilder: (_, index) => SizedBox(width: 12.w),
              itemBuilder: (context, index) {
                final rest = controller.popularRestaurants[index];
                return PopularRestaurantCard(
                  restaurant: rest,
                  controller: controller,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  /// -------------------------------------------------------------
  /// 7. PlomoShop (Groceries): Cards with Grocery Produce
  /// -------------------------------------------------------------
  Widget _buildPlomoShop() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Section Title + See More
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PlomoShop',
                style: GoogleFonts.roboto(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2E0A66),
                ),
              ),
              InkWell(
                onTap: () => Get.toNamed(AppRoutes.popularShops),
                child: Text(
                  'See More',
                  style: GoogleFonts.roboto(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2E0A66),
                    decoration: TextDecoration.underline,
                    decorationColor: const Color(0xFF2E0A66),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 10.h),

        /// Horizontal List
        SizedBox(
          height: 240.h,
          child: Obx(
            () => ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              itemCount: controller.plomoShops.length,
              separatorBuilder: (_, index) => SizedBox(width: 12.w),
              itemBuilder: (context, index) {
                final shop = controller.plomoShops[index];
                return PlomoShopCard(
                  shop: shop,
                  controller: controller,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
