import 'package:solala/core/constants/app_assets.dart';
import 'package:solala/core/constants/app_colors.dart';
import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/core/functions/navigation.dart';
import 'package:solala/core/routes/app_router.dart';
import 'package:solala/core/services/service_locator.dart';
import 'package:solala/core/state_management/user_cubit/user_cubit.dart';
import 'package:solala/core/widgets/app_buttons.dart';
import 'package:solala/features/login/presentation/manager/login_cubit.dart';
import 'package:solala/features/login/presentation/manager/login_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_styles.dart';
import '../../../../core/widgets/fixed_text_fields.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginCubit>(),
      child: const _LoginViewBody(),
    );
  }
}

class _LoginViewBody extends StatefulWidget {
  const _LoginViewBody();

  @override
  State<_LoginViewBody> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginViewBody> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          Future.delayed(const Duration(seconds: 1), () {
            context.read<UserCubit>().setGuestStatus(false);
            customGo(context, AppRouter.homePage);
          });
        } else if (state is LoginFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
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
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.w, vertical: 30.h),
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
                              AppStrings.welcomeBack.tr() + " 👋",
                              style: AppStyles.styleBold24(context).copyWith(color: AppColors.pureWhiteColor),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              AppStrings.welcomeBackSubtitle.tr(),
                              style: AppStyles.styleMedium14(context).copyWith(color: AppColors.pureWhiteColor),
                            ),
                            SizedBox(height: 30.h),

                            /// Phone
                            SecondaryTextFormField(
                              controller: _phoneController,
                              labelText: AppStrings.phoneNumber.tr(),
                              maxLength: 11,
                              validate: (v) => v!.isEmpty ? 'Please enter your phone number' : null,
                            ),

                            SizedBox(height: 16.h),

                            /// Password
                            SecondaryTextFormField(
                              isPasswordField: true,
                              suffixIcon:    Icon(Icons.remove_red_eye, color: AppColors.pureWhiteColor)   ,
                              controller: _passwordController,
                              labelText: AppStrings.password.tr(),
                              validate: (v) => v!.isEmpty ? 'Please enter your password' : null,
                            ),


                            SizedBox(height: 20.h),

                            /// Login Button
                            PrimaryButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<LoginCubit>().login(
                                    phoneNumber: _phoneController.text,
                                    password: _passwordController.text,
                                  );
                                }
                              },
                              child: state is LoginLoadingState
                                  ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                                  : Text(
                                AppStrings.login.tr(),
                                style: AppStyles.styleSemiBold18(context)
                                    .copyWith(color: AppColors.pureWhiteColor),
                              ),
                            ),

                            SizedBox(height: 26.h),

                            /// OR Separator
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.white.withOpacity(.3),
                                  ),
                                ),
                                Padding(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 8.h),
                                  child: Text(AppStrings.or.tr(),
                                      style: AppStyles.styleMedium14(context).copyWith(color: AppColors.pureWhiteColor)),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.white.withOpacity(.3),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 20.h),

                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      AppStrings.doNotHaveAnAccount.tr(),
                                      style: AppStyles.styleMedium14(context).copyWith(color: AppColors.pureWhiteColor)
                                  ),
                                  const SizedBox(width: 6),
                                  GestureDetector(
                                    onTap: () {
                                      customPush(
                                          context, AppRouter.chooseRoleView);
                                    },
                                    child:  Text(
                                        AppStrings.signUp.tr(),
                                        style: AppStyles.styleMedium14(context).copyWith(color: AppColors.primaryColor)
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 10.h),


                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}
