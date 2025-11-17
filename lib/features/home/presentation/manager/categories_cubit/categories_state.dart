import 'package:solala/core/errors/failure.dart';
import 'package:solala/features/home/data/models/categories_models/categories_model.dart';
import 'package:equatable/equatable.dart';

abstract class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object?> get props => [];
}

class CategoriesInitial extends CategoriesState {
  const CategoriesInitial();
}

class CategoriesLoading extends CategoriesState {
  const CategoriesLoading();
}

class CategoriesSuccess extends CategoriesState {
  final CategoriesModel categoriesModel;
  final int currentPage;
  final int lastPage;

  const CategoriesSuccess({
    required this.categoriesModel,
    required this.currentPage,
    required this.lastPage,
  });

  @override
  List<Object?> get props => [categoriesModel, currentPage, lastPage];
}

class CategoriesLoadingMore extends CategoriesState {
  final CategoriesModel categoriesModel;
  final int currentPage;
  final int lastPage;

  const CategoriesLoadingMore({
    required this.categoriesModel,
    required this.currentPage,
    required this.lastPage,
  });

  @override
  List<Object?> get props => [categoriesModel, currentPage, lastPage];
}

class CategoriesFailure extends CategoriesState {
  final Failure failure;

  const CategoriesFailure(this.failure);

  @override
  List<Object?> get props => [failure];
}
