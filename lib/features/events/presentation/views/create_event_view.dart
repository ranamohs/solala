import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:solala/features/events/data/models/create_event_model.dart';
import 'package:solala/features/events/data/models/event_model.dart';
import '../../../../core/constants/app_assets.dart';
import '../manager/events_cuibt/events_cubit.dart';
import '../manager/events_cuibt/events_state.dart';

class AddEditEventView extends StatefulWidget {
  const AddEditEventView({super.key, this.event});
  final EventModel? event;

  @override
  State<AddEditEventView> createState() => _AddEditEventViewState();
}

class _AddEditEventViewState extends State<AddEditEventView> {
  bool get isArabic => context.locale.languageCode == 'ar';
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
  void initState() {
    super.initState();
    if (widget.event != null) {
      _titleArController.text = widget.event!.title?.ar ?? '';
      _titleEnController.text = widget.event!.title?.en ?? '';
      _typeArController.text = widget.event!.type?.ar ?? '';
      _typeEnController.text = widget.event!.type?.en ?? '';
      _descriptionArController.text = widget.event!.description?.ar ?? '';
      _descriptionEnController.text = widget.event!.description?.en ?? '';
      _addressArController.text = widget.event!.address?.ar ?? '';
      _addressEnController.text = widget.event!.address?.en ?? '';
      if (widget.event!.eventDate != null) {
        try {
          final date = DateTime.parse(widget.event!.eventDate!);
          _eventDateController.text = DateFormat('yyyy-MM-dd').format(date);
        } catch (_) {}
      }
    }
  }

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
          title: Text(
            widget.event == null
                ? AppStrings.createEvent.tr()
                : isArabic
                ? "تعديل المناسبة"
                : "Edit Event",
            style: AppStyles.styleBold18(context)
                .copyWith(color: AppColors.secondaryColor),
          ),
        ),
        body: BlocListener<EventsCubit, EventsState>(
          listener: (context, state) {
            if (state is CreateEventSuccess || state is UpdateEventSuccess) {
              final message = state is CreateEventSuccess
                  ? state.message
                  : (state as UpdateEventSuccess).message;
              fixedSnackBar(
                context,
                message: message,
                icon: Icons.check,
                iconColor: Colors.green,
              );
              Navigator.pop(context);
            } else if (state is CreateEventFailure ||
                state is UpdateEventFailure) {
              final message = state is CreateEventFailure
                  ? state.message
                  : (state as UpdateEventFailure).message;
              fixedSnackBar(
                context,
                message: message,
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
                            : (widget.event?.image != null
                            ? CachedNetworkImageProvider(
                            widget.event!.image!)
                            : null) as ImageProvider?,
                        child: _image == null && widget.event?.image == null
                            ? const Icon(Icons.add_a_photo,
                            size: 50, color: Colors.white)
                            : null,
                      ),
                    ),
                    const VerticalSpace(20),
                    SecondaryTextFormField(
                      controller: _titleArController,
                      labelText: AppStrings.titleAr.tr(),
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.thisFieldIsRequired.tr();
                        }
                        return null;
                      },
                    ),
                    const VerticalSpace(20),
                    SecondaryTextFormField(
                      controller: _titleEnController,
                      labelText: AppStrings.titleEn.tr(),
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.thisFieldIsRequired.tr();
                        }
                        return null;
                      },
                    ),
                    const VerticalSpace(20),
                    SecondaryTextFormField(
                      controller: _typeArController,
                      labelText: AppStrings.typeAr.tr(),
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.thisFieldIsRequired.tr();
                        }
                        return null;
                      },
                    ),
                    const VerticalSpace(20),
                    SecondaryTextFormField(
                      controller: _typeEnController,
                      labelText: AppStrings.typeEn.tr(),
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.thisFieldIsRequired.tr();
                        }
                        return null;
                      },
                    ),
                    const VerticalSpace(20),
                    SecondaryTextFormField(
                      controller: _descriptionArController,
                      labelText: AppStrings.descriptionAr.tr(),
                      maxLines: 5,
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.thisFieldIsRequired.tr();
                        }
                        return null;
                      },
                    ),
                    const VerticalSpace(20),
                    SecondaryTextFormField(
                      controller: _descriptionEnController,
                      labelText: AppStrings.descriptionEn.tr(),
                      maxLines: 5,
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.thisFieldIsRequired.tr();
                        }
                        return null;
                      },
                    ),
                    const VerticalSpace(20),
                    SecondaryTextFormField(
                      controller: _addressArController,
                      labelText: AppStrings.addressAr.tr(),
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.thisFieldIsRequired.tr();
                        }
                        return null;
                      },
                    ),
                    const VerticalSpace(20),
                    SecondaryTextFormField(
                      controller: _addressEnController,
                      labelText: AppStrings.addressEn.tr(),
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.thisFieldIsRequired.tr();
                        }
                        return null;
                      },
                    ),
                    const VerticalSpace(20),
                    SecondaryTextFormField(
                      controller: _eventDateController,
                      labelText: AppStrings.eventDate.tr(),
                      readOnly: true,
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.thisFieldIsRequired.tr();
                        }
                        return null;
                      },
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
                          isLoading: state is CreateEventLoading ||
                              state is UpdateEventLoading,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (widget.event == null) {
                                if (_image != null) {
                                  context.read<EventsCubit>().createEvent(
                                    context: context,
                                    createEventModel: CreateEventModel(
                                      titleAr: _titleArController.text,
                                      titleEn: _titleEnController.text,
                                      typeAr: _typeArController.text,
                                      typeEn: _typeEnController.text,
                                      descriptionAr:
                                      _descriptionArController.text,
                                      descriptionEn:
                                      _descriptionEnController.text,
                                      addressAr: _addressArController.text,
                                      addressEn: _addressEnController.text,
                                      eventDate: _eventDateController.text,
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
                                context.read<EventsCubit>().updateEvent(
                                  eventId: widget.event!.id!,
                                  context: context,
                                  updateEventModel: CreateEventModel(
                                    titleAr: _titleArController.text,
                                    titleEn: _titleEnController.text,
                                    typeAr: _typeArController.text,
                                    typeEn: _typeEnController.text,
                                    descriptionAr:
                                    _descriptionArController.text,
                                    descriptionEn:
                                    _descriptionEnController.text,
                                    addressAr: _addressArController.text,
                                    addressEn: _addressEnController.text,
                                    eventDate: _eventDateController.text,
                                    image: _image ?? File(''),
                                  ),
                                );
                              }
                            }
                          },
                          text: widget.event == null
                              ? AppStrings.create.tr()
                              : isArabic
                              ? "تعديل"
                              : "Update",
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
