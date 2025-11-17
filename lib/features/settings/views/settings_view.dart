import 'package:easy_localization/easy_localization.dart';
import 'package:solala/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/functions/navigation.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/services/service_locator.dart';
import '../../account/data/repos/delete_account_repo/delete_account_repo_impl.dart';
import '../../account/presentation/manager/delete_account_cubit/delete_account_cubit.dart';
import '../../account/presentation/widgets/delete_account_dialog.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          AppStrings.settings.tr(),
          style: AppStyles.styleMedium22(context),
        ),
        elevation: 0,
        centerTitle: true,
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
    );
  }

  Widget _buildSectionHeader(String title  , BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
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

  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 0,
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: Colors.grey[700]),
        title: Text(
          title,
          style: AppStyles.styleSemiBold16(context),

        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}
