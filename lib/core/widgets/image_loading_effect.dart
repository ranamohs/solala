import 'package:solala/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ImageLoadingEffect extends StatelessWidget {
  const ImageLoadingEffect({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.loadingEffectColor,
      highlightColor: AppColors.loadingEffectColor,
      child: Container(
        decoration: ShapeDecoration(
          color: AppColors.primaryColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        ),
      ),
    );
  }
}
