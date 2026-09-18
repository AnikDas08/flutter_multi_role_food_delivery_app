import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/nav_bar_controller.dart';

class MainNavBarScreen extends StatelessWidget {
  const MainNavBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<NavBarController>()
        ? Get.find<NavBarController>()
        : Get.put(NavBarController());

    controller.refreshRole();

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Obx(() {
        final currentIndex = controller.currentIndex.value;
        final screens = controller.screens;
        final navItems = controller.navItems;

        // Fallback safety if role changes and index is out of range
        final safeIndex =
            currentIndex < screens.length ? currentIndex : 0;

        return Scaffold(
          backgroundColor: Colors.white,
          body: IndexedStack(
            index: safeIndex,
            children: screens,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: const Border(
                top: BorderSide(
                  color: Color(0xFFF3F4F6),
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            padding: EdgeInsets.only(
              top: 10.h,
              bottom: bottomPadding > 0 ? bottomPadding : 12.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(navItems.length, (index) {
                final item = navItems[index];
                final isSelected = safeIndex == index;

                return Expanded(
                  child: InkWell(
                    onTap: () => controller.changeIndex(index),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            item.iconPath,
                            width: 25.w,
                            height: 25.h,
                            fit: BoxFit.contain,
                            colorFilter: ColorFilter.mode(
                              isSelected
                                  ? const Color(0xFF341280)
                                  : const Color(0xFF6B7280),
                              BlendMode.srcIn,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              item.label,
                              maxLines: 1,
                              style: GoogleFonts.roboto(
                                fontSize: 11.sp,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSelected
                                    ? const Color(0xFF341280)
                                    : const Color(0xFF6B7280),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      }),
    );
  }
}
