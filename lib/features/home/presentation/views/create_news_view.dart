import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:solala/core/constants/app_colors.dart';
import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/core/constants/app_styles.dart';
import 'package:solala/core/functions/fixed_snack_bar.dart';
import 'package:solala/core/widgets/app_buttons.dart';
import 'package:solala/core/widgets/fixed_text_fields.dart';
import 'package:solala/core/widgets/spacing.dart';
import 'package:solala/features/home/presentation/manager/news_cubit/news_cubit.dart';
import 'package:solala/features/home/presentation/manager/news_cubit/news_state.dart';

import '../../../../core/constants/app_assets.dart';
import '../../data/models/news_model/news_model.dart';

class CreateNewsView extends StatefulWidget {
  const CreateNewsView({super.key});

  @override
  State<CreateNewsView> createState() => _CreateNewsViewState();
}

class _CreateNewsViewState extends State<CreateNewsView> {
  final _formKey = GlobalKey<FormState>();
  final _titleArController = TextEditingController();
  final _titleEnController = TextEditingController();
  final _descriptionArController = TextEditingController();
  final _descriptionEnController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleArController.dispose();
    _titleEnController.dispose();
    _descriptionArController.dispose();
    _descriptionEnController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.homeBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            AppStrings.createNews.tr(),
            style: AppStyles.styleBold18(context)
                .copyWith(color: AppColors.secondaryColor),
          ),
        ),
        body: BlocListener<NewsCubit, NewsState>(
          listener: (context, state) {
            if (state is CreateNewsSuccess) {
              fixedSnackBar(
                context,
                message: state.message,
                icon: Icons.check,
                iconColor: Colors.green,
              );
              Navigator.pop(context);
            } else if (state is CreateNewsError) {
              fixedSnackBar(
                context,
                message: state.message,
                icon: Icons.error,
                iconColor: Colors.red,
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primaryColor,
                      AppColors.secondaryColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50.r,
                        backgroundColor: Colors.white54,
                        backgroundImage:
                        _image != null ? FileImage(_image!) : null,
                        child: _image == null
                            ? const Icon(Icons.add_a_photo,
                            size: 50, color: Colors.white)
                            : null,
                      ),
                    ),
                    const VerticalSpace(20),
                    SecondaryTextFormField(
                        controller: _titleArController,
                        labelText: AppStrings.titleAr.tr()),
                    const VerticalSpace(20),
                    SecondaryTextFormField(
                        controller: _titleEnController,
                        labelText: AppStrings.titleEn.tr()),
                    const VerticalSpace(20),
                    SecondaryTextFormField(
                      controller: _descriptionArController,
                      labelText: AppStrings.descriptionAr.tr(),
                      maxLines: 5,
                    ),
                    const VerticalSpace(20),
                    SecondaryTextFormField(
                      controller: _descriptionEnController,
                      labelText: AppStrings.descriptionEn.tr(),
                      maxLines: 5,
                    ),
                    const VerticalSpace(30),
                    BlocBuilder<NewsCubit, NewsState>(
                      builder: (context, state) {
                        return PrimaryButton(
                          isLoading: state is CreateNewsLoading,
                          onPressed: () {
                            if (_formKey.currentState!.validate() &&
                                _image != null) {
                              context.read<NewsCubit>().createNews(
                                CreateNewsRequestModel(
                                  titleAr: _titleArController.text,
                                  titleEn: _titleEnController.text,
                                  descriptionAr:
                                  _descriptionArController.text,
                                  descriptionEn:
                                  _descriptionEnController.text,
                                  image: _image!,
                                ),
                              );
                            } else if (_image == null) {
                              fixedSnackBar(
                                context,
                                message: AppStrings.pleaseSelectImage.tr(),
                                icon: Icons.error,
                                iconColor: Colors.red,
                              );
                            }
                          },
                          text: AppStrings.create.tr(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
