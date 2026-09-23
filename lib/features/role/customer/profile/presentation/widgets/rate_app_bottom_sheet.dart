import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';

void showRateAppBottomSheet(BuildContext context) {
  HapticFeedback.lightImpact();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (modalContext) => const RateAppBottomSheet(),
  );
}

class RateAppBottomSheet extends StatelessWidget {
  const RateAppBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          /// Top accent magenta gradient bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 4.5.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFE879F9),
                    Color(0xFFD946EF),
                    Color(0xFFC026D3),
                    Color(0xFFE879F9),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 12.h),

                /// Centered Emoji Graphic with Bubbles
                SizedBox(
                  width: 96.w,
                  height: 96.w,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      /// Main soft purple circle
                      Container(
                        width: 76.w,
                        height: 76.w,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF3E8FF),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '🙂',
                            style: TextStyle(fontSize: 36.sp),
                          ),
                        ),
                      ),

                      /// Pink bubble top right
                      Positioned(
                        top: 4.h,
                        right: 8.w,
                        child: Container(
                          width: 15.w,
                          height: 15.w,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF472B6),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),

                      /// Lavender bubble bottom left
                      Positioned(
                        bottom: 12.h,
                        left: 4.w,
                        child: Container(
                          width: 14.w,
                          height: 14.w,
                          decoration: const BoxDecoration(
                            color: Color(0xFFC4B5FD),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                /// Title: Enjoying our app?
                Text(
                  'Enjoying our app?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 21.sp.clamp(19.0, 24.0),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E293B),
                  ),
                ),

                SizedBox(height: 8.h),

                /// Subtitle
                Text(
                  'It only takes a few seconds to share\nyour feedback.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 13.5.sp.clamp(12.5, 15.0),
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF64748B),
                    height: 1.45,
                  ),
                ),

                SizedBox(height: 28.h),

                /// Primary Button: Yes, I love it 😍
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                      Get.toNamed(
                        AppRoutes.shareReview,
                        arguments: {
                          'fromRateApp': true,
                          'showOrderDelivered': false,
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E0A66),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                    ),
                    child: Text(
                      'Yes, I love it 😍',
                      style: GoogleFonts.roboto(
                        fontSize: 15.sp.clamp(14.0, 17.0),
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 14.h),

                /// Secondary Button: Not really 🙃
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                      AppSnackbar.info(
                        title: 'Thank You',
                        message: "Thank you for your feedback! We're constantly working to improve your experience.",
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF3E8FF),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                    ),
                    child: Text(
                      'Not really 🙃',
                      style: GoogleFonts.roboto(
                        fontSize: 15.sp.clamp(14.0, 17.0),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF4C1D95),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 18.h),

                /// Tertiary Button: MAYBE LATER
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text(
                      'MAYBE LATER',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 12.5.sp.clamp(11.5, 14.0),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF64748B),
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: bottomPadding > 0 ? bottomPadding : 10.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
