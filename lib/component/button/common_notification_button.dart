import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/utils/constants/app_icons.dart';

class CommonNotificationButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool hasNotification;
  final double? size;

  const CommonNotificationButton({
    super.key,
    this.onTap,
    this.hasNotification = true,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final buttonSize = size ?? 44.w;

    return GestureDetector(
      onTap: onTap ?? () => Get.toNamed(AppRoutes.notifications),
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              AppIcons.notificationIcon,
              width: 24.w,
              height: 24.h,
              fit: BoxFit.contain,
              colorFilter: const ColorFilter.mode(
                Color(0xFF2E0A66),
                BlendMode.srcIn,
              ),
            ),
            if (hasNotification)
              Positioned(
                top: 10.h,
                right: 11.w,
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
