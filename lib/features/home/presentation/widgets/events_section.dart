import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/services/service_locator.dart';
import '../manager/numering_events_cubit/numbering_events_cubit.dart';
import '../manager/numering_events_cubit/numbering_events_state.dart';

class EventsSection extends StatelessWidget {
  const EventsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NumberingEventsCubit>()..getNumberingEvents(),
      child: BlocBuilder<NumberingEventsCubit, NumberingEventsState>(
        builder: (context, state) {
          if (state is NumberingEventsSuccess) {
            return Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'members',
                    value: state.numberingEventsModel.data!.familiesMemberCount
                        .toString(),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _StatCard(
                    title: 'Events',
                    value:
                    state.numberingEventsModel.data!.eventsCount.toString(),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _StatCard(
                    title: 'News',
                    value:
                    state.numberingEventsModel.data!.newsCount.toString(),
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
      ),
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
      height: 90.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        gradient:  LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.beigeColor ,
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
              style:AppStyles.styleMedium14(context).copyWith(
                color: AppColors.secondaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              value,
              style:AppStyles.styleMedium14(context).copyWith(
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
