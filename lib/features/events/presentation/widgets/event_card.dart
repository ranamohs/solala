import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:solala/core/constants/app_colors.dart';
import 'package:solala/core/constants/app_constants.dart';
import 'package:solala/core/constants/app_styles.dart';
import 'package:solala/core/widgets/retry_widget.dart';
import 'package:solala/features/events/data/models/event_model.dart';
import 'package:solala/features/events/presentation/views/event_details_view.dart';

import '../manager/events_cuibt/events_cubit.dart';
import '../manager/events_cuibt/events_state.dart';


class EventCard extends StatefulWidget {
  const EventCard({super.key, required this.event});
  final EventModel event;

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.beigeColor,
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.lightGreenColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32.5,
                    backgroundImage: CachedNetworkImageProvider(
                      widget.event.image ?? AppConstants.noImageUrl,
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.event.title?.ar ?? '',
                          style: AppStyles.styleBold16(context)
                              .copyWith(color: AppColors.secondaryColor)),
                      SizedBox(height: 3),
                      Text(widget.event.eventDate?.split('T')[0] ?? '',
                          style: AppStyles.styleMedium14(context)
                              .copyWith(color: AppColors.secondaryColor)),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                        if (_isExpanded) {
                          context
                              .read<EventsCubit>()
                              .getEventDetails(widget.event.id!);
                        }
                      });
                    },
                    child: Container(
                      width: 32.w,
                      height: 32.h,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                          _isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 22.sp),
                    ),
                  ),
                ],
              ),
            ),
            if (_isExpanded)
              BlocBuilder<EventsCubit, EventsState>(
                builder: (context, state) {
                  if (state is EventsSuccess) {
                    final isLoading =
                    state.loadingEvents.contains(widget.event.id);
                    final eventDetails = state.eventDetails[widget.event.id];
                    final error = state.errorEvents[widget.event.id];

                    if (isLoading) {
                      return Center(
                        child: LoadingAnimationWidget.flickr(
                          leftDotColor: AppColors.primaryColor,
                          rightDotColor: AppColors.greenColor,
                          size: 64,
                        ),
                      );
                    } else if (error != null) {
                      return RetryWidget(message: error   ,onPressed: () {
                        context.read<EventsCubit>().getEventDetails(widget.event.id!);
                      }, );
                    } else if (eventDetails != null) {
                      return EventDetailsView(eventDetails: eventDetails);
                    }
                  }
                  return const SizedBox.shrink();
                },
              ),
          ],
        ),
      ),
    );
  }
}
