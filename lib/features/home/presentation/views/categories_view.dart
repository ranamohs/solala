import 'package:easy_localization/easy_localization.dart';
import 'package:solala/core/widgets/spacing.dart';
import 'package:solala/features/home/presentation/widgets/categories_grid_view_section.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';

class AllCategoriesView extends StatelessWidget{
  const AllCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(AppStrings.categories.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            VerticalSpace(32),
            Expanded(child: AllCategoriesGridViewSection()),
          ],
        ),
      ),
    );
  }
}