import 'package:dartz/dartz.dart';
import 'package:solala/core/errors/failure.dart';
import 'package:solala/features/shops/data/models/wishlist_model.dart';

abstract class WishlistRepo {
  Future<Either<Failure, Unit>> toggleWishlist({required int shopId});
  Future<Either<Failure, WishlistModel>> getWishlist();
}