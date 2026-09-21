import 'package:flutter_code_structure/utils/app_snackbar.dart';
import 'package:get/get.dart';

enum DriverOrderStatus {
  newOrder,
  inTransit,
  completed,
}

class DriverOrderItem {
  final String id;
  final String orderNumber;
  final String customerName;
  final String customerAvatar;
  final int itemCount;
  final double totalAmount;
  final Rx<DriverOrderStatus> status;
  final String time;
  final String date;

  DriverOrderItem({
    required this.id,
    required this.orderNumber,
    required this.customerName,
    required this.customerAvatar,
    required this.itemCount,
    required this.totalAmount,
    required DriverOrderStatus status,
    required this.time,
    required this.date,
  }) : status = status.obs;
}

class DriverOrdersController extends GetxController {
  static DriverOrdersController get instance =>
      Get.find<DriverOrdersController>();

  final RxList<DriverOrderItem> orders = <DriverOrderItem>[
    DriverOrderItem(
      id: '1',
      orderNumber: '#ORD-001',
      customerName: 'John Doe',
      customerAvatar:
          'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=200',
      itemCount: 2,
      totalAmount: 89.99,
      status: DriverOrderStatus.newOrder,
      time: '10:30 AM',
      date: 'Today',
    ),
    DriverOrderItem(
      id: '2',
      orderNumber: '#ORD-002',
      customerName: 'Sarah Smith',
      customerAvatar:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
      itemCount: 1,
      totalAmount: 45.50,
      status: DriverOrderStatus.inTransit,
      time: '9:15 AM',
      date: 'Today',
    ),
    DriverOrderItem(
      id: '3',
      orderNumber: '#ORD-003',
      customerName: 'Mike Johnson',
      customerAvatar:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200',
      itemCount: 3,
      totalAmount: 156.75,
      status: DriverOrderStatus.completed,
      time: '8:45 AM',
      date: 'Today',
    ),
    DriverOrderItem(
      id: '4',
      orderNumber: '#ORD-004',
      customerName: 'Mike Johnson',
      customerAvatar:
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
      itemCount: 3,
      totalAmount: 156.75,
      status: DriverOrderStatus.completed,
      time: '8:45 AM',
      date: 'Today',
    ),
  ].obs;

  void handleAction(DriverOrderItem order) {
    if (order.status.value == DriverOrderStatus.newOrder) {
      order.status.value = DriverOrderStatus.inTransit;
      AppSnackbar.success(
        title: 'Started Processing',
        message: 'Order ${order.orderNumber} is now picked up / in transit.',
      );
    } else if (order.status.value == DriverOrderStatus.inTransit) {
      order.status.value = DriverOrderStatus.completed;
      AppSnackbar.success(
        title: 'Order Completed',
        message: 'Order ${order.orderNumber} has been successfully delivered.',
      );
    } else {
      AppSnackbar.success(
        title: 'Order Completed',
        message: 'Order ${order.orderNumber} is already completed.',
      );
    }
  }
}
