import 'package:solala/core/constants/app_assets.dart';
import 'package:solala/core/constants/app_colors.dart';
import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/core/functions/navigation.dart';
import 'package:solala/core/routes/app_router.dart';
import 'package:solala/core/state_management/user_cubit/user_cubit.dart';
import 'package:solala/features/register/presentation/manager/register_cubit.dart';
import 'package:solala/features/register/presentation/manager/register_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../core/constants/app_styles.dart';
import '../../../../core/functions/fixed_snack_bar.dart';
import '../widgets/register_form.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  void initState() {
    super.initState();
    context.read<RegisterCubit>().getFamilies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccessState) {
          context.read<UserCubit>().setGuestStatus(false);
          customPush(context, AppRouter.verificationView);
        } else if (state is RegisterFailureState) {
          fixedSnackBar(
            context,
            message: state.failedModel.message,
            icon: Icons.error,
            iconColor: Colors.red,
            iconBgColor: Colors.red.withOpacity(0.1),
            boxColor: Colors.red.withOpacity(0.1),
          );
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is RegisterLoadingState,
          child: Scaffold(
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
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 30.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(22.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.18),
                        ),
                      ),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${AppStrings.getStarted.tr()} 👋",
                              style: AppStyles.styleBold24(context).copyWith(color: AppColors.pureWhiteColor),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              AppStrings.fillFormToProceed.tr(),
                              style: AppStyles.styleMedium14(context).copyWith(color: AppColors.pureWhiteColor)
                            ),
                            SizedBox(height: 30.h),

                            /// THE SAME FORM EXACTLY
                            const RegisterForm(),

                            SizedBox(height: 25.h),

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
                                  const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    "Or",
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(.9)),
                                  ),
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
                                    AppStrings.alreadyHaveAnAccount.tr(),
                                    style: AppStyles.styleMedium14(context).copyWith(color: AppColors.pureWhiteColor)
                                  ),
                                  const SizedBox(width: 6),
                                  GestureDetector(
                                    onTap: () {
                                      customPush(
                                          context, AppRouter.loginView);
                                    },
                                    child:  Text(
                                      AppStrings.login.tr(),
                                      style: AppStyles.styleMedium14(context).copyWith(color: AppColors.primaryColor)
                                    ),
                                  ),
                                ],
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
          ),
        );
      },
    );
  }
}
