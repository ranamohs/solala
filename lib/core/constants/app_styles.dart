import 'package:solala/core/constants/app_colors.dart' show AppColors;
import 'package:solala/core/constants/app_fonts.dart' show AppFonts;
import 'package:solala/core/functions/is_arabic.dart' show isArabic;
import 'package:flutter/material.dart';

abstract class AppStyles {
  static TextStyle styleExtraBold20(BuildContext context) {
    return TextStyle(
      fontSize: getResponsiveFontSize(context, fontSize: 16),
      fontWeight: FontWeight.w800,
      fontFamily: getFontFamily(context),
      color: AppColors.pureBlackColor,
    );
  }

  static TextStyle styleBold25(BuildContext context) {
    return TextStyle(
      fontSize: getResponsiveFontSize(context, fontSize: 25),
      fontWeight: FontWeight.w700,
      fontFamily: getFontFamily(context),
      color: AppColors.primaryColor,
    );
  }

  static TextStyle styleBold24(BuildContext context) {
    return TextStyle(
      fontSize: getResponsiveFontSize(context, fontSize: 24),
      fontWeight: FontWeight.w700,
      fontFamily: getFontFamily(context),
      color: AppColors.pureWhiteColor,
    );
  }

  static TextStyle styleBold18(BuildContext context) {
    return TextStyle(
      fontSize: getResponsiveFontSize(context, fontSize: 18),
      fontWeight: FontWeight.w700,
      fontFamily: getFontFamily(context),
      color: AppColors.pureWhiteColor,
    );
  }

  static TextStyle styleBold16(BuildContext context) {
    return TextStyle(
      fontSize: getResponsiveFontSize(context, fontSize: 16),
      fontWeight: FontWeight.w700,
      fontFamily: getFontFamily(context),
      color: AppColors.pureWhiteColor,
    );
  }

  static TextStyle styleBold13(BuildContext context) {
    return TextStyle(
      fontSize: getResponsiveFontSize(context, fontSize: 13),
      fontWeight: FontWeight.w700,
      fontFamily: getFontFamily(context),
      color: AppColors.primaryColor,
    );
  }

  static TextStyle styleBold20(BuildContext context) {
    return TextStyle(
      fontSize: getResponsiveFontSize(context, fontSize: 20),
      fontWeight: FontWeight.w700,
      fontFamily: getFontFamily(context),
      color: AppColors.pureBlackColor,
    );
  }

  static TextStyle styleSemiBold24(BuildContext context) {
    return TextStyle(
      fontSize: getResponsiveFontSize(context, fontSize: 24),
      fontWeight: FontWeight.w600,
      fontFamily: getFontFamily(context),
      color: AppColors.offBlackColor,
    );
  }

  static TextStyle styleSemiBold20(BuildContext context) {
    return TextStyle(
      fontSize: getResponsiveFontSize(context, fontSize: 20),
      fontWeight: FontWeight.w600,
      fontFamily: getFontFamily(context),
      color: AppColors.pureWhiteColor,
    );
  }

  static TextStyle styleSemiBold18(BuildContext context) {
    return TextStyle(
      fontSize: getResponsiveFontSize(context, fontSize: 18),
      fontWeight: FontWeight.w600,
      fontFamily: getFontFamily(context),
      color: AppColors.primaryColor,
    );
  }

  static TextStyle styleSemiBold16(BuildContext context) {
    return TextStyle(
      fontSize: getResponsiveFontSize(context, fontSize: 16),
      fontWeight: FontWeight.w600,
      fontFamily: getFontFamily(context),
      color: AppColors.pureBlackColor,
    );
  }

  static TextStyle styleSemiBold14(BuildContext context) {
    return TextStyle(
      fontSize: getResponsiveFontSize(context, fontSize: 14),
      fontWeight: FontWeight.w600,
      fontFamily: getFontFamily(context),
      color: AppColors.pureBlackColor,
    );
  }

  static TextStyle styleSemiBold12(BuildContext context) {
    return TextStyle(
      fontSize: getResponsiveFontSize(context, fontSize: 12),
      fontWeight: FontWeight.w600,
      fontFamily: getFontFamily(context),
      color: AppColors.primaryColor,
    );
  }

  static TextStyle styleMedium22(BuildContext context) {
    return TextStyle(
      fontSize: getResponsiveFontSize(context, fontSize: 22),
      fontWeight: FontWeight.w600,
      fontFamily: getFontFamily(context),
      color: AppColors.primaryColor,
    );
  }

  static TextStyle styleMedium20(BuildContext context) {
    return TextStyle(
      fontSize: getResponsiveFontSize(context, fontSize: 20),
      fontWeight: FontWeight.w500,
      fontFamily: getFontFamily(context),
      color: AppColors.primaryColor,
    );
  }

  static TextStyle styleMedium18(BuildContext context) {
    return TextStyle(
      fontSize: getResponsiveFontSize(context, fontSize: 18),
      fontWeight: FontWeight.w500,
      fontFamily: getFontFamily(context),
      color: AppColors.pureWhiteColor,
    );
  }

  static TextStyle styleMedium16(BuildContext context) {
    return TextStyle(
      fontSize: getResponsiveFontSize(context, fontSize: 16),
      fontWeight: FontWeight.w500,
      fontFamily: getFontFamily(context),
      color: AppColors.offBlackColor,
    );
  }

  static TextStyle styleMedium10(BuildContext context) {
    return TextStyle(
      fontSize: getResponsiveFontSize(context, fontSize: 10),
      fontWeight: FontWeight.w500,
      fontFamily: getFontFamily(context),
      color: AppColors.pureBlackColor,
    );
  }

  static TextStyle styleMedium14(BuildContext context) {
    return TextStyle(
      fontSize: getResponsiveFontSize(context, fontSize: 14),
      fontWeight: FontWeight.w500,
      fontFamily: getFontFamily(context),
      color: AppColors.greyColor,
    );
  }

  static TextStyle styleLight20(BuildContext context) {
    return TextStyle(
      fontSize: getResponsiveFontSize(context, fontSize: 20),
      fontWeight: FontWeight.w300,
      fontFamily: getFontFamily(context),
      color: AppColors.primaryColor,
    );
  }

  static TextStyle styleLight18(BuildContext context) {
    return TextStyle(
      fontSize: getResponsiveFontSize(context, fontSize: 18),
      fontWeight: FontWeight.w300,
      fontFamily: getFontFamily(context),
      color: AppColors.primaryColor,
    );
  }

  static TextStyle styleRegular22(BuildContext context) {
    return TextStyle(
      fontSize: getResponsiveFontSize(context, fontSize: 22),
      fontWeight: FontWeight.w400,
      fontFamily: getFontFamily(context),
      color: AppColors.offGreyColor,
    );
  }

  static TextStyle styleRegular20(BuildContext context) {
    return TextStyle(
      fontSize: getResponsiveFontSize(context, fontSize: 20),
      fontWeight: FontWeight.w400,
      fontFamily: getFontFamily(context),
      color: AppColors.pureWhiteColor,
    );
  }

  static TextStyle styleRegular18(BuildContext context) {
    return TextStyle(
      fontSize: getResponsiveFontSize(context, fontSize: 18),
      fontWeight: FontWeight.w400,
      fontFamily: getFontFamily(context),
      color: AppColors.primaryColor,
    );
  }

  static TextStyle styleRegular16(BuildContext context) {
    return TextStyle(
      fontSize: getResponsiveFontSize(context, fontSize: 16),
      fontWeight: FontWeight.w400,
      fontFamily: getFontFamily(context),
      color: AppColors.offBlackColor,
    );
  }

  static TextStyle styleRegular14(BuildContext context) {
    return TextStyle(
      fontSize: getResponsiveFontSize(context, fontSize: 14),
      fontWeight: FontWeight.w400,
      fontFamily: getFontFamily(context),
      color: AppColors.pureBlackColor,
    );
  }

  static TextStyle styleRegular10(BuildContext context) {
    return TextStyle(
      fontSize: getResponsiveFontSize(context, fontSize: 10),
      fontWeight: FontWeight.w400,
      fontFamily: getFontFamily(context),
      color: AppColors.lightGreyColor,
    );
  }

  static TextStyle styleRegular12(BuildContext context) {
    return TextStyle(
      fontSize: getResponsiveFontSize(context, fontSize: 12),
      fontWeight: FontWeight.w400,
      fontFamily: getFontFamily(context),
      color: Color(0xffFFD52A),
    );
  }

  static TextStyle styleMedium12(BuildContext context) {
    return TextStyle(
      fontSize: getResponsiveFontSize(context, fontSize: 12),
      fontWeight: FontWeight.w500,
      fontFamily: getFontFamily(context),
      color: AppColors.lightGreyColor,
    );
  }
}

// scaleFactor
// responsive font size
// (min , max) font size

double getResponsiveFontSize(context, {required double fontSize}) {
  double scaleFactor = getScaleFactor(context);
  double responsiveFontSize = fontSize * scaleFactor;

  double min = fontSize * .8;
  double max = fontSize * 1.2;

  return responsiveFontSize.clamp(min, max);
}

double getScaleFactor(context) {
  // var dispatcher = PlatformDispatcher.instance;
  // var physicalWidth = dispatcher.presentation.first.physicalSize.width;
  // var devicePixelRatio = dispatcher.presentation.first.devicePixelRatio;
  // double width = physicalWidth / devicePixelRatio;
  double width = MediaQuery.sizeOf(context).width;
  if (width < 700) {
    return width / 370;
  } else if (width < 1300) {
    return width / 950;
  } else {
    return width / 1700;
  }
}

String getFontFamily(BuildContext context) {
  return isArabic(context) ? AppFonts.cairoFont : AppFonts.almaraiFont;
}
