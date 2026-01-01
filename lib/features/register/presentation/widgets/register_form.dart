import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/core/constants/app_colors.dart';
import 'package:solala/core/constants/app_styles.dart';
import 'package:solala/core/widgets/spacing.dart';
import 'package:solala/features/register/data/models/register_data_model.dart';
import 'package:solala/features/register/presentation/manager/register_cubit.dart';
import 'package:solala/features/register/presentation/manager/register_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/fixed_text_fields.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          /// -------- Name ---------
          // TextFormField(
          //   controller: _nameController,
          //   style: const TextStyle(color: Colors.white),
          //   decoration: _fieldDecoration(AppStrings.name.tr()),
          //   validator: (v) => v!.isEmpty ? 'Please enter your name' : null,
          // ),
          SecondaryTextFormField(
            controller: _nameController,
            labelText: AppStrings.name.tr(),
            validate: (v) => v!.isEmpty ? 'Please enter your name' : null,

          ),
          const VerticalSpace(16),
          SecondaryTextFormField(
            controller: _phoneController,
            labelText: AppStrings.phoneNumber.tr(),
            maxLength: 11,
            validate: (v) => v!.isEmpty ? 'Please enter your phone number' : null,
          ),
          const VerticalSpace(16),
          SecondaryTextFormField(
            controller: _emailController,
            labelText: AppStrings.email.tr(),
            validate: (v) => v!.isEmpty ? 'Please enter your email' : null,
          ),
          const VerticalSpace(16),
          SecondaryTextFormField(
            isPasswordField: true,
            suffixIcon:    Icon(Icons.remove_red_eye, color: AppColors.pureWhiteColor)   ,
            controller: _passwordController,
            labelText: AppStrings.password.tr(),
            validate: (v) => v!.isEmpty ? 'Please enter your password' : null,
          ),
          const VerticalSpace(16),
          SecondaryTextFormField(
            isPasswordField: true,
            suffixIcon: Icon(Icons.remove_red_eye, color: AppColors.pureWhiteColor),
            controller: _confirmPasswordController,
            labelText: AppStrings.confirmPassword.tr(),
            validate: (v) => v!.isEmpty ? 'Please enter your confirm password' : null,
          ),
          const VerticalSpace(32),
          PrimaryButton( onPressed: () {
            if (_formKey.currentState!.validate()) {
              final data = RegisterDataModel(
                name: _nameController.text,
                phoneNumber: _phoneController.text,
                email: _emailController.text,
                password: _passwordController.text,
                confirmPassword: _confirmPasswordController.text,
                type: 'user',
              );
              context.read<RegisterCubit>().register(data);
            }
          },
            text: AppStrings.signUp.tr(),
          )
        ],
      ),
    );
  }
}
