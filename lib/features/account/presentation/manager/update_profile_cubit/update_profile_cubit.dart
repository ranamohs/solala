import 'dart:io';

import 'package:solala/features/account/presentation/manager/update_profile_cubit/update_profile_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/update_profile_failure_model.dart';
import '../../../data/models/update_profile_success_model.dart';
import '../../../data/repos/update_profile_repo/update_profile_repo.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  final UpdateProfileRepo updateProfileRepo;
  UpdateProfileCubit({required this.updateProfileRepo}) : super(UpdateProfileInitial());

  Future<void> updateProfile({required String name,required String phoneNumber,required String email,File? avatar}) async {
    emit(UpdateProfileLoading());

    final Either<UpdateProfileFailureModel, UpdateProfileSuccessModel> result = await updateProfileRepo.updateProfile(name: name, phoneNumber: phoneNumber, email: email, avatar: avatar);

    result.fold((failure) => emit(UpdateProfileFailure(failure)), (success) {
      emit(UpdateProfileSuccess(success: success));
    });
  }
}
