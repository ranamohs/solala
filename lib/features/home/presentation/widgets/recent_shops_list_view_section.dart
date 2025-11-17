import 'package:easy_localization/easy_localization.dart';
import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/core/functions/dummy_lists.dart';
import 'package:solala/core/widgets/retry_widget.dart';
import 'package:solala/features/home/presentation/manager/recent_shops_cubit/recent_shops_cubit.dart';
import 'package:solala/features/home/presentation/manager/recent_shops_cubit/recent_shops_state.dart';
import 'package:solala/features/home/presentation/widgets/recent_shops_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RecentShopsListViewSection extends StatelessWidget {
  const RecentShopsListViewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RcenetShopsCubit, RcenetShopsState>(
        builder: (context, state) {
          if (state is RcenetShopsLoading) {
            return Skeletonizer(
                child: RecentShopsListView(categories: getDummyCategories()));
          } else if (state is RcenetShopsSuccess) {
            final shops = state.categoriesModel.data.take(4).toList();
            return RecentShopsListView(categories: shops);
          } else if (state is RcenetShopsFailure) {
            return RetryWidget(
              message: state.failure.errMessage,
              onPressed: () {
                context.read<RcenetShopsCubit>().getRcenetShops();
              },
            );
          } else {
            return RetryWidget(
              message: AppStrings.unexpectedError.tr(),
              onPressed: () {
                context.read<RcenetShopsCubit>().getRcenetShops();
              },
            );
          }
        });
  }
}

