import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:solala/core/constants/end_points.dart';
import 'package:solala/core/databases/cache/secure_storage_helper.dart';
import 'package:solala/core/errors/failure.dart';
import 'package:solala/features/shops/data/models/wishlist_model.dart';
import 'package:solala/features/shops/data/repos/favourite/whishlist_repo.dart';

import '../../../../../core/databases/api/dio_consumer.dart';


class WishlistRepoImp implements WishlistRepo {
  final DioConsumer dioConsumer;
  final SecureStorageHelper secureStorageHelper;

  WishlistRepoImp({
    required this.dioConsumer,
    required this.secureStorageHelper,
  });

  @override
  Future<Either<Failure, Unit>> toggleWishlist({required int shopId}) async {
    try {
      final token = await secureStorageHelper.getToken();
      await dioConsumer.post(
        EndPoints.toggleWishlist,
        data: {
          ApiKey.shopId: shopId,
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      return right(unit);
    } on DioException catch (e) {
      return left(ServerFailure(errMessage: e.response?.data['message']['ar']));
    }
  }

  @override
  Future<Either<Failure, WishlistModel>> getWishlist() async {
    try {
      final token = await secureStorageHelper.getToken();
      final response = await dioConsumer.get(
        EndPoints.wishlist,

          headers: {
            'Authorization': 'Bearer $token',
          },
        );

      return Right(WishlistModel.fromJson(response));
    } on DioException catch (e) {
      return Left(ServerFailure(errMessage: e.response?.data['message']['ar']));
    }
  }
}