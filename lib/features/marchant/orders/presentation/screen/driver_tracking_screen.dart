import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/driver_tracking_controller.dart';

class DriverTrackingScreen extends StatelessWidget {
  const DriverTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<DriverTrackingController>()
        ? Get.find<DriverTrackingController>()
        : Get.put(DriverTrackingController());

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF262626),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFF262626),
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 18,
            ),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Get.back();
              }
            },
          ),
          title: Text(
            'Incoming Driver for Order ${controller.orderNumber}',
            style: GoogleFonts.roboto(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        body: Stack(
          children: [
            /// 1. Full Map View (Top Section)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 270.h,
              child: Image.asset(
                'assets/images/driver_tracking_map.png',
                fit: BoxFit.fill,
                alignment: Alignment.center,
              ),
            ),

            /// 2. Floating Bottom Sheet Card
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  top: 10.h,
                  bottom: bottomPadding > 0 ? bottomPadding + 8.h : 22.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.r),
                  ),
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
                    /// Top Drag Handle Indicator
                    Container(
                      width: 38.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    /// Green Circular Check Badge
                    Container(
                      width: 68.w,
                      height: 68.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFF22C55E),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x3322C55E),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 40.sp,
                        ),
                      ),
                    ),

                    SizedBox(height: 18.h),

                    /// Status Title
                    Text(
                      controller.statusTitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E293B),
                        letterSpacing: -0.2,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    /// Status Subtitle
                    Text(
                      controller.statusSubtitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF475569),
                        height: 1.4,
                      ),
                    ),

                    SizedBox(height: 22.h),

                    /// Message Button
                    GestureDetector(
                      onTap: controller.messageDriver,
                      child: Container(
                        height: 50.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E0A66),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_rounded,
                              color: Colors.white,
                              size: 16.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Message',
                              style: GoogleFonts.roboto(
                                fontSize: 15.sp,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
