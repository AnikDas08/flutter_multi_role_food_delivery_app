import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_code_structure/config/route/app_routes.dart';

enum DriverWithdrawalMethod {
  bankAccount,
  office,
}

class DriverWithdrawFundsController extends GetxController {
  static DriverWithdrawFundsController get instance =>
      Get.find<DriverWithdrawFundsController>();

  final RxString availableBalance = '\$2,847'.obs;
  late final TextEditingController amountController;

  final List<String> quickChips = [
    '\$100',
    '\$250',
    '\$500',
    '\$1000',
    '\$1,250',
    '\$2,847',
  ];

  final RxInt selectedChipIndex = 5.obs; // Index 5 ($2,847) active as in screenshot
  final Rx<DriverWithdrawalMethod> selectedMethod =
      DriverWithdrawalMethod.bankAccount.obs;

  @override
  void onInit() {
    super.onInit();
    amountController = TextEditingController(text: '\$2,847.00 USD');
  }

  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }

  void selectChip(int index) {
    selectedChipIndex.value = index;
    final val = quickChips[index].replaceAll('\$', '').replaceAll(',', '');
    amountController.text = '\$$val.00 USD';
  }

  void selectMethod(DriverWithdrawalMethod method) {
    selectedMethod.value = method;
  }

  void onContinue() {
    final rawText = amountController.text.trim();
    final cleanStr = rawText
        .replaceAll('\$', '')
        .replaceAll('USD', '')
        .replaceAll(',', '')
        .trim();
    final parsed = double.tryParse(cleanStr) ?? 0.0;

    if (parsed <= 0) {
      Get.toNamed(
        AppRoutes.withdrawalNotPossible,
        arguments: {'amount': '\$0.00'},
      );
    } else {
      String formattedDisplay;
      if (parsed == parsed.roundToDouble()) {
        final intVal = parsed.toInt();
        final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
        final strWithCommas =
            '$intVal'.replaceAllMapped(reg, (Match m) => '${m[1]},');
        formattedDisplay = '\$$strWithCommas';
      } else {
        formattedDisplay = '\$${parsed.toStringAsFixed(2)}';
      }

      Get.toNamed(
        AppRoutes.confirmWithdrawal,
        arguments: {
          'amount': formattedDisplay,
          'method': selectedMethod.value,
        },
      );
    }
  }
}
