import 'package:solala/core/constants/app_colors.dart';
import 'package:solala/core/constants/app_constants.dart';
import 'package:solala/core/constants/app_styles.dart';
import 'package:solala/core/functions/is_arabic.dart';
import 'package:solala/core/routes/app_router.dart' show AppRouter;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart' show GoRouter;

import '../../../../core/services/service_locator.dart';
import '../../data/models/shops_model.dart';
import '../../data/repos/favourite/whishlist_repo.dart';
import '../manager/favourite_cubit/wishlist_cubit.dart';
import '../manager/favourite_cubit/wishlist_state.dart';

class ServiceTile extends StatefulWidget {
  const ServiceTile({
    super.key,
    required this.shopData,
  });

  final ShopData shopData;

  @override
  State<ServiceTile> createState() => _ServiceTileState();
}

class _ServiceTileState extends State<ServiceTile> {
  late bool isInWishlist;

  @override
  void initState() {
    super.initState();
    isInWishlist = widget.shopData.isInWishlist;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).push(
          AppRouter.serviceDetailsView,
          extra: widget.shopData.copyWith(
            isInWishlist: isInWishlist,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 180,
              width: double.infinity,
              color: Colors.grey[200],
              child: Stack(
                children: [
                  Image.network(
                    widget.shopData.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[600],
                        ),
                      );
                    },
                  ),
                  // Heart Icon - Top Right
                  Positioned(
                    top: 12,
                    right: 12,
                    child: BlocProvider(
                      create: (context) => WishlistCubit(
                        wishlistRepo: getIt<WishlistRepo>(),
                      ),
                      child: BlocConsumer<WishlistCubit, WishlistState>(
                        listener: (context, state) {
                          if (state is WishlistSuccess) {
                            setState(() {
                              isInWishlist = !isInWishlist;
                            });
                          }
                        },
                        builder: (context, state) {
                          return GestureDetector(
                            onTap: () {
                              context.read<WishlistCubit>().toggleWishlist(
                                shopId: widget.shopData.id,
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(8),
                              child: state is WishlistLoading
                                  ? const CircularProgressIndicator()
                                  : Icon(
                                isInWishlist
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Shop Name
          Text(
            isArabic(context)
                ? widget.shopData.name.ar
                : widget.shopData.name.en,
            style: AppStyles.styleMedium16(context).copyWith(
              color: AppColors.pureBlackColor,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}