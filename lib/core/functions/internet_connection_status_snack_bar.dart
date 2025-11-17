import 'package:solala/core/constants/app_colors.dart';
import 'package:solala/core/constants/app_styles.dart';
import 'package:flutter/material.dart';

void internetConnectionStatusSnackBar(BuildContext context,
    {bool? isConnected}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: isConnected! ? Colors.green : Colors.red,
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      duration: const Duration(seconds: 3),
      content: Center(
        child: Text(isConnected ? 'متصل بالإنترنت' : ' غير متصل بالإنترنت',
            style: AppStyles.styleMedium16(context)
                .copyWith(color: AppColors.offWhiteColor)),
      ),
    ),
  );
}
