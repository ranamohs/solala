import 'package:solala/core/data/models/auth_failure_model.dart';
import 'package:solala/core/databases/cache/user_data_manager.dart';
import 'package:solala/features/account/data/repos/update_profile_repo/update_profile_repo.dart';
import 'package:solala/features/register/data/models/register_data_model.dart';
import 'package:solala/features/register/data/models/register_success_model.dart';
import 'package:solala/features/register/data/repos/register_repo.dart';
import 'package:solala/features/register/presentation/manager/register_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterRepo registerRepo;
  final UserDataManager userDataManager;
  final UpdateProfileRepo updateProfileRepo;

  RegisterCubit({required this.registerRepo, required this.userDataManager, required this.updateProfileRepo}) : super(RegisterInitialState());

  Future<void> register(RegisterDataModel registerData) async {
    emit(RegisterLoadingState());

    final Either<AuthFailureModel, RegisterSuccessModel> result =
    await registerRepo.register(registerData: registerData);

    result.fold((failure) => emit(RegisterFailureState(failure)), (register) {
      emit(RegisterSuccessState(register: register));
    });
  }

  Future<void> verifyLoginCode(String code) async {
    emit(VerifyLoginCodeLoadingState());

    final Either<AuthFailureModel, RegisterSuccessModel> result =
    await registerRepo.verifyLoginCode(code: code);

    result.fold((failure) => emit(VerifyLoginCodeFailureState(failure)),
            (register) {
          emit(VerifyLoginCodeSuccessState(register: register));
        });
  }

  Future<void> joinFamily(String familyCode) async {
    emit(JoinFamilyLoadingState());

    final Either<AuthFailureModel, String> result =
    await registerRepo.joinFamily(familyCode: familyCode);

    result.fold((failure) => emit(JoinFamilyFailureState(failure)), (_) {
      emit(JoinFamilySuccessState());
    });
  }
}
