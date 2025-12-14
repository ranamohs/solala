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
import 'package:solala/core/services/service_locator.dart';
import 'package:solala/core/widgets/app_buttons.dart';
import 'package:solala/core/widgets/fixed_text_fields.dart';
import 'package:solala/core/widgets/spacing.dart';
import 'package:solala/features/events/data/models/create_event_model.dart';

import '../../../../core/constants/app_assets.dart';
import '../manager/events_cuibt/events_cubit.dart';
import '../manager/events_cuibt/events_state.dart';

class CreateEventView extends StatefulWidget {
  const CreateEventView({super.key});

  @override
  State<CreateEventView> createState() => _CreateEventViewState();
}

class _CreateEventViewState extends State<CreateEventView> {
  final _formKey = GlobalKey<FormState>();
  final _titleArController = TextEditingController();
  final _titleEnController = TextEditingController();
  final _typeArController = TextEditingController();
  final _typeEnController = TextEditingController();
  final _descriptionArController = TextEditingController();
  final _descriptionEnController = TextEditingController();
  final _addressArController = TextEditingController();
  final _addressEnController = TextEditingController();
  final _eventDateController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleArController.dispose();
    _titleEnController.dispose();
    _typeArController.dispose();
    _typeEnController.dispose();
    _descriptionArController.dispose();
    _descriptionEnController.dispose();
    _addressArController.dispose();
    _addressEnController.dispose();
    _eventDateController.dispose();
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
          title: Text(AppStrings.createEvent.tr() , style: AppStyles.styleBold18(context).copyWith(color: AppColors.secondaryColor),),
        ),
        body: BlocListener<EventsCubit, EventsState>(
          listener: (context, state) {
            if (state is CreateEventSuccess) {
              fixedSnackBar(
                context,
                message: state.message,
                icon: Icons.check,
                iconColor: Colors.green,
              );
              Navigator.pop(context);
            } else if (state is CreateEventFailure) {
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
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[200],
                      backgroundImage:
                      _image != null ? FileImage(_image!) : null,
                      child: _image == null
                          ? const Icon(Icons.add_a_photo,
                          size: 50, color: Colors.grey)
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
                      controller: _typeArController,
                      labelText: AppStrings.typeAr.tr()),
                  const VerticalSpace(20),
                  SecondaryTextFormField(
                      controller: _typeEnController,
                      labelText: AppStrings.typeEn.tr()),
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
                  const VerticalSpace(20),
                  SecondaryTextFormField(
                      controller: _addressArController,
                      labelText: AppStrings.addressAr.tr()),
                  const VerticalSpace(20),
                  SecondaryTextFormField(
                      controller: _addressEnController,
                      labelText: AppStrings.addressEn.tr()),
                  const VerticalSpace(20),
                  SecondaryTextFormField(
                    controller: _eventDateController,
                    labelText: AppStrings.eventDate.tr(),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        _eventDateController.text =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                      }
                    },
                  ),
                  const VerticalSpace(30),
                  BlocBuilder<EventsCubit, EventsState>(
                    builder: (context, state) {
                      return PrimaryButton(
                        isLoading: state is CreateEventLoading,
                        onPressed: () {
                          if (_formKey.currentState!.validate() &&
                              _image != null) {
                            context.read<EventsCubit>().createEvent(
                              context: context,
                              createEventModel: CreateEventModel(
                                titleAr: _titleArController.text,
                                titleEn: _titleEnController.text,
                                typeAr: _typeArController.text,
                                typeEn: _typeEnController.text,
                                descriptionAr: _descriptionArController.text,
                                descriptionEn:
                                _descriptionEnController.text,
                                addressAr: _addressArController.text,
                                addressEn: _addressEnController.text,
                                eventDate: _eventDateController.text,
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
    );
  }
}
