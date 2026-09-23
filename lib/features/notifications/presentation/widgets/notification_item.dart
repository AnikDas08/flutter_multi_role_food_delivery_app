import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/model/notification_model.dart';
import '../../../../../utils/extensions/extension.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel item;
  final VoidCallback? onTap;

  const NotificationItem({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final (iconData, iconColor, bgColor) = _getIconProperties(item.type);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: item.isRead ? Colors.white : const Color(0xFFFAF8FF),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: item.isRead
              ? const Color(0xFFF1F5F9)
              : const Color(0xFFE9D5FF),
          width: item.isRead ? 1.0 : 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: item.isRead ? 0.02 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap?.call();
          },
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 1. Notification Themed Icon
                Container(
                  width: 44.w.clamp(40.0, 48.0),
                  height: 44.w.clamp(40.0, 48.0),
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      iconData,
                      color: iconColor,
                      size: 22.sp.clamp(20.0, 24.0),
                    ),
                  ),
                ),

                SizedBox(width: 12.w),

                /// 2. Notification Content: Title, Message, Time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Title & Time Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              item.title.isNotEmpty ? item.title : item.type,
                              style: GoogleFonts.roboto(
                                fontSize: 14.5.sp.clamp(13.5, 16.5),
                                fontWeight: item.isRead
                                    ? FontWeight.w600
                                    : FontWeight.w700,
                                color: const Color(0xFF1E293B),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            _formatTime(item.createdAt),
                            style: GoogleFonts.roboto(
                              fontSize: 11.5.sp.clamp(10.5, 13.0),
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 5.h),

                      /// Message
                      Text(
                        item.message,
                        style: GoogleFonts.roboto(
                          fontSize: 13.sp.clamp(12.0, 14.5),
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF64748B),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),

                /// 3. Unread Purple Dot Indicator
                if (!item.isRead) ...[
                  SizedBox(width: 8.w),
                  Padding(
                    padding: EdgeInsets.only(top: 6.h),
                    child: Container(
                      width: 8.w.clamp(7.0, 9.0),
                      height: 8.w.clamp(7.0, 9.0),
                      decoration: const BoxDecoration(
                        color: Color(0xFF7C3AED),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Format notification relative time
  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return date.checkTime;
    }
  }

  /// Determine icon, color and background based on notification type
  (IconData, Color, Color) _getIconProperties(String type) {
    switch (type.toLowerCase()) {
      case 'order':
        return (
          Icons.lunch_dining_rounded,
          const Color(0xFFEA580C),
          const Color(0xFFFFEDD5),
        );
      case 'promo':
      case 'discount':
        return (
          Icons.local_offer_rounded,
          const Color(0xFFC026D3),
          const Color(0xFFFAE8FF),
        );
      case 'wallet':
      case 'payment':
        return (
          Icons.account_balance_wallet_rounded,
          const Color(0xFF16A34A),
          const Color(0xFFDCFCE7),
        );
      case 'delivery':
      case 'tracking':
        return (
          Icons.delivery_dining_rounded,
          const Color(0xFF7C3AED),
          const Color(0xFFEDE9FE),
        );
      default:
        return (
          Icons.notifications_active_rounded,
          const Color(0xFF2563EB),
          const Color(0xFFDBEAFE),
        );
    }
  }
}
