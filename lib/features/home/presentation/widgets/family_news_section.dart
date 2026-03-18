import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:solala/core/widgets/retry_widget.dart';
import 'package:solala/features/home/data/models/news_model/news_model.dart';
import 'package:solala/features/home/presentation/manager/news_cubit/news_cubit.dart';
import 'package:solala/features/home/presentation/manager/news_cubit/news_state.dart';

import '../../../../../core/functions/strip_html.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/constants/app_styles.dart';
import '../views/all_news_view.dart';

class FamilyNewsSection extends StatefulWidget {
  final String accountType;
  const FamilyNewsSection({super.key, required this.accountType});

  @override
  State<FamilyNewsSection> createState() => _FamilyNewsSectionState();
}

class _FamilyNewsSectionState extends State<FamilyNewsSection> {
  @override
  void initState() {
    super.initState();
    context.read<NewsCubit>().getReports();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: AppStrings.news.tr(),
                    style: AppStyles.styleBold16(context)
                        .copyWith(color: AppColors.pureBlackColor),
                  ),
                  TextSpan(
                    text: AppStrings.ourFamily.tr(),
                    style: AppStyles.styleBold16(context)
                        .copyWith(color: AppColors.greenColor),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllNewsView(),
                  ),
                );
              },
              child: Text(
                AppStrings.viewAll.tr(),
                style: AppStyles.styleBold16(context)
                    .copyWith(color: AppColors.greenColor),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        BlocBuilder<NewsCubit, NewsState>(
          builder: (context, state) {
            if (state is ReportsSuccess) {
              final reports = state.reportModel.data ?? [];
              if (reports.isEmpty) {
                return Center(
                  child: Text(
                    widget.accountType == 'provider'
                        ? AppStrings.createNewsForYourFamily.tr()
                        : AppStrings.noNewsFoundTillNow.tr(),
                    style: AppStyles.styleMedium18(context).copyWith(
                      color: AppColors.secondaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              return SizedBox(
                height: 100.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final item = reports[index];
                    return _FamilyNewsCard(item: item);
                  },
                  separatorBuilder: (context, index) => SizedBox(width: 12.w),
                  itemCount: reports.length,
                ),
              );
            } else if (state is ReportsFailure) {
              return RetryWidget(message: state.message, onPressed: () {
                context.read<NewsCubit>().getReports();
              });
            } else {
              return Center(
                child: LoadingAnimationWidget.flickr(
                  leftDotColor: AppColors.primaryColor,
                  rightDotColor: AppColors.greenColor,
                  size: 64,
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

class _FamilyNewsCard extends StatelessWidget {
  final ReportData item;

  const _FamilyNewsCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final title = isArabic ? item.title?.ar : item.title?.en;
    final description =
    stripHtml(isArabic ? item.description?.ar : item.description?.en);
    final familyName =
    isArabic ? item.familyDetails?.name?.ar : item.familyDetails?.name?.en;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<NewsCubit>(),
              child: AllNewsView(report: item),
            ),
          ),
        );
      },
      child: Container(
        width: 230.w,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              blurRadius: 6.r,
              offset: const Offset(0, 3),
              color: Colors.black.withOpacity(0.15),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(
            //   familyName ?? '',
            //   style: AppStyles.styleBold16(context)
            //       .copyWith(color: AppColors.pureWhiteColor),
            // ),
            // SizedBox(height: 4.h),
            Text(
              title ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.styleBold16(context)
                  .copyWith(color: AppColors.pureWhiteColor),
            ),
            SizedBox(height: 4.h),
            Text(
              description ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.styleMedium14(context)
                  .copyWith(color: AppColors.pureWhiteColor),
            ),
          ],
        ),
      ),
    );
  }
}
