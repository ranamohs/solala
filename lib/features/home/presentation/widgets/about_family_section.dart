import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solala/core/constants/app_colors.dart';
import 'package:solala/core/constants/app_styles.dart';

class AboutFamilySection extends StatelessWidget {
  const AboutFamilySection({super.key});

  @override
  Widget build(BuildContext context) {
    const Color goldBorder = Color(0xFFCC9A33);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                  text: 'About our ',
                  style: AppStyles.styleBold16(context).copyWith(
                      color: AppColors.pureBlackColor
                  )
              ),
              TextSpan(
                  text: 'family',
                  style: AppStyles.styleBold16(context).copyWith(
                      color: AppColors.greenColor
                  )
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),

        // البوكس الذهبي
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: goldBorder, width: 1),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                Container(
                  width: 4,
                  decoration: const BoxDecoration(
                    color: goldBorder,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      bottomLeft: Radius.circular(4),
                    ),
                  ),
                ),

                // النصوص
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 10.h
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min, // ✅ إضافة mainAxisSize
                      children: [
                        Text(
                          'Founder: Ali Hashem',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          'Family Code: 48795477',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}