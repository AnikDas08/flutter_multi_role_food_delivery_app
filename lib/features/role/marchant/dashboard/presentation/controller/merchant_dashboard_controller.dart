import 'package:get/get.dart';
import 'package:flutter_code_structure/services/storage/storage_services.dart';

class OrderItemModel {
  final String orderNumber;
  final String customerName;
  final int itemCount;
  final String amount;
  final String status;
  final int badgeIndex;

  const OrderItemModel({
    required this.orderNumber,
    required this.customerName,
    required this.itemCount,
    required this.amount,
    required this.status,
    required this.badgeIndex,
  });
}

class MerchantDashboardController extends GetxController {
  static MerchantDashboardController get instance =>
      Get.find<MerchantDashboardController>();

  String get merchantName {
    final user = LocalStorage.user;
    if (user != null && user.name.isNotEmpty) {
      return user.name;
    }
    return 'Sarah';
  }

  final String totalRevenue = '\$24,567';
  final String totalBalance = '\$2,847';
  final String availableWithdrawal = '\$2,847';
  final String codLiability = '\$67.00';
  final String unpaidEarnings = '\$450.00';

  final List<OrderItemModel> recentOrders = const [
    OrderItemModel(
      orderNumber: '#12847',
      customerName: 'John Doe',
      itemCount: 2,
      amount: '\$156.00',
      status: 'Pending',
      badgeIndex: 1,
    ),
    OrderItemModel(
      orderNumber: '#12846',
      customerName: 'Sarah Smith',
      itemCount: 1,
      amount: '\$89.50',
      status: 'Processing',
      badgeIndex: 2,
    ),
    OrderItemModel(
      orderNumber: '#12845',
      customerName: 'Mike Johnson',
      itemCount: 3,
      amount: '\$234.75',
      status: 'Completed',
      badgeIndex: 3,
    ),
  ];
}
