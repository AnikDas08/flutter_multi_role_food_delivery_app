import 'package:get/get.dart';
import '../../../../../../config/route/app_routes.dart';

enum PayoutMethod { bankTransfer, office }

class RequestSettlementController extends GetxController {
  static RequestSettlementController get instance =>
      Get.find<RequestSettlementController>();

  final Rx<PayoutMethod> selectedMethod = PayoutMethod.bankTransfer.obs;
  final String amount = '\$67.00';

  void setMethod(PayoutMethod method) {
    selectedMethod.value = method;
  }

  void submitPayoutRequest() {
    Get.toNamed(AppRoutes.settlementSuccess);
  }
}
