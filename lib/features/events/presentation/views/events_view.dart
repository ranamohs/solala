import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:solala/core/services/service_locator.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/widgets/retry_widget.dart';
import '../manager/events_cuibt/events_cubit.dart';
import '../manager/events_cuibt/events_state.dart';
import '../widgets/event_card.dart';

class EventsView extends StatelessWidget {
  const EventsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<EventsCubit>()..getEvents(),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.homeBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(90.h),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25.r),
                  bottomRight: Radius.circular(25.r),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  child: Text(
                    AppStrings.events.tr(),
                    style: AppStyles.styleBold20(context)
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          body: BlocBuilder<EventsCubit, EventsState>(
            builder: (context, state) {
              if (state is EventsLoading) {
                return Center(
                  child: LoadingAnimationWidget.flickr(
                    leftDotColor: AppColors.primaryColor,
                    rightDotColor: AppColors.greenColor,
                    size: 64,
                  ),
                );
              } else if (state is EventsSuccess) {
                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: state.events.length,
                  itemBuilder: (context, index) {
                    return EventCard(event: state.events[index]);
                  },
                );
              } else if (state is EventsFailure) {
                return RetryWidget(
                  message: state.errorMessage,
                  onPressed: () => context.read<EventsCubit>().getEvents(),
                );
              } else {
                return SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }
}
