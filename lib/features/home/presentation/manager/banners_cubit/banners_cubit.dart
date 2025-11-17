import 'package:solala/core/errors/failure.dart';
import 'package:solala/features/home/data/models/banners_models/banners_model.dart';
import 'package:solala/features/home/data/repos/banners_repo/banners_repo.dart';
import 'package:solala/features/home/presentation/manager/banners_cubit/banners_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BannersCubit extends Cubit<BannersState> {
  final BannersRepo bannersRepo;

  BannersCubit({required this.bannersRepo}) : super(const BannersInitial());

  Future<void> getBanners() async {
    emit(const BannersLoading());

    final Either<Failure, BannersModel> result = await bannersRepo.getBanners();

    result.fold(
      (failure) => emit(BannersFailure(failure)),
      (bannersModel) => emit(BannersSuccess(bannersModel)),
    );
  }
}
