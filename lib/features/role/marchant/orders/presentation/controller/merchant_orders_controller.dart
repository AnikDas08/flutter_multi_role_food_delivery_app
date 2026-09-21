import 'package:get/get.dart';
import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';
import 'package:flutter_code_structure/features/common/nav_bar/presentation/controller/nav_bar_controller.dart';

enum OrderStatusType {
  newOrder,
  inTransit,
  completed,
  assignDriver,
}

class MerchantOrderModel {
  final String orderId;
  final OrderStatusType statusType;
  final String statusLabel;
  final String customerName;
  final int itemCount;
  final String totalPrice;
  final String time;
  final String date;
  final String avatarUrl;

  const MerchantOrderModel({
    required this.orderId,
    required this.statusType,
    required this.statusLabel,
    required this.customerName,
    required this.itemCount,
    required this.totalPrice,
    required this.time,
    required this.date,
    required this.avatarUrl,
  });
}

class MerchantOrdersController extends GetxController {
  static MerchantOrdersController get instance =>
      Get.find<MerchantOrdersController>();

  final RxList<MerchantOrderModel> orders = <MerchantOrderModel>[
    const MerchantOrderModel(
      orderId: '#ORD-001',
      statusType: OrderStatusType.newOrder,
      statusLabel: 'New',
      customerName: 'John Doe',
      itemCount: 2,
      totalPrice: '\$89.99',
      time: '10:30 AM',
      date: 'Today',
      avatarUrl:
          'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150',
    ),
    const MerchantOrderModel(
      orderId: '#ORD-002',
      statusType: OrderStatusType.inTransit,
      statusLabel: 'In Transit',
      customerName: 'Sarah Smith',
      itemCount: 1,
      totalPrice: '\$45.50',
      time: '9:15 AM',
      date: 'Today',
      avatarUrl:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
    ),
    const MerchantOrderModel(
      orderId: '#ORD-003',
      statusType: OrderStatusType.completed,
      statusLabel: 'Completed',
      customerName: 'Mike Johnson',
      itemCount: 3,
      totalPrice: '\$156.75',
      time: '8:45 AM',
      date: 'Today',
      avatarUrl:
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150',
    ),
    const MerchantOrderModel(
      orderId: '#ORD-004',
      statusType: OrderStatusType.assignDriver,
      statusLabel: 'Assign Driver',
      customerName: 'Emma Wilson',
      itemCount: 1,
      totalPrice: '\$29.99',
      time: '7:20 AM',
      date: 'Today',
      avatarUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
    ),
  ].obs;

  void startProcessing(String orderId) {
    AppSnackbar.success(
      title: 'Order Processing',
      message: 'Started processing order $orderId',
    );
  }

  void assignDriver(String orderId) {
    if (Get.isRegistered<NavBarController>()) {
      NavBarController.instance.changeIndex(3);
    } else {
      Get.toNamed(AppRoutes.merchantDrivers);
    }
  }
}
