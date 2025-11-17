import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/core/functions/dummy_lists.dart';
import 'package:solala/core/widgets/retry_widget.dart';
import 'package:solala/features/home/presentation/manager/categories_cubit/categories_cubit.dart';
import 'package:solala/features/home/presentation/manager/categories_cubit/categories_state.dart';
import 'package:solala/features/home/presentation/widgets/categories_grid_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/widgets/fixit_indicators.dart';

class AllCategoriesGridViewSection extends StatelessWidget {
  const AllCategoriesGridViewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryRefreshIndicator(
      onRefresh: ()async{
        context.read<CategoriesCubit>().getCategories();
      },
      child: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
          if (state is CategoriesLoading) {
            return Skeletonizer(child: CategoriesGridView(categories: getDummyCategories()));
          } else if (state is CategoriesSuccess) {
            final categories = state.categoriesModel.data;
            return CategoriesGridView(
              categories: categories,
            );
          } else if (state is CategoriesFailure) {
            return RetryWidget(
              message: state.failure.errMessage,
              onPressed: (){
                context.read<CategoriesCubit>().getCategories();
              },
            );
          } else {
            return RetryWidget(
              message: AppStrings.unexpectedError.tr(),
              onPressed: (){
                context.read<CategoriesCubit>().getCategories();
              },
            );
          }
        },
      ),
    );
  }
}