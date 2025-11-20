import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_styles.dart';

class FamilyNewsSection extends StatelessWidget {
  const FamilyNewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_FamilyNewsItem> items = [
      const _FamilyNewsItem(
        date: '5 Nov',
        title: 'Annual Family Reunion',
        placeAndTime: 'At the Riverside Park • 4:00 PM',
        description: 'Potluck style—bring a dish!.',
      ),
      const _FamilyNewsItem(
        date: '12 Dec',
        title: 'Family Meeting',
        placeAndTime: 'Grandma’s House • 7:30 PM',
        description: 'Discuss holiday plans together.',
      ),
      const _FamilyNewsItem(
        date: '1 Jan',
        title: 'New Year Celebration',
        placeAndTime: 'City Center • 9:00 PM',
        description: 'Fireworks and family gathering.',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: AppStrings.news.tr(),
                style: AppStyles.styleBold16(context)
                    .copyWith(color: AppColors.pureBlackColor),
              ),
              TextSpan(
                text: AppStrings.ourFamily.tr(),
                style: AppStyles.styleBold16(context)
                    .copyWith(color: AppColors.greenColor),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),

        SizedBox(
          height: 100.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final item = items[index];
              return _FamilyNewsCard(item: item);
            },
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            itemCount: items.length,
          ),
        ),
      ],
    );
  }
}

class _FamilyNewsItem {
  final String date;
  final String title;
  final String placeAndTime;
  final String description;

  const _FamilyNewsItem({
    required this.date,
    required this.title,
    required this.placeAndTime,
    required this.description,
  });
}

class _FamilyNewsCard extends StatelessWidget {
  final _FamilyNewsItem item;

  const _FamilyNewsCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.w,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            blurRadius: 6.r,
            offset: const Offset(0, 3),
            color: Colors.black.withOpacity(0.15),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Text(
            item.date,
            style: AppStyles.styleBold16(context).copyWith(color: AppColors.pureWhiteColor),
          ),
           SizedBox(height: 4.h),

          Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.styleBold16(context).copyWith(color: AppColors.pureWhiteColor),
          ),
           SizedBox(height: 4.h),
          Text(
            item.placeAndTime,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.styleMedium14(context).copyWith(color: AppColors.pureWhiteColor),
          ),
           SizedBox(height: 4.h),

          Text(
            item.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.styleMedium14(context).copyWith(color: AppColors.pureWhiteColor),
          ),
        ],
      ),
    );
  }
}
