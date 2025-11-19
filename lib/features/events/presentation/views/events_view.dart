import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_styles.dart';

class EventsView extends StatelessWidget {
  const EventsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.homeBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize:  Size.fromHeight(90.h),
          child: Container(
            decoration:  BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25.r),
                bottomRight: Radius.circular(25.r),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Text(
                  AppStrings.events.tr(),
                  style: AppStyles.styleBold20(context)
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ),

        body: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: 5,
          itemBuilder: (context, index) {
            return Padding(
              padding:  EdgeInsets.only(bottom: 20.h),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.beigeColor,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Container(
                  padding:  EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.lightGreenColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [

                       Icon(Icons.event_available,
                          color:AppColors.primaryColor, size: 26.sp),
                       SizedBox(width: 20.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          Text("Marriage",
                              style: AppStyles.styleBold16(context).copyWith(color: AppColors.secondaryColor)),
                          SizedBox(height: 3),
                          Text("2025/10/28",
                              style: AppStyles.styleMedium14(context).copyWith(color: AppColors.secondaryColor)),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        width: 32.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor,
                          shape: BoxShape.circle,
                        ),
                        child:  Icon(Icons.keyboard_arrow_down,
                            color: Colors.white, size: 22.sp),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
