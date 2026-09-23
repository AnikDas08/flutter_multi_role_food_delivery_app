import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/utils/app_snackbar.dart';

class MerchantBusinessInfoScreen extends StatefulWidget {
  const MerchantBusinessInfoScreen({super.key});

  @override
  State<MerchantBusinessInfoScreen> createState() =>
      _MerchantBusinessInfoScreenState();
}

class _MerchantBusinessInfoScreenState
    extends State<MerchantBusinessInfoScreen> {
  late final TextEditingController _businessNameController;
  late final TextEditingController _taxIdController;
  late final TextEditingController _addressController;

  String _selectedBusinessType = 'Cafe & Restaurant';
  final List<String> _businessTypes = [
    'Cafe & Restaurant',
    'Fast Food',
    'Bakery & Dessert',
    'Grocery Store',
    'Bar & Beverage',
  ];

  @override
  void initState() {
    super.initState();
    _businessNameController =
        TextEditingController(text: 'The Coffee Corner');
    _taxIdController = TextEditingController(text: '12-3456789');
    _addressController = TextEditingController(
      text: '123 Main Street Downtown District New York, NY 10001',
    );
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _taxIdController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _onSave() {
    HapticFeedback.lightImpact();
    AppSnackbar.success(
      title: 'Business Info Updated',
      message: 'Business information saved successfully.',
    );
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// 1. Top Bar: Circular Back Button & Title
            _buildTopBar(),

            /// 2. Scrollable Form Body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 540),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Section Title: Business Details
                        Text(
                          'Business Details',
                          style: GoogleFonts.roboto(
                            fontSize: 15.5.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2E0A66),
                          ),
                        ),

                        SizedBox(height: 16.h),

                        /// 1. Business Name
                        _buildLabel('Business Name'),
                        SizedBox(height: 6.h),
                        _buildTextField(_businessNameController),

                        SizedBox(height: 14.h),

                        /// 2. Business Type Dropdown
                        _buildLabel('Business Type'),
                        SizedBox(height: 6.h),
                        _buildBusinessTypeDropdown(),

                        SizedBox(height: 14.h),

                        /// 3. Tax ID / EIN (Optional)
                        _buildLabel('Tax ID / EIN (Optional)'),
                        SizedBox(height: 6.h),
                        _buildTextField(_taxIdController),

                        SizedBox(height: 14.h),

                        /// 4. Business Address (Multiline)
                        _buildLabel('Business Address'),
                        SizedBox(height: 6.h),
                        _buildAddressField(),

                        SizedBox(height: 36.h),

                        /// Save Changes Button
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _onSave,
                          child: Container(
                            width: double.infinity,
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E0A66),
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                            child: Center(
                              child: Text(
                                'Save Changes',
                                style: GoogleFonts.roboto(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: bottomPadding > 0 ? bottomPadding : 16.h),
                      ],
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

  /// Top Bar with Circular Back Button and Centered Title
  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Row(
        children: [
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
          Expanded(
            child: Center(
              child: Text(
                'Edit Business Info',
                style: GoogleFonts.roboto(
                  fontSize: 18.sp.clamp(16.0, 22.0),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2E0A66),
                ),
              ),
            ),
          ),
          SizedBox(width: 42.w.clamp(38.0, 46.0)),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.roboto(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF64748B),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.1),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          style: GoogleFonts.roboto(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1E293B),
          ),
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBusinessTypeDropdown() {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedBusinessType,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 20.sp,
            color: const Color(0xFF64748B),
          ),
          style: GoogleFonts.roboto(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1E293B),
          ),
          items: _businessTypes.map((type) {
            return DropdownMenuItem<String>(
              value: type,
              child: Text(type),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              setState(() => _selectedBusinessType = val);
            }
          },
        ),
      ),
    );
  }

  Widget _buildAddressField() {
    return Container(
      height: 104.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.1),
      ),
      child: TextField(
        controller: _addressController,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: GoogleFonts.roboto(
          fontSize: 13.5.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF1E293B),
          height: 1.45,
        ),
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(14.w),
        ),
      ),
    );
  }
}
