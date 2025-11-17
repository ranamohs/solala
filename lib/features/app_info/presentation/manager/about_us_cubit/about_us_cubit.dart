
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/about_us.dart';
import '../../../data/repos/about_us_repo/about_us_repo.dart';
import 'about_us_state.dart';
import 'package:dartz/dartz.dart';


class AboutUsCubit extends Cubit<AboutUsState> {
  final AboutUsRepo repo;
  AboutUsCubit({required this.repo}) : super(AboutUsLoadingState());

  AboutUsModel? _cache;

  Future<void> fetchAboutUs() async {
    if (_cache != null) {
      emit(AboutUsCachedLoadingState(cachedData: _cache!));
    } else {
      emit(AboutUsLoadingState());
    }

    final Either<String, AboutUsModel> res = await repo.fetchAboutUs();
    res.fold(
          (err) => emit(AboutUsFailureState(message: err)),
          (model) {
        _cache = model;
        emit(AboutUsSuccessState(info: model));
      },
    );
  }
}
