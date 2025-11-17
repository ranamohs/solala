import 'package:solala/core/constants/app_constants.dart';
import 'package:solala/core/constants/app_styles.dart';
import 'package:solala/core/functions/is_arabic.dart';
import 'package:solala/core/functions/run_if_connected.dart';
import 'package:solala/core/routes/app_router.dart';
import 'package:solala/core/widgets/image_loading_effect.dart';
import 'package:solala/features/home/data/models/categories_models/categories_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.category,
  });

  final CategoryData category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        runIfConnected(
          context: context,
          onConnected: () {
            GoRouter.of(context).push(AppRouter.categoryDetailsView, extra: {
              'categoryId': category.id,
              'arName': category.name.ar,
              'enName': category.name.en,
            });
          },
        );
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25.r),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: category.image ?? AppConstants.noImageUrl,
                placeholder: (context, url) => const ImageLoadingEffect(),
                errorWidget: (context, url, error) => CachedNetworkImage(
                  placeholder: (context, url) => const ImageLoadingEffect(),
                  imageUrl: AppConstants.noImageUrl,
                  errorWidget: (context, url, error) =>
                  const Icon(Icons.error),
                ),
              ),
            ),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.r),
                color: AppColors.splashColor.withOpacity(0.4),
              ),
            ),
          ),


          Positioned.fill(

            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40.h),
              child: Text(
                isArabic(context) ? category.name.ar : category.name.en,
                style: AppStyles.styleExtraBold20(context),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}