import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../shops/data/models/shops_model.dart';

abstract class ShopsSearchRepo {
  Future<Either<Failure, ShopsModel>> searchShops(String query);
}