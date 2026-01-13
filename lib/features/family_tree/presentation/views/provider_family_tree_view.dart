import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:solala/core/constants/app_colors.dart';
import 'package:solala/core/constants/app_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/core/widgets/app_buttons.dart';
import 'package:solala/core/widgets/fixed_text_fields.dart';
import 'package:solala/core/widgets/spacing.dart';
import '../../../../core/functions/fixed_snack_bar.dart';
import '../manager/family_cubit/family_cubit.dart';
import '../manager/family_cubit/family_state.dart';

class ProviderFamilyView extends StatefulWidget {
  const ProviderFamilyView({super.key});

  @override
  State<ProviderFamilyView> createState() => _ProviderFamilyViewState();
}

class _ProviderFamilyViewState extends State<ProviderFamilyView> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final _nameArController = TextEditingController();
  final _nameEnController = TextEditingController();
  final _descriptionArController = TextEditingController();
  final _descriptionEnController = TextEditingController();
  final _codeController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _nameArController.dispose();
    _nameEnController.dispose();
    _descriptionArController.dispose();
    _descriptionEnController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      child: BlocConsumer<FamilyTreeCubit, FamilyTreeState>(
        listener: (context, state) {
          if (state is CreateFamilySuccess) {
            fixedSnackBar(
              context,
              message: state.basicModel.message?.ar ?? 'تم إنشاء العائلة بنجاح',
              icon: Icons.check,
              iconColor: Colors.green,
              iconBgColor: Colors.green.withOpacity(0.1),
              boxColor: Colors.green.withOpacity(0.1),
            );
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                context.read<FamilyTreeCubit>().getFamilyTree();
              }
            });
          } else if (state is CreateFamilyFailure) {
            fixedSnackBar(
              context,
              message: state.failure.errMessage,
              icon: Icons.error,
              iconColor: Colors.red,
              iconBgColor: Colors.red.withOpacity(0.1),
              boxColor: Colors.red.withOpacity(0.1),

            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 30.h),
                      padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.primaryColor,
                            AppColors.secondaryColor.withOpacity(0.9),
                          ],
                        ) ,
                        borderRadius: BorderRadius.circular(22.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.18),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppStrings.createNewFamily.tr(),
                                style: AppStyles.styleBold16(context)
                                    .copyWith(color: AppColors.greenColor),
                              ),
                              Icon(
                                Icons.people,
                                size: 32.sp,
                                color: AppColors.white,
                              ),
                            ],
                          ),
                          const VerticalSpace(24),
                          GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 50.r,
                              backgroundColor: Colors.white.withOpacity(0.1),
                              backgroundImage:
                              _image != null ? FileImage(_image!) : null,
                              child: _image == null
                                  ?  Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 40.sp,
                              )
                                  : null,
                            ),
                          ),
                          const VerticalSpace(24),
                          SecondaryTextFormField(
                            controller: _nameArController,
                            labelText: '${AppStrings.familyName.tr()} (AR)',
                            // validator: (value) {
                            //   if (value == null || value.isEmpty) {
                            //     return 'Please enter the family name in Arabic';
                            //   }
                            //   return null;
                            // },
                          ),
                          const VerticalSpace(16),
                          SecondaryTextFormField(
                            controller: _nameEnController,
                            labelText: '${AppStrings.familyName.tr()} (EN)',
                            // validator: (value) {
                            //   if (value == null || value.isEmpty) {
                            //     return 'Please enter the family name in English';
                            //   }
                            //   return null;
                            // },
                          ),
                          const VerticalSpace(16),
                          SecondaryTextFormField(
                            controller: _descriptionArController,
                            labelText: AppStrings.familyDescriptionAr.tr(),
                          ),
                          const VerticalSpace(16),
                          SecondaryTextFormField(
                            controller: _descriptionEnController,
                            labelText: AppStrings.familyDescriptionEn.tr(),
                          ),
                          const VerticalSpace(16),
                          SecondaryTextFormField(
                            controller: _codeController,
                            labelText: AppStrings.familyCode.tr(),

                          ),
                          const VerticalSpace(26),
                          PrimaryButton(
                            isLoading: state is CreateFamilyLoading,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<FamilyTreeCubit>().createFamily(
                                  nameAr: _nameArController.text,
                                  nameEn: _nameEnController.text,
                                  descriptionAr: _descriptionArController.text,
                                  descriptionEn: _descriptionEnController.text,
                                  code: _codeController.text,
                                  image: _image?.path ?? '',
                                );
                              }
                            },
                            text: AppStrings.addFamily.tr(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                  )
              );
          },
      ),
    );
  }
}
