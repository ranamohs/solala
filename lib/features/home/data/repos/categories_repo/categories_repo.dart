import 'package:solala/core/errors/failure.dart';
import 'package:solala/features/home/data/models/categories_models/categories_model.dart';
import 'package:dartz/dartz.dart';

abstract class CategoriesRepo{
  Future<Either<Failure,CategoriesModel>> getCategories({int? page});
}