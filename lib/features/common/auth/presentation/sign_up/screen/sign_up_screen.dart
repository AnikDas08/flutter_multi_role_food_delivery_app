import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:flutter_code_structure/component/app_bar/common_app_bar.dart';
import 'package:flutter_code_structure/component/button/common_button.dart';
import 'package:flutter_code_structure/component/text/common_text.dart';
import 'package:flutter_code_structure/utils/constants/app_colors.dart';
import 'package:flutter_code_structure/utils/extensions/extension.dart';
import '../../../../../../config/route/app_routes.dart';
import '../../../../../../services/storage/storage_services.dart';
import '../controller/sign_up_controller.dart';
import '../widgets/already_account_rich_text.dart';
import '../widgets/driver_sign_up_view.dart';
import '../widgets/merchant_sign_up_view.dart';
import '../widgets/profile_image_picker_widget.dart';
import '../widgets/sign_up_all_field.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final _formKey = GlobalKey<FormState>();

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
      child: GetBuilder<SignUpController>(
        init: Get.isRegistered<SignUpController>()
            ? Get.find<SignUpController>()
            : Get.put(SignUpController()),
        initState: (_) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final ctrl = Get.isRegistered<SignUpController>()
                ? Get.find<SignUpController>()
                : Get.put(SignUpController());
            final argsRole = (Get.arguments != null && Get.arguments is Map)
                ? Get.arguments['role']
                : null;
            final savedRole = argsRole ?? LocalStorage.myRole;
            if (savedRole != null && savedRole.toString().isNotEmpty) {
              ctrl.setSelectedRole(savedRole.toString());
            }
          });
        },
        builder: (controller) {
          if (controller.isDriver) {
            return DriverSignUpView(controller: controller);
          }
          if (controller.isMerchant) {
            return MerchantSignUpView(controller: controller);
          }

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: const CommonAppBar(
              title: 'Create an Account',
              titleSize: 30,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// Header Subtitle
                    CommonText(
                      text: controller.signUpDescription,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6B7280),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      top: 4,
                      bottom: 16,
                    ),

                    /// Profile Image
                    ProfileImagePickerWidget(
                      controller: controller,
                      sheetTitle: 'Customer Profile Photo',
                    ),

                    SizedBox(height: 16.h),

                    /// Input Fields
                    SignUpAllField(controller: controller),

                    24.height,

                    /// "Create a Account" Button
                    CommonButton(
                      titleText: 'Create a Account',
                      titleSize: 16,
                      titleWeight: FontWeight.w600,
                      buttonRadius: 10,
                      buttonHeight: 50,
                      buttonColor: AppColors.primaryColor,
                      borderColor: AppColors.primaryColor,
                      isLoading: controller.isLoading,
                      onTap: () {
                        if (!_formKey.currentState!.validate()) return;
                        controller.signUpUser();
                      },
                    ),

                    24.height,

                    /// Already have an account? Sign In
                    const AlreadyAccountRichText(),

                    30.height,
                  ],
                ),
              ),
            ),
          ),
        );
        },
      ),
    );
  }
}
