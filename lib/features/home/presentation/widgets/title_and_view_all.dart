import 'package:solala/core/constants/app_colors.dart';
import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/core/constants/app_styles.dart';
import 'package:solala/core/functions/run_if_connected.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TitleAndViewAll extends StatelessWidget {
  const TitleAndViewAll({
    super.key,
    required this.title,
    required this.onPressed,
    this.viewAllText,
  });

  final String title;
  final void Function() onPressed;
  final String? viewAllText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppStyles.styleSemiBold16(context)
              .copyWith(color: AppColors.pureBlackColor),
        ),
        TextButton(
          onPressed: () {
            runIfConnected(context: context, onConnected: onPressed);
          },
          child: Text(
            viewAllText ?? AppStrings.viewAll.tr(),
            style: AppStyles.styleMedium14(context)
                .copyWith(color: AppColors.primaryColor),
          ),
        ),
      ],
    );
  }
}