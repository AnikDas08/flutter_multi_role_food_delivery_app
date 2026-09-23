import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';
import 'package:flutter_code_structure/utils/constants/app_images.dart';
import '../controller/customer_dashboard_controller.dart';

class AddOnItem {
  final String id;
  final String name;
  final double price;
  final String image;

  const AddOnItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });
}

class RelatedItem {
  final String id;
  final String restaurant;
  final String orderCode;
  final String description;
  final double price;
  final String estTime;
  final double rating;
  final String image;
  final RxBool isFavorite;

  RelatedItem({
    required this.id,
    required this.restaurant,
    required this.orderCode,
    required this.description,
    required this.price,
    required this.estTime,
    required this.rating,
    required this.image,
    bool isFav = false,
  }) : isFavorite = isFav.obs;
}

class PopularItemDetailsScreen extends StatefulWidget {
  final CustomerPopularItem? item;

  const PopularItemDetailsScreen({
    super.key,
    this.item,
  });

  @override
  State<PopularItemDetailsScreen> createState() =>
      _PopularItemDetailsScreenState();
}

class _PopularItemDetailsScreenState extends State<PopularItemDetailsScreen> {
  late CustomerPopularItem _item;
  final RxBool _isFavorite = false.obs;
  final RxInt _quantity = 1.obs;
  final RxBool _isDescriptionExpanded = false.obs;
  final RxBool _showReviews = false.obs;

  // Selected add-on IDs (by default, 'pepper' is selected matching the mockup)
  final RxSet<String> _selectedAddOns = <String>{'pepper'}.obs;

  final List<AddOnItem> _addOns = const [
    AddOnItem(
      id: 'pepper',
      name: 'Pepper julienned',
      price: 2.30,
      image: AppImages.pepperJulienned,
    ),
    AddOnItem(
      id: 'spinach',
      name: 'Baby spinach',
      price: 2.30,
      image: AppImages.babySpinach,
    ),
    AddOnItem(
      id: 'mushroom',
      name: 'Mushroom',
      price: 2.30,
      image: AppImages.mushroomSlice,
    ),
  ];

  late final List<RelatedItem> _relatedItems;

  @override
  void initState() {
    super.initState();
    // Use passed widget item, or Get.arguments, or default to the Beef Hawaiian Burger
    if (widget.item != null) {
      _item = widget.item!;
    } else if (Get.arguments is CustomerPopularItem) {
      _item = Get.arguments as CustomerPopularItem;
    } else {
      _item = const CustomerPopularItem(
        id: 'item_1',
        title: 'Beef Hawaiian Burger',
        rating: 5.0,
        distanceTime: '1.2 km - 20 min',
        description:
            'Juicy, flame-grilled beef patty stacked with sweet grilled pineapple, melted cheddar cheese, and crispy bacon...',
        price: 12.99,
        imageUrl: AppImages.chezBurgers,
        restaurantName: 'Burger King',
        reviewCount: '4.8k reviews',
        fullDescription:
            'Juicy, flame-grilled beef patty stacked with sweet grilled pineapple, melted cheddar cheese, and crispy bacon, all topped with fresh lettuce, tomato, and a tangy teriyaki glaze. Served on a toasted brioche bun for the perfect sweet-and-savory bite.',
      );
    }

    _relatedItems = [
      RelatedItem(
        id: 'rel_1',
        restaurant: 'Chez Panisse Cafe',
        orderCode: 'Order#0394',
        description:
            'A hearty, meaty delight loaded with flavor meaty delight loaded...',
        price: 12.99,
        estTime: 'Est:15 min',
        rating: 4.8,
        image: AppImages.beefPizza,
      ),
      RelatedItem(
        id: 'rel_2',
        restaurant: 'Chez Panisse Cafe',
        orderCode: 'Order#0394',
        description:
            'A hearty, meaty delight loaded with flavor meaty delight loaded...',
        price: 18.99,
        estTime: 'Est:15 min',
        rating: 4.8,
        image: AppImages.chocolateMuffins,
      ),
      RelatedItem(
        id: 'rel_3',
        restaurant: 'Chez Panisse Cafe',
        orderCode: 'Order#0394',
        description:
            'A hearty, meaty delight loaded with flavor meaty delight loaded...',
        price: 12.99,
        estTime: 'Est:15 min',
        rating: 4.8,
        image: AppImages.doubleBurger,
      ),
    ];
  }

  void _toggleAddOn(String id) {
    if (_selectedAddOns.contains(id)) {
      _selectedAddOns.remove(id);
    } else {
      _selectedAddOns.add(id);
    }
  }

  double get _totalPrice {
    double base = _item.price;
    for (final addon in _addOns) {
      if (_selectedAddOns.contains(addon.id)) {
        base += addon.price;
      }
    }
    return base * _quantity.value;
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// ── 1. Scrollable Content ──────────────────────────────
          Positioned.fill(
            bottom: 80.h, // Leave room for bottom sticky bar
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Hero Image with top back button overlay
                  _buildHeroImage(topPadding),

                  /// Main Details Body
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16.h),

                        /// Title, Favorite & Subtitle & Price
                        _buildTitleSection(),

                        SizedBox(height: 18.h),

                        /// Description
                        _buildDescriptionSection(),

                        SizedBox(height: 20.h),

                        /// Add more Items
                        _buildAddMoreItemsSection(),

                        SizedBox(height: 14.h),

                        /// Reviews Row (5.0 ★ (4.8k reviews) >)
                        _buildReviewsRow(),

                        SizedBox(height: 18.h),

                        /// Toggle Reviews or Related Items
                        Obx(() {
                          if (_showReviews.value) {
                            return _buildAllReviewsSection();
                          } else {
                            return _buildRelatedItemsSection();
                          }
                        }),

                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// ── 2. Sticky Bottom Bar ───────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomBar(),
          ),
        ],
      ),
    );
  }

  /// ── Hero Food Image ──────────────────────────────────────────
  Widget _buildHeroImage(double topPadding) {
    return Stack(
      children: [
        /// Food Image
        SizedBox(
          width: double.infinity,
          height: 270.h,
          child: _item.imageUrl.startsWith('http')
              ? Image.network(
                  _item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.asset(
                    AppImages.chezBurgers,
                    fit: BoxFit.cover,
                  ),
                )
              : Image.asset(
                  _item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.asset(
                    AppImages.chezBurgers,
                    fit: BoxFit.cover,
                  ),
                ),
        ),

        /// Top Bar with ONLY Circular Back Button (Notification removed as requested)
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
      ],
    );
  }

  /// ── Title, Favorite, Restaurant & Price ───────────────────────
  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title + Favorite Icon
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                _item.title,
                style: GoogleFonts.roboto(
                  fontSize: 21.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF2E0A66),
                  height: 1.2,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Obx(
              () => GestureDetector(
                onTap: () {
                  _isFavorite.value = !_isFavorite.value;
                  AppSnackbar.success(
                    title: _isFavorite.value ? 'Saved' : 'Removed',
                    message: _isFavorite.value
                        ? '${_item.title} added to favorites'
                        : '${_item.title} removed from favorites',
                  );
                },
                child: Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
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

        SizedBox(height: 4.h),

        /// Subtitle / Restaurant
        Text(
          _item.restaurantName,
          style: GoogleFonts.roboto(
            fontSize: 13.5.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF8E8E93),
          ),
        ),

        SizedBox(height: 6.h),

        /// Price
        Text(
          '\$${_item.price.toStringAsFixed(2)}',
          style: GoogleFonts.roboto(
            fontSize: 19.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFFFFB039),
          ),
        ),
      ],
    );
  }

  /// ── Description Section ──────────────────────────────────────
  Widget _buildDescriptionSection() {
    final String fullText = _item.fullDescription ??
        'Juicy, flame-grilled beef patty stacked with sweet grilled pineapple, melted cheddar cheese, and crispy bacon, all topped with fresh lettuce, tomato, and a tangy teriyaki glaze. Served on a toasted brioche bun for the perfect sweet-and-savory bite.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: GoogleFonts.roboto(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2E0A66),
          ),
        ),
        SizedBox(height: 8.h),
        Obx(
          () {
            final isExpanded = _isDescriptionExpanded.value;
            return GestureDetector(
              onTap: () =>
                  _isDescriptionExpanded.value = !_isDescriptionExpanded.value,
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.roboto(
                    fontSize: 13.sp,
                    height: 1.5,
                    color: const Color(0xFF6B7280),
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(
                      text: isExpanded || fullText.length <= 160
                          ? fullText
                          : '${fullText.substring(0, 155)}... ',
                    ),
                    if (!isExpanded && fullText.length > 160)
                      TextSpan(
                        text: 'read more...',
                        style: GoogleFonts.roboto(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFFFB039),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),

        SizedBox(height: 12.h),

        /// Centered three dots indicator
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDot(),
              SizedBox(width: 6.w),
              _buildDot(),
              SizedBox(width: 6.w),
              _buildDot(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDot() {
    return Container(
      width: 4.w,
      height: 4.w,
      decoration: const BoxDecoration(
        color: Color(0xFFCBD5E1),
        shape: BoxShape.circle,
      ),
    );
  }

  /// ── Add more Items Section ───────────────────────────────────
  Widget _buildAddMoreItemsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add more Items',
          style: GoogleFonts.roboto(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2E0A66),
          ),
        ),
        SizedBox(height: 12.h),
        ..._addOns.map((addon) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _buildAddOnRow(addon),
          );
        }),
      ],
    );
  }

  Widget _buildAddOnRow(AddOnItem addon) {
    return Obx(() {
      final isSelected = _selectedAddOns.contains(addon.id);

      return GestureDetector(
        onTap: () => _toggleAddOn(addon.id),
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            /// Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                ),
                child: Image.asset(
                  addon.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.fastfood,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ),
            ),

            SizedBox(width: 12.w),

            /// Name
            Expanded(
              child: Text(
                addon.name,
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2E0A66),
                ),
              ),
            ),

            /// Price
            Text(
              '+ \$${addon.price.toStringAsFixed(2)}',
              style: GoogleFonts.roboto(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF64748B),
              ),
            ),

            SizedBox(width: 12.w),

            /// Custom Radio Button
            Container(
              width: 22.w,
              height: 22.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFAB47BC)
                      : const Color(0xFFCBD5E1),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFAB47BC),
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      );
    });
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
              _item.rating.toStringAsFixed(1),
              style: GoogleFonts.roboto(
                fontSize: 15.5.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF2E0A66),
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              '(${_item.reviewCount})',
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

  /// ── Related Items Section ────────────────────────────────────
  Widget _buildRelatedItemsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Related Items',
          style: GoogleFonts.roboto(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2E0A66),
          ),
        ),
        SizedBox(height: 14.h),
        ..._relatedItems.map((item) {
          return Padding(
            padding: EdgeInsets.only(bottom: 14.h),
            child: _buildRelatedItemCard(item),
          );
        }),
      ],
    );
  }

  Widget _buildRelatedItemCard(RelatedItem item) {
    return Container(
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
                  item.image,
                  width: 82.w,
                  height: 82.w,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 82.w,
                    height: 82.w,
                    color: const Color(0xFFF1F5F9),
                    child: const Icon(Icons.fastfood, color: Color(0xFF94A3B8)),
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
                      item.isFavorite.value = !item.isFavorite.value;
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
                          item.isFavorite.value
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 13.sp,
                          color: item.isFavorite.value
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

          /// Center Details (Restaurant, OrderCode, Description, Price + Est time)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.restaurant,
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2E0A66),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  item.orderCode,
                  style: GoogleFonts.roboto(
                    fontSize: 11.sp,
                    color: const Color(0xFF9E9E9E),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  item.description,
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
                      '\$${item.price.toStringAsFixed(2)}',
                      style: GoogleFonts.roboto(
                        fontSize: 14.5.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF2E0A66),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      item.estTime,
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
                      item.rating.toStringAsFixed(1),
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
                    Get.find<CustomerDashboardController>().cartCount.value++;
                    AppSnackbar.success(
                      title: 'Added to Cart',
                      message: '${item.restaurant} item added to cart.',
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
    );
  }

  /// ── Bottom Sticky Bar ────────────────────────────────────────
  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            /// Quantity Selector Pill: [-]  1  [+]
            Container(
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3F6),
                borderRadius: BorderRadius.circular(26.r),
              ),
              child: Obx(
                () => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Minus Button
                    GestureDetector(
                      onTap: () {
                        if (_quantity.value > 1) {
                          _quantity.value--;
                        }
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Icon(
                          Icons.remove,
                          size: 18.sp,
                          color: const Color(0xFF2E0A66),
                        ),
                      ),
                    ),

                    /// Quantity Number
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: Text(
                        '${_quantity.value}',
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF2E0A66),
                        ),
                      ),
                    ),

                    /// Solid Purple Circle with White Plus
                    GestureDetector(
                      onTap: () {
                        _quantity.value++;
                      },
                      child: Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2E0A66),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.add,
                            size: 18.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(width: 14.w),

            /// Checkout Button
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  final dashboardCtrl =
                      Get.find<CustomerDashboardController>();
                  dashboardCtrl.cartCount.value += _quantity.value;
                  Get.toNamed(
                    AppRoutes.orderConfirmation,
                    arguments: {
                      'fromCart': false,
                      'items': [
                        {
                          'title': _item.title,
                          'price': _totalPrice / _quantity.value,
                          'quantity': _quantity.value,
                          'imageUrl': _item.imageUrl.isNotEmpty
                              ? _item.imageUrl
                              : AppImages.doubleBurger,
                        }
                      ],
                    },
                  );
                },
                child: Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E0A66),
                    borderRadius: BorderRadius.circular(26.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Checkout',
                        style: GoogleFonts.roboto(
                          fontSize: 15.5.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
