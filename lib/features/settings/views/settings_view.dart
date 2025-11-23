import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:solala/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/functions/navigation.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/services/service_locator.dart';
import '../../../core/state_management/user_cubit/user_cubit.dart';
import '../../../core/state_management/user_cubit/user_state.dart';
import '../../account/data/repos/delete_account_repo/delete_account_repo_impl.dart';
import '../../account/data/repos/logout_repo/logout_repo_impl.dart';
import '../../account/presentation/manager/delete_account_cubit/delete_account_cubit.dart';
import '../../account/presentation/manager/logout_cubit/logout_cubit.dart';
import '../../account/presentation/widgets/delete_account_dialog.dart';
import '../../account/presentation/widgets/logout_dialog.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
       image: DecorationImage(
         image: AssetImage(AppAssets.homeBackground),
         fit: BoxFit.cover,
       )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            AppStrings.settings.tr(),
            style: AppStyles.styleBold25(context)
                .copyWith(color: AppColors.greenColor),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionHeader(AppStrings.general.tr() , context),
            _buildSettingItem(
              context: context,
              icon: Icons.language,
              title: AppStrings.changeLanguage.tr(),
              onTap: () {
                customPush(context, AppRouter.changeLanguageView);
              },
            ),
            _buildSettingItem(
              context: context,
              icon: Icons.privacy_tip_outlined,
              title: AppStrings.privacyPolicy.tr(),
              onTap: () {
                customPush(context, AppRouter.privacyPolicyView);
              },
            ),
            _buildSettingItem(
              context: context,
              icon: Icons.info_outline,
              title: AppStrings.aboutUs.tr(),
              onTap: () {
                customPush(context, AppRouter.aboutUsView);
              },
            ),

            const SizedBox(height: 24),

            _buildSectionHeader(AppStrings.account.tr() , context),
            _buildSettingItem(
              context: context,
              icon: Icons.description_outlined,
              title: AppStrings.termsAndConditions.tr(),
              onTap: () {
                customPush(context, AppRouter.termsAndConditionsView);
              },
            ),
            BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                return _buildSettingItem(
                  context: context,
                  icon: Icons.logout,
                  title: state.isGuest
                      ? AppStrings.login.tr()
                      : AppStrings.logout.tr(),
                  isLogout: true,
                  onTap: () {
                    if (state.isGuest) {
                      GoRouter.of(context).go(AppRouter.loginView);
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return BlocProvider(
                            create: (_) => LogoutCubit(
                              logoutRepo: getIt<LogoutRepoImpl>(),
                            ),
                            child: LogoutDialog(),
                          );
                        },
                      );
                    }
                  },
                );
              },
            ),
            _buildSettingItem(
              context: context,
              icon: Icons.delete_outline,
              title: AppStrings.deleteAccount.tr(),
              titleColor: Colors.red,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return BlocProvider(
                      create: (_) => DeleteAccountCubit(
                        deleteAccountRepo: getIt<DeleteAccountRepoImpl>(),
                      ),
                      child: DeleteAccountDialog(),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title  , BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: Text(
        title,
        style: AppStyles.styleSemiBold18(context),
      ),
    );
  }

  Widget _buildSettingItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    Color titleColor = Colors.black,
    required VoidCallback onTap,
    bool isLogout = false,

  }) {
    return Card(
      margin:  EdgeInsets.symmetric(vertical: 4.h),
      elevation: 0,
      color: Colors.white,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.secondaryColor.withOpacity(0.8),
          ),
          child: Icon(icon, color: AppColors.pureWhiteColor)),
        title: Text(
          title,
          style: AppStyles.styleSemiBold16(context),

        ),
        trailing:  Icon(
          Icons.arrow_forward_ios,
          size: 18.sp,
          color: AppColors.secondaryColor.withOpacity(0.8),
        ),
        onTap: onTap,
        contentPadding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      ),
    );
  }
}
