
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/about_us.dart';
import '../../../data/repos/privacy_repo/privacy_repo.dart';
import 'privacy_state.dart';
import 'package:dartz/dartz.dart';


class PrivacyCubit extends Cubit<PrivacyState> {
  final PrivacyRepo repo;
  PrivacyCubit({required this.repo}) : super(PrivacyLoadingState());

  AboutUsModel? _cache;

  Future<void> fetchPrivacy() async {
    if (_cache != null) {
      emit(PrivacyCachedLoadingState(cachedData: _cache!));
    } else {
      emit(PrivacyLoadingState());
    }

    final Either<String, AboutUsModel> res = await repo.fetchPrivacy();
    res.fold(
          (err) => emit(PrivacyFailureState(message: err)),
          (model) {
        _cache = model;
        emit(PrivacySuccessState(info: model));
      },
    );
  }
}
