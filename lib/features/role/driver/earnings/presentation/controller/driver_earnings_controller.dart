import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:get/get.dart';

class DriverEarningsController extends GetxController {
  static DriverEarningsController get instance =>
      Get.find<DriverEarningsController>();

  final RxString totalBalance = '\$2,847'.obs;
  final RxString availableWithdrawal = '\$2,847'.obs;
  final RxString codLiability = '\$67.00'.obs;
  final RxString earnedThisMonth = '\$67.00'.obs;
  final RxString withdrawnThisMonth = '\$850'.obs;
  final RxString remainingThisMonth = '\$1,300'.obs;

  void onWithdrawFunds() {
    Get.toNamed(AppRoutes.driverWithdrawFunds);
  }

  void onCodLiabilityTap() {
    Get.toNamed(
      AppRoutes.driverRemitCodLiability,
      arguments: {'amount': codLiability.value},
    );
  }
}
