import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:solala/core/errors/failure.dart';

import '../../../data/models/family_model.dart';
import '../../../data/repos/family_repo.dart';
import 'family_state.dart';

class FamilyTreeCubit extends Cubit<FamilyTreeState> {
  final FamilyTreeRepo familyTreeRepo;

  FamilyTreeCubit({required this.familyTreeRepo}) : super(FamilyTreeInitial());

  Future<void> getFamilyTree() async {
    emit(FamilyTreeLoading());

    final Either<Failure, FamilyTreeModel> result =
    await familyTreeRepo.getFamilyTree();

    result.fold(
          (failure) => emit(FamilyTreeFailure(failure)),
          (familyTreeModel) => emit(FamilyTreeSuccess(familyTreeModel)),
    );
  }

  Future<void> addFamilyMember({
    required String name,
    required String gender,
    required String relation,
    required int parentId,
    required String avatar,
  }) async {
    emit(AddFamilyMemberLoading());

    final result = await familyTreeRepo.addFamilyMember(
      name: name,
      gender: gender,
      relation: relation,
      parentId: parentId,
      avatar: avatar,
    );

    result.fold(
          (failure) => emit(AddFamilyMemberFailure(failure)),
          (basicModel) => emit(AddFamilyMemberSuccess(basicModel)),
    );
  }

  Future<void> updateFamilyMember({
    required int memberId,
    required String name,
    required String gender,
    required String relation,
    required String avatar,
  }) async {
    emit(UpdateFamilyMemberLoading());

    final result = await familyTreeRepo.updateFamilyMember(
      memberId: memberId,
      name: name,
      gender: gender,
      relation: relation,
      avatar: avatar,
    );

    result.fold(
          (failure) => emit(UpdateFamilyMemberFailure(failure)),
          (familyMember) => emit(UpdateFamilyMemberSuccess(familyMember)),
    );
  }

  Future<void> deleteFamilyMember({required int memberId}) async {
    emit(DeleteFamilyMemberLoading());

    final result = await familyTreeRepo.deleteFamilyMember(memberId: memberId);

    result.fold(
          (failure) => emit(DeleteFamilyMemberFailure(failure)),
          (basicModel) => emit(DeleteFamilyMemberSuccess(basicModel)),
    );
  }
}