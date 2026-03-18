import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:solala/core/databases/cache/user_data_manager.dart';
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
import 'create_news_view.dart';

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
      child: Builder(builder: (context) => _buildView(context)),
    );
  }

  Widget _buildView(BuildContext context) {
    final accountType = getIt<UserDataManager>().getAccountType();
    return DefaultTabController(
      length: 2,
      child: Container(
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
            actions: [
              if (accountType == 'provider' && report == null)
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<NewsCubit>(),
                          child: const AddEditNewsView(),
                        ),
                      ),
                    ).then((_) => context.read<NewsCubit>().getReports());
                  },
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: AppColors.greenColor,
                    size: 32.sp,
                  ),
                ),
            ],
            bottom: report == null
                ? PreferredSize(
              preferredSize: Size.fromHeight(60.h),
              child: Container(
                height: 50.h,
                margin: EdgeInsets.symmetric(
                    horizontal: 12.w, vertical: 5.h),
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: AppColors.beigeColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                      color: AppColors.secondaryColor.withOpacity(0.2)),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor:
                  AppColors.secondaryColor.withOpacity(0.7),
                  labelStyle: AppStyles.styleMedium14(context)
                      .copyWith(fontWeight: FontWeight.w700),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(text: AppStrings.recentNews.tr()),
                    Tab(text: AppStrings.oldNews.tr()),
                  ],
                ),
              ),
            )
                : null,
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
                final reports = state.reportModel.data ?? [];
                if (reports.isEmpty) {
                  return Center(
                    child: Text(
                      AppStrings.noNewsFoundTillNow.tr(),
                      style: AppStyles.styleBold20(context).copyWith(
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  );
                }

                final now = DateTime.now();
                final today = DateTime(now.year, now.month, now.day);

                final recentNews = reports.where((r) {
                  if (r.createdAt == null) return true;
                  try {
                    final date = DateTime.parse(r.createdAt!);
                    final newsDay = DateTime(date.year, date.month, date.day);
                    return newsDay.isAtSameMomentAs(today) || newsDay.isAfter(today);
                  } catch (e) {
                    return true;
                  }
                }).toList();
                recentNews.sort((a, b) => (b.createdAt ?? '').compareTo(a.createdAt ?? ''));

                final oldNews = reports.where((r) {
                  if (r.createdAt == null) return false;
                  try {
                    final date = DateTime.parse(r.createdAt!);
                    final newsDay = DateTime(date.year, date.month, date.day);
                    return newsDay.isBefore(today);
                  } catch (e) {
                    return false;
                  }
                }).toList();
                oldNews.sort((a, b) => (b.createdAt ?? '').compareTo(a.createdAt ?? ''));

                return TabBarView(
                  children: [
                    _buildNewsList(context, recentNews),
                    _buildNewsList(context, oldNews),
                  ],
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
      ),
    );
  }

  Widget _buildNewsList(BuildContext context, List<ReportData> news) {
    if (news.isEmpty) {
      return Center(
        child: Text(
          AppStrings.noNewsFoundTillNow.tr(),
          style: AppStyles.styleMedium18(context).copyWith(
            color: AppColors.secondaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: news.length,
      itemBuilder: (context, index) {
        return NewsCard(report: news[index]);
      },
    );
  }
}
