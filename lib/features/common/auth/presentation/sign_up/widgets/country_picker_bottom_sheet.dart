import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/countries.dart';

import 'package:flutter_code_structure/utils/constants/app_colors.dart';

class CountryPickerBottomSheet {
  CountryPickerBottomSheet._();

  static void show(
    BuildContext context, {
    required Country selectedCountry,
    required ValueChanged<Country> onSelectCountry,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredCountries = searchQuery.isEmpty
                ? countries
                : countries.where((c) {
                    final q = searchQuery.toLowerCase();
                    return c.name.toLowerCase().contains(q) ||
                        c.dialCode.contains(q) ||
                        c.code.toLowerCase().contains(q);
                  }).toList();

            return Container(
              height: 0.78.sh,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    /// Drag handle
                    Container(
                      width: 44.w,
                      height: 4.h,
                      margin: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),

                    /// Header
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Select Country',
                            style: GoogleFonts.roboto(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.black,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded, color: Color(0xFF6B7280)),
                            onPressed: () => Navigator.of(bottomSheetContext).pop(),
                          ),
                        ],
                      ),
                    ),

                    /// Search field
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      child: TextField(
                        onChanged: (val) {
                          setModalState(() {
                            searchQuery = val.trim();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search country or dial code...',
                          hintStyle: GoogleFonts.roboto(
                            fontSize: 14.sp,
                            color: const Color(0xFF9CA3AF),
                          ),
                          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF9CA3AF)),
                          filled: true,
                          fillColor: const Color(0xFFF3F4F6),
                          contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),

                    const Divider(height: 1, color: Color(0xFFE5E7EB)),

                    /// Countries list
                    Expanded(
                      child: filteredCountries.isEmpty
                          ? Center(
                              child: Text(
                                'No country found',
                                style: GoogleFonts.roboto(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF9CA3AF),
                                ),
                              ),
                            )
                          : ListView.separated(
                              itemCount: filteredCountries.length,
                              separatorBuilder: (_, __) => const Divider(
                                height: 1,
                                indent: 56,
                                color: Color(0xFFF3F4F6),
                              ),
                              itemBuilder: (context, index) {
                                final country = filteredCountries[index];
                                final isSelected = selectedCountry.code == country.code;
                                return InkWell(
                                  onTap: () {
                                    onSelectCountry(country);
                                    Navigator.of(bottomSheetContext).pop();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20.w,
                                      vertical: 12.h,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          country.flag,
                                          style: TextStyle(fontSize: 22.sp),
                                        ),
                                        SizedBox(width: 14.w),
                                        Expanded(
                                          child: Text(
                                            country.name,
                                            style: GoogleFonts.roboto(
                                              fontSize: 14.sp,
                                              fontWeight: isSelected
                                                  ? FontWeight.w700
                                                  : FontWeight.w400,
                                              color: isSelected
                                                  ? AppColors.primaryColor
                                                  : const Color(0xFF1F2937),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '+${country.dialCode}',
                                          style: GoogleFonts.roboto(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF6B7280),
                                          ),
                                        ),
                                        if (isSelected) ...[
                                          SizedBox(width: 8.w),
                                          const Icon(
                                            Icons.check_circle_rounded,
                                            color: AppColors.primaryColor,
                                            size: 18,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                );
                              },
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
}
