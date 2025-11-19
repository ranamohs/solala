import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';

class EventsSection extends StatelessWidget {
  const EventsSection({
    super.key,
    this.members = 140,
    this.events = 10,
    this.news = 5,
  });

  final int members;
  final int events;
  final int news;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'members',
            value: members.toString(),
          ),
        ),
         SizedBox(width: 12.w),
        Expanded(
          child: _StatCard(
            title: 'Events',
            value: events.toString(),
          ),
        ),
         SizedBox(width: 12.w),
        Expanded(
          child: _StatCard(
            title: 'News',
            value: news.toString(),
          ),
        ),
      ],
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
