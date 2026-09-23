import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../component/other_widgets/no_data.dart';
import '../../../../utils/app_snackbar.dart';
import '../controller/notifications_controller.dart';
import '../../data/model/notification_model.dart';
import '../widgets/notification_item.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<NotificationModel> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    if (Get.isRegistered<NotificationsController>()) {
      final ctrl = Get.find<NotificationsController>();
      if (ctrl.notifications.isNotEmpty) {
        _notifications.addAll(ctrl.notifications);
        return;
      }
    }

    _notifications.addAll([
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

  void _markAllAsRead() {
    HapticFeedback.lightImpact();
    setState(() {
      for (int i = 0; i < _notifications.length; i++) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    });

    if (Get.isRegistered<NotificationsController>()) {
      Get.find<NotificationsController>().markAllAsRead();
    } else {
      AppSnackbar.success(
        title: 'Notifications',
        message: 'All notifications marked as read',
      );
    }
  }

  void _markAsRead(int index) {
    if (index >= 0 && index < _notifications.length) {
      if (!_notifications[index].isRead) {
        HapticFeedback.lightImpact();
        setState(() {
          _notifications[index] = _notifications[index].copyWith(isRead: true);
        });

        if (Get.isRegistered<NotificationsController>()) {
          Get.find<NotificationsController>().markAsRead(index);
        }
      }
    }
  }

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// 1. Top Bar: Back Button, Centered Title, Balanced Spacer
            _buildTopBar(context),

            /// 2. Read All action bar on top of the list
            _buildReadAllBar(),

            /// 3. Notification List
            Expanded(
              child: _buildList(),
            ),
          ],
        ),
      ),
    );
  }

  /// App Bar: Circular Back Button on left, Centered "Notifications" Title, Balanced spacer
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Row(
        children: [
          /// Circular Back Button with reliable Material + InkWell tap handling
          Material(
            color: Colors.white,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  Get.back();
                }
              },
              customBorder: const CircleBorder(),
              child: Container(
                width: 44.w.clamp(40.0, 48.0),
                height: 44.w.clamp(40.0, 48.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16.sp.clamp(14.0, 18.0),
                    color: const Color(0xFF2E0A66),
                  ),
                ),
              ),
            ),
          ),

          /// Centered Title: "Notifications"
          Expanded(
            child: Center(
              child: Text(
                'Notifications',
                style: GoogleFonts.roboto(
                  fontSize: 18.sp.clamp(16.0, 22.0),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2E0A66),
                ),
              ),
            ),
          ),

          /// Balanced spacer to keep title perfectly centered
          SizedBox(width: 44.w.clamp(40.0, 48.0)),
        ],
      ),
    );
  }

  /// "Read all" section right on top of the list
  Widget _buildReadAllBar() {
    if (_notifications.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Left: Label & Unread Badge
          Row(
            children: [
              Text(
                'Recent',
                style: GoogleFonts.roboto(
                  fontSize: 15.sp.clamp(14.0, 17.0),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E293B),
                ),
              ),
              if (_unreadCount > 0) ...[
                SizedBox(width: 8.w),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE9FE),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '$_unreadCount new',
                    style: GoogleFonts.roboto(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF7C3AED),
                    ),
                  ),
                ),
              ],
            ],
          ),

          /// Right: "Read all" Button with Material + InkWell for guaranteed tap response
          Material(
            color: const Color(0xFFFAF5FF),
            borderRadius: BorderRadius.circular(10.r),
            child: InkWell(
              onTap: _markAllAsRead,
              borderRadius: BorderRadius.circular(10.r),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.done_all_rounded,
                      size: 16.sp.clamp(14.0, 18.0),
                      color: const Color(0xFF7C3AED),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      'Read all',
                      style: GoogleFonts.roboto(
                        fontSize: 13.sp.clamp(12.0, 14.5),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF7C3AED),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Notification List
  Widget _buildList() {
    if (_notifications.isEmpty) {
      return const Center(child: NoData());
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      itemCount: _notifications.length,
      itemBuilder: (_, index) {
        final item = _notifications[index];
        return NotificationItem(
          item: item,
          onTap: () => _markAsRead(index),
        );
      },
    );
  }
}
