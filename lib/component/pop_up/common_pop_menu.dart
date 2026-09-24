import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../config/route/app_routes.dart';
import '../../../utils/app_snackbar.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_string.dart';
import '../../services/storage/storage_services.dart';
import '../../utils/helpers/validation.dart';
import '../button/common_button.dart';
import '../text/common_text.dart';
import '../text_field/common_text_field.dart';

class PopUpMenu extends StatelessWidget {
  const PopUpMenu({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onTap,
    this.height = 30,
    this.selectedColor = AppColors.primaryColor,
    this.unselectedColor = Colors.transparent,
    this.style,
    this.isContainer = false,
    this.iconColor = AppColors.black,
    this.iconData = Icons.keyboard_arrow_down_outlined,
  });

  final List<String> items;
  final List<String> selectedItem;
  final Color selectedColor;
  final Color iconColor;
  final Color unselectedColor;
  final double height;
  final Function(int index) onTap;
  final TextStyle? style;
  final bool isContainer;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.h,
      child: PopupMenuButton<String>(
        shape: RoundedRectangleBorder(
          borderRadius: .circular(8.r),
          side: BorderSide(color: selectedColor),
        ),
        offset: const Offset(1, 1),
        padding: .zero,
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: 'option1',
            child: Column(
              children: List.generate(
                items.length,
                (index) => GestureDetector(
                  onTap: () async {
                    await AnimationPopUpState.closeDialog();
                    onTap(index);
                  },
                  child: Padding(
                    padding: const .all(12.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const .all(10),
                          decoration: BoxDecoration(
                            border: .all(color: selectedColor),
                            color:
                                selectedItem.contains(items[index].toString())
                                ? selectedColor
                                : unselectedColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(items[index].toString(), style: style),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        icon: Padding(
          padding: .only(left: isContainer ? 40 : 0),
          child: Icon(iconData, color: iconColor, size: height),
        ),
      ),
    );
  }
}

void logOutPopUp({VoidCallback? onConfirm}) {
  Get.dialog(
    Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Soft Red Icon Header
            Container(
              width: 60.w,
              height: 60.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFEE2E2),
              ),
              child: Center(
                child: Icon(
                  Icons.logout_rounded,
                  color: const Color(0xFFEF4444),
                  size: 28.sp,
                ),
              ),
            ),

            SizedBox(height: 18.h),

            /// Title
            Text(
              'Log Out',
              style: GoogleFonts.roboto(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E293B),
              ),
            ),

            SizedBox(height: 8.h),

            /// Subtitle
            Text(
              'Are you sure you want to log out?\nYou will need to sign in again to access your account.',
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF64748B),
                height: 1.45,
              ),
            ),

            SizedBox(height: 24.h),

            /// Actions Row: Cancel & Log Out
            Row(
              children: [
                /// Cancel Button
                Expanded(
                  child: SizedBox(
                    height: 46.h,
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFFE2E8F0),
                          width: 1.2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        backgroundColor: Colors.white,
                        elevation: 0,
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 12.w),

                /// Confirm Log Out Button
                Expanded(
                  child: SizedBox(
                    height: 46.h,
                    child: ElevatedButton(
                      onPressed: () async {
                        Get.back();
                        if (onConfirm != null) {
                          onConfirm();
                        } else {
                          await LocalStorage.removeAllPrefData();
                          Get.offAllNamed(AppRoutes.roleSelection);
                          AppSnackbar.success(
                            title: 'Logged Out',
                            message: 'You have been logged out successfully.',
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                      ),
                      child: Text(
                        'Log Out',
                        style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: true,
  );
}

void showDeleteAccountPopUp({
  void Function(String password)? onConfirm,
}) {
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final isPasswordHidden = true.obs;
  final isDeleting = false.obs;

  Get.dialog(
    Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 22.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Soft Red Icon Header with Trash Icon
              Container(
                width: 60.w,
                height: 60.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFEE2E2),
                ),
                child: Center(
                  child: Icon(
                    Icons.delete_forever_rounded,
                    color: const Color(0xFFEF4444),
                    size: 28.sp,
                  ),
                ),
              ),

              SizedBox(height: 18.h),

              /// Title
              Text(
                'Delete Account',
                style: GoogleFonts.roboto(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E293B),
                ),
              ),

              SizedBox(height: 8.h),

              /// Subtitle
              Text(
                'Are you sure you want to delete your account? This action is permanent and all your data will be permanently removed.',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF64748B),
                  height: 1.45,
                ),
              ),

              SizedBox(height: 20.h),

              /// Password Input Field
              Obx(
                () => TextFormField(
                  controller: passwordController,
                  obscureText: isPasswordHidden.value,
                  style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    color: const Color(0xFF1E293B),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your password to confirm';
                    }
                    if (value.trim().length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    hintStyle: GoogleFonts.roboto(
                      fontSize: 13.5.sp,
                      color: const Color(0xFF94A3B8),
                    ),
                    prefixIcon: const Icon(
                      Icons.lock_outline_rounded,
                      size: 20,
                      color: Color(0xFF64748B),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordHidden.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                        color: const Color(0xFF64748B),
                      ),
                      onPressed: () {
                        isPasswordHidden.value = !isPasswordHidden.value;
                      },
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: const BorderSide(
                        color: Color(0xFFE2E8F0),
                        width: 1.2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: const BorderSide(
                        color: Color(0xFFE2E8F0),
                        width: 1.2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: const BorderSide(
                        color: Color(0xFFEF4444),
                        width: 1.5,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: const BorderSide(
                        color: Color(0xFFEF4444),
                        width: 1.2,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              /// Action Buttons Row
              Row(
                children: [
                  /// Cancel Button
                  Expanded(
                    child: SizedBox(
                      height: 46.h,
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFFE2E8F0),
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          backgroundColor: Colors.white,
                          elevation: 0,
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.roboto(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  /// Delete Button
                  Expanded(
                    child: SizedBox(
                      height: 46.h,
                      child: Obx(
                        () => ElevatedButton(
                          onPressed: isDeleting.value
                              ? null
                              : () async {
                                  if (!formKey.currentState!.validate()) return;
                                  isDeleting.value = true;
                                  final enteredPassword =
                                      passwordController.text.trim();
                                  Get.back();
                                  if (onConfirm != null) {
                                    onConfirm(enteredPassword);
                                  } else {
                                    await LocalStorage.removeAllPrefData();
                                    Get.offAllNamed(AppRoutes.roleSelection);
                                    AppSnackbar.success(
                                      title: 'Account Deleted',
                                      message:
                                          'Your account has been deleted permanently.',
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEF4444),
                            disabledBackgroundColor:
                                const Color(0xFFEF4444).withValues(alpha: 0.6),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.r),
                            ),
                          ),
                          child: isDeleting.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Delete',
                                  style: GoogleFonts.roboto(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: true,
  );
}

void deletePopUp({
  required TextEditingController controller,
  required VoidCallback onTap,
  bool isLoading = false,
}) {
  final formKey = GlobalKey<FormState>();
  showDialog(
    context: Get.context!,
    builder: (context) {
      return AnimationPopUp(
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: .circular(12.0)),
          contentPadding: const .only(bottom: 12),
          title: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Center(
                  child: CommonText(
                    text: AppString.areYouSure,
                    fontSize: 20.sp,
                    fontWeight: .w700,
                    bottom: 24.h,
                  ),
                ),
                CommonText(
                  text: AppString.deleteDetails,
                  fontSize: 16.sp,
                  maxLines: 2,
                  bottom: 20.h,
                ),
                CommonTextField(
                  controller: controller,
                  labelText: AppString.enterYouPassword,
                  validator: AppValidation.required,
                ),
              ],
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: CommonButton(
                    titleText: AppString.cancel,
                    titleColor: AppColors.black,
                    borderColor: AppColors.black,
                    buttonColor: AppColors.transparent,
                    buttonRadius: 4.r,
                    buttonHeight: 48.h,
                    onTap: AnimationPopUpState.closeDialog,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: CommonButton(
                    titleText: AppString.done,
                    buttonRadius: 4.r,
                    buttonHeight: 48.h,
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        await AnimationPopUpState.closeDialog();
                        onTap();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

class AnimationPopUp extends StatefulWidget {
  const AnimationPopUp({super.key, required this.child});

  final Widget child;

  @override
  AnimationPopUpState createState() => AnimationPopUpState();
}

class AnimationPopUpState extends State<AnimationPopUp>
    with TickerProviderStateMixin {
  static late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  static Future<void> closeDialog() async {
    await _animationController.reverse();
    if (Get.context!.mounted) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: FadeTransition(
            opacity: ModalRoute.of(context)!.animation!,
            child: widget.child,
          ),
        );
      },
    );
  }
}
