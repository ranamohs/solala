
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_styles.dart';

class FamilyTreeView extends StatelessWidget {
  const FamilyTreeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
       image: DecorationImage(
         image: AssetImage(AppAssets.homeBackground),
         fit: BoxFit.cover,
       )
      ),
      child:  Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title:  Text(
           AppStrings.familyTree.tr(),
            style: AppStyles.styleBold18(context).copyWith(color: AppColors.greenColor),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Text('Family Tree'),
        ),

      ),
    );
  }
}
