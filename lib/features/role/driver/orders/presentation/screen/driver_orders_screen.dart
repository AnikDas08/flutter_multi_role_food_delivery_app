import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/driver_orders_controller.dart';
import '../widgets/driver_order_card.dart';

class DriverOrdersScreen extends StatelessWidget {
  const DriverOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<DriverOrdersController>()
        ? Get.find<DriverOrdersController>()
        : Get.put(DriverOrdersController());

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFD),
      body: SafeArea(
        child: Column(
          children: [
            /// 1. Top Header Title: "Orders"
            Padding(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              child: Center(
                child: Text(
                  'Orders',
                  style: GoogleFonts.roboto(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2E0A66),
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ),

            /// 2. Orders Scrollable List
            Expanded(
              child: Obx(
                () => ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  itemCount: controller.orders.length,
                  separatorBuilder: (_, __) => SizedBox(height: 14.h),
                  itemBuilder: (context, index) {
                    final order = controller.orders[index];
                    return DriverOrderCard(
                      controller: controller,
                      order: order,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
