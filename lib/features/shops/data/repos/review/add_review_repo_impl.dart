import 'package:dartz/dartz.dart';
import 'package:solala/core/constants/end_points.dart';
import 'package:solala/core/databases/api/dio_consumer.dart';

import '../../../../../core/databases/cache/secure_storage_helper.dart';
import '../../../../../core/errors/failure.dart';
import 'add_review_repo.dart';

class AddReviewRepoImpl implements AddReviewRepo {
  final DioConsumer dioConsumer;
  final SecureStorageHelper secureStorageHelper;

  AddReviewRepoImpl({required this.dioConsumer , required this.secureStorageHelper});

  @override
  Future<Either<Failure, void>> addReview({
    required int shopId,
    required int rating,
    required String comment,
  }) async {
    try {
      final token = await secureStorageHelper.getToken();
      await dioConsumer.post(
        '${EndPoints.shops}/$shopId/${EndPoints.addReview}',
        data: {
          ApiKey.rating: rating,
          ApiKey.comment: comment,
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }
}