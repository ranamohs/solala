import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:solala/core/functions/floating_snack_bar.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/functions/fixed_snack_bar.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/fixed_text_fields.dart';
import '../manager/register_cubit.dart';
import '../manager/register_state.dart';

class VerificationView extends StatefulWidget {
  const VerificationView({super.key});

  @override
  State<VerificationView> createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  final TextEditingController _verificationCodeController =
  TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    _verificationCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is JoinFamilyLoadingState) {
          isLoading = true;
          setState(() {});
        } else if (state is JoinFamilySuccessState) {
          isLoading = false;
          setState(() {});
          GoRouter.of(context).pushReplacement(AppRouter.homePage);
        } else if (state is JoinFamilyFailureState) {
          isLoading = false;
          setState(() {});
          final message = state.failedModel.messageLocalized?.ar ?? state.failedModel.message ?? 'An unknown error occurred';
          fixedSnackBar(
            context,
            message: message,
            icon: Icons.error,
            iconColor: Colors.red,
            iconBgColor: Colors.red.withOpacity(0.1),
            boxColor: Colors.red.withOpacity(0.6),
            durationInSeconds: 3,
          );
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.homeBackground),
                fit: BoxFit.cover,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: SizedBox(
                  height: size.height,
                  width: size.width,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 70.h,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.h, vertical: 14.w),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryColor,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12.r),
                              bottomRight: Radius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            AppStrings.verification.tr(),
                            style:
                            AppStyles.styleSemiBold18(context).copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 100.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.h),
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: size.height * 0.25.h,
                                  child: Image.asset(
                                    AppAssets.verificationImage,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 42.w),
                          child: PrimaryTextFormField(
                            controller: _verificationCodeController,
                            labelText: AppStrings.verificationCode.tr(),
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return AppStrings.pleaseEnterVerificationCode
                                    .tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Text(
                                AppStrings.pleaseEnterTheOtpSentTo.tr(),
                                textAlign: TextAlign.center,
                                style:
                                AppStyles.styleMedium14(context).copyWith(
                                  color: AppColors.pureBlackColor,
                                ),
                              ),

                            ],
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 42.w),
                          child: PrimaryButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<RegisterCubit>().joinFamily(
                                    _verificationCodeController.text);
                              }
                            },
                            text: AppStrings.send.tr(),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Padding(
                          padding: EdgeInsets.only(bottom: 24.h),
                          child: RichText(
                            text: TextSpan(
                              style: AppStyles.styleMedium14(context).copyWith(
                                color: AppColors.pureBlackColor,
                              ),
                              children: [
                                TextSpan(text: AppStrings.didNotGetTheCode.tr() + "  " ),
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      context.read<RegisterCubit>().joinFamily(
                                          _verificationCodeController.text);
                                    },
                                  text: AppStrings.resend.tr(),
                                  style: AppStyles.styleMedium14(context)
                                      .copyWith(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
