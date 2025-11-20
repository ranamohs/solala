import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:solala/core/constants/app_colors.dart';
import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/core/constants/app_styles.dart';
import 'package:solala/core/databases/cache/user_data_manager.dart';
import 'package:solala/core/functions/is_arabic.dart';
import 'package:solala/core/services/service_locator.dart';
import 'package:solala/features/home/presentation/manager/family_info_cubit/family_info_cubit.dart';
import 'package:solala/features/home/presentation/manager/family_info_cubit/family_info_state.dart';

import '../../../../core/widgets/retry_widget.dart';

class AboutFamilySection extends StatelessWidget {
  const AboutFamilySection({super.key});

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                  text: AppStrings.about.tr(),
                  style: AppStyles.styleBold16(context)
                      .copyWith(color: AppColors.pureBlackColor)),
              TextSpan(
                  text:AppStrings.ourFamily.tr(),
                  style: AppStyles.styleBold16(context)
                      .copyWith(color: AppColors.greenColor)),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        BlocBuilder<FamilyInfoCubit, FamilyInfoState>(
          builder: (context, state) {
            if (state is FamilyInfoLoading) {
              return Center(
                child: LoadingAnimationWidget.flickr(
                  leftDotColor: AppColors.primaryColor,
                  rightDotColor: AppColors.greenColor,
                  size: 64,
                ),
              );
            } else if (state is FamilyInfoSuccess) {
              final familyInfo = state.familyInfoModel.data;
              return _buildFamilyInfoContainer(
                context,
                isArabic(context)
                    ? familyInfo?.name?.ar ?? ''
                    : familyInfo?.name?.en ?? '',
                familyInfo?.code ?? '',
              );
            } else if (state is FamilyInfoFailure) {
              return RetryWidget(
                message: state.failure.errMessage,
                onPressed: () {
                  final familyId = getIt<UserDataManager>().getUserFamilyId();
                  if (familyId != null) {
                    context
                        .read<FamilyInfoCubit>()
                        .getFamilyInfo(familyId: familyId);
                  }
                },
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }

  Widget _buildFamilyInfoContainer(
      BuildContext context, String name, String code) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color:AppColors.primaryColor, width: 1),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              decoration: const BoxDecoration(
                color:AppColors.primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                         AppStrings.familyName.tr(),
                          style: AppStyles.styleBold16(context)
                      .copyWith(color: AppColors.secondaryColor),
                        ),
                        Text(
                          ":   $name",
                          style: AppStyles.styleBold16(context)
                      .copyWith(color: AppColors.pureBlackColor),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Text(
                          AppStrings.familyCode.tr(),
                          style: AppStyles.styleBold16(context)
                      .copyWith(color: AppColors.secondaryColor),
                        ),
                        Text(":   $code", style: AppStyles.styleBold16(context)
                      .copyWith(color: AppColors.pureBlackColor),),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}