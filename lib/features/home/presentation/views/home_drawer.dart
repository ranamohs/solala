import 'package:easy_localization/easy_localization.dart';
import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/core/routes/app_router.dart';
import 'package:solala/core/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/state_management/user_cubit/user_cubit.dart';
import '../../../../core/state_management/user_cubit/user_state.dart';
import '../../../account/data/repos/logout_repo/logout_repo_impl.dart';
import '../../../account/presentation/manager/logout_cubit/logout_cubit.dart';
import '../../../account/presentation/widgets/logout_dialog.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 280.w,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Container(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              width: double.infinity,
              height: 180.h,
              decoration: BoxDecoration(
                color: Color(0xFFF4D77D),

              ),
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.close,
                          size: 24.sp,
                          color: Colors.black,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ),
                    // Circular Logo Container
                    Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Image.asset(
                          AppAssets.appLogo,
                          width: 50.w,
                          height: 50.h,
                        ),
                      ),
                    ),
                    VerticalSpace(24.h)
                  ],
                ),
              ),
            ),
            // Beige Content Section
            Expanded(
              child: Container(
                color: Color(0xFFF5EDE2),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24.h),
                      _buildDrawerItem(
                        icon: Icons.favorite_outline,
                        title: AppStrings.myFavourite.tr(),
                        onTap: () {
                          Navigator.of(context).pop();
                          GoRouter.of(context).push(AppRouter.wishlistView);
                        },
                      ),
                      // Logout Button

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(
              icon,
              size: 20.sp,
              color: isLogout ? Color(0xFF8B4513) : Colors.black87,
            ),
            SizedBox(width: 16.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isLogout ? Color(0xFF8B4513) : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}