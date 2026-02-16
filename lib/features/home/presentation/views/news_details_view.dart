import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solala/core/constants/app_colors.dart';
import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/core/constants/app_styles.dart';
import 'package:solala/core/functions/strip_html.dart';
import 'package:solala/features/home/data/models/news_model/news_model.dart';

class NewsDetailsView extends StatelessWidget {
  const NewsDetailsView({super.key, required this.reportDetails});
  final ReportData reportDetails;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final title = isArabic ? reportDetails.title?.ar : reportDetails.title?.en;
    final description = stripHtml(isArabic
        ? reportDetails.description?.ar
        : reportDetails.description?.en);
    final familyName = isArabic
        ? reportDetails.familyDetails?.name?.ar
        : reportDetails.familyDetails?.name?.en;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${AppStrings.description.tr()}:',
            style: AppStyles.styleBold16(context).copyWith(color: AppColors.secondaryColor),
          ),
          SizedBox(height: 5.h),
          Text(
            description.isNotEmpty ? description : (isArabic ? 'لا يوجد وصف' : 'No description'),
            style: AppStyles.styleMedium14(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
