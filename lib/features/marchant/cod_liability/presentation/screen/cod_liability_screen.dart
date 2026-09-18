import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/component/app_bar/common_app_bar.dart';
import 'package:flutter_code_structure/component/button/common_button.dart';
import 'package:flutter_code_structure/utils/constants/app_colors.dart';
import 'package:flutter_code_structure/utils/extensions/extension.dart';
import '../controller/cod_liability_controller.dart';

class CodLiabilityScreen extends StatelessWidget {
  const CodLiabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<CodLiabilityController>()
        ? Get.find<CodLiabilityController>()
        : Get.put(CodLiabilityController());

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CommonAppBar(
        title: 'COD Liability',
        titleSize: 18,
        titleWeight: FontWeight.w600,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    16.height,

                    /// Large Amount
                    Text(
                      controller.totalLiability,
                      style: GoogleFonts.roboto(
                        fontSize: 42.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                        letterSpacing: -1,
                      ),
                    ),

                    SizedBox(height: 6.h),

                    /// Subtitle
                    Text(
                      'Exclude delivery fees',
                      style: GoogleFonts.roboto(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF4B5563),
                      ),
                    ),

                    20.height,

                    /// Pending Settlement Banner
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE9FE),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: Text(
                          'Pending settlement from COD orders',
                          style: GoogleFonts.roboto(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF374151),
                          ),
                        ),
                      ),
                    ),

                    24.height,

                    /// Orders List
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.orders.length,
                      separatorBuilder: (_, __) => SizedBox(height: 18.h),
                      itemBuilder: (context, index) {
                        final order = controller.orders[index];
                        return _buildOrderItem(order);
                      },
                    ),

                    24.height,
                  ],
                ),
              ),
            ),

            /// Bottom Total and Action Button
            Container(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 16.h,
                bottom: bottomPadding > 0 ? bottomPadding + 8.h : 20.h,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF111827),
                        ),
                      ),
                      Text(
                        controller.totalLiability,
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF111827),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  CommonButton(
                    titleText: 'Request for Settlement',
                    buttonColor: const Color(0xFF2E0A66),
                    borderColor: const Color(0xFF2E0A66),
                    buttonRadius: 14,
                    buttonHeight: 50,
                    titleSize: 15,
                    titleWeight: FontWeight.w600,
                    onTap: controller.requestSettlement,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(CodOrderItem order) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// User Avatar / Initials
        Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFE5E7EB),
              width: 1.5,
            ),
          ),
          child: ClipOval(
            child: order.avatarUrl != null && order.avatarUrl!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: order.avatarUrl!,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => _buildInitialsBadge(order.initials),
                    errorWidget: (_, __, ___) =>
                        _buildInitialsBadge(order.initials),
                  )
                : _buildInitialsBadge(order.initials),
          ),
        ),

        SizedBox(width: 14.w),

        /// Order Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.customerName,
                style: GoogleFonts.roboto(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF111827),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Order ${order.orderNumber}',
                style: GoogleFonts.roboto(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF6B7280),
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                '${order.itemCount} item via COD',
                style: GoogleFonts.roboto(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),

        /// Amount & Timestamp
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              order.time,
              style: GoogleFonts.roboto(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF6B7280),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              order.amount,
              style: GoogleFonts.roboto(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF111827),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              order.date,
              style: GoogleFonts.roboto(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInitialsBadge(String initials) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E293B),
            Color(0xFF0F172A),
          ],
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: GoogleFonts.roboto(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
