import 'package:solala/core/constants/app_colors.dart';
import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/core/constants/app_styles.dart';
import 'package:solala/core/widgets/retry_widget.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:solala/features/shops/presentation/widgets/services_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/fixit_indicators.dart';
import '../manager/shops_cubit/shops_cubit.dart';
import '../manager/shops_cubit/shops_state.dart';

class ShopsListViewSection extends StatefulWidget {
  final int categoryId;

  const ShopsListViewSection({super.key, required this.categoryId});

  @override
  State<ShopsListViewSection> createState() =>
      _ShopsListViewSectionState();
}

class _ShopsListViewSectionState extends State<ShopsListViewSection> {
  final ScrollController _scrollController = ScrollController();

  void _setupScrollListener() {
    _scrollController.addListener(() {
      final cubit = context.read<ShopsCubit>();
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      final threshold = 100;

      if (maxScroll - currentScroll <= threshold && !cubit.isLoadingMore) {
        cubit.loadNextPage(widget.categoryId);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _setupScrollListener();
    context.read<ShopsCubit>().getShops(categoryId: widget.categoryId);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryRefreshIndicator(
      onRefresh: () async {
        context.read<ShopsCubit>().refreshServices(widget.categoryId);
      },
      child: BlocBuilder<ShopsCubit, ShopsState>(
        builder: (context, state) {
          if (state is ServicesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ServicesSuccess) {
            final servicesModel = state.servicesModel;
            return Stack(
              children: [
                servicesModel.data.isEmpty
                    ? Center(
                  child: Text(
                    'Empty',
                    style: AppStyles.styleSemiBold24(context).copyWith(color: AppColors.pureBlackColor),
                  ),
                )
                    : ServicesListView(
                  services: servicesModel.data,
                  scrollController: _scrollController,
                ),
                if (state is ServicesLoadingMore)
                  const Positioned(
                    bottom: 8,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
              ],
            );
          } else if (state is ServicesLoadingMore) {
            final servicesModel = state.servicesModel;
            return Stack(
              children: [
                servicesModel.data.isEmpty
                    ? Center(
                  child: Text(
                    'Empty',
                    style: AppStyles.styleSemiBold24(context).copyWith(color: AppColors.pureBlackColor),
                  ),
                )
                    : ServicesListView(
                  services: servicesModel.data,
                  scrollController: _scrollController,
                ),
                const Positioned(
                  bottom: 8,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 3),
                    ),
                  ),
                ),
              ],
            );
          } else if (state is ServicesFailure) {
            return RetryWidget(
              message: state.failure.errMessage,
              onPressed: () {
                context.read<ShopsCubit>().getShops(categoryId: widget.categoryId);
              },
            );
          } else {
            return RetryWidget(
              message: AppStrings.unexpectedError.tr(),
              onPressed: () {
                context.read<ShopsCubit>().getShops(categoryId: widget.categoryId);
              },
            );
          }
        },
      ),
    );
  }
}


