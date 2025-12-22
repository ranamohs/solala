


import 'package:equatable/equatable.dart';

import '../../../../../core/data/models/basic_model.dart';
import '../../../../../core/errors/failure.dart';
import '../../../data/models/family_member_details_model.dart';
import '../../../data/models/family_model.dart';

abstract class FamilyTreeState extends Equatable {
  const FamilyTreeState();

  @override
  List<Object> get props => [];
}

class FamilyTreeInitial extends FamilyTreeState {}

class FamilyTreeLoading extends FamilyTreeState {}

class FamilyTreeSuccess extends FamilyTreeState {
  final FamilyTreeModel familyTreeModel;

  const FamilyTreeSuccess(this.familyTreeModel);

  @override
  List<Object> get props => [familyTreeModel];
}

class FamilyTreeFailure extends FamilyTreeState {
  final Failure failure;

  const FamilyTreeFailure(this.failure);

  @override
  List<Object> get props => [failure];
}

class GetFamilyMemberDetailsLoading extends FamilyTreeState {}

class GetFamilyMemberDetailsSuccess extends FamilyTreeState {
  final FamilyMemberDetailsModel memberDetailsModel;

  const GetFamilyMemberDetailsSuccess(this.memberDetailsModel);

  @override
  List<Object> get props => [memberDetailsModel];
}

class GetFamilyMemberDetailsFailure extends FamilyTreeState {
  final Failure failure;

  const GetFamilyMemberDetailsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}

class CreateFamilyLoading extends FamilyTreeState {}

class CreateFamilySuccess extends FamilyTreeState {
  final BasicModel basicModel;

  const CreateFamilySuccess(this.basicModel);

  @override
  List<Object> get props => [basicModel];
}

class CreateFamilyFailure extends FamilyTreeState {
  final Failure failure;

  const CreateFamilyFailure(this.failure);

  @override
  List<Object> get props => [failure];
}

class UpdateFamilyMemberLoading extends FamilyTreeState {}

class UpdateFamilyMemberSuccess extends FamilyTreeState {
  final FamilyMember familyMember;

  const UpdateFamilyMemberSuccess(this.familyMember);

  @override
  List<Object> get props => [familyMember];
}

class UpdateFamilyMemberFailure extends FamilyTreeState {
  final Failure failure;

  const UpdateFamilyMemberFailure(this.failure);

  @override
  List<Object> get props => [failure];
}

class DeleteFamilyMemberLoading extends FamilyTreeState {}

class DeleteFamilyMemberSuccess extends FamilyTreeState {
  final BasicModel basicModel;

  const DeleteFamilyMemberSuccess(this.basicModel);

  @override
  List<Object> get props => [basicModel];
}

class DeleteFamilyMemberFailure extends FamilyTreeState {
  final Failure failure;

  const DeleteFamilyMemberFailure(this.failure);

  @override
  List<Object> get props => [failure];
}

class AddFamilyMemberLoading extends FamilyTreeState {}

class AddFamilyMemberSuccess extends FamilyTreeState {
  final BasicModel basicModel;

  const AddFamilyMemberSuccess(this.basicModel);

  @override
  List<Object> get props => [basicModel];
}

class AddFamilyMemberFailure extends FamilyTreeState {
  final Failure failure;

  const AddFamilyMemberFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
