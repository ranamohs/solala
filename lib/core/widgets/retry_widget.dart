import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/core/widgets/error_container.dart';
import 'package:solala/core/widgets/spacing.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'app_buttons.dart';

class RetryWidget extends StatelessWidget {
  const RetryWidget({
    super.key, required this.message, required this.onPressed,
  });

  final String message;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ErrorContainer(message: message),
          VerticalSpace(8),
          RetryButton(
              text: AppStrings.retry.tr(),
              onPressed: onPressed
          )
        ],
      ),
    );
  }
}