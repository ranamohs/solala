import 'dart:async';


import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/functions/navigation.dart';
import '../../../../core/routes/app_router.dart';


class IntroView extends StatefulWidget {

  const IntroView({super.key});

  @override
  State<IntroView> createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      customGo(context, AppRouter.introViewWithButton);
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            AppAssets.introBackground,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.65),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(44.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.introTitle.tr(),
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w900,
                      color: AppColors.darkGry,
                    ),

                  ),
                  SizedBox(height: 10.h),
                  Text(
                    AppStrings.subtitle.tr(),
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: AppColors.darkGry,
                      fontWeight: FontWeight.w900,
                    ),

                  ),
                  SizedBox(height: 60.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}