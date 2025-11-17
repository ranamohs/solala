import 'package:solala/core/errors/failure.dart';
import 'package:solala/features/home/data/models/categories_models/categories_model.dart';
import 'package:solala/features/home/data/repos/categories_repo/categories_repo.dart';
import 'package:solala/features/home/presentation/manager/categories_cubit/categories_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final CategoriesRepo categoriesRepo;

  CategoriesCubit({required this.categoriesRepo}) : super(const CategoriesInitial());

  bool get isLoadingMore => state is CategoriesLoadingMore;

  Future<void> getCategories({int page = 1}) async {
    CategoriesModel? oldModel;
    int currentPage = 1;
    int lastPage = 1;

    if (state is CategoriesSuccess) {
      final successState = state as CategoriesSuccess;
      oldModel = successState.categoriesModel;
      currentPage = successState.currentPage;
      lastPage = successState.lastPage;
    } else if (state is CategoriesLoadingMore) {
      final loadingMoreState = state as CategoriesLoadingMore;
      oldModel = loadingMoreState.categoriesModel;
      currentPage = loadingMoreState.currentPage;
      lastPage = loadingMoreState.lastPage;
    }

    if (page == 1) {
      emit(const CategoriesLoading());
    } else if (oldModel != null) {
      emit(CategoriesLoadingMore(
        categoriesModel: oldModel,
        currentPage: currentPage,
        lastPage: lastPage,
      ));
    }

    final Either<Failure, CategoriesModel> result = await categoriesRepo.getCategories(page: page);

    result.fold(
          (failure) => emit(CategoriesFailure(failure)),
          (newModel) {
        final mergedModel = (page == 1 || oldModel == null)
            ? newModel
            : _mergeCategories(oldModel, newModel);

        emit(CategoriesSuccess(
          categoriesModel: mergedModel,
          currentPage: newModel.meta.currentPage,
          lastPage: newModel.meta.lastPage,
        ));
      },
    );
  }

  void loadNextPage() {
    if (state is CategoriesSuccess) {
      final successState = state as CategoriesSuccess;
      if (successState.currentPage < successState.lastPage) {
        getCategories(page: successState.currentPage + 1);
      }
    }
  }

  void refreshCategories() {
    getCategories(page: 1);
  }

  CategoriesModel _mergeCategories(CategoriesModel oldData, CategoriesModel newData) {
    final mergedData = List<CategoryData>.from(oldData.data)..addAll(newData.data);

    return CategoriesModel(
      data: mergedData,
      links: newData.links,
      meta: newData.meta,
    );
  }
}
