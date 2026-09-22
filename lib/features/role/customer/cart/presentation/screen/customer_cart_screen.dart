import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/features/common/nav_bar/presentation/controller/nav_bar_controller.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';
import 'package:flutter_code_structure/utils/constants/app_images.dart';

class CustomerCartItem {
  final String id;
  final String title;
  final String restaurant;
  final double rating;
  final String time;
  final String calories;
  final double price;
  final String imageUrl;
  final RxInt quantity;

  CustomerCartItem({
    required this.id,
    required this.title,
    required this.restaurant,
    required this.rating,
    required this.time,
    required this.calories,
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
  final RxList<CustomerCartItem> _items = <CustomerCartItem>[
    CustomerCartItem(
      id: 'cart_1',
      title: 'Double Cheeseburger',
      restaurant: 'Chez Panisse Cafe',
      rating: 4.8,
      time: '30 min',
      calories: '615 Kcal',
      price: 12.99,
      imageUrl: AppImages.doubleBurger,
      initialQuantity: 1,
    ),
    CustomerCartItem(
      id: 'cart_2',
      title: 'Double Cheeseburger',
      restaurant: 'Chez Panisse Cafe',
      rating: 4.8,
      time: '30 min',
      calories: '615 Kcal',
      price: 12.99,
      imageUrl: AppImages.doubleBurger,
      initialQuantity: 1,
    ),
    CustomerCartItem(
      id: 'cart_3',
      title: 'Double Cheeseburger',
      restaurant: 'Chez Panisse Cafe',
      rating: 4.8,
      time: '30 min',
      calories: '615 Kcal',
      price: 12.99,
      imageUrl: AppImages.doubleBurger,
      initialQuantity: 1,
    ),
    CustomerCartItem(
      id: 'cart_4',
      title: 'Double Cheeseburger',
      restaurant: 'Chez Panisse Cafe',
      rating: 4.8,
      time: '30 min',
      calories: '615 Kcal',
      price: 12.99,
      imageUrl: AppImages.doubleBurger,
      initialQuantity: 1,
    ),
  ].obs;

  double get _totalPrice {
    return _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity.value));
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

  void _removeAll() {
    if (_items.isEmpty) return;
    _items.clear();
    AppSnackbar.info(
      title: 'Cart Cleared',
      message: 'All items removed from your cart.',
    );
  }

  void _restoreDefaultItems() {
    _items.assignAll([
      CustomerCartItem(
        id: 'cart_1',
        title: 'Double Cheeseburger',
        restaurant: 'Chez Panisse Cafe',
        rating: 4.8,
        time: '30 min',
        calories: '615 Kcal',
        price: 12.99,
        imageUrl: AppImages.doubleBurger,
        initialQuantity: 1,
      ),
      CustomerCartItem(
        id: 'cart_2',
        title: 'Double Cheeseburger',
        restaurant: 'Chez Panisse Cafe',
        rating: 4.8,
        time: '30 min',
        calories: '615 Kcal',
        price: 12.99,
        imageUrl: AppImages.doubleBurger,
        initialQuantity: 1,
      ),
      CustomerCartItem(
        id: 'cart_3',
        title: 'Double Cheeseburger',
        restaurant: 'Chez Panisse Cafe',
        rating: 4.8,
        time: '30 min',
        calories: '615 Kcal',
        price: 12.99,
        imageUrl: AppImages.doubleBurger,
        initialQuantity: 1,
      ),
      CustomerCartItem(
        id: 'cart_4',
        title: 'Double Cheeseburger',
        restaurant: 'Chez Panisse Cafe',
        rating: 4.8,
        time: '30 min',
        calories: '615 Kcal',
        price: 12.99,
        imageUrl: AppImages.doubleBurger,
        initialQuantity: 1,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          return Column(
            children: [
              /// 1. Top Bar: Back button on left, Centered "My Carts" title, NO notification icon
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Back Button
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _onBackPress,
                      child: Container(
                        width: 42.w,
                        height: 42.w,
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
                            size: 16.sp,
                            color: const Color(0xFF2E0A66),
                          ),
                        ),
                      ),
                    ),

                    /// Centered Title: "My Carts"
                    Text(
                      'My Carts',
                      style: GoogleFonts.roboto(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2E0A66),
                      ),
                    ),

                    /// Balanced Spacer on right (Notification bell removed as requested)
                    SizedBox(width: 42.w),
                  ],
                ),
              ),

              /// 2. Header Row: "4 items: 2 restaurants" & "Remove All"
              if (_items.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_items.length} items: 2 restaurants',
                        style: GoogleFonts.roboto(
                          fontSize: 15.5.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2E0A66),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _removeAll,
                        child: Text(
                          'Remove All',
                          style: GoogleFonts.roboto(
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFFF5252),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              SizedBox(height: 6.h),

              /// 3. Scrollable Items List with Swipe-to-Delete or Empty State
              Expanded(
                child: _items.isEmpty
                    ? _buildEmptyCart()
                    : ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
                        itemCount: _items.length,
                        separatorBuilder: (_, __) => SizedBox(height: 14.h),
                        itemBuilder: (context, index) {
                          final item = _items[index];
                          return _SwipeableCartCard(
                            key: ValueKey(item.id),
                            item: item,
                            index: index,
                            onDelete: () {
                              _items.removeAt(index);
                              AppSnackbar.info(
                                title: 'Item Removed',
                                message: '${item.title} removed from cart.',
                              );
                            },
                            onIncrement: () {
                              item.quantity.value++;
                            },
                            onDecrement: () {
                              if (item.quantity.value > 1) {
                                item.quantity.value--;
                              } else {
                                _items.removeAt(index);
                              }
                            },
                          );
                        },
                      ),
              ),

              /// 4. Bottom Fixed Checkout Button
              if (_items.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(
                    left: 20.w,
                    right: 20.w,
                    top: 10.h,
                    bottom: 14.h,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: () {
                        AppSnackbar.success(
                          title: 'Checkout',
                          message:
                              'Proceeding with ${_items.length} items (Total: \$${_totalPrice.toStringAsFixed(2)})',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E0A66),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'All Checkout',
                        style: GoogleFonts.roboto(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
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

  /// Empty cart screen matching the user mockup
  Widget _buildEmptyCart() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.orderEmpty,
              width: 190.w,
              height: 190.w,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(
                Icons.shopping_cart_outlined,
                size: 72.sp,
                color: const Color(0xFFCBD5E1),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'You cart is empty!',
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2E0A66),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Explore and add items to the cart\nto show here...',
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF5B21B6),
                height: 1.35,
              ),
            ),
            SizedBox(height: 28.h),
            ElevatedButton(
              onPressed: _restoreDefaultItems,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E0A66),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'Restore Items',
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}

/// Swipeable Cart Item Card matching the mockup with the red trash can reveal
class _SwipeableCartCard extends StatefulWidget {
  final CustomerCartItem item;
  final int index;
  final VoidCallback onDelete;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  const _SwipeableCartCard({
    required Key key,
    required this.item,
    required this.index,
    required this.onDelete,
    this.onIncrement,
    this.onDecrement,
  }) : super(key: key);

  @override
  State<_SwipeableCartCard> createState() => _SwipeableCartCardState();
}

class _SwipeableCartCardState extends State<_SwipeableCartCard> {
  double _dragOffset = 0.0;
  static const double _actionWidth = 82.0;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.primaryDelta!;
      if (_dragOffset > 0) _dragOffset = 0;
      if (_dragOffset < -_actionWidth) _dragOffset = -_actionWidth;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_dragOffset < -_actionWidth / 2 || details.primaryVelocity! < -250) {
      setState(() {
        _dragOffset = -_actionWidth;
      });
    } else {
      setState(() {
        _dragOffset = 0;
      });
    }
  }

  void _close() {
    if (_dragOffset != 0) {
      setState(() {
        _dragOffset = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          /// Red Delete Action Button Behind Card (matching the screenshot)
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: _actionWidth.w,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                _close();
                widget.onDelete();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFEB4335),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16.r),
                    bottomRight: Radius.circular(16.r),
                    topLeft: Radius.circular(20.r),
                    bottomLeft: Radius.circular(20.r),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.white,
                    size: 28.sp,
                  ),
                ),
              ),
            ),
          ),

          /// Sliding White Card
          AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            transform: Matrix4.translationValues(_dragOffset.w, 0, 0),
            child: GestureDetector(
              onTap: _dragOffset < 0 ? _close : null,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// Left Burger Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.asset(
                        widget.item.imageUrl,
                        width: 84.w,
                        height: 84.w,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 84.w,
                          height: 84.w,
                          color: const Color(0xFFF1F5F9),
                          child: Icon(
                            Icons.fastfood_rounded,
                            color: const Color(0xFFCBD5E1),
                            size: 32.sp,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 12.w),

                    /// Right Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /// Restaurant & Star Rating
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.item.restaurant,
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
                                  SizedBox(width: 2.w),
                                  Text(
                                    widget.item.rating.toStringAsFixed(1),
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

                          SizedBox(height: 6.h),

                          /// Badges: "30 min" & "615 Kcal"
                          Row(
                            children: [
                              _buildPillBadge(widget.item.time),
                              SizedBox(width: 8.w),
                              _buildPillBadge(widget.item.calories),
                            ],
                          ),

                          SizedBox(height: 10.h),

                          /// Price & Quantity Stepper
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /// Price in warm orange/amber
                              Text(
                                '\$${widget.item.price.toStringAsFixed(2)}',
                                style: GoogleFonts.roboto(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFF59E0B),
                                ),
                              ),

                              /// Stepper: [ - ] 1 [ + ]
                              Obx(
                                () => Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    /// Minus Button
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: widget.onDecrement,
                                      child: Container(
                                        width: 26.w,
                                        height: 26.w,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFFF1F5F9),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.remove,
                                            size: 14.sp,
                                            color: const Color(0xFF2E0A66),
                                          ),
                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                                      child: Text(
                                        '${widget.item.quantity.value}',
                                        style: GoogleFonts.roboto(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF2E0A66),
                                        ),
                                      ),
                                    ),

                                    /// Plus Button
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: widget.onIncrement,
                                      child: Container(
                                        width: 26.w,
                                        height: 26.w,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFF2E0A66),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.add,
                                            size: 14.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillBadge(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        label,
        style: GoogleFonts.roboto(
          fontSize: 10.5.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF64748B),
        ),
      ),
    );
  }
}
