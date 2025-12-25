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

class SendCodeView extends StatefulWidget {
  const SendCodeView({super.key});

  @override
  State<SendCodeView> createState() => _SendCodeViewState();
}

class _SendCodeViewState extends State<SendCodeView> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state is SendVerificationCodeSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            customPush(context, AppRouter.resetPasswordView, extra: _emailController.text );
          } else if (state is SendVerificationCodeFailure) {

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
                              AppStrings.forgotPassword.tr(),
                              style: AppStyles.styleBold24(context).copyWith(color: AppColors.pureWhiteColor),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              AppStrings.enterYourEmail.tr(),
                              style: AppStyles.styleMedium14(context).copyWith(color: AppColors.pureWhiteColor),
                            ),
                            SizedBox(height: 30.h),
                            SecondaryTextFormField(
                              controller: _emailController,
                              labelText: AppStrings.email.tr(),
                              validate: (v) => v!.isEmpty ? AppStrings.pleaseEnterYourEmail.tr() : null,
                            ),
                            SizedBox(height: 20.h),
                            PrimaryButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<ForgotPasswordCubit>().sendVerificationCode(context: context, email: _emailController.text);
                                }
                              },
                              child: state is SendVerificationCodeLoading
                                  ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                                  : Text(
                                AppStrings.sendVerificationCode.tr(),
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
