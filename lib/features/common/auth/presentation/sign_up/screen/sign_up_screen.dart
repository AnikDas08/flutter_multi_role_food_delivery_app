import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:flutter_code_structure/component/app_bar/common_app_bar.dart';
import 'package:flutter_code_structure/component/button/common_button.dart';
import 'package:flutter_code_structure/component/text/common_text.dart';
import 'package:flutter_code_structure/utils/constants/app_colors.dart';
import 'package:flutter_code_structure/utils/extensions/extension.dart';
import '../controller/sign_up_controller.dart';
import '../widgets/already_account_rich_text.dart';
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
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CommonAppBar(
          title: 'Create an Account',
          titleSize: 30,
        ),
        body: GetBuilder<SignUpController>(
          builder: (controller) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// Header Subtitle
                    const CommonText(
                      text: 'Create an account or log in to\nexplore about our app',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6B7280),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      top: 4,
                      bottom: 16,
                    ),

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
            );
          },
        ),
      ),
    );
  }
}
