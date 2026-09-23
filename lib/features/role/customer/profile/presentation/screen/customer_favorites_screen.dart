import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/features/role/customer/dashboard/presentation/controller/customer_dashboard_controller.dart';
import 'package:flutter_code_structure/features/role/customer/dashboard/presentation/widgets/plomo_shop_card.dart';
import 'package:flutter_code_structure/features/role/customer/dashboard/presentation/widgets/popular_item_card.dart';
import 'package:flutter_code_structure/features/role/customer/dashboard/presentation/widgets/popular_restaurant_card.dart';
import 'package:flutter_code_structure/utils/constants/app_images.dart';

class CustomerFavoritesScreen extends StatefulWidget {
  const CustomerFavoritesScreen({super.key});

  @override
  State<CustomerFavoritesScreen> createState() =>
      _CustomerFavoritesScreenState();
}

class _CustomerFavoritesScreenState extends State<CustomerFavoritesScreen> {
  final List<String> _tabs = const ['Items', 'Restaurants', 'PlomoShop'];

  CustomerDashboardController get _controller {
    if (Get.isRegistered<CustomerDashboardController>()) {
      return Get.find<CustomerDashboardController>();
    }
    return Get.put(CustomerDashboardController(), permanent: true);
  }

  late final List<CustomerPopularItem> _favoriteItems;
  late final List<CustomerRestaurant> _favoriteRestaurants;
  late final List<CustomerShop> _favoriteShops;

  @override
  void initState() {
    super.initState();

    _favoriteItems = [
      const CustomerPopularItem(
        id: 'fav_item_1',
        title: 'Beef Hawaiian Burger',
        rating: 5.0,
        distanceTime: '1.2 km - 20 min',
        description:
            'Juicy, flame-grilled beef patty stacked with sweet grilled pineapple, melted cheddar cheese, and crispy bacon...',
        price: 12.99,
        imageUrl: AppImages.chezBurgers,
        restaurantName: 'Burger King',
      ),
      const CustomerPopularItem(
        id: 'fav_item_2',
        title: 'Beef Pizza',
        rating: 4.8,
        distanceTime: '1.5 km - 25 min',
        description:
            'A hearty, meaty delight loaded with flavor crust topped with rich mozzarella cheese...',
        price: 14.50,
        imageUrl: AppImages.beefPizza,
        restaurantName: 'Pizza Hut',
      ),
      const CustomerPopularItem(
        id: 'fav_item_3',
        title: 'Double Beef Burger',
        rating: 4.9,
        distanceTime: '1.3 km - 22 min',
        description:
            'Double flame-grilled beef patties with melted American cheese and signature sauce...',
        price: 9.99,
        imageUrl: AppImages.doubleBurger,
        restaurantName: 'Burger Lab',
      ),
      const CustomerPopularItem(
        id: 'fav_item_4',
        title: 'Chocolate Muffins',
        rating: 4.7,
        distanceTime: '2.0 km - 15 min',
        description:
            'Freshly baked rich chocolate chip muffins with decadent molten chocolate core...',
        price: 5.50,
        imageUrl: AppImages.chocolateMuffins,
        restaurantName: 'Bakery Co.',
      ),
    ];

    _favoriteRestaurants = [
      CustomerRestaurant(
        id: 'fav_rest_1',
        name: 'Chez Panisse Cafe',
        rating: 4.7,
        startingPrice: 5.00,
        description:
            'A hearty, meaty delight loaded with flavor crust topped with rich...',
        deliveryType: 'Free Delivery',
        location: 'Mirpur 10, Dhaka',
        imageUrl: AppImages.chezBurgers,
        isFav: true,
      ),
      CustomerRestaurant(
        id: 'fav_rest_2',
        name: 'Grill & Chill Diner',
        rating: 4.9,
        startingPrice: 7.50,
        description:
            'Fire-grilled steaks and skewers with garlic herb butter...',
        deliveryType: 'Free Delivery',
        location: 'Gulshan 2, Dhaka',
        imageUrl:
            'https://images.unsplash.com/photo-1544025162-d76694265947?w=600&q=80',
        isFav: true,
      ),
    ];

    _favoriteShops = [
      CustomerShop(
        id: 'fav_shop_1',
        name: 'Wanderlust Bazaar',
        rating: 4.7,
        startingPrice: 1.99,
        description:
            'A hearty, fresh grocery produce market loaded with organic fruits...',
        deliveryType: 'Free Delivery',
        location: 'Mirpur 10, Dhaka',
        imageUrl:
            'https://images.unsplash.com/photo-1542838132-92c53300491e?w=600&q=80',
        isFav: true,
      ),
      CustomerShop(
        id: 'fav_shop_2',
        name: 'Daily Super Shop',
        rating: 4.8,
        startingPrice: 5.00,
        description:
            'All your daily household essentials, dairy, bakery and fresh groceries...',
        deliveryType: '\$5',
        location: 'Mirpur 10, Dhaka',
        imageUrl:
            'https://images.unsplash.com/photo-1488459716781-31db52582fe9?w=600&q=80',
        isFav: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFC),
        body: SafeArea(
          child: Column(
            children: [
              /// 1. Top Bar
              _buildTopBar(context),

              SizedBox(height: 8.h),

              /// 2. Modern 3-Pill Tab Bar: Items, Restaurants, PlomoShop
              _buildTabBar(),

              SizedBox(height: 12.h),

              /// 3. Tab Views
              Expanded(
                child: TabBarView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildItemsTab(),
                    _buildRestaurantsTab(),
                    _buildShopsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Top Bar with Circular Back button, centered title, balanced spacer (no notification icon)
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Row(
        children: [
          /// Circular Back Button
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              HapticFeedback.lightImpact();
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                Get.offAllNamed(AppRoutes.mainNavBar);
              }
            },
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
                'My Favorites',
                style: GoogleFonts.roboto(
                  fontSize: 18.sp.clamp(16.0, 22.0),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2E0A66),
                ),
              ),
            ),
          ),

          /// Balanced spacer to keep title centered
          SizedBox(width: 42.w.clamp(38.0, 46.0)),
        ],
      ),
    );
  }

  /// Modern Segmented / Pill Tab Bar
  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: TabBar(
        onTap: (_) => HapticFeedback.selectionClick(),
        indicator: BoxDecoration(
          color: const Color(0xFF2E0A66),
          borderRadius: BorderRadius.circular(22.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2E0A66).withValues(alpha: 0.25),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF64748B),
        labelStyle: GoogleFonts.roboto(
          fontSize: 13.5.sp.clamp(12.0, 15.0),
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: GoogleFonts.roboto(
          fontSize: 13.5.sp.clamp(12.0, 15.0),
          fontWeight: FontWeight.w500,
        ),
        tabs: _tabs.map((tab) => Tab(text: tab, height: 38.h)).toList(),
      ),
    );
  }

  /// 1. Favorite Food Items Tab
  Widget _buildItemsTab() {
    if (_favoriteItems.isEmpty) {
      return _buildEmptyState(
        'No favorite items yet',
        Icons.favorite_border_rounded,
      );
    }

    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 0.68,
      ),
      itemCount: _favoriteItems.length,
      itemBuilder: (context, index) {
        final item = _favoriteItems[index];
        return PopularItemCard(
          item: item,
          controller: _controller,
          width: null,
          imageHeight: 104,
          isFavorite: true,
          showFavoriteIcon: true,
          onFavoriteTap: () {
            HapticFeedback.lightImpact();
            setState(() {
              _favoriteItems.removeAt(index);
            });
            _controller.toggleItemFavorite(item.id, item.title);
          },
        );
      },
    );
  }

  /// 2. Favorite Restaurants Tab
  Widget _buildRestaurantsTab() {
    final restaurants = _favoriteRestaurants;

    if (restaurants.isEmpty) {
      return _buildEmptyState(
        'No favorite restaurants yet',
        Icons.restaurant_rounded,
      );
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: restaurants.length,
      separatorBuilder: (_, __) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final restaurant = restaurants[index];
        return PopularRestaurantCard(
          restaurant: restaurant,
          controller: _controller,
          isVertical: true,
          width: null,
          imageHeight: 170,
        );
      },
    );
  }

  /// 3. Favorite PlomoShop Stores Tab
  Widget _buildShopsTab() {
    final shops = _favoriteShops;

    if (shops.isEmpty) {
      return _buildEmptyState(
        'No favorite shops yet',
        Icons.storefront_rounded,
      );
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: shops.length,
      separatorBuilder: (_, __) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final shop = shops[index];
        return PlomoShopCard(
          shop: shop,
          controller: _controller,
          isVertical: true,
          width: null,
          imageHeight: 170,
        );
      },
    );
  }

  /// Empty state placeholder
  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 76.w,
            height: 76.w,
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 36.sp,
              color: const Color(0xFF94A3B8),
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            message,
            style: GoogleFonts.roboto(
              fontSize: 15.sp.clamp(14.0, 17.0),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}
