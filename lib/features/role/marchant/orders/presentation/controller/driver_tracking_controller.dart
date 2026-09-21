import 'package:get/get.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';

class DriverTrackingController extends GetxController {
  static DriverTrackingController get instance =>
      Get.find<DriverTrackingController>();

  final String orderNumber = '#DR-1847';
  final String statusTitle = 'Driver in Transit.';
  final String statusSubtitle =
      'Driver is heading your way. Estimated\narrival: 5 min';

  void messageDriver() {
    AppSnackbar.info(
      title: "Message Driver",
      message: "Opening chat with driver Alex Rivera",
    );
  }
}
