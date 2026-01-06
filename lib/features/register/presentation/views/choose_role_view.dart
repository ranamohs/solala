import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/core/constants/app_styles.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/functions/navigation.dart';
import '../../../../core/routes/app_router.dart';

class ChooseRoleView extends StatelessWidget {
  const ChooseRoleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.authBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
       SizedBox(height: 24.h),
                Image.asset(
                  AppAssets.treeImage,
                  height:100.h,
                ),
                 SizedBox(height: 24.h),
                 Text(
                  AppStrings.welcomeBack.tr(),
                  style: AppStyles.styleMedium22(context).copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                 SizedBox(height: 8.h),
                 Text(
                  'اختر نوع حسابك للمتابعة',
                  style: AppStyles.styleRegular16(context).copyWith(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                 SizedBox(height: 60.h),
                _GradientRoleCard(
                  title: 'إضافة أسرة',
                  description: 'استخدم رمز الاسرة للانضمام اليها',
                  icon: Icons.person,
                  onTap: () {
                    customPush(
                        context, AppRouter.registerView);
                  },
                ),
                 SizedBox(height: 24.h),
                _GradientRoleCard(
                  title: 'أنشئ أسرة جديدة',
                  description: 'أنشئ أسرة تجريبية واستفد من مزايا شجرتنا',
                  icon: Icons.family_restroom,
                  onTap: () {
                    customPush(
                        context, AppRouter.providerRegisterView);
                  },
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GradientRoleCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _GradientRoleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_GradientRoleCard> createState() => _GradientRoleCardState();
}

class _GradientRoleCardState extends State<_GradientRoleCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFBF994B), Color(0xFF01271C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20.r,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(widget.icon, size: 30.sp, color: Colors.white),
              ),
               SizedBox(width: 20.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: AppStyles.styleMedium20(context).copyWith(
                        color: Colors.white,
                      ),
                    ),
                     SizedBox(height: 6.h),
                    Text(
                      widget.description,
                      style: AppStyles.styleRegular12(context).copyWith(
                        color: Colors.white.withOpacity(0.95),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white.withOpacity(0.9),
                size: 24.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
