import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';
import 'package:flutter_code_structure/utils/constants/app_images.dart';

class CustomerLiveTrackingScreen extends StatefulWidget {
  const CustomerLiveTrackingScreen({super.key});

  @override
  State<CustomerLiveTrackingScreen> createState() =>
      _CustomerLiveTrackingScreenState();
}

class _CustomerLiveTrackingScreenState
    extends State<CustomerLiveTrackingScreen> {
  String _driverName = 'Driver Julio';
  String _eta = '12 mins';
  String _orderNumber = '#12345';
  String _restaurant = 'Burger House';
  double _rating = 4.9;

  /// Map layer style: 0 = Grayscale Satellite, 1 = Color Satellite
  int _mapLayerIndex = 0;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is Map) {
      if (args['driverName'] != null &&
          args['driverName'].toString().isNotEmpty) {
        _driverName = args['driverName'].toString();
      }
      if (args['eta'] != null) _eta = args['eta'].toString();
      if (args['orderId'] != null) _orderNumber = args['orderId'].toString();
      if (args['restaurant'] != null) _restaurant = args['restaurant'].toString();
    }
  }

  void _onToggleMapLayer() {
    HapticFeedback.selectionClick();
    setState(() {
      _mapLayerIndex = (_mapLayerIndex + 1) % 2;
    });
    AppSnackbar.info(
      title: 'Map Layer',
      message: _mapLayerIndex == 0 ? 'Satellite Grayscale' : 'Satellite Standard',
    );
  }

  void _onMessageDriver() {
    HapticFeedback.lightImpact();
    Get.toNamed(
      AppRoutes.message,
      arguments: {
        'orderId': _orderNumber.replaceAll('#', ''),
        'restaurant': '$_driverName (Driver)',
        'status': 'Out for Delivery ($_eta away)',
        'isMerchant': false,
      },
    );
  }

  void _onViewOrderSummary() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order Summary',
                      style: GoogleFonts.roboto(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      _orderNumber,
                      style: GoogleFonts.roboto(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  'From: $_restaurant',
                  style: GoogleFonts.roboto(
                    fontSize: 13.sp,
                    color: const Color(0xFF64748B),
                  ),
                ),
                const Divider(height: 24, color: Color(0xFFF1F5F9)),
                _buildSummaryRow('Chicken Cheese Burger', 'x1', '\$20.16'),
                SizedBox(height: 8.h),
                _buildSummaryRow('Chez Burger Meal', 'x1', '\$18.99'),
                SizedBox(height: 8.h),
                _buildSummaryRow('Delivery Fee', '', '\$15.00'),
                const Divider(height: 24, color: Color(0xFFF1F5F9)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Price',
                      style: GoogleFonts.roboto(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      '\$54.15',
                      style: GoogleFonts.roboto(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF2E0A66),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  height: 46.h,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E0A66),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Close',
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(String name, String qty, String price) {
    return Row(
      children: [
        Expanded(
          child: Text(
            name,
            style: GoogleFonts.roboto(
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF334155),
            ),
          ),
        ),
        if (qty.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              qty,
              style: GoogleFonts.roboto(
                fontSize: 13.sp,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ),
        Text(
          price,
          style: GoogleFonts.roboto(
            fontSize: 13.5.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF1E293B),
        body: Stack(
          children: [
            /// 1. Full Screen Satellite / Aerial Map
            Positioned.fill(
              child: _buildMapBackground(),
            ),

            /// 2. Glowing Road Route with Street Name & Pins
            Positioned.fill(
              child: _buildRouteOverlay(),
            ),

            /// 3. Floating Layer Toggle Button (Right side above bottom card)
            Positioned(
              right: 18.w,
              bottom: bottomPadding > 0 ? bottomPadding + 88.h : 98.h,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _onToggleMapLayer,
                child: Container(
                  width: 52.w.clamp(46.0, 58.0),
                  height: 52.w.clamp(46.0, 58.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.22),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.layers_rounded,
                      color: const Color(0xFF1E293B),
                      size: 25.sp.clamp(22.0, 28.0),
                    ),
                  ),
                ),
              ),
            ),

            /// 4. Top Floating Driver Info Card
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 540),
                      child: _buildTopDriverCard(),
                    ),
                  ),
                ),
              ),
            ),

            /// 5. Bottom Sheet with "Message Driver" and "View order Summary"
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildBottomSheetCard(bottomPadding),
            ),
          ],
        ),
      ),
    );
  }

  /// 1. Map Background with Grayscale / Color Satellite Filter
  Widget _buildMapBackground() {
    Widget mapImage = Image.asset(
      'assets/images/driver_tracking_map.png',
      fit: BoxFit.fill,
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      errorBuilder: (_, __, ___) => Container(
        color: const Color(0xFF475569),
        child: const Center(
          child: Icon(Icons.map_rounded, color: Colors.white24, size: 80),
        ),
      ),
    );

    if (_mapLayerIndex == 0) {
      // Grayscale matrix matching the user's monochrome satellite screenshot
      mapImage = ColorFiltered(
        colorFilter: const ColorFilter.matrix(<double>[
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0,      0,      0,      1, 0,
        ]),
        child: mapImage,
      );
    }

    return mapImage;
  }

  /// 2. Glowing Vertical Route with Scooter, "Your Home", and Street Name
  Widget _buildRouteOverlay() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;

        // Route extends from bottom delivery scooter position to top home destination
        final routeTop = screenHeight * 0.28;
        final routeBottom = screenHeight * 0.75;
        final routeHeight = routeBottom - routeTop;
        final routeLeft = (screenWidth / 2) - 17.w;

        return Stack(
          children: [
            /// Glowing Vertical Road
            Positioned(
              top: routeTop + 14.h,
              left: routeLeft,
              width: 34.w,
              height: routeHeight - 20.h,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.85),
                      Colors.white.withOpacity(0.60),
                      Colors.white.withOpacity(0.80),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      blurRadius: 14,
                      spreadRadius: 3,
                    ),
                  ],
                ),
              ),
            ),

            /// Street Name "Dili" centered on the road
            Positioned(
              top: routeTop + (routeHeight * 0.42),
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.40),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    'Dili',
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ),

            /// Side Marker on Left: "our Home"
            Positioned(
              top: routeTop + 60.h,
              left: 8.w,
              child: Row(
                children: [
                  Icon(
                    Icons.home_rounded,
                    color: Colors.white,
                    size: 20.sp,
                    shadows: const [
                      Shadow(color: Colors.black54, blurRadius: 4),
                    ],
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'our Home',
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      shadows: const [
                        Shadow(color: Colors.black87, blurRadius: 4),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// "Your Home" Label & Circular Destination Pin
            Positioned(
              top: routeTop - 18.h,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Black pill: "Your Home"
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 3.5.h),
                    decoration: BoxDecoration(
                      color: const Color(0xDD000000),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.85),
                        width: 1.2,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'Your Home',
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  SizedBox(height: 4.h),

                  /// Circular Pin with House Icon
                  Container(
                    width: 30.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF1E293B),
                      border: Border.all(color: Colors.white, width: 2.2),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.home_rounded,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// Delivery Scooter at the bottom of the glowing road
            Positioned(
              top: routeBottom - 16.h,
              left: (screenWidth / 2) - 30.w,
              child: _buildDeliveryScooterIcon(),
            ),
          ],
        );
      },
    );
  }

  /// Stylized Scooter with Delivery Box matching the design screenshot
  Widget _buildDeliveryScooterIcon() {
    return Container(
      width: 60.w,
      height: 44.h,
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// White outline glow/shadow for contrast against map
          Transform.scale(
            scale: 1.08,
            child: Icon(
              Icons.moped_rounded,
              color: Colors.white,
              size: 44.sp,
            ),
          ),

          /// Black scooter body
          Icon(
            Icons.moped_rounded,
            color: const Color(0xFF111827),
            size: 40.sp,
          ),

          /// Delivery Box outline on back rack
          Positioned(
            left: 5.w,
            top: 4.h,
            child: Container(
              width: 14.w,
              height: 14.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2.r),
                border: Border.all(
                  color: const Color(0xFF111827),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 4. Top Floating Driver Information Card
  Widget _buildTopDriverCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Back Arrow
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Get.back(),
            child: Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Icon(
                Icons.arrow_back,
                color: const Color(0xFF1E293B),
                size: 22.sp,
              ),
            ),
          ),

          /// Driver Avatar & Details
          Row(
            children: [
              /// Driver Circular Profile Photo
              ClipOval(
                child: Image.asset(
                  AppImages.profileImage,
                  width: 44.w.clamp(40.0, 48.0),
                  height: 44.w.clamp(40.0, 48.0),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 44.w,
                    height: 44.w,
                    color: const Color(0xFFF3E8FF),
                    child: const Icon(Icons.person, color: Color(0xFF7C3AED)),
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              /// Driver Name & Subtitle ("is 12 mins away.")
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _driverName,
                      style: GoogleFonts.roboto(
                        fontSize: 16.5.sp.clamp(15.0, 18.0),
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'is $_eta away.',
                      style: GoogleFonts.roboto(
                        fontSize: 13.sp.clamp(12.0, 14.5),
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          /// Status Row: "12 mins", "Live" badge, and "4.9 ⭐⭐"
          Row(
            children: [
              /// "12 mins" in Mint Green Text
              Text(
                _eta,
                style: GoogleFonts.roboto(
                  fontSize: 12.5.sp.clamp(11.5, 14.0),
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF10B981),
                ),
              ),

              SizedBox(width: 8.w),

              /// "Live" Badge (Vibrant green capsule)
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.5.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'Live',
                  style: GoogleFonts.roboto(
                    fontSize: 11.sp.clamp(10.0, 12.5),
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),

              const Spacer(),

              /// Rating: "4.9 ⭐⭐"
              Row(
                children: [
                  Text(
                    _rating.toStringAsFixed(1),
                    style: GoogleFonts.roboto(
                      fontSize: 13.sp.clamp(12.0, 14.5),
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF475569),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Icon(
                    Icons.star_rounded,
                    color: const Color(0xFFF59E0B),
                    size: 16.sp,
                  ),
                  Icon(
                    Icons.star_rounded,
                    color: const Color(0xFFF59E0B),
                    size: 16.sp,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 5. Bottom Sheet Card with "Message Driver" & "View order Summary"
  Widget _buildBottomSheetCard(double bottomPadding) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 10.h,
        bottom: bottomPadding > 0 ? bottomPadding + 8.h : 20.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Top Drag Handle
          Container(
            width: 38.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          SizedBox(height: 16.h),

          /// Two Action Buttons
          Row(
            children: [
              /// Left Button: "Message Driver" (Solid deep purple)
              Expanded(
                child: SizedBox(
                  height: 46.h.clamp(42.0, 50.0),
                  child: ElevatedButton(
                    onPressed: _onMessageDriver,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E0A66),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      'Message Driver',
                      style: GoogleFonts.roboto(
                        fontSize: 13.5.sp.clamp(12.0, 15.0),
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              /// Right Button: "View order Summary" (Outline with deep purple border)
              Expanded(
                child: SizedBox(
                  height: 46.h.clamp(42.0, 50.0),
                  child: OutlinedButton(
                    onPressed: _onViewOrderSummary,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                        color: Color(0xFF2E0A66),
                        width: 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      'View order Summary',
                      style: GoogleFonts.roboto(
                        fontSize: 12.5.sp.clamp(11.0, 14.5),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2E0A66),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
