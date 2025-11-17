import 'package:solala/features/register/data/models/family_model.dart';
import 'package:solala/features/register/data/models/register_data_model.dart';
import 'package:solala/core/data/models/auth_failure_model.dart';
import 'package:solala/features/register/data/models/register_success_model.dart';
import 'package:solala/features/register/data/repos/register_repo.dart';
import 'package:solala/features/register/presentation/manager/register_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterRepo registerRepo;

  RegisterCubit({required this.registerRepo}) : super(RegisterInitialState());

  Future<void> register(RegisterDataModel registerData) async {
    emit(RegisterLoadingState());

    final Either<AuthFailureModel, RegisterSuccessModel> result =
    await registerRepo.register(registerData: registerData);

    result.fold((failure) => emit(RegisterFailureState(failure)), (register) {
      emit(RegisterSuccessState(register: register));
    });
  }

  Future<void> getFamilies() async {
    emit(GetFamiliesLoadingState());

    final Either<AuthFailureModel, List<FamilyModel>> result =
    await registerRepo.getFamilies();

    result.fold((failure) => emit(GetFamiliesFailureState(failure)), (families) {
      emit(GetFamiliesSuccessState(families: families));
    });
  }
}
