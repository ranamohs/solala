import 'package:solala/core/errors/failure.dart';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/shops_model.dart';
import '../../../data/repos/shops/shops_repo.dart';
import 'shops_state.dart';

class ShopsCubit extends Cubit<ShopsState> {
  final ShopsRepo servicesRepo;

  ShopsCubit({required this.servicesRepo}) : super(const ServicesInitial());

  bool get isLoadingMore => state is ServicesLoadingMore;

  Future<void> getShops({
    required int categoryId,
    int page = 1,
  }) async {
    ShopsModel? oldModel;
    int currentPage = 1;
    int lastPage = 1;

    if (state is ServicesSuccess) {
      final successState = state as ServicesSuccess;
      oldModel = successState.servicesModel;
      currentPage = successState.currentPage;
      lastPage = successState.lastPage;
    } else if (state is ServicesLoadingMore) {
      final loadingMoreState = state as ServicesLoadingMore;
      oldModel = loadingMoreState.servicesModel;
      currentPage = loadingMoreState.currentPage;
      lastPage = loadingMoreState.lastPage;
    }

    if (page == 1) {
      emit(const ServicesLoading());
    } else if (oldModel != null) {
      emit(ServicesLoadingMore(
        servicesModel: oldModel,
        currentPage: currentPage,
        lastPage: lastPage,
      ));
    }

    final Either<Failure, ShopsModel> result =
    await servicesRepo.getShops(page: page, categoryId: categoryId);

    result.fold(
          (failure) => emit(ServicesFailure(failure)),
          (newModel) {
        final mergedModel = (page == 1 || oldModel == null)
            ? newModel
            : _mergeServices(oldModel, newModel);

        emit(ServicesSuccess(
          servicesModel: mergedModel,
          currentPage: newModel.meta.currentPage,
          lastPage: newModel.meta.lastPage,
        ));
      },
    );
  }

  void loadNextPage(int categoryId) {
    if (state is ServicesSuccess) {
      final successState = state as ServicesSuccess;
      if (successState.currentPage < successState.lastPage && !isLoadingMore) {
        getShops(
          categoryId: categoryId,
          page: successState.currentPage + 1,
        );
      }
    }
  }

  void refreshServices(int categoryId) {
    getShops(categoryId: categoryId, page: 1);
  }

  ShopsModel _mergeServices(ShopsModel oldData, ShopsModel newData) {
    final mergedData = List<ShopData>.from(oldData.data)..addAll(newData.data);

    return ShopsModel(
      data: mergedData,
      links: newData.links,
      meta: newData.meta,
    );
  }
}


