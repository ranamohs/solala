import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/core/constants/app_colors.dart';
import 'package:solala/core/functions/navigation.dart';
import 'package:solala/core/routes/app_router.dart';
import 'package:solala/core/widgets/spacing.dart';
import 'package:solala/features/register/data/models/register_data_model.dart';
import 'package:solala/features/register/presentation/manager/register_cubit.dart';
import 'package:solala/features/register/presentation/manager/register_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/fixit_buttons.dart';
import '../../../../core/widgets/fixit_text_fields.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  int? _selectedFamilyId;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PrimaryTextFormField(
            hintText: AppStrings.name.tr(),
            controller: _nameController,
            textInputType: TextInputType.name,
            validation: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const VerticalSpace(16),
          PrimaryTextFormField(
            maxLength: 11,
            hintText: AppStrings.phoneNumber.tr(),
            textInputType: TextInputType.phone,
            controller: _phoneController,
            validation: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
          ),
          const VerticalSpace(16),
          PrimaryTextFormField(
            hintText: AppStrings.email.tr(),
            textInputType: TextInputType.emailAddress,
            controller: _emailController,
            validation: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const VerticalSpace(16),
          BlocBuilder<RegisterCubit, RegisterState>(
            builder: (context, state) {
              if (state is GetFamiliesSuccessState) {
                return DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    hintText: AppStrings.chooseYourFamily.tr(),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  value: _selectedFamilyId,
                  items: state.families.map((family) {
                    return DropdownMenuItem<int>(
                      value: family.id,
                      child: Text(family.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFamilyId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a family';
                    }
                    return null;
                  },
                );
              } else if (state is GetFamiliesLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return PrimaryTextFormField(
                  hintText: AppStrings.chooseYourFamily.tr(),
                  enabled: false,
                );
              }
            },
          ),
          const VerticalSpace(16),
          PrimaryTextFormField(
            hintText: AppStrings.password.tr(),
            controller: _passwordController,
            textInputType: TextInputType.visiblePassword,
            isPasswordField: true,
            validation: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const VerticalSpace(16),
          PrimaryTextFormField(
            hintText: AppStrings.confirmPassword.tr(),
            controller: _confirmPasswordController,
            textInputType: TextInputType.visiblePassword,
            isPasswordField: true,
            validation: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const VerticalSpace(32),
          PrimaryButton(
            text: AppStrings.createAccount.tr(),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                FocusScope.of(context).unfocus();

                final registerData = RegisterDataModel(
                  name: _nameController.text,
                  email: _emailController.text,
                  phoneNumber: _phoneController.text,
                  password: _passwordController.text,
                  confirmPassword: _confirmPasswordController.text,
                  familyId: _selectedFamilyId!,
                );

                context.read<RegisterCubit>().register(registerData);
              }
            },
          ),
          const VerticalSpace(50),

          // Sign in link
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppStrings.alreadyHaveAnAccount.tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                ),
                const HorizontalSpace(8),
                GestureDetector(
                  onTap: () {
                    customPush(context, AppRouter.loginView);
                  },
                  child: Text(
                    AppStrings.login.tr(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.iconColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const VerticalSpace(24),
        ],
      ),
    );
  }
}