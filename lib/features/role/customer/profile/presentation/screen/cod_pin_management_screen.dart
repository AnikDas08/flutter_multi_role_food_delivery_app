import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/utils/app_snackbar.dart';

class CodPinManagementScreen extends StatefulWidget {
  const CodPinManagementScreen({super.key});

  @override
  State<CodPinManagementScreen> createState() => _CodPinManagementScreenState();
}

class _CodPinManagementScreenState extends State<CodPinManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();

  bool _obscureNewPin = true;
  bool _obscureConfirmPin = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _newPinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  void _onSavePin() {
    HapticFeedback.lightImpact();
    final newPin = _newPinController.text.trim();
    final confirmPin = _confirmPinController.text.trim();

    if (newPin.isEmpty) {
      AppSnackbar.error(
        title: 'Validation Error',
        message: 'Please enter your new COD PIN number',
      );
      return;
    }

    if (newPin.length < 4) {
      AppSnackbar.error(
        title: 'Invalid PIN',
        message: 'PIN must be at least 4 digits',
      );
      return;
    }

    if (newPin != confirmPin) {
      AppSnackbar.error(
        title: 'Mismatch',
        message: 'PIN numbers do not match',
      );
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _isLoading = false);
        AppSnackbar.success(
          title: 'Success',
          message: 'COD PIN has been saved successfully.',
        );
        Get.back();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// 1. Top Custom App Bar matching screenshot with notification icon removed
            _buildTopBar(context),

            /// 2. Body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 540),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 12.h),

                          /// Subtitle
                          Text(
                            'Enter and Confirm your New PIN Number\nto Secure Cash on Delivery Orders',
                            style: GoogleFonts.roboto(
                              fontSize: 14.sp.clamp(13.0, 16.0),
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF334155),
                              height: 1.45,
                            ),
                          ),

                          SizedBox(height: 28.h),

                          /// New PIN Number Field
                          Text(
                            'New PIN Number',
                            style: GoogleFonts.roboto(
                              fontSize: 12.5.sp.clamp(11.5, 14.0),
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF374151),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            height: 48.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                                width: 1.2,
                              ),
                            ),
                            child: TextFormField(
                              controller: _newPinController,
                              obscureText: _obscureNewPin,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(6),
                              ],
                              style: GoogleFonts.roboto(
                                fontSize: 14.sp.clamp(13.0, 16.0),
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF1E293B),
                                letterSpacing: 3,
                              ),
                              decoration: InputDecoration(
                                hintText: '••••••',
                                hintStyle: GoogleFonts.roboto(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF94A3B8),
                                  letterSpacing: 3,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 14.w,
                                  vertical: 12.h,
                                ),
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureNewPin = !_obscureNewPin;
                                    });
                                  },
                                  icon: Icon(
                                    _obscureNewPin
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 20.sp,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 20.h),

                          /// Confirm New PIN Number Field
                          Text(
                            'Confirm New PIN Number',
                            style: GoogleFonts.roboto(
                              fontSize: 12.5.sp.clamp(11.5, 14.0),
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF374151),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            height: 48.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                                width: 1.2,
                              ),
                            ),
                            child: TextFormField(
                              controller: _confirmPinController,
                              obscureText: _obscureConfirmPin,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(6),
                              ],
                              style: GoogleFonts.roboto(
                                fontSize: 14.sp.clamp(13.0, 16.0),
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF1E293B),
                                letterSpacing: 3,
                              ),
                              decoration: InputDecoration(
                                hintText: '••••••',
                                hintStyle: GoogleFonts.roboto(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF94A3B8),
                                  letterSpacing: 3,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 14.w,
                                  vertical: 12.h,
                                ),
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPin = !_obscureConfirmPin;
                                    });
                                  },
                                  icon: Icon(
                                    _obscureConfirmPin
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 20.sp,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 32.h),

                          /// Bottom Action Button: Save PIN
                          SizedBox(
                            width: double.infinity,
                            height: 50.h,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _onSavePin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E0A66),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.r),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : Text(
                                      'Save PIN',
                                      style: GoogleFonts.roboto(
                                        fontSize: 15.sp.clamp(14.0, 17.0),
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),

                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Top Bar with Circular Back button, centered title, and balanced spacer (notification icon removed)
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
              Get.back();
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
                'COD Pin Management',
                style: GoogleFonts.roboto(
                  fontSize: 17.5.sp.clamp(16.0, 20.0),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2E0A66),
                ),
              ),
            ),
          ),

          /// Right balanced spacer (notification icon removed)
          SizedBox(width: 42.w.clamp(38.0, 46.0)),
        ],
      ),
    );
  }
}
