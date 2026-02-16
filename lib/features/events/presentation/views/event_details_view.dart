import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solala/core/constants/app_colors.dart';
import 'package:solala/core/constants/app_styles.dart';
import 'package:solala/core/functions/strip_html.dart';
import 'package:solala/features/events/data/models/event_model.dart';

import '../../../../core/constants/app_strings.dart';

class EventDetailsView extends StatelessWidget {
  const EventDetailsView({super.key, required this.eventDetails});
  final EventModel eventDetails;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final description = stripHtml(
        isArabic ? eventDetails.description?.ar : eventDetails.description?.en);
    final inviter = isArabic
        ? eventDetails.familyDetails?.name?.ar
        : eventDetails.familyDetails?.name?.en;
    final address =
    isArabic ? eventDetails.address?.ar : eventDetails.address?.en;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildDetailRow(
          AppStrings.description.tr(),
          description.isNotEmpty
              ? description
              : (isArabic ? 'لا يوجد وصف' : 'No description'),
          context,
        ),
        _buildDetailRow(AppStrings.inviter.tr(), inviter ?? '', context),
        _buildDetailRow(
            AppStrings.date.tr(),
            eventDetails.eventDate?.split('T')[0] ?? '',
            context),
        _buildDetailRow(AppStrings.place.tr(), address ?? '', context),
      ],
    );
  }

  Widget _buildDetailRow(String title, String value, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        children: [
          Text(
            title,
            style:
            AppStyles.styleBold16(context).copyWith(color: AppColors.secondaryColor),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: AppStyles.styleMedium14(context),
          ),
        ],
      ),
    );
  }
}
