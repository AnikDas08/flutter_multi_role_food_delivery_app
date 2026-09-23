import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/app_snackbar.dart';
import '../../data/model/notification_model.dart';

class NotificationsController extends GetxController {
  final List<NotificationModel> notifications = [];
  bool isLoading = false;

  static NotificationsController get instance =>
      Get.find<NotificationsController>();

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  @override
  void onInit() {
    super.onInit();
    populateDefaults();
  }

  void populateDefaults() {
    if (notifications.isEmpty) {
      notifications.addAll([
        NotificationModel(
          id: '1',
          title: 'Order Delivered Successfully',
          message:
              'Your order #3921 from Burger House has arrived at your doorstep. Enjoy your meal!',
          linkId: '3921',
          type: 'order',
          role: 'customer',
          receiver: 'user',
          v: 0,
          createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
          updatedAt: DateTime.now().subtract(const Duration(minutes: 15)),
          isRead: false,
        ),
        NotificationModel(
          id: '2',
          title: '25% Flash Discount Today!',
          message:
              'Special offer: Enjoy 25% off on all Plomobites orders today! Use coupon code FLASH25 at checkout.',
          linkId: 'promo',
          type: 'promo',
          role: 'customer',
          receiver: 'user',
          v: 0,
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
          isRead: false,
        ),
        NotificationModel(
          id: '3',
          title: 'Wallet Top-up Successful',
          message:
              'Your deposit of \$50.00 via Mandiri Bank Transfer was verified and credited to your balance.',
          linkId: 'wallet',
          type: 'wallet',
          role: 'customer',
          receiver: 'user',
          v: 0,
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
          isRead: false,
        ),
        NotificationModel(
          id: '4',
          title: 'Driver Lucas Is On The Way',
          message:
              'Your delivery partner Lucas Nathan picked up your order and is heading towards your location.',
          linkId: '3921',
          type: 'delivery',
          role: 'customer',
          receiver: 'user',
          v: 0,
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
          isRead: true,
        ),
        NotificationModel(
          id: '5',
          title: 'Welcome to PlomoGo!',
          message:
              'Discover local restaurants, fresh groceries, and fast contactless deliveries in your neighborhood.',
          linkId: 'welcome',
          type: 'system',
          role: 'customer',
          receiver: 'user',
          v: 0,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          updatedAt: DateTime.now().subtract(const Duration(days: 1)),
          isRead: true,
        ),
      ]);
    }
  }

  void markAllAsRead() {
    for (int i = 0; i < notifications.length; i++) {
      notifications[i] = notifications[i].copyWith(isRead: true);
    }
    update();
    AppSnackbar.success(
      title: 'Notifications',
      message: 'All notifications marked as read',
    );
  }

  void markAsRead(int index) {
    if (index >= 0 && index < notifications.length) {
      if (!notifications[index].isRead) {
        notifications[index] = notifications[index].copyWith(isRead: true);
        update();
      }
    }
  }
}
