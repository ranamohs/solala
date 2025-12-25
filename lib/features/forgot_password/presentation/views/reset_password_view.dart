import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solala/core/constants/app_assets.dart';
import 'package:solala/core/constants/app_colors.dart';
import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/core/constants/app_styles.dart';
import 'package:solala/core/functions/navigation.dart';
import 'package:solala/core/routes/app_router.dart';
import 'package:solala/core/widgets/app_buttons.dart';
import 'package:solala/core/widgets/fixed_text_fields.dart';

import '../manager/cubit/forgot_password_cubit.dart';
import '../manager/cubit/forgot_password_state.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key, required this.email});

  final String email;

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            customGo(context, AppRouter.loginView);
          } else if (state is ResetPasswordFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.authBackground),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22.w),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(22.r),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.15),
                      ),
                    ),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.resetPassword.tr(),
                              style: AppStyles.styleBold24(context).copyWith(color: AppColors.pureWhiteColor),
                            ),
                            SizedBox(height: 30.h),
                            SecondaryTextFormField(
                              controller: _codeController,
                              labelText: AppStrings.code.tr(),
                              validate: (v) => v!.isEmpty ? AppStrings.pleaseEnterTheCode.tr() : null,
                            ),
                            SizedBox(height: 16.h),
                            SecondaryTextFormField(
                              isPasswordField: true,
                              controller: _passwordController,
                              labelText: AppStrings.newPassword.tr(),
                              validate: (v) => v!.isEmpty ? AppStrings.pleaseEnterYourNewPassword.tr() : null,
                            ),
                            SizedBox(height: 16.h),
                            SecondaryTextFormField(
                              isPasswordField: true,
                              controller: _passwordConfirmationController,
                              labelText: AppStrings.confirmNewPassword.tr(),
                              validate: (v) => v!.isEmpty ? AppStrings.pleaseConfirmYourNewPassword.tr() : null,
                            ),
                            SizedBox(height: 20.h),
                            PrimaryButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<ForgotPasswordCubit>().resetPassword(
                                    context: context,
                                    email: widget.email,
                                    code: _codeController.text,
                                    password: _passwordController.text,
                                    passwordConfirmation: _passwordConfirmationController.text,
                                  );
                                }
                              },
                              child: state is ResetPasswordLoading
                                  ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                                  : Text(
                                AppStrings.resetPassword.tr(),
                                style: AppStyles.styleSemiBold18(context).copyWith(color: AppColors.pureWhiteColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
