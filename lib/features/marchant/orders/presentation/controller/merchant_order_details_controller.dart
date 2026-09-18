import 'package:get/get.dart';
import '../../../../../../config/route/app_routes.dart';
import '../../../../../../utils/app_snackbar.dart';

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
    AppSnackbar.info(
      title: "Message Driver",
      message: "Opening chat with driver Alex Rivera",
    );
  }

  void messageCustomer() {
    AppSnackbar.info(
      title: "Message Customer",
      message: "Opening chat with customer Sarah Johnson",
    );
  }
}
