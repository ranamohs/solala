import 'package:solala/core/constants/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:solala/core/constants/app_strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/functions/navigation.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/widgets/fixit_buttons.dart';

class SuccessDialog extends StatelessWidget {
  final VoidCallback onRateService;

  const SuccessDialog({
    super.key,
    required this.onRateService,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon
           Image.asset(AppAssets.successDialog , width: 100, height: 100,),
             SizedBox(height: 16.h),
            // Success Title
            Text(
              AppStrings.success.tr(),
              style:AppStyles.styleSemiBold16(context)
            ),
             SizedBox(height: 8.h),
            // Success Message
            Text(
              AppStrings.requestSentSuccessfully.tr(),
              textAlign: TextAlign.center,
            style: AppStyles.styleMedium14(context)
            ),

             SizedBox(height: 24.h),

            // Rate Service Button
            PrimaryButton(
              onPressed: onRateService,
              text: AppStrings.rateService.tr(),
            ),

             SizedBox(height: 12.h),

            // Close Button
           PrimaryButton(
            onPressed: () {
              customGo(context, AppRouter.homePage);
            },
            text: AppStrings.cancel.tr(),
           ),
          ],
        ),
      ),
    );
  }
}