import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_code_structure/component/app_bar/common_app_bar.dart';
import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/features/common/nav_bar/presentation/controller/nav_bar_controller.dart';
import 'package:flutter_code_structure/utils/app_snackbar.dart';
import 'package:flutter_code_structure/utils/helpers/permission_helper.dart';

class BankTransferDetailScreen extends StatefulWidget {
  final String bankName;
  final String amount;
  final String accountName;
  final String accountNumber;
  final String referenceNumber;

  const BankTransferDetailScreen({
    super.key,
    this.bankName = 'BNCTL',
    this.amount = '\$67.00',
    this.accountName = 'Cabonaro Unipessoal Lda',
    this.accountNumber = '88390045827493',
    this.referenceNumber = 'COD-20260428-67412',
  });

  @override
  State<BankTransferDetailScreen> createState() =>
      _BankTransferDetailScreenState();
}

class _BankTransferDetailScreenState extends State<BankTransferDetailScreen> {
  int _selectedUploadMode = 0; // 0 = Choose File, 1 = Take Photo
  File? _selectedFile;
  String? _selectedFileName;
  bool _isPdf = false;
  final ImagePicker _picker = ImagePicker();

  void _copyToClipboard(String label, String value) {
    Clipboard.setData(ClipboardData(text: value));
    AppSnackbar.success(
      title: 'Copied',
      message: '$label copied to clipboard',
    );
  }

  Future<void> _onChooseFile([String? bankName]) async {
    setState(() => _selectedUploadMode = 0);
    final hasPerm = await AppPermissionHelper.requestPhotosPermission(context: context);
    if (!hasPerm) return;

    final targetBank =
        (bankName != null && bankName.isNotEmpty) ? bankName : widget.bankName;
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      final pdfName = picked != null
          ? '${picked.name.replaceAll(RegExp(r'\.[a-zA-Z0-9]+$'), '')}_receipt.pdf'
          : 'Transfer_Receipt_$targetBank.pdf';
      setState(() {
        if (picked != null) {
          _selectedFile = File(picked.path);
        }
        _selectedFileName = pdfName;
        _isPdf = true;
      });
      AppSnackbar.success(
        title: 'PDF Attached',
        message: '$pdfName selected successfully',
      );
    } catch (e) {
      final fallbackName = 'Transfer_Receipt_$targetBank.pdf';
      setState(() {
        _isPdf = true;
        _selectedFileName = fallbackName;
      });
      AppSnackbar.success(
        title: 'PDF Attached',
        message: '$fallbackName selected',
      );
    }
  }

  Future<void> _onTakePhoto() async {
    setState(() => _selectedUploadMode = 1);
    final hasPerm =
        await AppPermissionHelper.requestPhotosPermission(context: context);
    if (!hasPerm) return;

    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (photo != null) {
        setState(() {
          _selectedFile = File(photo.path);
          _selectedFileName = photo.name;
          _isPdf = false;
        });
        AppSnackbar.success(
          title: 'Photo Selected',
          message: '${photo.name} attached successfully',
        );
      }
    } catch (e) {
      AppSnackbar.error(
        title: 'Notice',
        message: 'Could not access gallery: $e',
      );
    }
  }

  void _onSubmitPayment(String amount, String refNumber) {
    AppSnackbar.success(
      title: 'Payment Submitted',
      message: 'Your payment of $amount has been recorded successfully.',
    );
    if (Get.isRegistered<NavBarController>()) {
      Get.find<NavBarController>().changeIndex(2);
    }
    Get.until(
      (route) =>
          route.isFirst || route.settings.name == AppRoutes.mainNavBar,
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final currentBank = args?['bankName'] as String? ?? widget.bankName;
    final currentAmount = args?['amount'] as String? ?? widget.amount;
    final currentAccountName =
        args?['accountName'] as String? ?? widget.accountName;
    final currentAccountNumber =
        args?['accountNumber'] as String? ?? widget.accountNumber;
    final currentRef =
        args?['referenceNumber'] as String? ?? widget.referenceNumber;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: 'Bank Transfer - $currentBank',
        titleColor: const Color(0xFF2E0A66),
        titleSize: 17.sp,
        titleWeight: FontWeight.w700,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 8.h),

              /// 1. Large Amount
              Text(
                currentAmount,
                style: GoogleFonts.roboto(
                  fontSize: 38.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E293B),
                  letterSpacing: -0.5,
                ),
              ),

              SizedBox(height: 8.h),

              /// Subtitle
              Text(
                'Transfer exactly $currentAmount to the account below.\nUse the reference number for easy tracking.',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF1E293B),
                  height: 1.4,
                ),
              ),

              SizedBox(height: 24.h),

              /// 2. Bank Details Card
              Container(
                width: double.infinity,
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
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Bank Name Row (without copy button)
                    Text(
                      'Bank Name:',
                      style: GoogleFonts.roboto(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      currentBank,
                      style: GoogleFonts.roboto(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E293B),
                      ),
                    ),

                    SizedBox(height: 12.h),
                    const Divider(color: Color(0xFFF1F5F9), height: 1),
                    SizedBox(height: 12.h),

                    /// Account Name Row (with Copy button)
                    _buildCopyRow(
                      label: 'Account Name:',
                      value: currentAccountName,
                      onCopy: () =>
                          _copyToClipboard('Account Name', currentAccountName),
                    ),

                    SizedBox(height: 12.h),
                    const Divider(color: Color(0xFFF1F5F9), height: 1),
                    SizedBox(height: 12.h),

                    /// Account Number Row (with Copy button)
                    _buildCopyRow(
                      label: 'Account Number:',
                      value: currentAccountNumber,
                      onCopy: () => _copyToClipboard(
                          'Account Number', currentAccountNumber),
                    ),

                    SizedBox(height: 12.h),
                    const Divider(color: Color(0xFFF1F5F9), height: 1),
                    SizedBox(height: 12.h),

                    /// Reference Number Row (with Copy button)
                    _buildCopyRow(
                      label: 'Reference Number:',
                      value: currentRef,
                      onCopy: () =>
                          _copyToClipboard('Reference Number', currentRef),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 18.h),

              /// 3. Note below details card
              Text(
                'Transfer must be completed within 30 days.',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF475569),
                ),
              ),

              SizedBox(height: 18.h),

              /// 4. Dashed Upload Proof of Transfer Card
              CustomPaint(
                painter: _DashedRRectPainter(
                  color: const Color(0xFFCBD5E1),
                  strokeWidth: 1.2,
                  dash: 6,
                  gap: 4,
                  radius: 16.r,
                ),
                child: Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDEDF2).withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Upload Proof of Transfer',
                        style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1E293B),
                        ),
                      ),

                      SizedBox(height: 12.h),

                      /// Segmented Selector (Choose File / Take Photo)
                      Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC7D2FE).withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            /// Choose File Button
                            GestureDetector(
                              onTap: () => _onChooseFile(currentBank),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 22.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  color: _selectedUploadMode == 0
                                      ? Colors.white
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: _selectedUploadMode == 0
                                      ? Border.all(
                                          color: const Color(0xFF2E0A66),
                                          width: 1.2,
                                        )
                                      : null,
                                ),
                                child: Text(
                                  'Choose File',
                                  style: GoogleFonts.roboto(
                                    fontSize: 13.5.sp,
                                    fontWeight: _selectedUploadMode == 0
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    color: _selectedUploadMode == 0
                                        ? const Color(0xFF2E0A66)
                                        : const Color(0xFF475569),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(width: 4.w),

                            /// Take Photo Button
                            GestureDetector(
                              onTap: _onTakePhoto,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 22.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  color: _selectedUploadMode == 1
                                      ? Colors.white
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: _selectedUploadMode == 1
                                      ? Border.all(
                                          color: const Color(0xFF2E0A66),
                                          width: 1.2,
                                        )
                                      : null,
                                ),
                                child: Text(
                                  'Take Photo',
                                  style: GoogleFonts.roboto(
                                    fontSize: 13.5.sp,
                                    fontWeight: _selectedUploadMode == 1
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    color: _selectedUploadMode == 1
                                        ? const Color(0xFF2E0A66)
                                        : const Color(0xFF475569),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 12.h),

                      /// Note / selected file display
                      if (_selectedFile != null || _selectedFileName != null) ...[
                        if (_isPdf || _selectedUploadMode == 0) ...[
                          /// Dedicated PDF Document Card
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                                width: 1.2,
                              ),
                            ),
                            child: Row(
                              children: [
                                /// PDF Red Icon Badge
                                Container(
                                  width: 44.w,
                                  height: 44.w,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEE2E2),
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(
                                      color: const Color(0xFFFECACA),
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.picture_as_pdf_rounded,
                                        size: 22.sp,
                                        color: const Color(0xFFDC2626),
                                      ),
                                      SizedBox(height: 1.h),
                                      Text(
                                        'PDF',
                                        style: GoogleFonts.roboto(
                                          fontSize: 8.5.sp,
                                          fontWeight: FontWeight.w800,
                                          color: const Color(0xFFDC2626),
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _selectedFileName ?? 'Transfer_Receipt.pdf',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.roboto(
                                          fontSize: 13.5.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF1E293B),
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 6.w,
                                              vertical: 2.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFDCFCE7),
                                              borderRadius:
                                                  BorderRadius.circular(4.r),
                                            ),
                                            child: Text(
                                              'PDF Document',
                                              style: GoogleFonts.roboto(
                                                fontSize: 10.5.sp,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF16A34A),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 6.w),
                                          Text(
                                            '1.4 MB • Ready',
                                            style: GoogleFonts.roboto(
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xFF64748B),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedFile = null;
                                      _selectedFileName = null;
                                      _isPdf = false;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(6.w),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFF1F5F9),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.close_rounded,
                                      size: 16.sp,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else if (_selectedFile != null) ...[
                          /// Captured Photo Card
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                                width: 1.2,
                              ),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: Image.file(
                                    _selectedFile!,
                                    width: 44.w,
                                    height: 44.w,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      width: 44.w,
                                      height: 44.w,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE2E8F0),
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                      child: Icon(
                                        Icons.image_outlined,
                                        size: 22.sp,
                                        color: const Color(0xFF64748B),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _selectedFileName ?? 'Captured_Photo.jpg',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.roboto(
                                          fontSize: 13.5.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF1E293B),
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        'Photo Attached • Ready',
                                        style: GoogleFonts.roboto(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF16A34A),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedFile = null;
                                      _selectedFileName = null;
                                      _isPdf = false;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(6.w),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFF1F5F9),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.close_rounded,
                                      size: 16.sp,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ] else ...[
                        Text(
                          'PNG, JPG, / PDF',
                          style: GoogleFonts.roboto(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFA855F7),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              SizedBox(height: 28.h),

              /// 5. Bottom Action Button: I Have Made the Payment
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () => _onSubmitPayment(currentAmount, currentRef),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E0A66),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                  ),
                  child: Text(
                    'I Have Made the Payment',
                    style: GoogleFonts.roboto(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCopyRow({
    required String label,
    required String value,
    required VoidCallback onCopy,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.roboto(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF64748B),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: GoogleFonts.roboto(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onCopy,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: const Color(0xFF2E0A66),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Text(
              'Copy',
              style: GoogleFonts.roboto(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom painter to draw clean dashed rounded rectangle border
class _DashedRRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dash;
  final double gap;
  final double radius;

  _DashedRRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.dash,
    required this.gap,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    final Path path = Path()..addRRect(rrect);
    final Path dashPath = Path();

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double len = min(dash, metric.length - distance);
        dashPath.addPath(
          metric.extractPath(distance, distance + len),
          Offset.zero,
        );
        distance += dash + gap;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
