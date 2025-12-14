import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:solala/core/databases/cache/user_data_manager.dart';
import 'package:solala/core/services/service_locator.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/widgets/retry_widget.dart';
import '../manager/events_cuibt/events_cubit.dart';
import '../manager/events_cuibt/events_state.dart';
import '../widgets/event_card.dart';
import 'create_event_view.dart';

class EventsView extends StatelessWidget {
  const EventsView({super.key});

  @override
  Widget build(BuildContext context) {
    final accountType = getIt<UserDataManager>().getAccountType();
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
            AppStrings.events.tr(),
            style: AppStyles.styleBold25(context)
                .copyWith(color: AppColors.greenColor),
          ),
          actions: [
            if (accountType == 'provider')
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<EventsCubit>(),
                        child: const CreateEventView(),
                      ),
                    ),
                  ).then((_) => context.read<EventsCubit>().getEvents());
                },
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: AppColors.greenColor,
                ),
              ),
          ],
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
              if (state.events.isEmpty) {
                return Center(
                  child: Text(
                    AppStrings.noEventsFoundTillNow.tr(),
                    style: AppStyles.styleMedium18(context).copyWith(
                      color: AppColors.secondaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
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
    );
  }
}
