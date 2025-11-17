import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/widgets/fixit_buttons.dart';

class VerificationSuccessWidget extends StatelessWidget {
  const VerificationSuccessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.homeBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Image.asset(
                AppAssets.otpCheckIcon,
                width: 200.w,
                height: 200.h,
              ),
              SizedBox(height: 24.h),
              Text(
                AppStrings.thankYou.tr(),
                style: AppStyles.styleSemiBold24(context),
              ),
              SizedBox(height: 8.h),
              Text(
                AppStrings.verificationHasDone.tr(),
                style: AppStyles.styleMedium16(context),
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 42.w),
                child: PrimaryButton(
                  onPressed: () {
                    GoRouter.of(context).push(AppRouter.homePage);
                  },
                  text: AppStrings.next.tr(),
                ),
              ),
              SizedBox(height: 48.h),
            ],
          ),
        ),
      ),
    );
  }
}
