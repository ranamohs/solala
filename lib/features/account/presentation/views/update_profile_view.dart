
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/fixed_app_bars.dart';
import '../../../../core/widgets/spacing.dart';
import '../widgets/update_profile_form.dart';

class UpdateProfileView extends StatelessWidget {
  const UpdateProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            VerticalSpace(60),
            UpdateProfileForm(),
            VerticalSpace(24),
          ],
        ),
      ),
    );
  }
}


