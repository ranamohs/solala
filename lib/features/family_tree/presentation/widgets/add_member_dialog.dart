
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';
import '../manager/family_cubit/family_cubit.dart';
import '../manager/family_cubit/family_state.dart';

class AddMemberDialog extends StatefulWidget {
  final int parentId;
  final bool isEditMode;
  final String? existingName;
  final String? existingGender;
  final String? existingRelation;
  final String? existingAvatar;
  final int? memberId;

  const AddMemberDialog({
    super.key,
    required this.parentId,
    this.isEditMode = false,
    this.existingName,
    this.existingGender,
    this.existingRelation,
    this.existingAvatar,
    this.memberId,
  });

  @override
  State<AddMemberDialog> createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _relationController;
  String? _gender;
  File? _image;
  bool _imageChanged = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existingName ?? '');
    _relationController = TextEditingController(text: widget.existingRelation ?? '');
    _gender = widget.existingGender;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _relationController.dispose();
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
        _imageChanged = true;
      });
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Icons.delete_outline, color: Colors.red.shade700, size: 24.sp),
            ),
             SizedBox(width: 12.sp),
             Text('تأكيد الحذف', style: AppStyles.styleBold16(context)),
          ],
        ),
        content:  Text(
          'هل أنت متأكد من حذف هذا العضو؟\nلا يمكن التراجع عن هذا الإجراء.',
          style: AppStyles.styleRegular14(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('إلغاء', style: AppStyles.styleRegular14(context).copyWith(color: Colors.grey.shade600)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              // Add delete logic here
              // context.read<FamilyTreeCubit>().deleteFamilyMember(widget.memberId!);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FamilyTreeCubit, FamilyTreeState>(
      listener: (context, state) {
        if (state is AddFamilyMemberSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                   SizedBox(width: 12.w),
                  Expanded(child: Text(state.basicModel.message.ar)),
                ],
              ),
              backgroundColor: Colors.green.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
              margin: const EdgeInsets.all(16),
            ),
          );
        } else if (state is AddFamilyMemberFailure) {
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      },
      builder: (context, state) {
        return Dialog(
          backgroundColor: Colors.white.withOpacity(0.9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
          elevation: 10,
          child: Container(
            constraints:  BoxConstraints(maxWidth: 500.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with gradient
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
                    borderRadius:  BorderRadius.only(
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
                          widget.isEditMode ? Icons.edit : Icons.person_add,
                          color: Colors.white,
                          size: 28.sp,
                        ),
                      ),
                       SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          widget.isEditMode ? 'تعديل بيانات العضو' : 'إضافة عضو جديد',
                          style: AppStyles.styleBold20(context).copyWith(color: Colors.white),
                        ),
                      ),
                      if (widget.isEditMode)
                        IconButton(
                          onPressed: _showDeleteConfirmation,
                          icon: const Icon(Icons.delete_outline, color: Colors.white),
                          tooltip: 'حذف العضو',
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
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,

                                ),
                                child: CircleAvatar(
                                  radius: 55.r,
                                  backgroundColor: Colors.white,
                                  backgroundImage: _image != null
                                      ? FileImage(_image!)
                                      : (widget.existingAvatar != null && !_imageChanged
                                      ? NetworkImage(widget.existingAvatar!)
                                      : null) as ImageProvider?,
                                  child: (_image == null && (widget.existingAvatar == null || _imageChanged))
                                      ? Icon(Icons.person, size: 50, color: Colors.grey.shade400)
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
                                      border: Border.all(color: Colors.white, width: 3),

                                    ),
                                    child:  Icon(
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
                                contentPadding:  EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 8.h,
                                ),
                              ),
                              items: [
                                DropdownMenuItem(
                                  value: 'male',
                                  child: Row(
                                    children: [
                                      Icon(Icons.male, color: Colors.blue.shade700, size: 20),
                                      const SizedBox(width: 8),
                                      const Text('ذكر'),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'female',
                                  child: Row(
                                    children: [
                                      Icon(Icons.female, color: Colors.pink.shade700, size: 20.sp),
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
                          child:  Text(
                            'إلغاء',
                            style: AppStyles.styleBold16(context).copyWith(color: AppColors.secondaryColor),
                          ),
                        ),
                      ),
                       SizedBox(width: 12.w),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: state is AddFamilyMemberLoading
                              ? null
                              : () {
                            if (_formKey.currentState!.validate()) {
                              if (widget.isEditMode) {
                                // Add update logic here
                                // context.read<FamilyTreeCubit>().updateFamilyMember(...)
                              } else {
                                context.read<FamilyTreeCubit>().addFamilyMember(
                                  name: _nameController.text,
                                  gender: _gender!,
                                  relation: _relationController.text,
                                  parentId: widget.parentId,
                                  avatar: _image?.path ?? '',
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: state is AddFamilyMemberLoading
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
                              Icon(widget.isEditMode ? Icons.check : Icons.add , color: AppColors.primaryColor),
                               SizedBox(width: 8.w),
                              Text(
                                widget.isEditMode ? 'حفظ التعديلات' : 'إضافة',
                                style: AppStyles.styleBold20(context).copyWith(color: AppColors.primaryColor),
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
          contentPadding:  EdgeInsets.symmetric(
            horizontal: 8.w,
            vertical: 8.h,
          ),
        ),
        validator: validator,
      ),
    );
  }
}