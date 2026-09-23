import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/features/role/customer/dashboard/presentation/controller/customer_dashboard_controller.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';

class CustomerWalletActivityScreen extends StatefulWidget {
  const CustomerWalletActivityScreen({super.key});

  @override
  State<CustomerWalletActivityScreen> createState() =>
      _CustomerWalletActivityScreenState();
}

class _CustomerWalletActivityScreenState
    extends State<CustomerWalletActivityScreen> {
  late String _bankName;
  late String _bankFullName;
  late String _accountNo;

  final List<Map<String, dynamic>> _activities = const [
    {
      'amount': '+ \$15.00',
      'isCredit': true,
      'title': 'PLOMOGO',
      'subtitle': 'Order #3921',
      'time': '2 hours ago',
    },
    {
      'amount': '- \$8.50',
      'isCredit': false,
      'title': 'PLOMOGO',
      'subtitle': 'Order #3921',
      'time': '2 hours ago',
    },
    {
      'amount': '+ \$15.00',
      'isCredit': true,
      'title': 'PLOMOGO',
      'subtitle': 'Order #3921',
      'time': '2 hours ago',
    },
  ];

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is Map) {
      _bankName = args['name']?.toString() ?? 'Mandiri';
      _bankFullName = args['fullName']?.toString() ?? 'Bank Mandiri';
      _accountNo = args['accountNo']?.toString() ?? '1370-0098-4421';
    } else {
      _bankName = 'Mandiri';
      _bankFullName = 'Bank Mandiri';
      _accountNo = '1370-0098-4421';
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentBalance = '\$24.50';
    if (Get.isRegistered<CustomerDashboardController>()) {
      final ctrl = Get.find<CustomerDashboardController>();
      if (ctrl.balance.value.isNotEmpty) {
        currentBalance = ctrl.balance.value;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// Top Bar: Back button, Centered Title "Wallet", Balanced spacer
            _buildTopBar(context),

            /// Scrollable Body Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 1. Balance Card: "Your Wallet Balance", "$24.50", "Top Up" Button
                    _buildBalanceCard(context, currentBalance),

                    SizedBox(height: 18.h),

                    /// 2. Ongoing Transfer Card: "Ongoing Transfer", chevron, bank name, amounts, status badge
                    _buildOngoingTransferCard(context),

                    SizedBox(height: 24.h),

                    /// 3. Recent Activity Section Header
                    Text(
                      'Recent Activity',
                      style: GoogleFonts.roboto(
                        fontSize: 18.sp.clamp(16.0, 20.0),
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF180E29),
                      ),
                    ),

                    SizedBox(height: 14.h),

                    /// 4. Recent Activity List Cards
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _activities.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final item = _activities[index];
                        return _buildActivityCard(item);
                      },
                    ),

                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Top Bar with Circular Back Button and Centered "Wallet" Title
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Row(
        children: [
          /// Circular Back Button
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              HapticFeedback.lightImpact();
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                Get.back();
              }
            },
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

          /// Centered Title: "Wallet"
          Expanded(
            child: Center(
              child: Text(
                'Wallet',
                style: GoogleFonts.roboto(
                  fontSize: 18.sp.clamp(16.0, 22.0),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2E0A66),
                ),
              ),
            ),
          ),

          /// Balanced spacer to keep title centered
          SizedBox(width: 42.w.clamp(38.0, 46.0)),
        ],
      ),
    );
  }

  /// 1. Your Wallet Balance Card
  Widget _buildBalanceCard(BuildContext context, String balance) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Wallet Balance',
            style: GoogleFonts.roboto(
              fontSize: 14.sp.clamp(13.0, 16.0),
              fontWeight: FontWeight.w500,
              color: const Color(0xFF334155),
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                balance,
                style: GoogleFonts.roboto(
                  fontSize: 38.sp.clamp(32.0, 44.0),
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF180E29),
                  letterSpacing: -0.5,
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  HapticFeedback.lightImpact();
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    Get.toNamed(AppRoutes.customerWallet);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9333EA),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    'Top Up',
                    style: GoogleFonts.roboto(
                      fontSize: 13.sp.clamp(12.0, 15.0),
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 2. Ongoing Transfer Card
  Widget _buildOngoingTransferCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top Row: Ongoing Transfer + Circular Chevron
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Ongoing Transfer',
                style: GoogleFonts.roboto(
                  fontSize: 18.sp.clamp(16.0, 20.0),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF180E29),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  HapticFeedback.lightImpact();
                  _showTransferDetailsSheet(context);
                },
                child: Container(
                  width: 34.w.clamp(30.0, 38.0),
                  height: 34.w.clamp(30.0, 38.0),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: const Color(0xFF334155),
                      size: 22.sp.clamp(18.0, 24.0),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          /// Subtitle: "${BankName} Bank Transfer"
          Text(
            '$_bankName Bank Transfer',
            style: GoogleFonts.roboto(
              fontSize: 15.sp.clamp(14.0, 17.0),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
            ),
          ),

          SizedBox(height: 12.h),

          /// Row 1: Top-up Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top-up Amount',
                style: GoogleFonts.roboto(
                  fontSize: 14.sp.clamp(13.0, 15.0),
                  color: const Color(0xFF334155),
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '\$50.00',
                style: GoogleFonts.roboto(
                  fontSize: 14.sp.clamp(13.0, 15.0),
                  color: const Color(0xFF1E293B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          /// Row 2: Top-up Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top-up Amount',
                style: GoogleFonts.roboto(
                  fontSize: 14.sp.clamp(13.0, 15.0),
                  color: const Color(0xFF334155),
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '\$50.00',
                style: GoogleFonts.roboto(
                  fontSize: 14.sp.clamp(13.0, 15.0),
                  color: const Color(0xFF1E293B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          /// Status Waiting on Proof Pill Badge
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              HapticFeedback.lightImpact();
              _showTransferDetailsSheet(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFFE9D5FF),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'Status Waiting on Proof',
                style: GoogleFonts.roboto(
                  fontSize: 12.sp.clamp(11.0, 13.5),
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF7E22CE),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 3. Activity Card
  Widget _buildActivityCard(Map<String, dynamic> item) {
    final bool isCredit = item['isCredit'] == true;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          /// Amount on Left
          SizedBox(
            width: 76.w.clamp(68.0, 84.0),
            child: Text(
              item['amount'] as String,
              style: GoogleFonts.roboto(
                fontSize: 15.sp.clamp(14.0, 17.0),
                fontWeight: FontWeight.w700,
                color: isCredit
                    ? const Color(0xFF10B981)
                    : const Color(0xFFEF4444),
              ),
            ),
          ),

          SizedBox(width: 12.w),

          /// Middle: Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item['title'] as String,
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp.clamp(13.0, 16.0),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  item['subtitle'] as String,
                  style: GoogleFonts.roboto(
                    fontSize: 12.sp.clamp(11.0, 14.0),
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),

          /// Right: Time
          Text(
            item['time'] as String,
            style: GoogleFonts.roboto(
              fontSize: 12.sp.clamp(11.0, 13.5),
              fontWeight: FontWeight.w400,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  /// Transfer Details & Upload Proof Bottom Sheet
  void _showTransferDetailsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Handle bar
              Center(
                child: Container(
                  width: 44.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$_bankName Bank Transfer',
                        style: GoogleFonts.roboto(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF2E0A66),
                        ),
                      ),
                      Text(
                        _bankFullName,
                        style: GoogleFonts.roboto(
                          fontSize: 12.sp,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9D5FF),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      'Waiting Proof',
                      style: GoogleFonts.roboto(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF7E22CE),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              /// Account Number Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bank Account Number',
                          style: GoogleFonts.roboto(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          _accountNo,
                          style: GoogleFonts.roboto(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E293B),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: _accountNo));
                        HapticFeedback.lightImpact();
                        AppSnackbar.success(
                          title: 'Copied',
                          message: 'Account number copied to clipboard!',
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDE9FE),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          'Copy',
                          style: GoogleFonts.roboto(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2E0A66),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              /// Upload Proof Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    HapticFeedback.lightImpact();
                    AppSnackbar.success(
                      title: 'Proof Uploaded',
                      message:
                          'Proof uploaded successfully! Deposit is being verified.',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E0A66),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Upload Proof of Payment',
                    style: GoogleFonts.roboto(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
