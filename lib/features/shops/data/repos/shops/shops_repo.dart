import 'package:solala/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

import '../../models/shops_model.dart';


abstract class ShopsRepo {
  Future<Either<Failure, ShopsModel>> getShops({int? page,required int categoryId});
}
