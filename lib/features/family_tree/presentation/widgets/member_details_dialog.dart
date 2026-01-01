import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:solala/core/constants/app_assets.dart';
import 'package:solala/core/constants/app_colors.dart';
import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/core/constants/app_styles.dart';
import 'package:solala/features/family_tree/data/models/family_member_details_model.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class MemberDetailsDialog extends StatelessWidget {
  final FamilyMemberDetailsModel member;

  const MemberDetailsDialog({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
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
                      Icons.person,
                      color: Colors.white,
                      size: 28.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      member.name ?? '',
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
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 55.r,
                      backgroundColor: Colors.white,
                      backgroundImage: member.avatar != null &&
                          member.avatar!.isNotEmpty
                          ? CachedNetworkImageProvider(member.avatar!)
                          : AssetImage(AppAssets.accountIcon) as ImageProvider,
                    ),
                    const SizedBox(height: 28),
                    _buildDetailRow(
                        context, AppStrings.relation.tr(), member.relation),
                    _buildDetailRow(
                        context, AppStrings.gender.tr(), member.gender),
                    _buildDetailRow(
                        context,
                        AppStrings.birthDate.tr(),
                        member.birthDate != null
                            ? DateFormat('yyyy-MM-dd')
                            .format(DateTime.parse(member.birthDate!))
                            : null),
                    _buildDetailRow(context, AppStrings.birthPlace.tr(),
                        member.birthPlace),
                    _buildDetailRow(
                        context,
                        AppStrings.status.tr(),
                        member.isLive == true
                            ? AppStrings.alive.tr()
                            : AppStrings.deceased.tr()),
                    _buildDetailRow(
                        context, AppStrings.phone.tr(), member.phone),
                    _buildDetailRow(context, AppStrings.job.tr(), member.job),
                  ],
                ),
              ),
            ),
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
                        AppStrings.close.tr(),
                        style: AppStyles.styleBold16(context)
                            .copyWith(color: AppColors.secondaryColor),
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
  }

  Widget _buildDetailRow(BuildContext context, String title, String? value) {
    if (value == null || value.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$title :',
            style: AppStyles.styleMedium16(context).copyWith(
              color: AppColors.secondaryColor,

            ),
          ),
          Text(
            value,
            style: AppStyles.styleRegular16(context).copyWith(
              color: AppColors.greyColor.withOpacity(0.8),

            ),

          ),
        ],
      ),
    );
  }
}
