
import 'package:solala/core/functions/dummy_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:solala/core/widgets/retry_widget.dart';

import '../manager/banners_cubit/banners_cubit.dart';
import '../manager/banners_cubit/banners_state.dart';
import 'banners_sliders.dart';

class BannersSection extends StatelessWidget {
  const BannersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannersCubit, BannersState>(
      builder: (context, state) {
        if (state is BannersLoading) {
          return SliverSkeletonizer(
            child: SliverToBoxAdapter(
              child: BannersSliders(
                bannerData: getDummyBanners(),
              ),
            ),
          );
        } else if (state is BannersFailure) {
          return RetryWidget(message: state.failure.errMessage  , onPressed: () {
            context.read<BannersCubit>().getBanners();
          });
        } else if (state is BannersSuccess) {
          final banners = state.bannersModel.data ?? [];
          if (banners.isEmpty) {
            return const SliverToBoxAdapter(child: SizedBox.shrink());
          }
          return SliverToBoxAdapter(
            child: BannersSliders(
              bannerData: banners,
            ),
          );
        }

        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}
