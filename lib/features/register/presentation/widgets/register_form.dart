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

  int? _selectedFamilyId;
  InputDecoration _fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: AppStyles.styleRegular14(context).copyWith(color: AppColors.white),
      filled: true,
      fillColor: Colors.white.withOpacity(.1),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white.withOpacity(.4)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white.withOpacity(.7)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      hintStyle: TextStyle(color: Colors.white.withOpacity(.5)),
    );
  }

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
          BlocBuilder<RegisterCubit, RegisterState>(
            builder: (context, state) {
              if (state is GetFamiliesSuccessState) {
                return DropdownButtonFormField<int>(
                  value: _selectedFamilyId,
                  dropdownColor: AppColors.pureBlackColor.withOpacity(.7),
                  icon:  Icon(Icons.arrow_drop_down, color: AppColors.pureWhiteColor),
                  style: AppStyles.styleRegular14(context).copyWith(color: AppColors.white),
                  decoration: _fieldDecoration(AppStrings.chooseYourFamily.tr()),
                  items: state.families.map((f) {
                    return DropdownMenuItem(
                        value: f.id,
                        child: Text(f.name, style: AppStyles.styleRegular14(context).copyWith(color: AppColors.white),)
                    );
                  }).toList(),
                  onChanged: (v) {
                    setState(() => _selectedFamilyId = v);
                  },
                  validator: (v) =>
                  v == null ? "Please select a family" : null,
                );
              }
              return TextFormField(
                enabled: false,
                decoration: _fieldDecoration(AppStrings.chooseYourFamily.tr()),
              );
            },
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
                familyId: _selectedFamilyId!,
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
