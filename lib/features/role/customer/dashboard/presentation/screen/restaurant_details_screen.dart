import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';
import 'package:flutter_code_structure/utils/constants/app_images.dart';
import '../controller/customer_dashboard_controller.dart';
import '../widgets/popular_item_card.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  final dynamic entity; // CustomerRestaurant or CustomerShop

  const RestaurantDetailsScreen({
    super.key,
    this.entity,
  });

  @override
  State<RestaurantDetailsScreen> createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  late String _name;
  late String _address;
  late String _openHours;
  late double _rating;
  late String _reviewCount;
  late String _heroImage;
  late String _phoneNumber;
  final RxBool _isFavorite = false.obs;
  final RxBool _showReviews = false.obs;

  @override
  void initState() {
    super.initState();
    final dynamic data = widget.entity ?? Get.arguments;

    if (data is CustomerRestaurant) {
      _name = data.name;
      _address = data.location;
      _openHours = '10:00 AM – 10:00 PM';
      _rating = data.rating;
      _reviewCount = '4.8k reviews';
      _heroImage = data.imageUrl.isNotEmpty ? data.imageUrl : AppImages.chezBurgers;
      _isFavorite.value = data.isFavorite.value;
      _phoneNumber = '+13237502051';
    } else if (data is CustomerShop) {
      _name = data.name;
      _address = data.location;
      _openHours = '09:00 AM – 11:00 PM';
      _rating = data.rating;
      _reviewCount = '3.5k reviews';
      _heroImage = data.imageUrl.isNotEmpty ? data.imageUrl : AppImages.chezBurgers;
      _isFavorite.value = data.isFavorite.value;
      _phoneNumber = '+13237502052';
    } else {
      _name = 'Burger King';
      _address = '1453 W Manchester Ave Los Angeles';
      _openHours = '10:00 AM – 10:00 PM';
      _rating = 5.0;
      _reviewCount = '4.8k reviews';


      _heroImage = AppImages.chezBurgers;
      _phoneNumber = '+13237502051';

    }
  }

  Future<void> _launchDialer() async {
    final String cleanNumber = _phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final Uri launchUri = Uri.parse('tel:$cleanNumber');
    try {
      final bool launched = await launchUrl(
        launchUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        await launchUrl(launchUri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      debugPrint('Error launching dialer: $e');
      AppSnackbar.error(
        title: 'Could Not Open Dialer',
        message: 'Number: $_phoneNumber',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final dashboardCtrl = Get.find<CustomerDashboardController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ── 1. Hero Banner with Back Button & OPEN Badge ─────
            _buildHeroBanner(topPadding),

            /// ── 2. Content Body ──────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),

                  /// Restaurant Info (Name, Call, Favorite, Address, Hours)
                  _buildRestaurantInfo(),

                  SizedBox(height: 16.h),

                  /// Reviews Row (Tappable to toggle All Reviews view)
                  _buildReviewsRow(),

                  SizedBox(height: 18.h),

                  /// Either All Reviews OR (Popular Items + Menu)
                  Obx(() {
                    if (_showReviews.value) {
                      return _buildAllReviewsSection();
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Popular Items Section (Horizontal ListView)
                          _buildPopularItemsSection(dashboardCtrl),

                          SizedBox(height: 22.h),

                          /// Menu Section (Header with See more + Vertical ListView)
                          _buildMenuSection(dashboardCtrl),
                        ],
                      );
                    }
                  }),

                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ── Hero Banner ──────────────────────────────────────────────
  Widget _buildHeroBanner(double topPadding) {
    return Stack(
      children: [
        /// Background Image
        SizedBox(
          width: double.infinity,
          height: 250.h,
          child: _heroImage.startsWith('http')
              ? Image.network(
                  _heroImage,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.asset(
                    AppImages.chezBurgers,
                    fit: BoxFit.cover,
                  ),
                )
              : Image.asset(
                  _heroImage,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.asset(
                    AppImages.chezBurgers,
                    fit: BoxFit.cover,
                  ),
                ),
        ),

        /// Top-Left Back Button ONLY (Notification icon removed as requested)
        Positioned(
          top: topPadding + 8.h,
          left: 16.w,
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.chevron_left,
                  color: const Color(0xFF2E0A66),
                  size: 26.sp,
                ),
              ),
            ),
          ),
        ),


        /// Bottom-Left Purple "OPEN" Badge
        Positioned(
          bottom: 12.h,
          left: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: const Color(0xFF9C27B0),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8.r),
                bottomRight: Radius.circular(8.r),
              ),
            ),
            child: Text(
              'OPEN',
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// ── Restaurant Info ──────────────────────────────────────────
  Widget _buildRestaurantInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title + Action Buttons (Phone Call + Favorite Heart)
        Row(
          children: [
            Expanded(
              child: Text(
                _name,
                style: GoogleFonts.roboto(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF2E0A66),
                ),
              ),
            ),

            /// Phone Call Button
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _launchDialer,
              child: Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFD946EF),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Icon(
                    Icons.phone,
                    color: Colors.white,
                    size: 19.sp,
                  ),
                ),
              ),
            ),

            SizedBox(width: 8.w),

            /// Favorite Heart Button
            Obx(
              () => GestureDetector(
                onTap: () {
                  _isFavorite.value = !_isFavorite.value;
                  AppSnackbar.success(
                    title: _isFavorite.value ? 'Saved' : 'Removed',
                    message: _isFavorite.value
                        ? '$_name added to favorites'
                        : '$_name removed from favorites',
                  );
                },
                child: Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 1.2,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      _isFavorite.value
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 20.sp,
                      color: _isFavorite.value
                          ? const Color(0xFFE53935)
                          : const Color(0xFF2E0A66),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 6.h),

        /// Address
        RichText(
          text: TextSpan(
            style: GoogleFonts.roboto(
              fontSize: 12.5.sp,
              color: const Color(0xFF787878),
            ),
            children: [
              TextSpan(
                text: 'Address: ',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFFFB039),
                ),
              ),
              TextSpan(text: _address),
            ],
          ),
        ),

        SizedBox(height: 4.h),

        /// Open hours
        Text(
          'Open today: $_openHours',
          style: GoogleFonts.roboto(
            fontSize: 12.sp,
            color: const Color(0xFF787878),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  /// ── Reviews Row ──────────────────────────────────────────────
  Widget _buildReviewsRow() {
    return GestureDetector(
      onTap: () => _showReviews.value = !_showReviews.value,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            Icon(
              Icons.star_rounded,
              color: const Color(0xFFFFB039),
              size: 24.sp,
            ),
            SizedBox(width: 6.w),
            Text(
              _rating.toStringAsFixed(1),
              style: GoogleFonts.roboto(
                fontSize: 15.5.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF2E0A66),
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              '($_reviewCount)',
              style: GoogleFonts.roboto(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF8E8E93),
              ),
            ),
            const Spacer(),
            Obx(
              () => Icon(
                _showReviews.value
                    ? Icons.keyboard_arrow_down_rounded
                    : Icons.chevron_right,
                color: const Color(0xFF2E0A66),
                size: 24.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ── All Reviews Section ──────────────────────────────────────
  Widget _buildAllReviewsSection() {
    final List<Map<String, dynamic>> reviews = [
      {
        'name': 'Eleanor Summers',
        'time': 'Today, 16:40',
        'rating': 5,
        'comment':
            "What can I say it's fast food, it's Burger King.No different to any of the other burger kings, nice with adequate seating",
        'hasReply': true,
        'replyDate': 'October 15, 2023',
        'replyName': 'Eleanor Summers',
        'replyComment':
            "What can I say it's fast food, it's Burger King.No different to any of the other burger kings, nice with adequate seating",
      },
      {
        'name': 'Eleanor Summers',
        'time': 'Today, 16:40',
        'rating': 5,
        'comment':
            "What can I say it's fast food, it's Burger King.No different to any of the other burger kings, nice with adequate seating",
        'hasReply': false,
      },
      {
        'name': 'Eleanor Summers',
        'time': 'Today, 16:40',
        'rating': 5,
        'comment':
            "What can I say it's fast food, it's Burger King.No different to any of the other burger kings, nice with adequate seating",
        'hasReply': false,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Header: "All Reviews" and "Sort By"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'All Reviews',
              style: GoogleFonts.roboto(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2E0A66),
              ),
            ),
            Row(
              children: [
                Text(
                  'Sort By',
                  style: GoogleFonts.roboto(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2E0A66),
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.sort,
                  color: const Color(0xFF2E0A66),
                  size: 20.sp,
                ),
              ],
            ),
          ],
        ),

        SizedBox(height: 18.h),

        /// Reviews List
        ...reviews.map((rev) => _buildReviewItem(rev)),
      ],
    );
  }

  Widget _buildReviewItem(Map<String, dynamic> rev) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// User info row: Avatar + Name + Stars + Timestamp
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 19.r,
                backgroundImage: const AssetImage(AppImages.profileImage),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          rev['name'] as String,
                          style: GoogleFonts.roboto(
                            fontSize: 14.5.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2E0A66),
                          ),
                        ),
                        Text(
                          rev['time'] as String,
                          style: GoogleFonts.roboto(
                            fontSize: 11.5.sp,
                            color: const Color(0xFF9E9E9E),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      children: List.generate(
                        (rev['rating'] as int),
                        (_) => Icon(
                          Icons.star_rounded,
                          color: const Color(0xFFFFB039),
                          size: 16.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          /// Review Body
          Text(
            rev['comment'] as String,
            style: GoogleFonts.roboto(
              fontSize: 12.5.sp,
              height: 1.45,
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w400,
            ),
          ),

          /// Inset Restaurant Reply Box
          if (rev['hasReply'] == true) ...[
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: const Color(0xFFF1F5F9),
                  width: 1.2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'RESPONSE FROM RESTAURANT',
                        style: GoogleFonts.roboto(
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFFFB039),
                          letterSpacing: 0.4,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        rev['replyDate'] as String,
                        style: GoogleFonts.roboto(
                          fontSize: 10.5.sp,
                          color: const Color(0xFF9E9E9E),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    rev['replyName'] as String,
                    style: GoogleFonts.roboto(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2E0A66),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    rev['replyComment'] as String,
                    style: GoogleFonts.roboto(
                      fontSize: 12.sp,
                      height: 1.4,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ],

          SizedBox(height: 14.h),
          const Divider(
            color: Color(0xFFF1F5F9),
            thickness: 1.2,
          ),
        ],
      ),
    );
  }

  /// ── Popular Items Section (Horizontal ListView) ──────────────
  Widget _buildPopularItemsSection(CustomerDashboardController controller) {
    final List<CustomerPopularItem> items = [
      const CustomerPopularItem(
        id: 'pop_pizza_1',
        title: 'Beef Pizza',
        rating: 4.6,
        distanceTime: '1.3 km - 30 min',
        description: 'A hearty, meaty delight loaded with flavor...',
        price: 12.99,
        imageUrl: AppImages.beefPizza,
        restaurantName: 'Burger King',
      ),
      const CustomerPopularItem(
        id: 'pop_burger_1',
        title: 'Beef Burger',
        rating: 4.8,
        distanceTime: '1.3 km - 30 min',
        description: 'A hearty, meaty delight loaded with flavor...',
        price: 7.99,
        imageUrl: AppImages.chezBurgers,
        restaurantName: 'Burger King',
      ),
      const CustomerPopularItem(
        id: 'pop_burger_2',
        title: 'Beef Hawaiian Burger',
        rating: 5.0,
        distanceTime: '1.2 km - 20 min',
        description: 'Juicy flame-grilled beef patty stacked with cheddar...',
        price: 12.99,
        imageUrl: AppImages.chezBurgers,
        restaurantName: 'Burger King',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Items',
          style: GoogleFonts.roboto(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2E0A66),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 222.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final item = items[index];
              return PopularItemCard(
                item: item,
                controller: controller,
                width: 156,
              );
            },
          ),
        ),
      ],
    );
  }

  /// ── Menu Section (Header with See More + Vertical ListView) ──
  Widget _buildMenuSection(CustomerDashboardController controller) {
    final List<Map<String, dynamic>> menuList = [
      {
        'title': 'Chez Panisse Cafe',
        'code': 'Order#0394',
        'desc': 'A hearty, meaty delight loaded with flavor meaty delight loaded...',
        'price': 12.99,
        'time': 'Est:15 min',
        'rating': 4.8,
        'image': AppImages.doubleBurger,
      },
      {
        'title': 'Chez Panisse Cafe',
        'code': 'Order#0394',
        'desc': 'A hearty, meaty delight loaded with flavor meaty delight loaded...',
        'price': 12.99,
        'time': 'Est:15 min',
        'rating': 4.8,
        'image': AppImages.doubleBurger,
      },
      {
        'title': 'Chez Panisse Cafe',
        'code': 'Order#0394',
        'desc': 'A hearty, meaty delight loaded with flavor meaty delight loaded...',
        'price': 12.99,
        'time': 'Est:15 min',
        'rating': 4.8,
        'image': AppImages.doubleBurger,
      },
      {
        'title': 'Chez Panisse Cafe',
        'code': 'Order#0394',
        'desc': 'A hearty, meaty delight loaded with flavor meaty delight loaded...',
        'price': 12.99,
        'time': 'Est:15 min',
        'rating': 4.8,
        'image': AppImages.doubleBurger,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Header row with "Menu" and "See more"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Menu',
              style: GoogleFonts.roboto(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2E0A66),
              ),
            ),
            GestureDetector(
              onTap: () => Get.toNamed(
                AppRoutes.popularItems,
                arguments: {'title': 'Menu'},
              ),
              child: Text(
                'See more',
                style: GoogleFonts.roboto(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2E0A66),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        /// Vertical ListView of Menu Items
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: menuList.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final item = menuList[index];
            return _buildMenuItemCard(item, controller);
          },
        ),
      ],
    );
  }

  Widget _buildMenuItemCard(
    Map<String, dynamic> item,
    CustomerDashboardController controller,
  ) {
    final RxBool isFav = false.obs;

    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.popularItemDetails,
          arguments: CustomerPopularItem(
            id: 'menu_${item['title']}',
            title: item['title'],
            rating: item['rating'],
            distanceTime: '1.2 km - 15 min',
            description: item['desc'],
            price: item['price'],
            imageUrl: item['image'],
            restaurantName: _name,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: const Color(0xFFF1F5F9),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Food Photo with circular heart overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14.r),
                  child: Image.asset(
                    item['image'] as String,
                    width: 82.w,
                    height: 82.w,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 82.w,
                      height: 82.w,
                      color: const Color(0xFFF1F5F9),
                      child: const Icon(
                        Icons.fastfood,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                ),

                /// White Circular Heart Badge
                Positioned(
                  top: 6.w,
                  right: 6.w,
                  child: Obx(
                    () => GestureDetector(
                      onTap: () {
                        isFav.value = !isFav.value;
                      },
                      child: Container(
                        width: 24.w,
                        height: 24.w,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            isFav.value
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 13.sp,
                            color: isFav.value
                                ? const Color(0xFFE53935)
                                : const Color(0xFF2E0A66),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(width: 12.w),

            /// Center Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'] as String,
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2E0A66),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    item['code'] as String,
                    style: GoogleFonts.roboto(
                      fontSize: 11.sp,
                      color: const Color(0xFF9E9E9E),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    item['desc'] as String,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                      fontSize: 11.sp,
                      height: 1.3,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Text(
                        '\$${(item['price'] as double).toStringAsFixed(2)}',
                        style: GoogleFonts.roboto(
                          fontSize: 14.5.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF2E0A66),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        item['time'] as String,
                        style: GoogleFonts.roboto(
                          fontSize: 11.sp,
                          color: const Color(0xFF9E9E9E),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(width: 8.w),

            /// Right Column: Star Rating on Top, Purple Plus Button on Bottom
            SizedBox(
              height: 82.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  /// Rating
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: const Color(0xFFFFB039),
                        size: 15.sp,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        (item['rating'] as double).toStringAsFixed(1),
                        style: GoogleFonts.roboto(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2E0A66),
                        ),
                      ),
                    ],
                  ),

                  /// Purple + Button
                  GestureDetector(
                    onTap: () {
                      controller.cartCount.value++;
                      AppSnackbar.success(
                        title: 'Added to Cart',
                        message: '${item['title']} added to cart.',
                      );
                    },
                    child: Container(
                      width: 38.w,
                      height: 32.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E0A66),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
