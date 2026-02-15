import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solala/core/constants/app_colors.dart';
import 'package:solala/core/constants/app_styles.dart';
import 'package:solala/features/events/data/models/event_model.dart';

import '../../../../core/constants/app_strings.dart';

class EventDetailsView extends StatelessWidget {
  const EventDetailsView({super.key, required this.eventDetails});
  final EventModel eventDetails;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            eventDetails.decription?.ar ?? 'لا يوجد وصف',
            style: AppStyles.styleMedium16(context),
          ),
          SizedBox(height: 8.h),
          _buildDetailRow(AppStrings.inviter.tr(), eventDetails.familyDetails?.name?.ar ?? '' , context),
          _buildDetailRow(AppStrings.date.tr(), eventDetails.eventDate?.split('T')[0] ?? '' , context),
          _buildDetailRow(AppStrings.place.tr(), eventDetails.address?.ar ?? '' , context),
          // _buildDetailRow(AppStrings.invitees.tr(), 'Family' , context),
        ],
      ),
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
