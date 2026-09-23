import 'package:get/get.dart';
import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';

enum OrderStepStatus { inProcess, cooking, readyForPickup }

class FoodOrderItemModel {
  final String title;
  final int quantity;
  final String price;
  final String imageUrl;

  const FoodOrderItemModel({
    required this.title,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });
}

class MerchantOrderDetailsController extends GetxController {
  static MerchantOrderDetailsController get instance =>
      Get.find<MerchantOrderDetailsController>();

  final Rx<OrderStepStatus> currentStatus = OrderStepStatus.cooking.obs;
  final String orderId = '#48943';

  final List<FoodOrderItemModel> items = const [
    FoodOrderItemModel(
      title: 'Big mac Combo',
      quantity: 2,
      price: '\$18.98',
      imageUrl:
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=200',
    ),
    FoodOrderItemModel(
      title: 'Big mac Combo',
      quantity: 2,
      price: '\$18.98',
      imageUrl:
          'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?w=200',
    ),
    FoodOrderItemModel(
      title: 'Big mac Combo',
      quantity: 2,
      price: '\$18.98',
      imageUrl:
          'https://images.unsplash.com/photo-1550547660-d9450f859349?w=200',
    ),
    FoodOrderItemModel(
      title: 'Big mac Combo',
      quantity: 2,
      price: '\$18.98',
      imageUrl:
          'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=200',
    ),
  ];

  final String deliveryFee = '\$0.00';
  final String totalAmount = '\$27.95';

  void markReadyForPickup() {
    currentStatus.value = OrderStepStatus.readyForPickup;
    AppSnackbar.success(
      title: 'Order Updated',
      message: 'Order $orderId marked as Ready for Pickup',
    );
  }

  void seeDriverLocation() {
    Get.toNamed(AppRoutes.driverTracking);
  }

  void messageDriver() {
    Get.toNamed(
      AppRoutes.message,
      arguments: {
        'orderId': orderId.replaceAll('#', ''),
        'restaurant': 'Alex Rivera (Driver)',
        'name': 'Alex Rivera',
        'status': 'Assigned Driver',
        'avatar':
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200',
        'isMerchant': false,
        'hideShare': true,
        'showShare': false,
        'role': 'Driver',
      },
    );
  }

  void messageCustomer() {
    Get.toNamed(
      AppRoutes.message,
      arguments: {
        'orderId': orderId.replaceAll('#', ''),
        'restaurant': 'Sarah Johnson (Customer)',
        'name': 'Sarah Johnson',
        'status': 'Customer',
        'avatar':
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
        'isMerchant': false,
        'hideShare': true,
        'showShare': false,
        'role': 'Customer',
      },
    );
  }
}
