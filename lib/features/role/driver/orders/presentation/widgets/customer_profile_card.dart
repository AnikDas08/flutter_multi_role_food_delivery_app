import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/driver_order_details_controller.dart';
import '../controller/driver_orders_controller.dart';

class CustomerProfileCard extends StatelessWidget {
  final DriverOrderDetailsController controller;
  final DriverOrderItem? orderArg;

  const CustomerProfileCard({
    super.key,
    required this.controller,
    this.orderArg,
  });

  @override
  Widget build(BuildContext context) {
    final customerName = orderArg?.customerName ?? 'Sarah Johnson';
    final customerAvatar = orderArg?.customerAvatar ??
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200';

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          /// Top Row: Avatar with message badge, Name & Phone, Time & Rating
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Avatar with Teal "Message" Pill
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    width: 58.w,
                    height: 58.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFF1F5F9),
                        width: 1.5,
                      ),
                    ),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: customerAvatar,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Container(
                          color: const Color(0xFFEDE9FE),
                          child: Center(
                            child: Text(
                              customerName.isNotEmpty ? customerName[0] : 'S',
                              style: GoogleFonts.roboto(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF2E0A66),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  /// Teal "Message" pill badge
                  Positioned(
                    bottom: -6.h,
                    child: GestureDetector(
                      onTap: () => controller.openMessage(customerName),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF06B6D4),
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF06B6D4).withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.chat_bubble_rounded,
                              size: 9.sp,
                              color: Colors.white,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              'Message',
                              style: GoogleFonts.roboto(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(width: 14.w),

              /// Name and Phone Number
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customerName,
                      style: GoogleFonts.roboto(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      '+1 (555) 123-4567',
                      style: GoogleFonts.roboto(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),

              /// Time away and Star Rating
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time_filled_rounded,
                        size: 13.sp,
                        color: const Color(0xFF2E0A66),
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        '25 min away',
                        style: GoogleFonts.roboto(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2E0A66),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: 20.sp,
                        color: const Color(0xFFFBBF24),
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        '4.9',
                        style: GoogleFonts.roboto(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 24.h),

          /// Stepper Progress Bar (Order Accepted, Picked Up, Arrived, Delivered)
          _buildProgressStepper(),
        ],
      ),
    );
  }

  Widget _buildProgressStepper() {
    return Column(
      children: [
        Row(
          children: [
            /// Step 1: Order Accepted
            _buildStepCircle(isCompleted: true, isActive: false),
            Expanded(child: _buildStepLine(isActive: true)),

            /// Step 2: Picked Up
            _buildStepCircle(isCompleted: true, isActive: false),
            Expanded(child: _buildStepLine(isActive: true)),

            /// Step 3: Arrived
            _buildStepCircle(isCompleted: false, isActive: true),
            Expanded(child: _buildStepLine(isActive: false)),

            /// Step 4: Delivered
            _buildStepCircle(isCompleted: false, isActive: false),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStepLabel('Order Accepted', isCurrent: false),
            _buildStepLabel('Picked Up', isCurrent: false),
            _buildStepLabel('Arrived', isCurrent: true),
            _buildStepLabel('Delivered', isCurrent: false),
          ],
        ),
      ],
    );
  }

  Widget _buildStepCircle({
    required bool isCompleted,
    required bool isActive,
  }) {
    if (isCompleted) {
      return Container(
        width: 22.w,
        height: 22.w,
        decoration: const BoxDecoration(
          color: Color(0xFF9333EA),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            Icons.check_rounded,
            size: 14.sp,
            color: Colors.white,
          ),
        ),
      );
    } else if (isActive) {
      return Container(
        width: 22.w,
        height: 22.w,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFF9333EA),
            width: 2,
          ),
        ),
      );
    } else {
      return Container(
        width: 22.w,
        height: 22.w,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFC084FC),
            width: 2,
          ),
        ),
      );
    }
  }

  Widget _buildStepLine({required bool isActive}) {
    return Container(
      height: 3.h,
      color: isActive ? const Color(0xFF9333EA) : const Color(0xFFE2E8F0),
    );
  }

  Widget _buildStepLabel(String text, {required bool isCurrent}) {
    return SizedBox(
      width: 70.w,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.roboto(
          fontSize: 10.5.sp,
          fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w500,
          color: const Color(0xFF2E0A66),
        ),
      ),
    );
  }
}
