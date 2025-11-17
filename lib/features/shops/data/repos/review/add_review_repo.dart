import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failure.dart';

abstract class AddReviewRepo {
  Future<Either<Failure, void>> addReview({
    required int shopId,
    required int rating,
    required String comment,
  });
}