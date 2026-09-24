import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';

class ShareReviewScreen extends StatefulWidget {
  const ShareReviewScreen({super.key});

  @override
  State<ShareReviewScreen> createState() => _ShareReviewScreenState();
}

class _ShareReviewScreenState extends State<ShareReviewScreen> {
  final TextEditingController _reviewController = TextEditingController();
  final FocusNode _reviewFocusNode = FocusNode();

  String _restaurantName = 'Bella Italia';
  String _orderId = '#12345';
  int _selectedRating = 0; // 0 = unrated, 1 to 5 stars
  bool _isSubmitting = false;
  bool _showOrderDelivered = true;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;
    if (args is Map) {
      if (args['restaurant'] != null && args['restaurant'].toString().isNotEmpty) {
        _restaurantName = args['restaurant'].toString();
      }
      if (args['orderId'] != null && args['orderId'].toString().isNotEmpty) {
        _orderId = args['orderId'].toString();
      }
      if (args['showOrderDelivered'] != null) {
        _showOrderDelivered = args['showOrderDelivered'] == true;
      }
      if (args['fromRateApp'] == true) {
        _showOrderDelivered = false;
      }
    }
    final params = Get.parameters;
    if (params['showOrderDelivered'] != null) {
      _showOrderDelivered = params['showOrderDelivered'] == 'true';
    }
    if (params['fromRateApp'] == 'true') {
      _showOrderDelivered = false;
    }
  }

  @override
  void dispose() {
    _reviewController.dispose();
    _reviewFocusNode.dispose();
    super.dispose();
  }

  void _onStarTap(int rating) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedRating = rating;
    });
  }

  void _onShareExperience() async {
    if (_isSubmitting) return;

    FocusScope.of(context).unfocus();
    HapticFeedback.mediumImpact();

    setState(() {
      _isSubmitting = true;
    });

    final reviewText = _reviewController.text.trim();
    final ratingStars = _selectedRating > 0 ? '⭐' * _selectedRating : '⭐⭐⭐⭐⭐';
    final shareMessage =
        'I had an amazing meal from $_restaurantName via Julio Food Delivery! $ratingStars'
        '${reviewText.isNotEmpty ? '\n"$reviewText"' : ''}\nOrder: $_orderId';

    await Clipboard.setData(ClipboardData(text: shareMessage));

    if (!mounted) return;

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Get.offAllNamed(AppRoutes.mainNavBar);
    }

    AppSnackbar.success(
      title: 'Review Sent',
      message: 'Thank you! Your review has been submitted successfully.',
    );
  }

  void _onBackToHome() {
    HapticFeedback.lightImpact();
    Get.offAllNamed(AppRoutes.mainNavBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            /// 1. App Bar with Back Button and Centered Title
            _buildAppBar(),

            /// 2. Scrollable Body containing the Review Card
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: _buildReviewCard(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 1. App Bar: Circular Back Button, Centered Title, Balanced Spacer
  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Row(
        children: [
          /// Circular Back Button
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
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
                'Share Review',
                style: GoogleFonts.roboto(
                  fontSize: 18.sp.clamp(16.0, 22.0),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2E0A66),
                ),
              ),
            ),
          ),

          /// Balanced Spacer
          SizedBox(width: 42.w.clamp(38.0, 46.0)),
        ],
      ),
    );
  }

  /// 2. Main Review Card matching the user's design reference
  Widget _buildReviewCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: const Color(0xFFEEF2F6), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Top Mint Green Banner: Green Checkmark Badge, "Order Delivered!", Subtitle
          /// Hidden when navigated from Rate the App
          if (_showOrderDelivered) _buildMintHeader(),

          /// White Section: Rating stars, Review text field, Share button, Back to Home
          _buildCardBody(),
        ],
      ),
    );
  }

  /// Top Mint Green Header
  Widget _buildMintHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 26.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEFFBF5),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        children: [
          /// Green Circular Badge with White Checkmark
          Container(
            width: 52.w.clamp(48.0, 58.0),
            height: 52.w.clamp(48.0, 58.0),
            decoration: const BoxDecoration(
              color: Color(0xFF00C853),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 30.sp.clamp(26.0, 34.0),
              ),
            ),
          ),

          SizedBox(height: 14.h),

          /// "Order Delivered!" Title
          Text(
            'Order Delivered!',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 20.sp.clamp(18.0, 24.0),
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1E293B),
            ),
          ),

          SizedBox(height: 6.h),

          /// Subtitle with bold restaurant name
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'Your food from '),
                TextSpan(
                  text: _restaurantName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const TextSpan(
                  text: ' has arrived.\nHope you enjoyed your meal 😋',
                ),
              ],
            ),
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 13.5.sp.clamp(12.0, 15.0),
              fontWeight: FontWeight.w400,
              color: const Color(0xFF475569),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  /// White Body Section of the Card
  Widget _buildCardBody() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 1. "Rate your experience" Header
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star_rounded,
                  color: const Color(0xFFF59E0B),
                  size: 18.sp,
                ),
                SizedBox(width: 6.w),
                Text(
                  'Rate your experience',
                  style: GoogleFonts.roboto(
                    fontSize: 13.5.sp.clamp(12.0, 15.0),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF475569),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          /// 5 Interactive Star Rating Icons
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (index) {
                final starIndex = index + 1;
                final isFilled = _selectedRating >= starIndex;

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _onStarTap(starIndex),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
                    child: Icon(
                      isFilled ? Icons.star_rounded : Icons.star_border_rounded,
                      size: 38.sp.clamp(32.0, 44.0),
                      color: isFilled
                          ? const Color(0xFFF59E0B)
                          : const Color(0xFFCBD5E1),
                    ),
                  ),
                );
              }),
            ),
          ),

          SizedBox(height: 20.h),

          /// 2. "Write a review (optional)" Header
          Row(
            children: [
              Icon(
                Icons.chat_bubble_outline_rounded,
                color: const Color(0xFF64748B),
                size: 16.sp,
              ),
              SizedBox(width: 6.w),
              Text(
                'Write a review',
                style: GoogleFonts.roboto(
                  fontSize: 13.5.sp.clamp(12.0, 15.0),
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF334155),
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                '(optional)',
                style: GoogleFonts.roboto(
                  fontSize: 12.sp.clamp(11.0, 13.5),
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          /// Multi-line Text Area for review
          Container(
            height: 105.h.clamp(90.0, 130.0),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: 1.0,
              ),
            ),
            child: TextField(
              controller: _reviewController,
              focusNode: _reviewFocusNode,
              maxLines: null,
              expands: true,
              style: GoogleFonts.roboto(
                fontSize: 13.5.sp.clamp(12.0, 15.0),
                color: const Color(0xFF1E293B),
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Share your experience...',
                hintStyle: GoogleFonts.roboto(
                  fontSize: 13.5.sp.clamp(12.0, 15.0),
                  color: const Color(0xFF94A3B8),
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),

          SizedBox(height: 20.h),

          /// Subtle Divider
          const Divider(
            color: Color(0xFFF1F5F9),
            height: 1,
            thickness: 1.2,
          ),

          SizedBox(height: 16.h),

          /// 3. "Loved your meal?" Header
          Center(
            child: Text(
              '🎉  Loved your meal?',
              style: GoogleFonts.roboto(
                fontSize: 14.5.sp.clamp(13.0, 16.5),
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E293B),
              ),
            ),
          ),

          SizedBox(height: 12.h),

          /// 4. Gradient "Share Your Experience" Button
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _isSubmitting ? null : _onShareExperience,
            child: Container(
              width: double.infinity,
              height: 48.h.clamp(44.0, 52.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFE91E63),
                    Color(0xFFFF5722),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE91E63).withOpacity(0.28),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: _isSubmitting
                  ? const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.share_rounded,
                          color: Colors.white,
                          size: 18.sp.clamp(16.0, 22.0),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Share Your Experience',
                          style: GoogleFonts.roboto(
                            fontSize: 14.5.sp.clamp(13.0, 16.0),
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
            ),
          ),

          SizedBox(height: 14.h),

          /// 5. "Back to Home" Button (Order Details button removed per request)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _onBackToHome,
            child: Container(
              width: double.infinity,
              height: 46.h.clamp(42.0, 50.0),
              decoration: BoxDecoration(
                color: const Color(0xFF2E0A66),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.home_outlined,
                    color: Colors.white,
                    size: 19.sp.clamp(17.0, 22.0),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Back to Home',
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp.clamp(13.0, 15.5),
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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
}
