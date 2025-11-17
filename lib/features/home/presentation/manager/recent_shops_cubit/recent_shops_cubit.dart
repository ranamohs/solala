import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repos/recent_shops_repo/recent_shops_repo.dart';
import 'recent_shops_state.dart';

class RcenetShopsCubit extends Cubit<RcenetShopsState> {
  final RcenetShopsRepo rcenetShopsRepo;

  RcenetShopsCubit({required this.rcenetShopsRepo}) : super(const RcenetShopsInitial());

  Future<void> getRcenetShops() async {
    emit(const RcenetShopsLoading());

    final result = await rcenetShopsRepo.getRcenetShops();

    result.fold(
          (failure) => emit(RcenetShopsFailure(failure)),
          (categoriesModel) => emit(RcenetShopsSuccess(categoriesModel: categoriesModel)),
    );
  }

  void refreshRcenetShops() {
    getRcenetShops();
  }
}