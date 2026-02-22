import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:solala/core/constants/app_strings.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/databases/cache/user_data_manager.dart';
import '../../../../core/services/service_locator.dart';
import '../manager/numering_events_cubit/numbering_events_cubit.dart';
import '../manager/numering_events_cubit/numbering_events_state.dart';

class EventsSection extends StatefulWidget {
  const EventsSection({
    super.key,
  });

  @override
  State<EventsSection> createState() => _EventsSectionState();
}

class _EventsSectionState extends State<EventsSection> {
  @override
  void initState() {
    super.initState();
    context.read<NumberingEventsCubit>().getNumberingEvents();
  }

  @override
  Widget build(BuildContext context) {
    final accountType = getIt<UserDataManager>().getAccountType();
    return BlocBuilder<NumberingEventsCubit, NumberingEventsState>(
      builder: (context, state) {
        if (state is NumberingEventsSuccess) {
          final data = state.numberingEventsModel.data;
          if (accountType == 'provider' &&
              (data == null ||
                  ((data.eventsCount ?? 0) == 0 &&
                      (data.familiesMemberCount ?? 0) == 0 &&
                      (data.newsCount ?? 0) == 0))) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppStrings.events.tr(),
                        style: AppStyles.styleBold16(context)
                            .copyWith(color: AppColors.secondaryColor)),
                  ],
                ),
                Center(
                  child: Text(
                    AppStrings.createEventForYourFamily.tr(),
                    style: AppStyles.styleBold16(context)
                        .copyWith(color: AppColors.secondaryColor),
                  ),
                ),
              ],
            );
          }
          if (data == null) {
            return Center(
              child: Text(
                AppStrings.noEventsFoundTillNow.tr(),
                style: AppStyles.styleBold16(context)
                    .copyWith(color: AppColors.secondaryColor),
              ),
            );
          }
          return Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: AppStrings.members.tr(),
                  value: (data.familiesMemberCount ?? 0).toString(),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _StatCard(
                  title: AppStrings.events.tr(),
                  value: (data.eventsCount ?? 0).toString(),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _StatCard(
                  title: AppStrings.news.tr(),
                  value: (data.newsCount ?? 0).toString(),
                ),
              ),
            ],
          );
        } else if (state is NumberingEventsFailure) {
          return Center(
            child: Text(state.message),
          );
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
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.beigeColor,
            AppColors.lightGreenColor,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 8.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: AppStyles.styleMedium18(context).copyWith(
                color: AppColors.secondaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              value,
              style: AppStyles.styleMedium16(context).copyWith(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}