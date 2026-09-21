import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/component/app_bar/common_app_bar.dart';
import '../controller/driver_order_details_controller.dart';
import '../controller/driver_orders_controller.dart';
import '../widgets/customer_profile_card.dart';
import '../widgets/dropoff_card.dart';
import '../widgets/order_details_items_card.dart';
import '../widgets/payment_method_card.dart';
import '../widgets/pickup_card.dart';
import '../widgets/special_instruction_card.dart';

class DriverOrderDetailsScreen extends StatelessWidget {
  const DriverOrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<DriverOrderDetailsController>()
        ? Get.find<DriverOrderDetailsController>()
        : Get.put(DriverOrderDetailsController());

    final DriverOrderItem? orderArg =
        Get.arguments is DriverOrderItem ? Get.arguments as DriverOrderItem : null;
    final orderNumber = orderArg?.orderNumber ?? '#48943';

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFD),
      appBar: CommonAppBar(
        title: 'Order Details $orderNumber',
        titleColor: const Color(0xFF2E0A66),
        titleSize: 17.sp,
        titleWeight: FontWeight.w700,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 1. Customer Profile Card & Progress Stepper
                  CustomerProfileCard(
                    controller: controller,
                    orderArg: orderArg,
                  ),

                  SizedBox(height: 14.h),

                  /// 2. Pickup Card
                  PickupCard(controller: controller),

                  SizedBox(height: 14.h),

                  /// 3. Drop-off Card
                  DropOffCard(controller: controller),

                  SizedBox(height: 14.h),

                  /// 4. Order Details Card
                  const OrderDetailsItemsCard(),

                  SizedBox(height: 14.h),

                  /// 5. Especial Instruction Card
                  const SpecialInstructionCard(),

                  SizedBox(height: 14.h),

                  /// 6. Payment Method Card
                  const PaymentMethodCard(),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),

          /// 7. Bottom Action Button: "Mark as Ready for Pickup"
          _buildBottomActionButton(controller),
        ],
      ),
    );
  }

  Widget _buildBottomActionButton(DriverOrderDetailsController controller) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 20.h),
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
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 48.h,
          child: ElevatedButton(
            onPressed: () => controller.advanceStatus(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E0A66),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 18.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Mark as Ready for Pickup',
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
