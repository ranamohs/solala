import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/databases/cache/user_data_manager.dart';
import '../../../../core/functions/fixed_snack_bar.dart';
import '../../../../core/functions/is_arabic.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/state_management/user_cubit/user_cubit.dart';
import '../manager/delete_account_cubit/delete_account_cubit.dart';
import '../manager/delete_account_cubit/delete_account_state.dart';

class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final UserDataManager userDataManager = getIt<UserDataManager>();
    return BlocConsumer<DeleteAccountCubit, DeleteAccountState>(
      listener: (context, state) {
        if (state is DeleteAccountSuccessState) {
          GoRouter.of(context).go(AppRouter.loginView);
          context.read<UserCubit>().setGuestStatus(true);
          fixedSnackBar(
            context,
            message:isArabic(context)
                ? state.success.message.ar
                : state.success.message.en,
            icon: Icons.check_circle_outline,
            boxColor: Colors.green,
          );
          userDataManager.clearAllUserData();
        } else if (state is DeleteAccountFailureState) {
          GoRouter.of(context).pop();
          fixedSnackBar(
            context,
            message:isArabic(context)
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
                  AppStrings.deleteAccount.tr(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 16),

                // Message
                Text(
                  AppStrings.deleteAccountTitle.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,

                  ),
                ),

                const SizedBox(height: 24),

                // Buttons Row
                Row(
                  children: [
                    // Cancel Button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => GoRouter.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey,
                          side: const BorderSide(color:AppColors.primaryColor),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          AppStrings.cancel.tr(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Delete Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: state is DeleteAccountLoadingState
                            ? null
                            : () {
                          context.read<DeleteAccountCubit>().deleteAccount();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          disabledBackgroundColor: Colors.red.withOpacity(0.5),
                        ),
                        child: state is DeleteAccountLoadingState
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            : Text(
                          AppStrings.confirm.tr(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
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