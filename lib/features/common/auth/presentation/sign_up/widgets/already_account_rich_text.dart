import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_code_structure/config/route/app_routes.dart';
import 'package:flutter_code_structure/utils/constants/app_colors.dart';
import 'package:flutter_code_structure/utils/constants/app_string.dart';

import '../../../../../../services/storage/storage_services.dart';

class AlreadyAccountRichText extends StatelessWidget {
  const AlreadyAccountRichText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Already have an account? ',
            style: GoogleFonts.roboto(
              color: const Color(0xFF6B7280),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: 'Sign In',
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.toNamed(
                  AppRoutes.signIn,
                  arguments: {'role': LocalStorage.myRole},
                );
              },
            style: GoogleFonts.roboto(
              color: AppColors.primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primaryColor,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
