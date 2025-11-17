import 'package:solala/core/constants/app_colors.dart' show AppColors;
import 'package:flutter/material.dart';

class PrimaryCircularProgressIndicator extends StatelessWidget {
  const PrimaryCircularProgressIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      backgroundColor: AppColors.primaryColor,
      color: AppColors.pureWhiteColor,
    );
  }
}

class PrimaryRefreshIndicator extends StatelessWidget {
  const PrimaryRefreshIndicator(
      {super.key, required this.child, required this.onRefresh});

  final Widget child;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        elevation: 0,
        strokeWidth: 2.5,
        backgroundColor: AppColors.primaryColor,
        color: AppColors.pureWhiteColor,
        onRefresh: onRefresh,
        child: child);
  }
}