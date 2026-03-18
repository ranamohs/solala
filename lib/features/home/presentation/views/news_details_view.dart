import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solala/core/constants/app_colors.dart';
import 'package:solala/core/constants/app_constants.dart';
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
      padding: EdgeInsets.all(8.r),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightGreenColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: AppColors.greenColor, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// Image
            Container(
              height: 200.h,
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    reportDetails.image ?? AppConstants.noImageUrl,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            /// Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                title ?? '',
                textAlign: TextAlign.center,
                style: AppStyles.styleExtraBold20(context)
                    .copyWith(color: AppColors.secondaryColor),
              ),
            ),

            /// Description
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Column(
                children: [
                  Text(
                    '${AppStrings.description.tr()}:',
                    style: AppStyles.styleBold16(context)
                        .copyWith(color: AppColors.secondaryColor),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    description.isNotEmpty
                        ? description
                        : (isArabic ? 'لا يوجد وصف' : 'No description'),
                    textAlign: TextAlign.center,
                    style: AppStyles.styleRegular16(context)
                        .copyWith(color: AppColors.secondaryColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
