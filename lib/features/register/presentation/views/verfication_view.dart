import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/widgets/fixit_buttons.dart';

class VerificationView extends StatelessWidget {
  const VerificationView({super.key});

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
        body: Column(
          children: [
         
            Container(
              width: double.infinity,
              height: 70.h,
              padding:  EdgeInsets.symmetric(horizontal: 20.h, vertical: 14.w),
              decoration:  BoxDecoration(
                color:AppColors.secondaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12.r),
                  bottomRight: Radius.circular(12.r),
                ),
              ),
              child:  Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppStrings.verification,
                  style:AppStyles.styleSemiBold18(context).copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ),

             SizedBox(height: 100.h),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20.h),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: size.height * 0.25.h,
                      child: Image.asset(
                        AppAssets.verificationImage,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
             SizedBox(height: 24.h),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 32.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  4,
                      (index) => _OtpCircle(index: index),
                ),
              ),
            ),
             SizedBox(height: 24.h),
             Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    'Please enter the OTP sent to',
                    textAlign: TextAlign.center,
                    style: AppStyles.styleMedium14(context).copyWith(
                      color: AppColors.pureBlackColor,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Your Number',
                    textAlign: TextAlign.center,
                    style: AppStyles.styleMedium14(context).copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 42.w),
              child: PrimaryButton(
                onPressed: () {},
                text: AppStrings.send,
              ),
            ),

             SizedBox(height: 16.h),

            Padding(
              padding:  EdgeInsets.only(bottom: 24.h),
              child: RichText(
                text:  TextSpan(
                  style: AppStyles.styleMedium14(context).copyWith(
                    color: AppColors.pureBlackColor,
                  ),
                  children: [
                    TextSpan(text: "Didn't get the code? "),
                    TextSpan(
                      text: 'Resend',
                      style: AppStyles.styleMedium14(context).copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _OtpCircle extends StatelessWidget {
  final int index;
  const _OtpCircle({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey.shade400,
          width: 1.6,
        ),
        color: Colors.white.withOpacity(0.8),
      ),
      alignment: Alignment.center,
      child: Text(
        '', // هتربطيه بحقل إدخال بعدين لو حابة
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
