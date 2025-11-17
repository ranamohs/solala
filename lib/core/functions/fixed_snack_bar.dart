import 'package:solala/core/constants/app_colors.dart' show AppColors;
import 'package:solala/core/constants/app_colors.dart';
import 'package:solala/core/constants/app_styles.dart';
import 'package:solala/core/widgets/spacing.dart';
import 'package:flutter/material.dart';

void fixedSnackBar(
    BuildContext context, {
      String? message,
      IconData? icon,
      Color? iconColor,
      double? iconSize,
      Color? boxColor,
      Color? iconBgColor,
      Color? textColor,
      int? durationInSeconds,
    }) {
  final messenger = ScaffoldMessenger.of(context);

  messenger.clearSnackBars();

  final bg = boxColor ?? AppColors.lightGreyColor.withValues(alpha: 0.7);
  final iColor = iconColor ?? Colors.green;
  final iBg = iconBgColor;
  final tColor = textColor ?? AppColors.pureWhiteColor;

  messenger.showSnackBar(
    SnackBar(
      backgroundColor: bg,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
      duration: Duration(seconds: durationInSeconds ?? 3),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(vertical: 64, horizontal: 16),
      elevation: 6,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            iBg != null
                ? Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(64),
                color: iBg,
              ),
              child: Icon(
                icon,
                color: iColor,
                size: iconSize ?? 32,
              ),
            )
                : Icon(
              icon,
              color: iColor,
              size: iconSize ?? 32,
            ),
            const HorizontalSpace(8),
          ],
          Flexible(
            child: Text(
              message ?? '',
              textAlign: TextAlign.center,
              style: AppStyles.styleSemiBold14(context).copyWith(color: tColor),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
}