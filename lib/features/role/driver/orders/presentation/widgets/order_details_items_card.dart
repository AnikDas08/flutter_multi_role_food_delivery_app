import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderDetailsItemsCard extends StatelessWidget {
  const OrderDetailsItemsCard({super.key});

  @override
  Widget build(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header Row: Purple info icon + Order Details Title
          Row(
            children: [
              Icon(
                Icons.info_rounded,
                size: 20.sp,
                color: const Color(0xFF9333EA),
              ),
              SizedBox(width: 8.w),
              Text(
                'Order Details',
                style: GoogleFonts.roboto(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          /// Order ID pill
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              'Order: DR-2024-1847',
              style: GoogleFonts.roboto(
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF64748B),
              ),
            ),
          ),

          SizedBox(height: 14.h),

          /// 4 Order Items (Item No:03 - Item No:06)
          _buildOrderItemRow('Item No:03', '2x', 'Big mac Combo', '\$18.98'),
          SizedBox(height: 10.h),
          _buildOrderItemRow('Item No:04', '2x', 'Big mac Combo', '\$18.98'),
          SizedBox(height: 10.h),
          _buildOrderItemRow('Item No:05', '2x', 'Big mac Combo', '\$18.98'),
          SizedBox(height: 10.h),
          _buildOrderItemRow('Item No:06', '2x', 'Big mac Combo', '\$18.98'),

          SizedBox(height: 14.h),

          /// Delivery Fee area
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delivery Fee area',
                style: GoogleFonts.roboto(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1E293B),
                ),
              ),
              Text(
                '\$7.95',
                style: GoogleFonts.roboto(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          /// Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total:',
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E293B),
                ),
              ),
              Text(
                '\$27.95',
                style: GoogleFonts.roboto(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemRow(
    String itemNo,
    String quantity,
    String name,
    String price,
  ) {
    return Row(
      children: [
        Text(
          itemNo,
          style: GoogleFonts.roboto(
            fontSize: 12.5.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1E293B),
          ),
        ),
        SizedBox(width: 8.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2FE),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Text(
            quantity,
            style: GoogleFonts.roboto(
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0284C7),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            name,
            style: GoogleFonts.roboto(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF64748B),
            ),
          ),
        ),
        Text(
          price,
          style: GoogleFonts.roboto(
            fontSize: 12.5.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }
}
