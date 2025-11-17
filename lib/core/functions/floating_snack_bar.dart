import 'package:solala/core/constants/app_colors.dart';
import 'package:solala/core/constants/app_styles.dart';
import 'package:solala/core/widgets/spacing.dart';
import 'package:flutter/material.dart';

void floatingSnackBar(BuildContext context, String message,
    {IconData? icon,
    double? iconSize,
    Color? boxColor,
    Color? iconColor,
    int? durationInSeconds}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: AppColors.pureBlackColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      duration: Duration(seconds: durationInSeconds ?? 3),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          icon != null
              ? Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(64),
                    color: boxColor ?? Colors.green,
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? AppColors.pureWhiteColor,
                    size: iconSize ?? 24,
                  ),
                )
              : const SizedBox(),
          const HorizontalSpace(8),
          message.length <= 32
              ? Text(
                  message,
                  style: AppStyles.styleSemiBold14(context)
                      .copyWith(color: AppColors.offWhiteColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.6,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      message,
                      style: AppStyles.styleSemiBold14(context)
                          .copyWith(color: AppColors.offWhiteColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )),
        ],
      ),
    ),
  );
}
