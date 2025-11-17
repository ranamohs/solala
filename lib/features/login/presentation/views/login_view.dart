import 'package:solala/core/constants/app_assets.dart' show AppAssets;
import 'package:solala/core/constants/app_colors.dart' show AppColors;
import 'package:solala/core/constants/app_strings.dart' show AppStrings;
import 'package:solala/core/functions/navigation.dart';
import 'package:solala/core/routes/app_router.dart';
import 'package:solala/core/services/service_locator.dart';
import 'package:solala/core/state_management/user_cubit/user_cubit.dart';
import 'package:solala/features/login/presentation/manager/login_cubit.dart';
import 'package:solala/features/login/presentation/manager/login_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_styles.dart';
import '../../../../core/functions/floating_snack_bar.dart';
import '../../../../core/widgets/clickable_text.dart';
import '../../../../core/widgets/fixit_buttons.dart';
import '../../../../core/widgets/fixit_text_fields.dart';

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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
          context.read<UserCubit>().setGuestStatus(false);
          customGo(context, AppRouter.homePage);
        } else if (state is LoginFailureState) {
          floatingSnackBar(
            context,
            state.failedModel.errors!.values.first.first,
            icon: Icons.error_outline,
            boxColor: Colors.red,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.white,
                  AppColors.splashBackgroundStart,
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 24.w),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 60),
                      // Logo
                      Center(
                        child: Image.asset(
                          AppAssets.appLogo,
                          width: 109,
                          height: 109,
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Welcome Text
                      Text(
                        AppStrings.welcomeBack.tr(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppStrings.welcomeBackSubtitle.tr(),
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Phone Number Field
                      PrimaryTextFormField(
                        svgPath: AppAssets.phoneIcon,
                        hintText: AppStrings.phoneNumber.tr(),
                        controller: _phoneController,
                        type: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      // Password Field
                      PrimaryTextFormField(
                        svgPath: AppAssets.lockIcon,
                        hintText: AppStrings.password.tr(),
                        controller: _passwordController,
                        type: TextInputType.visiblePassword,
                        isPasswordField: true,
                      ),
                       SizedBox(height: 12.h),
                      Padding(
                        padding:  EdgeInsetsDirectional.only(end: 260.w),
                        child: ClickableText(
                          onTap: () {
                            customGo(context, AppRouter.homePage);
                            context.read<UserCubit>().setGuestStatus(true);
                          },
                          text: AppStrings.skip.tr(),
                          textStyle: AppStyles.styleBold13(context),
                        ),
                      ),
                      const SizedBox(height: 120),
                      // Login Button
                      state is LoginLoadingState
                          ? PrimaryButton(
                        child: CircularProgressIndicator(
                          color: AppColors.pureWhiteColor,
                        ),
                        onPressed: () {},
                      )
                          : PrimaryButton(
                        text: AppStrings.login.tr(),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          context.read<LoginCubit>().login(
                            phoneNumber: _phoneController.text.trim(),
                            password: _passwordController.text.trim(),
                          );
                        },
                      ),
                       SizedBox(height: 130.h),
                      // Sign up link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.doNotHaveAnAccount.tr(),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              customPush(context, AppRouter.registerView);
                            },
                            child: Text(
                              AppStrings.signUp.tr(),
                              style: const TextStyle(
                                color: AppColors.iconColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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