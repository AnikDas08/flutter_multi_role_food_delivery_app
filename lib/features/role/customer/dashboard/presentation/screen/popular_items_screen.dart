import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/utils/constants/app_images.dart';
import '../controller/customer_dashboard_controller.dart';
import '../widgets/popular_item_card.dart';

class PopularItemsScreen extends StatefulWidget {
  const PopularItemsScreen({super.key});

  @override
  State<PopularItemsScreen> createState() => _PopularItemsScreenState();
}

class _PopularItemsScreenState extends State<PopularItemsScreen> {
  final CustomerDashboardController controller =
      Get.find<CustomerDashboardController>();

  final RxString selectedFilter = 'All'.obs;

  final List<Map<String, String>> filters = [
    {'name': 'All', 'emoji': ''},
    {'name': 'Hamburger', 'emoji': '🍔'},
    {'name': 'Pizza', 'emoji': '🍕'},
    {'name': 'Drink', 'emoji': '🍹'},
  ];

  late final List<CustomerPopularItem> allItems;

  @override
  void initState() {
    super.initState();
    allItems = [
      const CustomerPopularItem(
        id: 'item_pizza_1',
        title: 'Beef Pizza',
        rating: 4.6,
        distanceTime: '1.3 km - 30 min',
        description:
            'A hearty, meaty delight loaded with flavor crust topped with rich cheese...',
        price: 12.99,
        imageUrl: AppImages.beefPizza,
      ),
      const CustomerPopularItem(
        id: 'item_burger_1',
        title: 'Beef Burger',
        rating: 4.9,
        distanceTime: '1.3 km - 30 min',
        description:
            'A hearty, meaty delight loaded with flavor crust topped with rich cheese...',
        price: 7.99,
        imageUrl: AppImages.chezBurgers,
      ),
      const CustomerPopularItem(
        id: 'item_pizza_2',
        title: 'Beef Pizza',
        rating: 4.6,
        distanceTime: '1.3 km - 30 min',
        description:
            'A hearty, meaty delight loaded with flavor crust topped with rich cheese...',
        price: 12.99,
        imageUrl: AppImages.beefPizza,
      ),
      const CustomerPopularItem(
        id: 'item_burger_2',
        title: 'Beef Burger',
        rating: 4.9,
        distanceTime: '1.3 km - 30 min',
        description:
            'A hearty, meaty delight loaded with flavor crust topped with rich cheese...',
        price: 7.99,
        imageUrl: AppImages.chezBurgers,
      ),
      const CustomerPopularItem(
        id: 'item_pizza_3',
        title: 'Beef Pizza',
        rating: 4.6,
        distanceTime: '1.3 km - 30 min',
        description:
            'A hearty, meaty delight loaded with flavor crust topped with rich cheese...',
        price: 12.99,
        imageUrl: AppImages.beefPizza,
      ),
      const CustomerPopularItem(
        id: 'item_burger_3',
        title: 'Beef Burger',
        rating: 4.9,
        distanceTime: '1.3 km - 30 min',
        description:
            'A hearty, meaty delight loaded with flavor crust topped with rich cheese...',
        price: 7.99,
        imageUrl: AppImages.chezBurgers,
      ),
      const CustomerPopularItem(
        id: 'item_drink_1',
        title: 'Fresh Mango Juice',
        rating: 4.8,
        distanceTime: '1.0 km - 15 min',
        description: 'Chilled freshly squeezed tropical mango nectar with mint...',
        price: 4.50,
        imageUrl:
            'https://images.unsplash.com/photo-1546173159-315724a31696?w=500&q=80',
      ),
      const CustomerPopularItem(
        id: 'item_drink_2',
        title: 'Berry Smoothie',
        rating: 4.7,
        distanceTime: '1.1 km - 15 min',
        description: 'Antioxidant rich blend of blueberries, strawberries and yogurt...',
        price: 5.20,
        imageUrl:
            'https://images.unsplash.com/photo-1553530666-ba11a7da3888?w=500&q=80',
      ),
    ];
  }

  List<CustomerPopularItem> _getFilteredItems() {
    final filter = selectedFilter.value;
    if (filter == 'All') return allItems;
    if (filter == 'Hamburger') {
      return allItems.where((i) => i.title.toLowerCase().contains('burger')).toList();
    }
    if (filter == 'Pizza') {
      return allItems.where((i) => i.title.toLowerCase().contains('pizza')).toList();
    }
    if (filter == 'Drink') {
      return allItems
          .where((i) =>
              i.title.toLowerCase().contains('juice') ||
              i.title.toLowerCase().contains('smoothie') ||
              i.title.toLowerCase().contains('drink'))
          .toList();
    }
    return allItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFC),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 8.h),

            /// Top Bar
            _buildAppBar(),

            SizedBox(height: 16.h),

            /// Filter Chips Row
            _buildFilterChips(),

            SizedBox(height: 14.h),

            /// Grid of Items
            Expanded(
              child: Obx(() {
                final items = _getFilteredItems();
                return GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 0.68,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return PopularItemCard(
                      item: item,
                      controller: controller,
                      width: null,
                      imageHeight: 100,
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
                'Popular Items',
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

  /// Horizontal filter chips
  Widget _buildFilterChips() {
    return SizedBox(
      height: 38.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, index) => SizedBox(width: 10.w),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final name = filter['name']!;
          final emoji = filter['emoji']!;

          return Obx(() {
            final isSelected = selectedFilter.value == name;
            return GestureDetector(
              onTap: () => selectedFilter.value = name,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: EdgeInsets.symmetric(
                  horizontal: isSelected ? 20.w : 14.w,
                  vertical: 7.h,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF2E0A66) : Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: const Color(0xFF2E0A66),
                    width: 1.2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF2E0A66).withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (emoji.isNotEmpty) ...[
                      Text(emoji, style: TextStyle(fontSize: 13.sp)),
                      SizedBox(width: 6.w),
                    ],
                    Text(
                      name,
                      style: GoogleFonts.roboto(
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : const Color(0xFF2E0A66),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
