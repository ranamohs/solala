import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:solala/core/constants/app_colors.dart';
import 'package:solala/core/constants/app_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/core/constants/app_styles.dart';
import 'package:solala/core/databases/cache/user_data_manager.dart';
import 'package:solala/core/functions/fixed_snack_bar.dart';
import 'package:solala/core/services/service_locator.dart';
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
  String? _accountType;

  @override
  void initState() {
    super.initState();
    _accountType = getIt<UserDataManager>().getAccountType();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return BlocListener<EventsCubit, EventsState>(
      listener: (context, state) {
        if (state is DeleteEventSuccess && state.eventId == widget.event.id) {
          fixedSnackBar(context,
              message: state.message,
              icon: Icons.check_circle,
              iconColor: Colors.white,
              boxColor: AppColors.greenColor);
        } else if (state is DeleteEventFailure &&
            state.eventId == widget.event.id) {
          fixedSnackBar(context,
              message: state.message,
              icon: Icons.error,
              iconColor: Colors.white,
              boxColor: AppColors.offRedColor);
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 18.h),
                margin: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.lightGreenColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30.r,
                      backgroundImage: CachedNetworkImageProvider(
                        widget.event.image ?? AppConstants.noImageUrl,
                      ),
                    ),

                    SizedBox(width: 15.w),

                    /// Title + Date
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.event.title?.ar ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.styleSemiBold14(context)
                                .copyWith(color: AppColors.secondaryColor),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            widget.event.eventDate != null
                                ? DateFormat('dd/MM/yyyy').format(
                              DateTime.parse(widget.event.eventDate!).toLocal(),
                            )
                                : '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyles.styleMedium14(context)
                                .copyWith(color: AppColors.secondaryColor),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 10.w),

                    if (_accountType == 'provider') ...[
                      BlocBuilder<EventsCubit, EventsState>(
                        builder: (context, state) {
                          if (state is DeleteEventLoading &&
                              state.eventId == widget.event.id) {
                            return SizedBox(
                              width: 32.w,
                              height: 32.h,
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
                                  title: Text(AppStrings.delete.tr(),
                                    style: AppStyles.styleMedium18(context)
                                        .copyWith(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  content: Text(isArabic
                                      ? "هل أنت متأكد من حذف هذه الفعالية؟"
                                      : "Are you sure you want to delete this event?",    style: AppStyles.styleMedium16(context),),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(dialogContext),
                                      child: Text(AppStrings.cancel.tr(),   style:
                                      AppStyles.styleMedium14(
                                        context,
                                      ).copyWith(
                                        fontWeight: FontWeight.w800,
                                      ),),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(dialogContext);
                                        context.read<EventsCubit>().deleteEvent(
                                            widget.event.id!, context);
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
                              width: 32.w,
                              height: 32.h,
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
                      SizedBox(width: 10.w),
                    ],

                    /// Expand Button
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
                          size: 22.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// Expanded Details
              if (_isExpanded)
                BlocBuilder<EventsCubit, EventsState>(
                  builder: (context, state) {
                    if (state is EventsSuccess) {
                      final isLoading =
                      state.loadingEvents.contains(widget.event.id);
                      final eventDetails =
                      state.eventDetails[widget.event.id];
                      final error =
                      state.errorEvents[widget.event.id];

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
                            context
                                .read<EventsCubit>()
                                .getEventDetails(widget.event.id!);
                          },
                        );
                      } else if (eventDetails != null) {
                        return EventDetailsView(
                          eventDetails: eventDetails,
                        );
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
