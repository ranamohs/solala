import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:solala/core/errors/failure.dart';
import 'package:solala/features/home/presentation/manager/family_info_cubit/family_info_state.dart';

import '../../../data/models/family_info_model/family_info_model.dart';
import '../../../data/repos/family_info_repos/family_info_repo.dart';

class FamilyInfoCubit extends Cubit<FamilyInfoState> {
  final FamilyInfoRepo familyInfoRepo;

  FamilyInfoCubit({required this.familyInfoRepo}) : super(FamilyInfoInitial());

  Future<void> getFamilyInfo({
    required String familyId,
  }) async {
    emit(FamilyInfoLoading());

    final Either<Failure, FamilyInfoModel> result =
    await familyInfoRepo.getFamilyInfo(familyId: familyId);

    result.fold(
          (failure) => emit(FamilyInfoFailure(failure)),
          (familyInfoModel) => emit(FamilyInfoSuccess(familyInfoModel)),
    );
  }
}
