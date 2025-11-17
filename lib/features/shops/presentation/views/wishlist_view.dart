import 'package:easy_localization/easy_localization.dart';
import 'package:solala/core/constants/app_assets.dart';
import 'package:solala/core/constants/app_constants.dart';
import 'package:solala/core/constants/app_strings.dart';
import 'package:solala/core/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solala/features/shops/presentation/widgets/category_shops.dart';

import '../../../../core/widgets/guest_widget.dart';
import '../manager/favourite_cubit/wishlist_cubit.dart';
import '../manager/favourite_cubit/wishlist_state.dart';
import 'package:solala/core/state_management/user_cubit/user_cubit.dart'; // تأكد من المسار الصحيح

class WishlistView extends StatelessWidget {
  const WishlistView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isGuest =
    context.select<UserCubit, bool>((cubit) => cubit.state.isGuest);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.myFavourite).tr(),
      ),
      body: isGuest
          ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: GuestWidget(
            inCircleAvatar: true,
            svgPath: AppAssets.profileIcon
        ),
      )
          : BlocProvider(
        create: (context) => getIt<WishlistCubit>()..getWishlist(),
        child: BlocBuilder<WishlistCubit, WishlistState>(
          builder: (context, state) {
            if (state is WishlistLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WishlistSuccess) {
              if (state.wishlistModel!.data.isEmpty) {
                return Center(child: Text(AppStrings.noFavoritesYet).tr());
              }
              return ListView.builder(
                itemCount: state.wishlistModel!.data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ServiceTile(
                      shopData: state.wishlistModel!.data[index].product,
                    ),
                  );
                },
              );
            } else if (state is WishlistFailure) {
              return Center(child: Text(state.errorMessage));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}