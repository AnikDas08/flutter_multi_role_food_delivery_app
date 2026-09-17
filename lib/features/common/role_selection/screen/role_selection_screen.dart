import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:flutter_code_structure/component/button/common_button.dart';
import 'package:flutter_code_structure/component/image/common_image.dart';
import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/features/common/auth/presentation/sign_up/controller/sign_up_controller.dart';
import 'package:flutter_code_structure/services/storage/storage_services.dart';
import 'package:flutter_code_structure/utils/constants/app_colors.dart';
import 'package:flutter_code_structure/utils/constants/app_images.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  Future<void> _onSelectRole(String role) async {
    await LocalStorage.setRole(role);
    final controller = Get.isRegistered<SignUpController>()
        ? Get.find<SignUpController>()
        : Get.put(SignUpController());
    controller.setSelectedRole(role);
    Get.toNamed(AppRoutes.signUp, arguments: {'role': role});
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
              /// Top Supermarket Aisle Photo (60% screen height)
              SizedBox(
                width: double.infinity,
                height: 0.50.sh,
                child: const CommonImage(
                  imageSrc: AppImages.roleSelectionImage,
                  fill: BoxFit.cover,
                ),
              ),

              const Spacer(flex: 2),

              /// Centered PLOMOGO Brand Logo (139w x 72h)
              const CommonImage(
                imageSrc: AppImages.plomogoLogo,
                width: 139,
                height: 72,
                fill: BoxFit.contain,
              ),

              const Spacer(flex: 3),

              /// Three Role Selection Buttons (Customer, Marchant, Driver)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Expanded(
                      child: CommonButton(
                        titleText: 'Customer',
                        titleSize: 14,
                        titleWeight: FontWeight.w600,
                        buttonRadius: 10,
                        buttonHeight: 46,
                        buttonColor: AppColors.primaryColor,
                        borderColor: AppColors.primaryColor,
                        onTap: () => _onSelectRole('customer'),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: CommonButton(
                        titleText: 'Marchant',
                        titleSize: 14,
                        titleWeight: FontWeight.w600,
                        buttonRadius: 10,
                        buttonHeight: 46,
                        buttonColor: AppColors.primaryColor,
                        borderColor: AppColors.primaryColor,
                        onTap: () => _onSelectRole('merchant'),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: CommonButton(
                        titleText: 'Driver',
                        titleSize: 14,
                        titleWeight: FontWeight.w600,
                        buttonRadius: 10,
                        buttonHeight: 46,
                        buttonColor: AppColors.primaryColor,
                        borderColor: AppColors.primaryColor,
                        onTap: () => _onSelectRole('driver'),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 36.h),
            ],
          ),
        ),
      ),
    );
  }
}
