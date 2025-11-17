import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/databases/cache/user_data_manager.dart';
import '../../../../core/functions/fixed_snack_bar.dart';
import '../../../../core/functions/is_arabic.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/state_management/bottom_navigation_bar_cubit/bottom_navigation_bar_cubit.dart';

import '../../../../core/widgets/fixit_app_bars.dart';
import '../../../../core/widgets/fixit_buttons.dart';
import '../../../../core/widgets/fixit_indicators.dart';
import '../../../../core/widgets/fixit_text_fields.dart';
import '../../../../core/widgets/spacing.dart';
import '../../data/models/contact_us_data_model.dart';
import '../manager/contact_us_cubit/contact_us_cubit.dart';
import '../manager/contact_us_cubit/contact_us_state.dart';

class HelpAndSupportView extends StatefulWidget {
  const HelpAndSupportView({super.key});

  @override
  State<HelpAndSupportView> createState() => _ContactUsForm();
}

class _ContactUsForm extends State<HelpAndSupportView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    final user = getIt<UserDataManager>();
    _nameController.text = user.getUserName() ?? '';
    _phoneNumberController.text = user.getUserPhoneNumber() ?? '';
    _emailController.text = user.getUserEmail() ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ContactUsCubit>(),
      child: BlocConsumer<ContactUsCubit, ContactUsState>(
        listener: (context, state) {
          if (state is ContactUsSuccessState) {
            context.read<BottomNavigationBarCubit>().changeIndex(0);
            fixedSnackBar(
              context,
              message: isArabic(context)
                  ? state.contactUs.message.ar
                  : state.contactUs.message.en,
              icon: Icons.check_circle_outline_outlined,
              boxColor: AppColors.greenColor,
            );
          } else if (state is ContactUsFailureState) {
            state.failure.errors == null
                ? fixedSnackBar(
              context,
              message: isArabic(context)
                  ? state.failure.messageLocalized?.ar
                  : state.failure.messageLocalized?.en,
              icon: Icons.error_outline,
              boxColor: AppColors.offRedColor,
            )
                : fixedSnackBar(
              context,
              message: state.failure.errors!.values.first.first,
              icon: Icons.error_outline,
              boxColor: AppColors.offRedColor,
            );
          }
        },
        builder: (context, state) {
          return
            IntrinsicHeight(

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryTextFormField(
                    hintText: AppStrings.subject.tr(),
                    controller: _subjectController,
                    textInputType: TextInputType.name,

                  ),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 60),


                  // Message Field
                  Container(
                    height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _messageController,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(12),
                          border: InputBorder.none,
                          hintText: AppStrings.yourMessage.tr(),
                        ),
                      ),
                    ),


                  const SizedBox(height: 30),

                  // Send Button
                  PrimaryButton(
                    onPressed: () {
                      final ContactUsDataModel contactUsDataModel =
                      ContactUsDataModel(
                        subject: _subjectController.text,
                        name: _nameController.text,
                        phoneNumber: _phoneNumberController.text,
                        email: _emailController.text,
                        message: _messageController.text,
                      );
                      FocusScope.of(context).unfocus();
                      context.read<ContactUsCubit>().contactUs(
                        name: _nameController.text,
                        email: _emailController.text,
                        message: _messageController.text,
                        subject: _subjectController.text,
                        phoneNumber: _phoneNumberController.text,
                      );
                    },
                    child: state is ContactUsLoadingState
                        ? PrimaryCircularProgressIndicator()
                        : Text(
                      AppStrings.send.tr(),
                      style: AppStyles.styleSemiBold20(context)
                          .copyWith(color: AppColors.pureWhiteColor),
                    ),
                  ),
                ],
              ),
            );

        },
      ),
    );
  }
}