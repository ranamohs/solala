import 'package:solala/features/search/presentation/manager/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repo/search_repo.dart';

class ShopsSearchCubit extends Cubit<ShopsSearchState> {
  final ShopsSearchRepo shopsSearchRepo;

  ShopsSearchCubit({required this.shopsSearchRepo}) : super(const ShopsSearchInitial());

  Future<void> searchShops(String query) async {
    emit(const ShopsSearchLoading());
    final result = await shopsSearchRepo.searchShops(query);
    result.fold(
          (failure) => emit(ShopsSearchFailure(failure)),
          (shopsModel) => emit(ShopsSearchSuccess(shopsModel: shopsModel)),
    );
  }

  void resetSearch() {
    emit(const ShopsSearchInitial());
  }
}