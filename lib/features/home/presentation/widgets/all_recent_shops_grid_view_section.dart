import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/core/functions/dummy_lists.dart';
import 'package:solala/core/widgets/retry_widget.dart';
import 'package:solala/features/home/presentation/manager/recent_shops_cubit/recent_shops_cubit.dart';
import 'package:solala/features/home/presentation/manager/recent_shops_cubit/recent_shops_state.dart';
import 'package:solala/features/home/presentation/widgets/all_recent_shops_grid_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/widgets/fixit_indicators.dart';

class AllRecentShopsGridViewSection extends StatelessWidget {
  const AllRecentShopsGridViewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryRefreshIndicator(
      onRefresh: ()async{
        context.read<RcenetShopsCubit>().getRcenetShops();
      },
      child: BlocBuilder<RcenetShopsCubit, RcenetShopsState>(
        builder: (context, state) {
          if (state is RcenetShopsLoading) {
            return Skeletonizer(child: AllRecentShopsGridView(categories: getDummyCategories()));
          } else if (state is RcenetShopsSuccess) {
            final categories = state.categoriesModel.data;
            return AllRecentShopsGridView(
              categories: categories,
            );
          } else if (state is RcenetShopsFailure) {
            return RetryWidget(
              message: state.failure.errMessage,
              onPressed: (){
                context.read<RcenetShopsCubit>().getRcenetShops();
              },
            );
          } else {
            return RetryWidget(
              message: AppStrings.unexpectedError.tr(),
              onPressed: (){
                context.read<RcenetShopsCubit>().getRcenetShops();
              },
            );
          }
        },
      ),
    );
  }
}