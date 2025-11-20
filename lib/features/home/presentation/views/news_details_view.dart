import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solala/core/constants/app_styles.dart';
import 'package:solala/features/home/data/models/news_model/news_model.dart';

class NewsDetailsView extends StatelessWidget {
  const NewsDetailsView({super.key, required this.reportDetails});
  final ReportData reportDetails;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final title = isArabic ? reportDetails.title?.ar : reportDetails.title?.en;
    final description =
    isArabic ? reportDetails.decription?.ar : reportDetails.decription?.en;
    final familyName = isArabic
        ? reportDetails.familyDetails?.name?.ar
        : reportDetails.familyDetails?.name?.en;
    final familyImage = reportDetails.familyDetails?.image;
    final negotiator = reportDetails.familyDetails?.negotiator;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    familyName ?? '',
                    style: AppStyles.styleBold16(context),
                  ),

                ],
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            title ?? '',
            style: AppStyles.styleBold16(context),
          ),
          SizedBox(height: 5.h),
          Text(
            description ?? '',
            style: AppStyles.styleMedium14(context),
          ),
        ],
      ),
    );
  }
}
