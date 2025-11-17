import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/databases/cache/user_data_manager.dart';
import '../../../../core/functions/fixed_snack_bar.dart';
import '../../../../core/functions/is_arabic.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/state_management/bottom_navigation_bar_cubit/bottom_navigation_bar_cubit.dart';

import '../../../../core/widgets/fixit_buttons.dart';
import '../../../../core/widgets/fixit_indicators.dart';
import '../../../../core/widgets/fixit_text_fields.dart';
import '../../../../core/widgets/spacing.dart';
import '../manager/update_profile_cubit/update_profile_cubit.dart';
import '../manager/update_profile_cubit/update_profile_state.dart';
import 'editable_profile_avatar.dart';

class UpdateProfileForm extends StatefulWidget {
  const UpdateProfileForm({super.key});

  @override
  State<UpdateProfileForm> createState() => _UpdateProfileForm();
}

class _UpdateProfileForm extends State<UpdateProfileForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  File? selectedImage;

  @override
  void initState() {
    final user = getIt<UserDataManager>();
    _nameController.text = user.getUserName() ?? '';
    _emailController.text = user.getUserEmail() ?? '';
    _phoneNumberController.text = user.getUserPhoneNumber() ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<UpdateProfileCubit>(),
      child: BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
        listener: (context, state) {
          if (state is UpdateProfileSuccess) {
            setState(() {
              selectedImage = null;
            });
            context.read<BottomNavigationBarCubit>().changeIndex(0);
            fixedSnackBar(
              context,
              message: isArabic(context)
                  ? state.success.message.ar
                  : state.success.message.en,
              icon: Icons.check_circle_outline_outlined,
              boxColor: AppColors.greenColor,
            );
          } else if (state is UpdateProfileFailure) {
            state.failure.errors == null
                ? fixedSnackBar(
              context,
              message: isArabic(context)
                  ? state.failure.message.ar
                  : state.failure.message.en,
              icon: Icons.error_outline,
              boxColor: AppColors.offRedColor,
            )
                : fixedSnackBar(
              context,
              message:
              state.failure.errors!.fieldErrors!.values.first.first,
              icon: Icons.error_outline,
              boxColor: AppColors.offRedColor,
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Header Section
                  Column(
                    children: [
                      VerticalSpace(16),
                      EditableProfileAvatar(
                        onImageSelected: (image) {
                          setState(() => selectedImage = image);
                          if (image != null) {}
                        },
                      ),
                      VerticalSpace(12),
                      Text(
                        _nameController.text.isNotEmpty
                            ? _nameController.text
                            : 'Guest',
                        style: AppStyles.styleSemiBold18(context),
                      ),
                      VerticalSpace(16),
                    ],
                  ),

                  // Account Information Section
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.accountInformation.tr(),
                              style: AppStyles.styleMedium14(context),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                AppStrings.edit.tr(),
                                style: AppStyles.styleMedium14(context)
                                    .copyWith(color: AppColors.primaryColor),
                              ),
                            ),
                          ],
                        ),
                        VerticalSpace(12),

                        // Name Field
                        PrimaryTextFormField(
                          hintText: AppStrings.name.tr(),
                          controller: _nameController,
                          textInputType: TextInputType.name,

                        ),
                        const SizedBox(height: 20),

                        // Email Field
                        PrimaryTextFormField(
                          hintText: AppStrings.email.tr(),
                          textInputType: TextInputType.emailAddress,
                          controller: _emailController,
                        ),
                        const SizedBox(height: 20),

                        // Phone Field
                        PrimaryTextFormField(
                          hintText: AppStrings.phoneNumber.tr(),
                          controller: _phoneNumberController,
                          textInputType: TextInputType.phone,

                        ),

                      ],
                    ),
                  ),
                  VerticalSpace(100),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    child: PrimaryButton(
                      onPressed: () {
                        context.read<UpdateProfileCubit>().updateProfile(
                          name: _nameController.text,
                          phoneNumber: _phoneNumberController.text,
                          email: _emailController.text,
                          avatar: selectedImage,
                        );
                      },
                      child: state is UpdateProfileLoading
                          ? PrimaryCircularProgressIndicator()
                          : Text(
                        AppStrings.edit.tr(),
                        style: AppStyles.styleSemiBold16(context)
                            .copyWith(color: AppColors.pureWhiteColor),
                      ),
                    ),
                  ),
                  VerticalSpace(24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }
}