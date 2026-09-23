import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';
import 'package:flutter_code_structure/utils/constants/app_images.dart';
import 'package:flutter_code_structure/utils/helpers/other_helper.dart';

/// Data class representing an in-chat message
class _ChatMessage {
  final String id;
  final String text;
  final String? imageUrl;
  final bool isFileImage;
  final String time;
  final bool isMe;
  final String? senderName;

  _ChatMessage({
    required this.id,
    required this.text,
    this.imageUrl,
    this.isFileImage = false,
    required this.time,
    required this.isMe,
    this.senderName,
  });
}

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  String _orderId = 'Order ID: #12345';
  String _restaurantName = 'The Burger king';
  String _orderStatus = 'Order in Progress';
  bool _isMerchant = true;

  /// Initial messages accurately matching the screenshot
  late final List<_ChatMessage> _messages;

  @override
  void initState() {
    super.initState();

    // Read route arguments or query parameters if provided
    final args = Get.arguments;
    if (args is Map) {
      if (args['orderId'] != null) _orderId = 'Order ID: #${args['orderId']}';
      if (args['restaurant'] != null) _restaurantName = args['restaurant'];
      if (args['status'] != null) _orderStatus = args['status'];
      if (args['isMerchant'] != null) {
        _isMerchant = args['isMerchant'] == true;
      }
    }
    final params = Get.parameters;
    if (params['orderId'] != null && params['orderId']!.isNotEmpty) {
      _orderId = 'Order ID: #${params['orderId']}';
    }
    if (params['name'] != null && params['name']!.isNotEmpty) {
      _restaurantName = params['name']!;
    }
    if (params['isMerchant'] != null) {
      _isMerchant = params['isMerchant'] == 'true';
    }

    // Additional check: if name or recipient indicates driver, hide share icon
    if (_restaurantName.toLowerCase().contains('driver') ||
        _restaurantName.toLowerCase().contains('rider')) {
      _isMerchant = false;
    }

    _messages = [
      _ChatMessage(
        id: 'msg_1',
        text: 'Hello! Jhon abraham',
        imageUrl: AppImages.chezBurgers,
        isFileImage: false,
        time: '09:25 AM',
        isMe: true,
      ),
      _ChatMessage(
        id: 'msg_2',
        text: 'Hello ! Jane How are you?',
        senderName: _restaurantName,
        time: '09:25 AM',
        isMe: false,
      ),
    ];
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onSendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    HapticFeedback.lightImpact();
    setState(() {
      _messages.add(
        _ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: text,
          time: _getFormattedCurrentTime(),
          isMe: true,
        ),
      );
    });

    _textController.clear();
    _scrollToBottom();
  }

  void _onSendImageMessage() {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Send Photo',
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2E0A66),
                  ),
                ),
                SizedBox(height: 16.h),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3E8FF),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      color: const Color(0xFF7A6B90),
                      size: 22.sp,
                    ),
                  ),
                  title: Text(
                    'Take a Photo',
                    style: GoogleFonts.roboto(
                      fontSize: 14.5.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2E0A66),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickAndSendPhoto(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3E8FF),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.photo_library_rounded,
                      color: const Color(0xFFD946EF),
                      size: 22.sp,
                    ),
                  ),
                  title: Text(
                    'Choose from Gallery',
                    style: GoogleFonts.roboto(
                      fontSize: 14.5.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2E0A66),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickAndSendPhoto(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickAndSendPhoto(ImageSource source) async {
    try {
      final pickedPath = await OtherHelper.pickImage(source: source);
      if (pickedPath != null && pickedPath.isNotEmpty) {
        HapticFeedback.lightImpact();
        setState(() {
          _messages.add(
            _ChatMessage(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              text: '',
              imageUrl: pickedPath,
              isFileImage: true,
              time: _getFormattedCurrentTime(),
              isMe: true,
            ),
          );
        });
        _scrollToBottom();
      }
    } catch (e) {
      AppSnackbar.error(
        title: 'Error',
        message: 'Could not access image: $e',
      );
    }
  }

  void _onShareTap() {
    HapticFeedback.mediumImpact();
    Get.toNamed(
      AppRoutes.shareReview,
      arguments: {
        'restaurant': _restaurantName,
        'orderId': _orderId,
        'status': _orderStatus,
      },
    );
  }

  String _getFormattedCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580),
            child: Column(
              children: [
                /// 1. Top Bar: Back Button, Centered "Order ID: #12345", NO Three Dots
                _buildTopBar(),

                /// 2. Restaurant / Order Header Info
                _buildRestaurantHeader(),

                const Divider(color: Color(0xFFF8FAFC), height: 1, thickness: 1),

                /// 3. Scrollable Chat Messages
                Expanded(
                  child: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: msg.isMe
                              ? _buildUserMessageBubble(msg)
                              : _buildRestaurantMessageBubble(msg),
                        );
                      },
                    ),
                  ),
                ),

                /// 4. Bottom Input Bar with Camera, Send Button, and Magenta Share Icon
                _buildBottomInputBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 1. Top Bar matching design: Back icon <, Centered Title, NO three dots
  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Row(
        children: [
          /// Circular Back Button
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Get.back(),
            child: Container(
              width: 42.w.clamp(38.0, 46.0),
              height: 42.w.clamp(38.0, 46.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                  width: 1.2,
                ),
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

          /// Centered Title: "Order ID: #12345"
          Expanded(
            child: Center(
              child: Text(
                _orderId,
                style: GoogleFonts.roboto(
                  fontSize: 18.sp.clamp(16.0, 22.0),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2E0A66),
                ),
              ),
            ),
          ),

          /// Balanced Spacer on Right (Three dots REMOVED per user request)
          SizedBox(width: 42.w.clamp(38.0, 46.0)),
        ],
      ),
    );
  }

  /// 2. Restaurant Header: Circular Logo, "The Burger king", "Order in Progress"
  Widget _buildRestaurantHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        children: [
          /// Avatar: Burger King emblem for merchant, Delivery Driver icon for driver
          if (_isMerchant)
            const _BurgerKingAvatar(size: 44)
          else
            Container(
              width: 44.w.clamp(40.0, 48.0),
              height: 44.w.clamp(40.0, 48.0),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF3E8FF),
              ),
              child: Center(
                child: Icon(
                  Icons.delivery_dining_rounded,
                  color: const Color(0xFF7C3AED),
                  size: 24.sp.clamp(20.0, 28.0),
                ),
              ),
            ),

          SizedBox(width: 12.w),

          /// Restaurant Name & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _restaurantName,
                  style: GoogleFonts.roboto(
                    fontSize: 15.5.sp.clamp(14.0, 17.5),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2E0A66),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  _orderStatus,
                  style: GoogleFonts.roboto(
                    fontSize: 12.5.sp.clamp(11.0, 14.0),
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF8E8E93),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 3A. Sent Message (Right side, Purple bubble with optional attached food picture)
  Widget _buildUserMessageBubble(_ChatMessage msg) {
    final bubbleMaxWidth = 230.w.clamp(200.0, 260.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: bubbleMaxWidth),
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: const Color(0xFF4C2299),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
              bottomLeft: Radius.circular(16.r),
              bottomRight: Radius.circular(4.r),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4C2299).withOpacity(0.18),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Text Message (if not empty)
              if (msg.text.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
                  child: Text(
                    msg.text,
                    style: GoogleFonts.roboto(
                      fontSize: 13.5.sp.clamp(12.0, 15.0),
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.35,
                    ),
                  ),
                ),

              /// Attached Food / Chat Picture (if present)
              if (msg.imageUrl != null) ...[
                if (msg.text.isNotEmpty) SizedBox(height: 8.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: msg.isFileImage
                      ? Image.file(
                          File(msg.imageUrl!),
                          width: double.infinity,
                          height: 140.h.clamp(110.0, 180.0),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 140.h,
                            color: Colors.black26,
                            child: const Center(
                              child: Icon(Icons.broken_image_rounded, color: Colors.white70),
                            ),
                          ),
                        )
                      : Image.asset(
                          msg.imageUrl!,
                          width: double.infinity,
                          height: 135.h.clamp(110.0, 160.0),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 135.h,
                            color: Colors.black26,
                            child: const Center(
                              child: Icon(Icons.fastfood, color: Colors.white70),
                            ),
                          ),
                        ),
                ),
              ],
            ],
          ),
        ),

        SizedBox(height: 4.h),

        /// Timestamp
        Padding(
          padding: EdgeInsets.only(right: 4.w),
          child: Text(
            msg.time,
            style: GoogleFonts.roboto(
              fontSize: 11.sp.clamp(10.0, 12.0),
              fontWeight: FontWeight.w400,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ),
      ],
    );
  }

  /// 3B. Received Message (Left side, Avatar, Sender Name, Soft lavender bubble)
  Widget _buildRestaurantMessageBubble(_ChatMessage msg) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Burger King Avatar
        const Padding(
          padding: EdgeInsets.only(top: 2.0),
          child: _BurgerKingAvatar(size: 36),
        ),

        SizedBox(width: 8.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Sender Name above bubble
              if (msg.senderName != null)
                Padding(
                  padding: EdgeInsets.only(left: 4.w, bottom: 4.h),
                  child: Text(
                    msg.senderName!,
                    style: GoogleFonts.roboto(
                      fontSize: 12.5.sp.clamp(11.0, 14.0),
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2E0A66),
                    ),
                  ),
                ),

              /// Soft Lavender Bubble
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE8F5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.r),
                    topRight: Radius.circular(16.r),
                    bottomLeft: Radius.circular(16.r),
                    bottomRight: Radius.circular(16.r),
                  ),
                ),
                child: Text(
                  msg.text,
                  style: GoogleFonts.roboto(
                    fontSize: 13.5.sp.clamp(12.0, 15.0),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF38147A),
                    height: 1.35,
                  ),
                ),
              ),

              SizedBox(height: 4.h),

              /// Timestamp
              Padding(
                padding: EdgeInsets.only(left: 4.w),
                child: Text(
                  msg.time,
                  style: GoogleFonts.roboto(
                    fontSize: 11.sp.clamp(10.0, 12.0),
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 4. Bottom Input Bar: Pastel lavender pill input with camera icon, dark purple send button, and magenta share button
  Widget _buildBottomInputBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 8.h,
        bottom: 12.h,
      ),
      color: Colors.white,
      child: Row(
        children: [
          /// Pill Shaped Input Field with Camera Icon
          Expanded(
            child: Container(
              height: 46.h.clamp(42.0, 52.0),
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF7EFFC),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: const Color(0xFFF1E4FA),
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      focusNode: _focusNode,
                      onSubmitted: (_) => _onSendMessage(),
                      style: GoogleFonts.roboto(
                        fontSize: 13.5.sp.clamp(12.0, 15.0),
                        color: const Color(0xFF2E0A66),
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type a message...',
                        hintStyle: GoogleFonts.roboto(
                          fontSize: 13.5.sp.clamp(12.0, 15.0),
                          color: const Color(0xFFA89FBA),
                          fontWeight: FontWeight.w400,
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),

                  /// Camera Icon Button
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _onSendImageMessage,
                    child: Padding(
                      padding: EdgeInsets.all(4.r),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        color: const Color(0xFF7A6B90),
                        size: 21.sp.clamp(18.0, 24.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: 8.w),

          /// Dark Purple Send Button
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _onSendMessage,
            child: Container(
              width: 44.w.clamp(40.0, 48.0),
              height: 44.w.clamp(40.0, 48.0),
              decoration: const BoxDecoration(
                color: Color(0xFF2E0A66),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Transform.rotate(
                  angle: -0.15,
                  child: Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 19.sp.clamp(17.0, 22.0),
                  ),
                ),
              ),
            ),
          ),

          /// Vibrant Magenta Share Button
          /// Shown only when chatting with merchant, hidden when driver
          if (_isMerchant) ...[
            SizedBox(width: 8.w),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _onShareTap,
              child: Container(
                width: 44.w.clamp(40.0, 48.0),
                height: 44.w.clamp(40.0, 48.0),
                decoration: const BoxDecoration(
                  color: Color(0xFFD946EF),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.share_rounded,
                    color: Colors.white,
                    size: 20.sp.clamp(18.0, 23.0),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Custom Vector Emblem for Burger King Matching the Design Accurately
class _BurgerKingAvatar extends StatelessWidget {
  final double size;
  const _BurgerKingAvatar({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// Blue Crescent Arc on Left
            Positioned(
              left: -size * 0.12,
              top: -size * 0.08,
              bottom: -size * 0.08,
              width: size * 1.05,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF005DAA),
                    width: size * 0.085,
                  ),
                ),
              ),
            ),

            /// White Center Ring
            Container(
              width: size * 0.82,
              height: size * 0.82,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),

            /// Burger Buns and Red Text
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Top Bun (Golden Orange)
                Container(
                  width: size * 0.52,
                  height: size * 0.13,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF47920),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(size * 0.13),
                    ),
                  ),
                ),

                SizedBox(height: size * 0.02),

                /// Centered Stacked Red Text: "BURGER KING"
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'BURGER',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: (size * 0.12).clamp(4.0, 10.0),
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFFD62300),
                        height: 0.9,
                        letterSpacing: -0.2,
                      ),
                    ),
                    Text(
                      'KING',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: (size * 0.12).clamp(4.0, 10.0),
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFFD62300),
                        height: 0.9,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: size * 0.02),

                /// Bottom Bun (Golden Orange)
                Container(
                  width: size * 0.52,
                  height: size * 0.11,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF47920),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(size * 0.11),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
