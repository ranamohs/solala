import 'package:solala/core/errors/failure.dart';
import 'package:solala/features/home/data/models/banners_models/banners_model.dart';
import 'package:dartz/dartz.dart';

abstract class BannersRepo {
  Future<Either<Failure, BannersModel>> getBanners();
}
