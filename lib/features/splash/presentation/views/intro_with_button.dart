
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/functions/navigation.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/widgets/fixit_buttons.dart';


class IntroWithButton extends StatelessWidget {
  const IntroWithButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.white,
              AppColors.splashColor,
            ],
          ),

        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            Image.asset(
             AppAssets.introImage,
              height: 200.h,
            ),
            SizedBox(height: 20.h),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 30.w),
              child: Text(
                AppStrings.introWithButton.tr(),
                textAlign: TextAlign.center,
                style: AppStyles.styleMedium16(context),
              ),
            ),
            const Spacer(flex: 1),
            SizedBox(
              width: 200,
              child: PrimaryButton(
                text: AppStrings.next.tr(),
                onPressed : () {
                  customGo(context, AppRouter.loginView);
                },
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
