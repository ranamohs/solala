import 'package:solala/core/functions/run_if_connected.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:solala/core/constants/app_assets.dart';
import 'package:solala/core/constants/app_colors.dart';
import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/core/constants/app_styles.dart';
import 'package:solala/core/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    this.text,
    required this.onPressed,
    this.child,
    this.isLoading = false,
  }) : assert(text != null || child != null, 'Provide either text or child');

  final String? text;
  final Widget? child;
  final bool isLoading;

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.offWhiteColor,
          shape: RoundedRectangleBorder(
            // side: BorderSide(
            //   color: AppColors.pureWhiteColor,
            // ),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: ()=> runIfConnected(
            context: context,
            onConnected: onPressed
        ),
        child: FittedBox(
          child:
              child ??
              Text(
                text!,
                style: AppStyles.styleBold18(context).copyWith(color: AppColors.pureWhiteColor),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
        ),
      ),
    );
  }
}

class NextButton extends StatelessWidget {
  const NextButton({
    super.key,
    this.text,
    required this.onPressed,
    this.child,
    this.height,
  }) : assert(text != null || child != null, 'Provide either text or child');

  final String? text;
  final Widget? child;
  final double? height;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: 256,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.offWhiteColor,
          shape: RoundedRectangleBorder(
            // side: BorderSide(
            //   color: AppColors.pureWhiteColor,
            // ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: ()=> runIfConnected(
            context: context,
            onConnected: onPressed
        ),
        child: FittedBox(
          child:
          child ??
              Text(
                text!,
                style: AppStyles.styleBold18(context).copyWith(color: AppColors.pureWhiteColor),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
        ),
      ),
    );
  }
}


class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.text,
    required this.onPressed,
    this.child,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
  }) : assert(text != null || child != null, 'Provide either text or child');

  final String? text;
  final Widget? child;
  final void Function() onPressed;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primaryColor,
        foregroundColor: AppColors.offWhiteColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor ?? AppColors.primaryColor),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      onPressed: onPressed,
      child: FittedBox(
        child:
            child ??
            FittedBox(
              child: Text(
                text!,
                style: AppStyles.styleSemiBold14(
                  context,
                ).copyWith(color: textColor),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    this.text,
    required this.onPressed,
    this.backgroundColor,
    this.child,
    this.borderColor,
  });

  final String? text;
  final Widget? child;
  final void Function() onPressed;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.pureWhiteColor,
        foregroundColor: AppColors.offWhiteColor,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor ?? AppColors.primaryColor),
          borderRadius: BorderRadius.circular(32),
        ),
      ),
      onPressed: onPressed,
      child: FittedBox(
        child:
            child ??
            Text(
              text ?? '',
              style: AppStyles.styleSemiBold14(
                context,
              ).copyWith(color: AppColors.primaryColor),
            ),
      ),
    );
  }
}

class RetryButton extends StatelessWidget {
  const RetryButton({super.key, this.text, required this.onPressed, this.child})
    : assert(text != null || child != null, 'Provide either text or child');

  final String? text;
  final Widget? child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.offWhiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child:
            child ??
            Text(
              text!,
              style: AppStyles.styleSemiBold18(
                context,
              ).copyWith(color: AppColors.pureWhiteColor),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
      ),
    );
  }
}

class CallButton extends StatelessWidget {
  const CallButton({super.key, this.text, required this.onPressed, this.child})
    : assert(text != null || child != null, 'Provide either text or child');

  final String? text;
  final Widget? child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      width: MediaQuery.sizeOf(context).width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor.withValues(alpha: 0.8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        onPressed: onPressed,
        child: FittedBox(
          child:
              child ??
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppAssets.phoneIcon,
                    height: 36,
                    colorFilter: ColorFilter.mode(
                      AppColors.pureWhiteColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  HorizontalSpace(8),
                  Localizations.override(
                    locale: Locale('en'),
                    context: context,
                    child: Text(
                      text!,
                      style: AppStyles.styleExtraBold20(
                        context,
                      ).copyWith(color: AppColors.pureWhiteColor),
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}

class CancelButton extends StatelessWidget {
  const CancelButton({
    super.key,
    this.text,
    required this.onPressed,
    this.child,
  });

  final String? text;
  final Widget? child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: onPressed,
        child: FittedBox(
          child:
              child ??
              Text(
                text ?? '',
                style: AppStyles.styleRegular14(
                  context,
                ).copyWith(color: AppColors.pureBlackColor),
              ),
        ),
      ),
    );
  }
}

class DeleteAccountButton extends StatelessWidget {
  const DeleteAccountButton({super.key, required this.onPressed});
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.offGreyColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: Text(
        AppStrings.deleteAccount.tr(),
        style: AppStyles.styleSemiBold18(
          context,
        ).copyWith(color: Colors.red.shade500),
      ),
    );
  }
}


class LanguageButton extends StatelessWidget {
  final String flagAsset;
  final String languageName;
  final bool isSelected;
  final double flagWidth;
  final double flagHeight;
  final bool isFlagImage;
  final VoidCallback onTap;

  const LanguageButton({
    Key? key,
    required this.flagAsset,
    required this.languageName,
    required this.isSelected,
    required this.flagWidth,
    required this.flagHeight,
    required this.isFlagImage,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            if (isFlagImage)
              Image.asset(
                flagAsset,
                width: flagWidth,
                height: flagHeight,
              )
            else
              Text(
                flagAsset,
                style: TextStyle(fontSize: 24.sp),
              ),
            SizedBox(width: 12.w),
            Text(
              languageName,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
