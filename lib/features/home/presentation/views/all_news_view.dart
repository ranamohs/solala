import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:solala/core/services/service_locator.dart';
import 'package:solala/features/home/data/models/news_model/news_model.dart';
import 'package:solala/features/home/presentation/manager/news_cubit/news_cubit.dart';
import 'package:solala/features/home/presentation/manager/news_cubit/news_state.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/app_styles.dart';
import '../../../../../core/widgets/retry_widget.dart';
import '../widgets/new_card.dart';

class AllNewsView extends StatelessWidget {
  const AllNewsView({super.key, this.report});
  final ReportData? report;

  @override
  Widget build(BuildContext context) {
    if (report != null) {
      return _buildView(context);
    }
    return BlocProvider(
      create: (context) => getIt<NewsCubit>()..getReports(),
      child: _buildView(context),
    );
  }

  Widget _buildView(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.homeBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            AppStrings.newsFamily.tr(),
            style: AppStyles.styleBold20(context)
                .copyWith(color: AppColors.secondaryColor),
          ),
        ),
        body: report != null
            ? ListView(
          padding: const EdgeInsets.all(20),
          children: [
            NewsCard(report: report!),
          ],
        )
            : BlocBuilder<NewsCubit, NewsState>(
          builder: (context, state) {
            if (state is ReportsLoading) {
              return Center(
                child: LoadingAnimationWidget.flickr(
                  leftDotColor: AppColors.primaryColor,
                  rightDotColor: AppColors.greenColor,
                  size: 64,
                ),
              );
            } else if (state is ReportsSuccess) {
              if (state.reportModel.data!.isEmpty) {
                return Center(
                  child: Text(
                    AppStrings.noNewsFoundTillNow.tr(),
                    style: AppStyles.styleBold20(context).copyWith(
                      color: AppColors.secondaryColor,
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: state.reportModel.data!.length,
                itemBuilder: (context, index) {
                  return NewsCard(report: state.reportModel.data![index]);
                },
              );
            } else if (state is ReportsFailure) {
              return RetryWidget(
                message: state.message,
                onPressed: () => context.read<NewsCubit>().getReports(),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
