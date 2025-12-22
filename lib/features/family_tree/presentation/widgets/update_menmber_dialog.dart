
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:solala/features/family_tree/data/models/family_model.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';
import '../manager/family_cubit/family_cubit.dart';
import '../manager/family_cubit/family_state.dart';

class UpdateMemberDialog extends StatefulWidget {
  final FamilyMember member;

  const UpdateMemberDialog({
    super.key,
    required this.member,
  });

  @override
  State<UpdateMemberDialog> createState() => _UpdateMemberDialogState();
}

class _UpdateMemberDialogState extends State<UpdateMemberDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _relationController;
  late TextEditingController _birthDateController;
  late TextEditingController _birthPlaceController;
  late TextEditingController _phoneController;
  late TextEditingController _jobController;
  String? _gender;
  File? _image;
  DateTime? _selectedDate;
  late bool _isLive;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.member.name ?? '');
    _relationController =
        TextEditingController(text: widget.member.relation ?? '');
    _birthDateController =
        TextEditingController(text: widget.member.birthDate ?? '');
    _birthPlaceController =
        TextEditingController(text: widget.member.birthPlace ?? '');
    _phoneController = TextEditingController(text: widget.member.phone ?? '');
    _jobController = TextEditingController(text: widget.member.job ?? '');
    _gender = widget.member.gender;
    _isLive = widget.member.isLive == 1;
    if (widget.member.birthDate != null && widget.member.birthDate!.isNotEmpty) {
      _selectedDate = DateTime.tryParse(widget.member.birthDate!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _relationController.dispose();
    _birthDateController.dispose();
    _birthPlaceController.dispose();
    _phoneController.dispose();
    _jobController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 512.w,
      maxHeight: 512.h,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FamilyTreeCubit, FamilyTreeState>(
      listener: (context, state) {
        if (state is UpdateFamilyMemberSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12.w),
                  Expanded(child: Text("تم التعديل بنجاح")),
                ],
              ),
              backgroundColor: Colors.green.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r)),
              margin: const EdgeInsets.all(16),
            ),
          );
        } else if (state is UpdateFamilyMemberFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  SizedBox(width: 12.w),
                  Expanded(child: Text(state.failure.errMessage)),
                ],
              ),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r)),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      },
      builder: (context, state) {
        return Dialog(
          backgroundColor: Colors.white.withOpacity(0.9),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
          elevation: 10,
          child: Container(
            constraints: BoxConstraints(maxWidth: 500.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryColor,
                        AppColors.secondaryColor.withOpacity(0.6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.r),
                      topRight: Radius.circular(24.r),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 28.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          'تعديل بيانات العضو',
                          style: AppStyles.styleBold20(context)
                              .copyWith(color: Colors.white),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Image picker with better design
                          Stack(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: CircleAvatar(
                                  radius: 55.r,
                                  backgroundColor: Colors.white,
                                  backgroundImage: _image != null
                                      ? FileImage(_image!)
                                      : (widget.member.avatar != null &&
                                      widget.member.avatar!.isNotEmpty
                                      ? NetworkImage(widget.member.avatar!)
                                      : null) as ImageProvider?,
                                  child: (_image == null &&
                                      (widget.member.avatar == null ||
                                          widget.member.avatar!.isEmpty))
                                      ? Icon(Icons.person,
                                      size: 50,
                                      color: Colors.grey.shade400)
                                      : null,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 3),
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 20.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 28),

                          // Name field
                          _buildTextField(
                            controller: _nameController,
                            label: 'الاسم',
                            icon: Icons.person_outline,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء إدخال الاسم';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // Gender dropdown
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: _gender,
                              decoration: InputDecoration(
                                labelText: 'الجنس',
                                prefixIcon: Icon(
                                  Icons.wc,
                                  color: AppColors.primaryColor,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 8.h,
                                ),
                              ),
                              items: [
                                DropdownMenuItem(
                                  value: 'male',
                                  child: Row(
                                    children: [
                                      Icon(Icons.male,
                                          color: Colors.blue.shade700,
                                          size: 20),
                                      const SizedBox(width: 8),
                                      const Text('ذكر'),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'female',
                                  child: Row(
                                    children: [
                                      Icon(Icons.female,
                                          color: Colors.pink.shade700,
                                          size: 20.sp),
                                      SizedBox(width: 8.w),
                                      const Text('أنثى'),
                                    ],
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _gender = value;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'الرجاء اختيار الجنس';
                                }
                                return null;
                              },
                            ),
                          ),

                          SizedBox(height: 16.h),

                          // Relation field
                          _buildTextField(
                            controller: _relationController,
                            label: 'صلة القرابة',
                            icon: Icons.family_restroom,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء إدخال صلة القرابة';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // Birth Date
                          _buildDateField(),

                          const SizedBox(height: 16),

                          // Birth Place
                          _buildTextField(
                            controller: _birthPlaceController,
                            label: 'مكان الميلاد',
                            icon: Icons.location_on_outlined,
                            validator: (value) => null, // Optional
                          ),

                          const SizedBox(height: 16),

                          // Phone
                          _buildTextField(
                            controller: _phoneController,
                            label: 'رقم الهاتف',
                            icon: Icons.phone_outlined,
                            validator: (value) => null, // Optional
                          ),

                          const SizedBox(height: 16),

                          // Job
                          _buildTextField(
                            controller: _jobController,
                            label: 'الوظيفة',
                            icon: Icons.work_outline,
                            validator: (value) => null,
                          ),
                          const SizedBox(height: 16),
                          _buildIsLiveSwitch(),
                        ],
                      ),
                    ),
                  ),
                ),

                // Action buttons
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(color: Colors.grey.shade400),
                          ),
                          child: Text(
                            'إلغاء',
                            style: AppStyles.styleBold16(context)
                                .copyWith(color: AppColors.secondaryColor),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: state is UpdateFamilyMemberLoading
                              ? null
                              : () {
                            if (_formKey.currentState!.validate()) {
                              context
                                  .read<FamilyTreeCubit>()
                                  .updateFamilyMember(
                                memberId: widget.member.id!,
                                name: _nameController.text,
                                gender: _gender!,
                                relation: _relationController.text,
                                avatar: _image?.path ?? '',
                                birthDate: _birthDateController.text,
                                birthPlace: _birthPlaceController.text,
                                isLive: _isLive ? 1 : 0,
                                phone: _phoneController.text,
                                job: _jobController.text,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: state is UpdateFamilyMemberLoading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check,
                                  color: AppColors.primaryColor),
                              SizedBox(width: 8.w),
                              Text(
                                'حفظ التعديلات',
                                style: AppStyles.styleBold20(context)
                                    .copyWith(
                                    color: AppColors.primaryColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColors.primaryColor),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 8.w,
            vertical: 8.h,
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDateField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: InkWell(
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: _selectedDate ?? DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (picked != null && picked != _selectedDate) {
            setState(() {
              _selectedDate = picked;
              _birthDateController.text = DateFormat('yyyy-MM-dd').format(picked);
            });
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'تاريخ الميلاد',
            prefixIcon: Icon(Icons.calendar_today_outlined, color: AppColors.primaryColor),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 8.w,
              vertical: 16.h,
            ),
          ),
          child: Text(
            _birthDateController.text.isEmpty ? 'اختيار التاريخ' : _birthDateController.text,
            style: AppStyles.styleRegular14(context).copyWith(
              color: _birthDateController.text.isEmpty ? Colors.grey.shade600 : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIsLiveSwitch() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: SwitchListTile(
        title: Text(
          'على قيد الحياة',
          style: AppStyles.styleRegular14(context),
        ),
        value: _isLive,
        onChanged: (bool value) {
          setState(() {
            _isLive = value;
          });
        },
        secondary: Icon(
          _isLive ? Icons.favorite : Icons.heart_broken_outlined,
          color: _isLive ? AppColors.primaryColor : Colors.grey,
        ),
      ),
    );
  }
}
