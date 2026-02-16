import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:solala/core/constants/app_colors.dart';
import 'package:solala/core/constants/app_constants.dart';
import 'package:solala/core/constants/app_styles.dart';
import 'package:solala/core/widgets/retry_widget.dart';
import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/core/databases/cache/user_data_manager.dart';
import 'package:solala/core/functions/fixed_snack_bar.dart';
import 'package:solala/core/services/service_locator.dart';
import 'package:solala/features/home/data/models/news_model/news_model.dart';
import 'package:solala/features/home/presentation/manager/news_cubit/news_cubit.dart';
import 'package:solala/features/home/presentation/manager/news_cubit/news_state.dart';
import 'package:solala/features/home/presentation/views/news_details_view.dart';

class NewsCard extends StatefulWidget {
  const NewsCard({super.key, required this.report});
  final ReportData report;

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  bool _isExpanded = false;
  String? _accountType;

  @override
  void initState() {
    super.initState();
    _accountType = getIt<UserDataManager>().getAccountType();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final title = isArabic ? widget.report.title?.ar : widget.report.title?.en;
    final newsImage = widget.report.image;

    return BlocListener<NewsCubit, NewsState>(
      listener: (context, state) {
        if (state is DeleteNewsSuccess && state.reportId == widget.report.id) {
          fixedSnackBar(
            context,
            message: state.message,
            icon: Icons.check_circle,
            iconColor: Colors.white,
            boxColor: AppColors.greenColor,
          );
        } else if (state is DeleteNewsError &&
            state.reportId == widget.report.id) {
          fixedSnackBar(
            context,
            message: state.message,
            icon: Icons.error,
            iconColor: Colors.white,
            boxColor: AppColors.offRedColor,
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 20.h),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.beigeColor,
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                    if (_isExpanded) {
                      context.read<NewsCubit>().getReportDetails(
                        widget.report.id!,
                      );
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 14.h,
                  ),
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.lightGreenColor,
                    borderRadius: BorderRadius.circular(22.r),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: CachedNetworkImage(
                          imageUrl: newsImage ?? AppConstants.noImageUrl,
                          width: 70.w,
                          height: 70.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              title ?? '',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyles.styleBold16(
                                context,
                              ).copyWith(color: AppColors.secondaryColor),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Container(
                        width: 34.w,
                        height: 34.w,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isExpanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: Colors.white,
                          size: 22.sp,
                        ),
                      ),
                      if (_accountType == 'provider') ...[
                        SizedBox(width: 10.w),
                        BlocBuilder<NewsCubit, NewsState>(
                          builder: (context, state) {
                            if (state is DeleteNewsLoading &&
                                state.reportId == widget.report.id) {
                              return SizedBox(
                                width: 34.w,
                                height: 34.w,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.offRedColor,
                                  ),
                                ),
                              );
                            }
                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) => AlertDialog(
                                    title: Text(
                                      AppStrings.delete.tr(),
                                      style: AppStyles.styleMedium18(context)
                                          .copyWith(
                                            color: AppColors.primaryColor,
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                    content: Text(
                                      isArabic
                                          ? "هل أنت متأكد من حذف هذا الخبر؟"
                                          : "Are you sure you want to delete this news?",
                                      style: AppStyles.styleMedium16(context),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(dialogContext),
                                        child: Text(
                                          AppStrings.cancel.tr(),
                                          style:
                                              AppStyles.styleMedium14(
                                                context,
                                              ).copyWith(
                                                fontWeight: FontWeight.w800,
                                              ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(dialogContext);
                                          context.read<NewsCubit>().deleteNews(
                                            widget.report.id!,
                                            context,
                                          );
                                        },
                                        child: Text(
                                          AppStrings.delete.tr(),
                                          style:
                                              AppStyles.styleMedium14(
                                                context,
                                              ).copyWith(
                                                color: AppColors.offRedColor,
                                                fontWeight: FontWeight.w800,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Container(
                                width: 34.w,
                                height: 34.w,
                                decoration: BoxDecoration(
                                  color: AppColors.offRedColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (_isExpanded)
                BlocBuilder<NewsCubit, NewsState>(
                  builder: (context, state) {
                    if (state is ReportsSuccess) {
                      final isLoading = state.loadingReports.contains(
                        widget.report.id,
                      );
                      final reportDetails =
                          state.reportDetails[widget.report.id];
                      final error = state.errorReports[widget.report.id];

                      if (isLoading) {
                        return Center(
                          child: LoadingAnimationWidget.flickr(
                            leftDotColor: AppColors.primaryColor,
                            rightDotColor: AppColors.greenColor,
                            size: 64,
                          ),
                        );
                      } else if (error != null) {
                        return RetryWidget(
                          message: error,
                          onPressed: () {
                            context.read<NewsCubit>().getReportDetails(
                              widget.report.id!,
                            );
                          },
                        );
                      } else if (reportDetails != null) {
                        return NewsDetailsView(reportDetails: reportDetails);
                      }
                    }
                    return const SizedBox.shrink();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
