import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:flutter_code_structure/component/text/common_text.dart';
import 'package:flutter_code_structure/utils/constants/app_colors.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.showBackButton = true,
    this.onBackTap,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor = Colors.white,
    this.elevation = 0,
    this.leadingWidth,
    this.titleSize = 24,
    this.titleWeight = FontWeight.w600,
    this.titleColor = const Color(0xFF111827),
    this.appBarHeight,
  });

  final String? title;
  final Widget? titleWidget;
  final bool showBackButton;
  final VoidCallback? onBackTap;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color backgroundColor;
  final double elevation;
  final double? leadingWidth;
  final double titleSize;
  final FontWeight titleWeight;
  final Color titleColor;
  final double? appBarHeight;

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight ?? 56.h);

  @override
  Widget build(BuildContext context) {
    Widget? leadingWidget = leading;

    if (leadingWidget == null && showBackButton) {
      leadingWidget = Padding(
        padding: EdgeInsets.only(left: 16.w),
        child: Center(
          child: GestureDetector(
            onTap: onBackTap ??
                () {
                  if (Navigator.canPop(context)) {
                    Get.back();
                  }
                },
            child: Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                  width: 1.2,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.primaryColor,
                  size: 16,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return AppBar(
      backgroundColor: backgroundColor,
      elevation: elevation,
      scrolledUnderElevation: 0,
      centerTitle: centerTitle,
      leadingWidth: leadingWidget != null ? (leadingWidth ?? 54.w) : 0,
      leading: leadingWidget,
      actions: actions,
      title: titleWidget ??
          (title != null && title!.isNotEmpty
              ? CommonText(
                  text: title!,
                  fontSize: titleSize,
                  fontWeight: titleWeight,
                  color: titleColor,
                )
              : null),
    );
  }
}
