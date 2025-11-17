import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_assets.dart';

class HomeAppbar extends StatelessWidget {
  final bool isArabic;

  const HomeAppbar({
    super.key,
    this.isArabic = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Logo
        Image.asset(
          AppAssets.appLogo,
          width: 52.w,
          height: 52.h,
        ),

        Spacer(),
        _circleIconButton(
          Icons.menu,
          onTap: () {
            if (isArabic) {
              Scaffold.of(context).openEndDrawer();
            } else {
              Scaffold.of(context).openDrawer();
            }
          },
        ),
      ],
    );
  }

  static Widget _circleIconButton(IconData icon, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Icon(icon, size: 24.sp),
    );
  }
}