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
import '../../data/models/event_model.dart';
import '../manager/events_cuibt/events_cubit.dart';
import '../manager/events_cuibt/events_state.dart';
import '../widgets/event_card.dart';
import 'create_event_view.dart';

class EventsView extends StatelessWidget {
  const EventsView({super.key});

  @override
  Widget build(BuildContext context) {
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
                          child: const AddEditEventView(),
                        ),
                      ),
                    ).then((_) => context.read<EventsCubit>().getEvents());
                  },
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: AppColors.greenColor,
                    size: 32.sp,
                  ),
                ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(60.h),
              child: Container(
                height: 50.h,
                margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: AppColors.beigeColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(color: AppColors.secondaryColor.withOpacity(0.2)),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.secondaryColor.withOpacity(0.7),
                  labelStyle: AppStyles.styleMedium14(context).copyWith(
                    fontWeight: FontWeight.w700
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(text: AppStrings.upcomingEvents.tr()),
                    Tab(text: AppStrings.pastEvents.tr()),
                  ],
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
                final now = DateTime.now();
                final today = DateTime(now.year, now.month, now.day);

                final upcomingEvents = state.events.where((e) {
                  if (e.eventDate == null) return false;
                  try {
                    final date = DateTime.parse(e.eventDate!);
                    final eventDay = DateTime(date.year, date.month, date.day);
                    return eventDay.isAfter(today) ||
                        eventDay.isAtSameMomentAs(today);
                  } catch (e) {
                    return false;
                  }
                }).toList();
                upcomingEvents.sort((a, b) {
                  final dateA = a.eventDate != null
                      ? DateTime.tryParse(a.eventDate!) ?? DateTime(0)
                      : DateTime(0);
                  final dateB = b.eventDate != null
                      ? DateTime.tryParse(b.eventDate!) ?? DateTime(0)
                      : DateTime(0);
                  return dateA.compareTo(dateB);
                });

                final pastEvents = state.events.where((e) {
                  if (e.eventDate == null) return true;
                  try {
                    final date = DateTime.parse(e.eventDate!);
                    final eventDay = DateTime(date.year, date.month, date.day);
                    return eventDay.isBefore(today);
                  } catch (e) {
                    return true;
                  }
                }).toList();
                pastEvents.sort((a, b) {
                  final dateA = a.eventDate != null
                      ? DateTime.tryParse(a.eventDate!) ?? DateTime(0)
                      : DateTime(0);
                  final dateB = b.eventDate != null
                      ? DateTime.tryParse(b.eventDate!) ?? DateTime(0)
                      : DateTime(0);
                  return dateB.compareTo(dateA);
                });

                return TabBarView(
                  children: [
                    _buildEventsList(context, upcomingEvents),
                    _buildEventsList(context, pastEvents),
                  ],
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

  Widget _buildEventsList(BuildContext context, List<EventModel> events) {
    if (events.isEmpty) {
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
      padding: EdgeInsets.all(20.w),
      itemCount: events.length,
      itemBuilder: (context, index) => EventCard(event: events[index]),
    );
  }
}
