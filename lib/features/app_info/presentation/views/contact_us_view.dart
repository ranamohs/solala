import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/widgets/fixed_app_bars.dart';
import '../../../../core/widgets/spacing.dart';
import 'help_and_support_view.dart';

class ContactUsView extends StatelessWidget {
  const ContactUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.settingsBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                VerticalSpace(120),
            Text(
              AppStrings.helpAndSupport.tr(),
              style: AppStyles.styleMedium22(context),
              textAlign: TextAlign.start,
            ),
                VerticalSpace(24),
                HelpAndSupportView(),
                VerticalSpace(8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}