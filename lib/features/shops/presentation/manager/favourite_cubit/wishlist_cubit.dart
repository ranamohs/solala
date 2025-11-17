import 'package:solala/features/shops/data/models/wishlist_model.dart';
import 'package:solala/features/shops/presentation/manager/favourite_cubit/wishlist_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repos/favourite/whishlist_repo.dart';


class WishlistCubit extends Cubit<WishlistState> {
  final WishlistRepo wishlistRepo;

  WishlistCubit({required this.wishlistRepo}) : super(WishlistInitial());

  Future<void> toggleWishlist({required int shopId}) async {
    emit(WishlistLoading());
    final result = await wishlistRepo.toggleWishlist(shopId: shopId);
    result.fold(
          (failure) => emit(WishlistFailure(errorMessage: failure.errMessage)),
          (_) => emit(WishlistSuccess()),
    );
  }

  Future<void> getWishlist() async {
    emit(WishlistLoading());
    final result = await wishlistRepo.getWishlist();
    result.fold(
          (failure) => emit(WishlistFailure(errorMessage: failure.errMessage)),
          (wishlist) => emit(WishlistSuccess(wishlistModel: wishlist)),
    );
  }
}