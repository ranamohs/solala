import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:solala/core/constants/app_colors.dart';

class EventCardShimmer extends StatelessWidget {
  const EventCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: EdgeInsets.only(bottom: 20.h),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.beigeColor,
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.lightGreenColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 26.sp,
                  height: 26.sp,
                  color: Colors.white,
                ),
                SizedBox(width: 20.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100.w,
                      height: 16.h,
                      color: Colors.white,
                    ),
                    SizedBox(height: 3),
                    Container(
                      width: 80.w,
                      height: 14.h,
                      color: Colors.white,
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
