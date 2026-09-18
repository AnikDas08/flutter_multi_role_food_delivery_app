import 'package:get/get.dart';
import '../../../../../../config/route/app_routes.dart';

class CodOrderItem {
  final String customerName;
  final String orderNumber;
  final int itemCount;
  final String time;
  final String amount;
  final String date;
  final String? avatarUrl;
  final String initials;

  const CodOrderItem({
    required this.customerName,
    required this.orderNumber,
    required this.itemCount,
    required this.time,
    required this.amount,
    required this.date,
    this.avatarUrl,
    required this.initials,
  });
}

class CodLiabilityController extends GetxController {
  static CodLiabilityController get instance =>
      Get.find<CodLiabilityController>();

  final String totalLiability = '\$67.00';

  final List<CodOrderItem> orders = const [
    CodOrderItem(
      customerName: 'John Doe',
      orderNumber: '#12847',
      itemCount: 2,
      time: '10:30 AM',
      amount: '\$25.00',
      date: 'Today',
      initials: 'JD',
    ),
    CodOrderItem(
      customerName: 'Sarah Smith',
      orderNumber: '#12842',
      itemCount: 1,
      time: '9:15 AM',
      amount: '\$18.50',
      date: 'Today',
      avatarUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
      initials: 'SS',
    ),
    CodOrderItem(
      customerName: 'Maria Santos',
      orderNumber: '#12839',
      itemCount: 3,
      time: '8:45 AM',
      amount: '\$23.50',
      date: 'Today',
      avatarUrl:
          'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150',
      initials: 'MS',
    ),
  ];

  void requestSettlement() {
    Get.toNamed(AppRoutes.requestSettlement);
  }
}
