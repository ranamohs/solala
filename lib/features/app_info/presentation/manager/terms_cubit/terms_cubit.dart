
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/about_us.dart';
import '../../../data/repos/about_us_repo/about_us_repo.dart';
import '../../../data/repos/terms_repo/terms_repo.dart';
import 'terms_state.dart';
import 'package:dartz/dartz.dart';


class TermsCubit extends Cubit<TermsState> {
  final TermsRepo repo;
  TermsCubit({required this.repo}) : super(TermsLoadingState());

  AboutUsModel? _cache;

  Future<void> fetchTerms() async {
    if (_cache != null) {
      emit(TermsCachedLoadingState(cachedData: _cache!));
    } else {
      emit(TermsLoadingState());
    }

    final Either<String, AboutUsModel> res = await repo.fetchTerms();
    res.fold(
          (err) => emit(TermsFailureState(message: err)),
          (model) {
        _cache = model;
        emit(TermsSuccessState(info: model));
      },
    );
  }
}
