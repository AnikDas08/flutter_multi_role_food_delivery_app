import 'package:get/get.dart';
import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';

class DriverTrackingController extends GetxController {
  static DriverTrackingController get instance =>
      Get.find<DriverTrackingController>();

  final String orderNumber = '#DR-1847';
  final String statusTitle = 'Driver in Transit.';
  final String statusSubtitle =
      'Driver is heading your way. Estimated\narrival: 5 min';

  void messageDriver() {
    Get.toNamed(
      AppRoutes.message,
      arguments: {
        'orderId': orderNumber.replaceAll('#', '').replaceAll('DR-', ''),
        'restaurant': 'Alex Rivera (Driver)',
        'name': 'Alex Rivera',
        'status': 'Driver in Transit',
        'avatar':
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200',
        'isMerchant': false,
        'hideShare': true,
        'showShare': false,
        'role': 'Driver',
      },
    );
  }
}
