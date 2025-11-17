import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/functions/is_arabic.dart';
import '../../../../core/functions/run_if_connected.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/widgets/image_loading_effect.dart';
import '../../../shops/data/models/shops_model.dart';

class ShopCard extends StatelessWidget {
  final ShopData shop;
  const ShopCard({Key? key, required this.shop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool ar = isArabic(context);
    final String title = ar ? shop.name.ar : shop.name.en;

    return GestureDetector(
      onTap: () => runIfConnected(
          context: context,
          onConnected: () {
            GoRouter.of(context).push(AppRouter.categoryDetailsView, extra: {
              'categoryId': shop.id,
              'arName': shop.name.ar,
              'enName': shop.name.en,
            });
          }),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: AppColors.pureWhiteColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.primaryColor.withOpacity(0.1), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],

        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            children: [
              // Background image
              CachedNetworkImage(
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                imageUrl: shop.image ,
                placeholder: (context, url) => const ImageLoadingEffect(),
                errorWidget: (context, url, error) => Container(
                  height: 200,
                  color: AppColors.lightGreyColor,
                  alignment: Alignment.center,
                  child: Icon(Icons.broken_image, color: AppColors.greyColor),
                ),
              ),

              // Subtle top->bottom dark overlay for readability
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.05),
                        Colors.black.withOpacity(0.35),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom info panel (like the screenshot)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    // soft light gradient panel
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFF4F7F9),
                        Color(0xFFE8EFF3),
                      ],
                    ),


                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title (shop name)
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.styleBold16(context).copyWith(
                          color: const Color(0xFF1C2731),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _LinkChip(
                            label:
                            ar ? 'التفاصيل والصور' : 'Details & Photos',
                            color: const Color(0xFFFF8D24),
                            onTap: () => GoRouter.of(context).push(
                              AppRouter.categoryDetailsView,
                              extra: {
                                'categoryId': shop.id,
                                'arName': shop.name.ar,
                                'enName': shop.name.en,
                              },
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class _LinkChip extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _LinkChip({
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
            height: 1.1,
          ),
        ),
      ),
    );
  }
}