import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solala/core/state_management/user_cubit/user_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:solala/core/databases/cache/secure_storage_helper.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/databases/cache/user_data_manager.dart';
import '../../../../core/functions/fixed_snack_bar.dart';
import '../../../../core/functions/is_arabic.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/services/service_locator.dart';
import '../manager/logout_cubit/logout_cubit.dart';
import '../manager/logout_cubit/logout_state.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final UserDataManager userDataManager = getIt<UserDataManager>();
    final SecureStorageHelper secureStorageHelper = getIt<SecureStorageHelper>();
    return BlocConsumer<LogoutCubit, LogoutState>(
      listener: (context, state) {
        if (state is LogoutSuccessState) {
          secureStorageHelper.deleteToken();
          context.read<UserCubit>().setGuestStatus(true);
          GoRouter.of(context).go(AppRouter.loginView);
          userDataManager.clearAllUserData();
          fixedSnackBar(
            context,
            message: isArabic(context)
                ? state.success.message.ar
                : state.success.message.en,
            icon: Icons.check_circle_outline,
            boxColor: Colors.green,
          );
        } else if (state is LogoutFailureState) {
          secureStorageHelper.deleteToken();
          context.read<UserCubit>().setGuestStatus(true);
          GoRouter.of(context).go(AppRouter.loginView);
          userDataManager.clearAllUserData();
          fixedSnackBar(
            context,
            message: isArabic(context)
                ? state.failure.message.ar
                : state.failure.message.en,
            icon: Icons.error_outline,
            boxColor: AppColors.offRedColor,
          );
        }
      },
      builder: (context, state) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  AppStrings.logout.tr(),
                  style: AppStyles.styleBold18(context),
                ),

                 SizedBox(height: 16.h),
                Text(
                  AppStrings.logoutMessage.tr(),
                  textAlign: TextAlign.center,
                  style: AppStyles.styleRegular14(context),
                ),

                 SizedBox(height: 24.h),
                Row(
                  children: [
                    // Cancel Button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => GoRouter.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey,
                          side: const BorderSide(color: AppColors.primaryColor),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          AppStrings.cancel.tr(),
                          style: AppStyles.styleMedium16(context),
                        ),
                      ),
                    ),
                     SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: state is LogoutLoadingState
                            ? null
                            : () {
                          context.read<LogoutCubit>().logout();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          disabledBackgroundColor: Colors.grey.withOpacity(0.5),
                        ),
                        child: state is LogoutLoadingState
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            : Text(
                          AppStrings.logout.tr(),
                          style: AppStyles.styleMedium16(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

