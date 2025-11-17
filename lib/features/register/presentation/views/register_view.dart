import 'package:solala/core/constants/app_strings.dart' show AppStrings;
import 'package:solala/core/constants/app_styles.dart';
import 'package:solala/core/constants/app_assets.dart';
import 'package:solala/core/constants/app_colors.dart';
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

import '../widgets/register_form.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccessState) {
          context.read<UserCubit>().setGuestStatus(false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration Successful!'),
            ),
          );
          customPush(context, AppRouter.homePage);
        } else if (state is RegisterFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
              Text(state.failedModel.message ?? 'Registration Failed!'),
            ),
          );
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is RegisterLoadingState,
          child: Scaffold(
            body: Container(
              // خلفية الصورة اللي تحت مع تغطية
              // decoration: const BoxDecoration(
              //   image: DecorationImage(
              //     image: AssetImage(AppAssets.registerBackground), // حط هنا الصورة اللي زي السكرين
              //     fit: BoxFit.cover,
              //   ),
              // ),
              child: Container(
                // طبقة جرين شفافة فوق الخلفية
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor.withOpacity(0.88),
                ),
                child: SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 24.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // العنوان زي الصورة
                          Text(
                            '${AppStrings.getStarted.tr()} 👋',
                            style: AppStyles.styleSemiBold16(context).copyWith(
                              fontSize: 24.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            AppStrings.fillFormToProceed.tr(),
                            style: AppStyles.styleRegular14(context).copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height: 32.h),
                          const RegisterForm(),
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
    );
  }
}
