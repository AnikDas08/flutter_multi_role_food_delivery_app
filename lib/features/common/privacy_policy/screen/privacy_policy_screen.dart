import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/config/route/app_routes.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFC),
      body: SafeArea(
        child: Column(
          children: [
            /// 1. Top App Bar
            _buildAppBar(context),

            /// 2. Scrollable Privacy Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Shield Header Card
                    _buildHeaderBanner(),

                    SizedBox(height: 16.h),

                    /// Sections
                    _buildSection(
                      title: '1. Introduction',
                      content:
                          'Welcome to Julio Food Delivery ("we", "our", or "us"). We are dedicated to respecting your privacy and protecting your personal information. This Privacy Policy explains how we collect, use, disclose, and safeguard your data when you use our mobile application and delivery services.',
                    ),

                    _buildSection(
                      title: '2. Information We Collect',
                      content:
                          'We collect information that you provide directly to us, including:\n'
                          '• Personal Details: Your name, email address, phone number, and profile picture.\n'
                          '• Delivery Information: Saved delivery addresses, pin codes, and delivery instructions.\n'
                          '• Payment & Transactions: Order history, transaction amounts, and payment method tokens (we never store raw card numbers).\n'
                          '• Device & Location Data: Real-time GPS location when tracking deliveries, device model, and operating system.',
                    ),

                    _buildSection(
                      title: '3. How We Use Your Information',
                      content:
                          'We use the collected information for various business and service purposes:\n'
                          '• To process, dispatch, and track your food and grocery orders in real time.\n'
                          '• To communicate delivery updates, order confirmations, and customer support responses.\n'
                          '• To personalize your dining recommendations based on your preferences.\n'
                          '• To maintain account security, detect fraud, and comply with legal requirements.',
                    ),

                    _buildSection(
                      title: '4. Information Sharing & Disclosure',
                      content:
                          'We do not sell your personal data. We only share information with:\n'
                          '• Partner Restaurants & Merchants: To fulfill your food preparation details.\n'
                          '• Assigned Delivery Drivers: To enable accurate pickup and home delivery.\n'
                          '• Verified Service Providers: Cloud hosting, analytics, and SMS/payment gateway providers under strict confidentiality agreements.',
                    ),

                    _buildSection(
                      title: '5. Data Security & Storage',
                      content:
                          'We employ industry-standard encryption protocols (TLS/SSL) and multi-factor security safeguards to protect your data. Your sensitive payment details are processed through PCI-DSS certified payment processors.',
                    ),

                    _buildSection(
                      title: '6. Your Rights & Choices',
                      content:
                          'You have full control over your personal information:\n'
                          '• You can review, update, or edit your profile details at any time in the app.\n'
                          '• You can enable or disable push notifications and location services in your device settings.\n'
                          '• You can request account deactivation or data removal by contacting our support team.',
                    ),

                    _buildSection(
                      title: '7. Contact Us',
                      content:
                          'If you have any questions, concerns, or requests regarding this Privacy Policy, please reach out to us:\n\n'
                          '• Email: privacy@juliofood.com\n'
                          '• Support: support@juliofood.com\n'
                          '• Address: 123 Food Street, Tech Hub, NY 10001\n\n'
                          'Last updated: September 2026',
                    ),

                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 1. Top App Bar
  Widget _buildAppBar(BuildContext context) {
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
                Get.offAllNamed(AppRoutes.mainNavBar);
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

          /// Centered Title
          Expanded(
            child: Center(
              child: Text(
                'Privacy Policy',
                style: GoogleFonts.roboto(
                  fontSize: 18.sp.clamp(16.0, 22.0),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2E0A66),
                ),
              ),
            ),
          ),

          /// Balanced spacer
          SizedBox(width: 42.w.clamp(38.0, 46.0)),
        ],
      ),
    );
  }

  /// Banner at the top of content
  Widget _buildHeaderBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF2E0A66),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E0A66).withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shield_outlined,
              color: Colors.white,
              size: 26.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Privacy Matters',
                  style: GoogleFonts.roboto(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'We protect your data with bank-grade security protocols.',
                  style: GoogleFonts.roboto(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Reusable Policy Section Card
  Widget _buildSection({required String title, required String content}) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 14.5.sp.clamp(13.5, 16.0),
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2E0A66),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            content,
            style: GoogleFonts.roboto(
              fontSize: 12.5.sp.clamp(11.5, 14.0),
              fontWeight: FontWeight.w400,
              color: const Color(0xFF475569),
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}
