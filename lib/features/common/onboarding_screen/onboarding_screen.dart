import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:flutter_code_structure/component/button/common_button.dart';
import 'package:flutter_code_structure/component/image/common_image.dart';
import 'package:flutter_code_structure/component/text/common_text.dart';
import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/utils/constants/app_colors.dart';
import 'package:flutter_code_structure/utils/constants/app_images.dart';

class OnboardingItem {
  final String image;
  final String title;
  final String description;

  const OnboardingItem({
    required this.image,
    required this.title,
    required this.description,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _pages = const [
    OnboardingItem(
      image: AppImages.firstOnboardingImage,
      title: 'Food',
      description:
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
    ),
    OnboardingItem(
      image: AppImages.secondOnboardingImage,
      title: 'Food',
      description:
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
    ),
    OnboardingItem(
      image: AppImages.thirdOnboardingImage,
      title: 'Food',
      description:
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.offNamed(AppRoutes.roleSelection);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: true,
          top: true,
          child: Column(
            children: [
              /// Swipeable Page Content (Hero Image + Logo + Text)
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final item = _pages[index];
                    return Column(
                      children: [
                        /// Top Hero Photo
                        SizedBox(
                          width: double.infinity,
                          height: 350.h,
                          child: CommonImage(
                            imageSrc: item.image,
                            width: 428,
                            height: 350,
                            fill: BoxFit.cover,
                          ),
                        ),

                        SizedBox(height: 24.h),

                        /// PLOMOGO Logo (Icon + Wordmark)
                        CommonImage(
                          imageSrc: AppImages.plomogoLogo,
                          height: 56,
                          fill: BoxFit.contain,
                        ),

                        SizedBox(height: 12.h),

                        /// Title
                        CommonText(
                          text: item.title,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textColor,
                        ),

                        SizedBox(height: 12.h),

                        /// Description
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.w),
                          child: CommonText(
                            text: item.description,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF6B7280),
                            maxLines: 8,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              /// Page Indicator Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (index) {
                  final bool isActive = index == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: EdgeInsets.symmetric(horizontal: 3.5.w),
                    width: isActive ? 24.w : 6.w,
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.primaryColor
                          : const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  );
                }),
              ),

              SizedBox(height: 24.h),

              /// Next Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: CommonButton(
                  titleText: 'Next',
                  titleSize: 16,
                  titleWeight: FontWeight.w600,
                  buttonRadius: 10,
                  buttonHeight: 48,
                  buttonColor: AppColors.primaryColor,
                  borderColor: AppColors.primaryColor,
                  onTap: _onNext,
                ),
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}

