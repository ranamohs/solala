import 'package:solala/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

import '../../models/categories_models/recent_shops_models.dart';

abstract class RcenetShopsRepo {
  Future<Either<Failure, RcenetShopsModel>> getRcenetShops();
}