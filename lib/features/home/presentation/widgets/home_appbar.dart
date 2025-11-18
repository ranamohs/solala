import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solala/core/constants/app_strings.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';

class HomeAppbar extends StatelessWidget {
  final bool isArabic;

  const HomeAppbar({
    super.key,
    this.isArabic = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

     Text(
      AppStrings.welcomeToTheFamilyTree.tr() + ' ' + "👋" ,
      style: AppStyles.styleBold18( context).copyWith(color: AppColors.greenColor),
     ),


      ],
    );
  }


}