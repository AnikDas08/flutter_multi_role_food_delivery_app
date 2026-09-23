import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/utils/app_snackbar.dart';

class SavedAddressItem {
  String title;
  String address;
  IconData icon;

  SavedAddressItem({
    required this.title,
    required this.address,
    required this.icon,
  });
}

class CustomerDeliveryAddressScreen extends StatefulWidget {
  const CustomerDeliveryAddressScreen({super.key});

  @override
  State<CustomerDeliveryAddressScreen> createState() =>
      _CustomerDeliveryAddressScreenState();
}

class _CustomerDeliveryAddressScreenState
    extends State<CustomerDeliveryAddressScreen> {
  final List<SavedAddressItem> _addresses = [
    SavedAddressItem(
      title: 'Home',
      address: 'House 12, Road 5, Dhaka',
      icon: Icons.home_rounded,
    ),
    SavedAddressItem(
      title: 'Office',
      address: 'Banani, Dhaka',
      icon: Icons.apartment_rounded,
    ),
    SavedAddressItem(
      title: 'Gym',
      address: 'Dhanmondi 27, Dhaka',
      icon: Icons.fitness_center_rounded,
    ),
  ];

  void _showAddAddressDialog() {
    HapticFeedback.lightImpact();

    String selectedType = 'Home';
    final customTitleController = TextEditingController();
    final addressController = TextEditingController();

    final List<Map<String, dynamic>> addressTypes = [
      {'label': 'Home', 'icon': Icons.home_rounded},
      {'label': 'Office', 'icon': Icons.apartment_rounded},
      {'label': 'Gym', 'icon': Icons.fitness_center_rounded},
      {'label': 'Other', 'icon': Icons.location_on_rounded},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final bottomInsets = MediaQuery.of(context).viewInsets.bottom;

            return Container(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 16.h,
                bottom: bottomInsets > 0 ? bottomInsets + 16.h : 24.h,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Drag handle
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

                    /// Title & Close
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add New Address',
                          style: GoogleFonts.roboto(
                            fontSize: 18.sp.clamp(16.0, 20.0),
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2E0A66),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(bottomSheetContext),
                          icon: Icon(
                            Icons.close_rounded,
                            color: const Color(0xFF64748B),
                            size: 22.sp,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),

                    /// Address Type Selector (Chips)
                    Text(
                      'Address Label',
                      style: GoogleFonts.roboto(
                        fontSize: 12.5.sp.clamp(11.5, 14.0),
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF64748B),
                      ),
                    ),

                    SizedBox(height: 8.h),

                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: addressTypes.map((type) {
                        final isSelected = selectedType == type['label'];
                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setModalState(() {
                              selectedType = type['label'] as String;
                              if (selectedType != 'Other') {
                                customTitleController.text = selectedType;
                              } else {
                                customTitleController.clear();
                              }
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF2E0A66)
                                  : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF2E0A66)
                                    : const Color(0xFFE2E8F0),
                                width: 1.2,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  type['icon'] as IconData,
                                  size: 16.sp,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF64748B),
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  type['label'] as String,
                                  style: GoogleFonts.roboto(
                                    fontSize: 13.sp.clamp(12.0, 14.5),
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF334155),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    if (selectedType == 'Other') ...[
                      SizedBox(height: 12.h),
                      Text(
                        'Custom Label Name',
                        style: GoogleFonts.roboto(
                          fontSize: 12.5.sp.clamp(11.5, 14.0),
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      SizedBox(height: 6.h),
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
                        child: TextField(
                          controller: customTitleController,
                          style: GoogleFonts.roboto(
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1E293B),
                          ),
                          decoration: InputDecoration(
                            hintText: 'e.g. Vacation Home, Studio',
                            hintStyle: GoogleFonts.roboto(
                              fontSize: 13.sp,
                              color: const Color(0xFF94A3B8),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 12.h,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],

                    SizedBox(height: 14.h),

                    /// Address Input
                    Text(
                      'Full Address',
                      style: GoogleFonts.roboto(
                        fontSize: 12.5.sp.clamp(11.5, 14.0),
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1.2,
                        ),
                      ),
                      child: TextField(
                        controller: addressController,
                        minLines: 3,
                        maxLines: 4,
                        style: GoogleFonts.roboto(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1E293B),
                        ),
                        decoration: InputDecoration(
                          hintText: 'e.g. House 12, Road 5, Dhaka',
                          hintStyle: GoogleFonts.roboto(
                            fontSize: 13.sp,
                            color: const Color(0xFF94A3B8),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 12.h,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    /// Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: () {
                          final title = selectedType == 'Other'
                              ? customTitleController.text.trim()
                              : selectedType;
                          final address = addressController.text.trim();

                          if (title.isEmpty) {
                            AppSnackbar.error(
                              title: 'Required',
                              message: 'Please provide an address label',
                            );
                            return;
                          }

                          if (address.isEmpty) {
                            AppSnackbar.error(
                              title: 'Required',
                              message: 'Please enter the full address',
                            );
                            return;
                          }

                          final IconData icon = selectedType == 'Home'
                              ? Icons.home_rounded
                              : selectedType == 'Office'
                                  ? Icons.apartment_rounded
                                  : selectedType == 'Gym'
                                      ? Icons.fitness_center_rounded
                                      : Icons.location_on_rounded;

                          setState(() {
                            _addresses.add(
                              SavedAddressItem(
                                title: title,
                                address: address,
                                icon: icon,
                              ),
                            );
                          });

                          Navigator.pop(bottomSheetContext);

                          AppSnackbar.success(
                            title: 'Address Added',
                            message: '$title has been saved successfully',
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E0A66),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                        ),
                        child: Text(
                          'Save Address',
                          style: GoogleFonts.roboto(
                            fontSize: 15.sp.clamp(14.0, 17.0),
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// 1. Top Custom App Bar
            _buildTopBar(context),

            /// 2. Scrollable Body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 540),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8.h),

                        /// Header matching screenshot
                        Text(
                          'Delivery Address',
                          style: GoogleFonts.roboto(
                            fontSize: 18.sp.clamp(16.0, 22.0),
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2E0A66),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Saved Addresses (${_addresses.length}/5)',
                          style: GoogleFonts.roboto(
                            fontSize: 13.sp.clamp(12.0, 14.5),
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF64748B),
                          ),
                        ),

                        SizedBox(height: 16.h),

                        /// List of Addresses matching screenshot
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _addresses.length,
                          separatorBuilder: (_, __) => SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            final item = _addresses[index];
                            return _buildAddressCard(item, index);
                          },
                        ),

                        SizedBox(height: 32.h),

                        /// Add Address Button
                        SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: ElevatedButton(
                            onPressed: _showAddAddressDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2E0A66),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.r),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_rounded,
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Add New Address',
                                  style: GoogleFonts.roboto(
                                    fontSize: 15.sp.clamp(14.0, 17.0),
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: bottomPadding > 0 ? bottomPadding + 10.h : 24.h),
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

  /// Top Bar: Back button, title, balanced spacer
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
                'Delivery Address',
                style: GoogleFonts.roboto(
                  fontSize: 18.sp.clamp(16.0, 22.0),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2E0A66),
                ),
              ),
            ),
          ),

          /// Balanced spacer to keep title centered (no notification icon)
          SizedBox(width: 42.w.clamp(38.0, 46.0)),
        ],
      ),
    );
  }

  /// Card matching the user's screenshot
  Widget _buildAddressCard(SavedAddressItem item, int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Icon Container matching screenshot
          Container(
            width: 48.w.clamp(42.0, 52.0),
            height: 48.w.clamp(42.0, 52.0),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Icon(
                item.icon,
                color: const Color(0xFF9333EA),
                size: 24.sp.clamp(20.0, 28.0),
              ),
            ),
          ),

          SizedBox(width: 14.w),

          /// Title and Address
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.roboto(
                    fontSize: 15.sp.clamp(14.0, 17.0),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2E0A66),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  item.address,
                  style: GoogleFonts.roboto(
                    fontSize: 12.5.sp.clamp(11.5, 14.0),
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),

          /// Delete button
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              setState(() {
                _addresses.removeAt(index);
              });
              AppSnackbar.info(
                title: 'Address Removed',
                message: '${item.title} has been removed',
              );
            },
            icon: Icon(
              Icons.delete_outline_rounded,
              color: const Color(0xFF94A3B8),
              size: 20.sp,
            ),
            tooltip: 'Remove',
          ),
        ],
      ),
    );
  }
}
