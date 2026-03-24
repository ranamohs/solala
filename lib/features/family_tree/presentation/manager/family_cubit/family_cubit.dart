import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:solala/core/errors/failure.dart';
import 'package:solala/features/family_tree/data/models/family_member_details_model.dart';

import '../../../data/models/family_model.dart';
import '../../../data/repos/family_repo.dart';
import 'family_state.dart';

class FamilyTreeCubit extends Cubit<FamilyTreeState> {
  final FamilyTreeRepo familyTreeRepo;
  FamilyTreeModel? _lastSuccessState;
  int _currentPage = 1;
  bool _isFetchingMore = false;

  FamilyTreeCubit({required this.familyTreeRepo}) : super(FamilyTreeInitial());

  Future<void> getFamilyTree({bool isPagination = false}) async {
    if (isPagination) {
      if (_isFetchingMore) return;
      if (_lastSuccessState?.meta?.currentPage ==
          _lastSuccessState?.meta?.lastPage) return;
      _isFetchingMore = true;
      _currentPage++;
      emit(FamilyTreeSuccess(_lastSuccessState!, isPaginationLoading: true));
    } else {
      _currentPage = 1;
      emit(FamilyTreeLoading());
    }

    final Either<Failure, FamilyTreeModel> result =
    await familyTreeRepo.getFamilyTree(page: _currentPage);

    if (isClosed) return;
    _isFetchingMore = false;
    result.fold(
          (failure) {
        if (isPagination) {
          _currentPage--;
          emit(FamilyTreeSuccess(_lastSuccessState!));
        } else {
          emit(FamilyTreeFailure(failure));
        }
      },
          (familyTreeModel) {
        if (isPagination && _lastSuccessState != null) {
          final updatedData = List<FamilyMember>.from(_lastSuccessState!.data ?? [])
            ..addAll(familyTreeModel.data ?? []);
          _lastSuccessState = FamilyTreeModel(
            status: familyTreeModel.status,
            message: familyTreeModel.message,
            data: updatedData,
            meta: familyTreeModel.meta,
            links: familyTreeModel.links,
          );
        } else {
          _lastSuccessState = familyTreeModel;
        }
        emit(FamilyTreeSuccess(_lastSuccessState!));
      },
    );
  }

  Future<void> searchFamilyTree({required String query}) async {
    if (_lastSuccessState == null) {
      return;
    }
    emit(FamilyTreeLoading());

    final result = await familyTreeRepo.searchFamilyTree(query: query);

    if (isClosed) return;
    result.fold(
          (failure) => emit(FamilyTreeFailure(failure)),
          (members) {
        final memberIds = members.map((e) => e.id!).toList();
        emit(FamilyTreeSuccess(_lastSuccessState!, searchResultIds: memberIds));
      },
    );
  }

  void clearSearch() {
    if (_lastSuccessState != null) {
      emit(FamilyTreeSuccess(_lastSuccessState!));
    }
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
    String? description,
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
      description: description,
    );

    if (isClosed) return;
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
    String? description,
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
      description: description,
    );

    if (isClosed) return;
    result.fold(
          (failure) => emit(UpdateFamilyMemberFailure(failure)),
          (familyMember) => emit(UpdateFamilyMemberSuccess(familyMember)),
    );
  }

  Future<void> deleteFamilyMember({required int memberId}) async {
    emit(DeleteFamilyMemberLoading());

    final result = await familyTreeRepo.deleteFamilyMember(memberId: memberId);

    if (isClosed) return;
    result.fold(
          (failure) => emit(DeleteFamilyMemberFailure(failure)),
          (basicModel) => emit(DeleteFamilyMemberSuccess(basicModel)),
    );
  }

  Future<void> createFamily({
    required String nameAr,
    required String nameEn,
    String? descriptionAr,
    String? descriptionEn,
    required String code,
    required String image,
  }) async {
    emit(CreateFamilyLoading());

    final result = await familyTreeRepo.createFamily(
      nameAr: nameAr,
      nameEn: nameEn,
      descriptionAr: descriptionAr,
      descriptionEn: descriptionEn,
      code: code,
      image: image,
    );

    if (isClosed) return;
    result.fold(
          (failure) => emit(CreateFamilyFailure(failure)),
          (basicModel) => emit(CreateFamilySuccess(basicModel)),
    );
  }

  Future<void> getFamilyMemberDetails({required int memberId}) async {
    emit(GetFamilyMemberDetailsLoading());

    final Either<Failure, FamilyMemberDetailsModel> result =
    await familyTreeRepo.getFamilyMemberDetails(memberId: memberId);

    if (isClosed) return;
    result.fold(
          (failure) => emit(GetFamilyMemberDetailsFailure(failure)),
          (memberDetailsModel) =>
          emit(GetFamilyMemberDetailsSuccess(memberDetailsModel)),
    );
  }
}