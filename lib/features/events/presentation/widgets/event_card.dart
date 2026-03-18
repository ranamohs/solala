import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:solala/core/constants/app_colors.dart';
import 'package:solala/core/constants/app_constants.dart';
import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/core/constants/app_styles.dart';
import 'package:solala/core/databases/cache/user_data_manager.dart';
import 'package:solala/core/functions/fixed_snack_bar.dart';
import 'package:solala/core/functions/strip_html.dart';
import 'package:solala/core/services/service_locator.dart';
import 'package:solala/core/widgets/retry_widget.dart';
import 'package:solala/features/events/data/models/event_model.dart';

import '../manager/events_cuibt/events_cubit.dart';
import '../manager/events_cuibt/events_state.dart';
import '../views/create_event_view.dart';

class EventCard extends StatefulWidget {
  const EventCard({super.key, required this.event});
  final EventModel event;

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  String? _accountType;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _accountType = getIt<UserDataManager>().getAccountType();
  }

  int? _calculateRemainingDays(String? eventDate) {
    if (eventDate == null) return null;
    try {
      final date = DateTime.parse(eventDate);
      final now = DateTime.now();
      final difference = date.difference(DateTime(now.year, now.month, now.day));
      return difference.inDays;
    } catch (e) {
      return null;
    }
  }

  String _getHijriDate(String? eventDate) {
    if (eventDate == null) return '';
    try {
      final date = DateTime.parse(eventDate);
      final hijri = HijriCalendar.fromDate(date);
      return "${hijri.hYear}/${hijri.hMonth}/${hijri.hDay}";
    } catch (e) {
      return '';
    }
  }

  String _getGregorianDate(String? eventDate) {
    if (eventDate == null) return '';
    try {
      final date = DateTime.parse(eventDate);
      return DateFormat('yyyy/MM/dd').format(date);
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final remainingDays = _calculateRemainingDays(widget.event.eventDate);
    final hijriDate = _getHijriDate(widget.event.eventDate);
    final gregDate = _getGregorianDate(widget.event.eventDate);
    final title = isArabic ? widget.event.title?.ar : widget.event.title?.en;

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
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                    if (_isExpanded) {
                      context.read<EventsCubit>().getEventDetails(
                        widget.event.id!,
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
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
                            child: CachedNetworkImage(
                              imageUrl:
                              widget.event.image ?? AppConstants.noImageUrl,
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
                                  isArabic
                                      ? (widget.event.type?.ar ?? '')
                                      : (widget.event.type?.en ?? ''),
                                  style: AppStyles.styleBold16(
                                    context,
                                  ).copyWith(color: AppColors.secondaryColor),
                                ),
                                if (remainingDays != null && remainingDays >= 0)
                                  Text(
                                    "${AppStrings.after.tr()} $remainingDays ${remainingDays > 2 ? AppStrings.days.tr() : AppStrings.day.tr()}",
                                    style: AppStyles.styleMedium16(context)
                                        .copyWith(
                                        color: AppColors.offRedColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

                          if (_accountType == 'provider') ...[
                            SizedBox(width: 10.w),
                            GestureDetector(
                              onTap: () {
                                final cubit = context.read<EventsCubit>();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: cubit,
                                      child:
                                      AddEditEventView(event: widget.event),
                                    ),
                                  ),
                                ).then((_) => cubit.getEvents());
                              },
                              child: Container(
                                width: 34.w,
                                height: 34.w,
                                decoration: BoxDecoration(
                                  color: AppColors.greenColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            BlocBuilder<EventsCubit, EventsState>(
                              builder: (context, state) {
                                if (state is DeleteEventLoading &&
                                    state.eventId == widget.event.id) {
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
                                    _showDeleteDialog(context, isArabic);
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
                          SizedBox(width:10.w ,),
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
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (_isExpanded)
                BlocBuilder<EventsCubit, EventsState>(
                  builder: (context, state) {
                    if (state is EventsSuccess) {
                      final isLoading = state.loadingEvents.contains(
                        widget.event.id,
                      );
                      final eventDetails = state.eventDetails[widget.event.id];
                      final error = state.errorEvents[widget.event.id];

                      if (isLoading) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: LoadingAnimationWidget.flickr(
                              leftDotColor: AppColors.primaryColor,
                              rightDotColor: AppColors.greenColor,
                              size: 64,
                            ),
                          ),
                        );
                      } else if (error != null) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: RetryWidget(
                            message: error,
                            onPressed: () {
                              context.read<EventsCubit>().getEventDetails(
                                widget.event.id!,
                              );
                            },
                          ),
                        );
                      } else if (eventDetails != null) {
                        return Padding(
                          padding: EdgeInsets.all(8.r),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.lightGreenColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(15.r),
                              border: Border.all(
                                  color: AppColors.greenColor, width: 2),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                /// Image
                                Container(
                                  height: 200.h,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 10.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        eventDetails.image ??
                                            AppConstants.noImageUrl,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                /// Title
                                Padding(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 16.w),
                                  child: Text(
                                    isArabic
                                        ? (eventDetails.title?.ar ?? '')
                                        : (eventDetails.title?.en ?? ''),
                                    textAlign: TextAlign.center,
                                    style: AppStyles.styleExtraBold20(context)
                                        .copyWith(
                                        color: AppColors.secondaryColor),
                                  ),
                                ),

                                /// Description
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.w, vertical: 8.h),
                                  child: Text(
                                    stripHtml(isArabic
                                        ? (eventDetails.description?.ar ?? '')
                                        : (eventDetails.description?.en ?? '')),
                                    textAlign: TextAlign.center,
                                    style: AppStyles.styleRegular16(context)
                                        .copyWith(
                                        color: AppColors.secondaryColor),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 16.h),
                                  child: Column(
                                    children: [
                                      Divider(
                                          color: AppColors.secondaryColor
                                              .withOpacity(0.3),
                                          indent: 40.w,
                                          endIndent: 40.w),
                                      // Text(
                                      //   "$hijriDate ${AppStrings.hijriLetter.tr()}",
                                      //   style: AppStyles.styleBold16(context)
                                      //       .copyWith(
                                      //       color:
                                      //       AppColors.secondaryColor),
                                      // ),
                                      Text(
                                        "$gregDate ${AppStrings.gregLetter.tr()}",
                                        style: AppStyles.styleBold16(context)
                                            .copyWith(
                                            color:
                                            AppColors.secondaryColor),
                                      ),
                                      if (eventDetails.address != null) ...[
                                        SizedBox(height: 10.h),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.location_on,
                                                color: AppColors.secondaryColor,
                                                size: 20.sp),
                                            SizedBox(width: 4.w),
                                            Text(
                                              isArabic
                                                  ? (eventDetails.address?.ar ??
                                                  '')
                                                  : (eventDetails.address?.en ??
                                                  ''),
                                              style: AppStyles.styleMedium14(
                                                  context)
                                                  .copyWith(
                                                  color: AppColors
                                                      .secondaryColor),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
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

  void _showDeleteDialog(BuildContext context, bool isArabic) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          AppStrings.delete.tr(),
          style: AppStyles.styleMedium18(context).copyWith(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Text(
          isArabic
              ? "هل أنت متأكد من حذف هذه الفعالية؟"
              : "Are you sure you want to delete this event?",
          style: AppStyles.styleMedium16(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppStrings.cancel.tr(),
                style: AppStyles.styleMedium14(context)
                    .copyWith(fontWeight: FontWeight.w800)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<EventsCubit>().deleteEvent(widget.event.id!, context);
            },
            child: Text(
              AppStrings.delete.tr(),
              style: AppStyles.styleMedium14(context).copyWith(
                  color: AppColors.offRedColor, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}
