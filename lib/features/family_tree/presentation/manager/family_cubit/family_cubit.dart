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
    int? parentId,
    required String avatar,
    String? birthDate,
    String? birthPlace,
    int? isLive,
    String? phone,
    String? job,
  }) async {
    emit(AddFamilyMemberLoading());

    final result = await familyTreeRepo.addFamilyMember(
      name: name,
      gender: gender,
      relation: relation,
      parentId: parentId,
      avatar: avatar,
      birthDate: birthDate,
      birthPlace: birthPlace,
      isLive: isLive,
      phone: phone,
      job: job,
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
    String? birthDate,
    String? birthPlace,
    int? isLive,
    String? phone,
    String? job,
  }) async {
    emit(UpdateFamilyMemberLoading());

    final result = await familyTreeRepo.updateFamilyMember(
      memberId: memberId,
      name: name,
      gender: gender,
      relation: relation,
      avatar: avatar,
      birthDate: birthDate,
      birthPlace: birthPlace,
      isLive: isLive,
      phone: phone,
      job: job,
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

  Future<void> createFamily({
    required String nameAr,
    required String nameEn,
    required String code,
    required String image,
  }) async {
    emit(CreateFamilyLoading());

    final result = await familyTreeRepo.createFamily(
      nameAr: nameAr,
      nameEn: nameEn,
      code: code,
      image: image,
    );

    result.fold(
          (failure) => emit(CreateFamilyFailure(failure)),
          (basicModel) => emit(CreateFamilySuccess(basicModel)),
    );
  }
}