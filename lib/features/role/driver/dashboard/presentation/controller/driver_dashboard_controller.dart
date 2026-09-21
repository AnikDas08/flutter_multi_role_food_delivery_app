import 'package:get/get.dart';
import 'package:flutter_code_structure/services/storage/storage_services.dart';

class DriverDashboardController extends GetxController {
  static DriverDashboardController get instance =>
      Get.find<DriverDashboardController>();

  final RxString driverName = 'Sarah'.obs;
  final RxString selectedTimeRange = 'Last 7 Days'.obs;

  @override
  void onInit() {
    super.onInit();
    if (LocalStorage.myName.isNotEmpty) {
      driverName.value = LocalStorage.myName;
    }
  }

  void setTimeRange(String range) {
    selectedTimeRange.value = range;
  }
}
