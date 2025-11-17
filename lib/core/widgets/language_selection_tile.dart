import 'package:solala/core/constants/app_colors.dart' show AppColors;
import 'package:solala/core/constants/app_styles.dart' show AppStyles;
import 'package:solala/core/widgets/spacing.dart' show VerticalSpace, HorizontalSpace;
import 'package:flutter/material.dart';

import '../constants/app_assets.dart';

class LanguageSelectionTile extends StatelessWidget {
  const LanguageSelectionTile({
    super.key,
    required this.onChangEnglish,
    required this.onChangArabic,
    this.groupValue,
  });

  final String? groupValue;
  final void Function(String?) onChangEnglish;
  final void Function(String?) onChangArabic;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GestureDetector(
            onTap: () => onChangArabic('ar'),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              decoration: ShapeDecoration(
                color:
                groupValue == 'ar'
                    ? AppColors.primaryColor
                    : AppColors.pureWhiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color:
                    groupValue == 'ar'
                        ? AppColors.primaryColor
                        : Colors.grey.shade300,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Image.asset(
                   AppAssets.arabicImage,
                    width: 28,
                    height: 28,
                  ),
                  HorizontalSpace(16),
                  Text(
                    'العربية',
                    style: AppStyles.styleSemiBold16(context).copyWith(
                      color:
                      groupValue == 'ar'
                          ? AppColors.pureWhiteColor
                          : AppColors.primaryColor,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    groupValue == 'ar'
                        ? Icons.check
                        : Icons.radio_button_unchecked,
                    color: AppColors.pureWhiteColor,
                  ),
                ],
              ),
            ),
          ),
        ),
        const VerticalSpace(18),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GestureDetector(
            onTap: () => onChangEnglish('en'),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              decoration: ShapeDecoration(
                color:
                groupValue == 'en'
                    ? AppColors.primaryColor
                    : AppColors.pureWhiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color:
                    groupValue == 'en'
                        ? AppColors.primaryColor
                        : Colors.grey.shade300,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Image.asset(
                    AppAssets.englishImage,
                    width: 28,
                    height: 28,
                  ),
                  HorizontalSpace(16),
                  Text(
                    'English',
                    style: AppStyles.styleSemiBold16(context).copyWith(
                      color:
                      groupValue == 'en'
                          ? AppColors.pureWhiteColor
                          : AppColors.primaryColor,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    groupValue == 'en'
                        ? Icons.check
                        : Icons.radio_button_unchecked,
                    color: AppColors.pureWhiteColor,
                  ),
                ],
              ),
            ),
          ),
        ),

      ],
    );
  }
}
