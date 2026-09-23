import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';
import 'package:get/get.dart';

class DriverOrderDetailsController extends GetxController {
  static DriverOrderDetailsController get instance =>
      Get.find<DriverOrderDetailsController>();

  final RxInt currentStep = 2.obs; // 0: Accepted, 1: Picked Up, 2: Arrived, 3: Delivered

  void advanceStatus() {
    if (currentStep.value < 3) {
      currentStep.value++;
      AppSnackbar.success(
        title: 'Status Updated',
        message: 'Order progress updated to next step.',
      );
    } else {
      AppSnackbar.success(
        title: 'Order Delivered',
        message: 'This order is already marked as delivered.',
      );
    }
  }

  void openMessage(String recipient) {
    Get.toNamed(
      AppRoutes.message,
      arguments: {
        'orderId': '12345',
        'restaurant': recipient,
        'status': 'Order in Progress',
        'isMerchant': false,
      },
    );
  }

  void startNavigation(String destination) {
    AppSnackbar.success(
      title: 'Navigation',
      message: 'Starting navigation to $destination.',
    );
  }
}
