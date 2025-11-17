import 'package:solala/core/constants/app_colors.dart';
import 'package:solala/core/functions/is_arabic.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class BackIconButton extends StatelessWidget {
  const BackIconButton({
    super.key,
    this.iconColor,
  });
  final Color? iconColor;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: 28,
      onPressed: () {
        GoRouter.of(context).pop();
      },
      color: iconColor ?? AppColors.primaryColor,
      icon: Icon(
       isArabic(context)?  FontAwesomeIcons.arrowRight : FontAwesomeIcons.arrowLeft,
        size: 28,
      ),
    );
  }
}