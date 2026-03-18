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

class AddEditNewsView extends StatefulWidget {
  const AddEditNewsView({super.key, this.report});
  final ReportData? report;

  @override
  State<AddEditNewsView> createState() => _AddEditNewsViewState();
}

class _AddEditNewsViewState extends State<AddEditNewsView> {
  final _formKey = GlobalKey<FormState>();
  final _titleArController = TextEditingController();
  final _titleEnController = TextEditingController();
  final _descriptionArController = TextEditingController();
  final _descriptionEnController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.report != null) {
      _titleArController.text = widget.report!.title?.ar ?? '';
      _titleEnController.text = widget.report!.title?.en ?? '';
      _descriptionArController.text = widget.report!.description?.ar ?? '';
      _descriptionEnController.text = widget.report!.description?.en ?? '';
    }
  }

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
            widget.report == null
                ? AppStrings.createNews.tr()
                : AppStrings.editNews.tr(),
            style: AppStyles.styleBold18(context)
                .copyWith(color: AppColors.secondaryColor),
          ),
        ),
        body: BlocListener<NewsCubit, NewsState>(
          listener: (context, state) {
            if (state is CreateNewsSuccess || state is UpdateNewsSuccess) {
              fixedSnackBar(
                context,
                message: state is CreateNewsSuccess
                    ? state.message
                    : (state as UpdateNewsSuccess).message,
                icon: Icons.check,
                iconColor: Colors.green,
              );
              Navigator.pop(context);
            } else if (state is CreateNewsError || state is UpdateNewsError) {
              fixedSnackBar(
                context,
                message: state is CreateNewsError
                    ? state.message
                    : (state as UpdateNewsError).message,
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
                        backgroundImage: _image != null
                            ? FileImage(_image!)
                            : (widget.report?.image != null
                            ? NetworkImage(widget.report!.image!)
                            : null) as ImageProvider?,
                        child: _image == null && widget.report?.image == null
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
                          isLoading: state is CreateNewsLoading ||
                              state is UpdateNewsLoading,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (widget.report == null) {
                                if (_image != null) {
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
                                } else {
                                  fixedSnackBar(
                                    context,
                                    message: AppStrings.pleaseSelectImage.tr(),
                                    icon: Icons.error,
                                    iconColor: Colors.red,
                                  );
                                }
                              } else {
                                context.read<NewsCubit>().updateNews(
                                  widget.report!.id!,
                                  CreateNewsRequestModel(
                                    titleAr: _titleArController.text,
                                    titleEn: _titleEnController.text,
                                    descriptionAr:
                                    _descriptionArController.text,
                                    descriptionEn:
                                    _descriptionEnController.text,
                                    image: _image,
                                  ),
                                );
                              }
                            }
                          },
                          text: widget.report == null
                              ? AppStrings.create.tr()
                              : AppStrings.update.tr(),
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
