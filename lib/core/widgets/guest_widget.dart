import 'package:easy_localization/easy_localization.dart';
import 'package:solala/core/widgets/spacing.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../constants/app_styles.dart';
import '../functions/navigation.dart';
import '../routes/app_router.dart';
import 'app_buttons.dart';

class GuestWidget extends StatelessWidget {
  const GuestWidget({
    super.key,
    required this.inCircleAvatar,
    required this.svgPath,
  });

  final bool inCircleAvatar;
  final String svgPath;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        Center(
          child:
              inCircleAvatar
                  ? CircleAvatar(
                    radius: 72,
                    backgroundColor: AppColors.lightGreyColor,
                    child: SvgPicture.asset(
                      svgPath,
                      height: 72,
                      colorFilter: ColorFilter.mode(
                        AppColors.pureWhiteColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  )
                  : SvgPicture.asset(
                    svgPath,
                    height: 128,
                    colorFilter: ColorFilter.mode(
                      AppColors.lightGreyColor,
                      BlendMode.srcIn,
                    ),
                  ),
        ),
        VerticalSpace(16),
        inCircleAvatar
            ? Text('Guest', style: AppStyles.styleSemiBold24(context))
            : SizedBox.shrink(),
        Spacer(flex: 4),
        SecondaryButton(
          text: AppStrings.login.tr(),
          onPressed: () {
            customGo(context, AppRouter.loginView);
          },
        ),
        Spacer(flex: 2),
      ],
    );
  }
}
