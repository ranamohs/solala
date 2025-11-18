


import 'package:equatable/equatable.dart';

import '../../../../../core/data/models/basic_model.dart';
import '../../../../../core/errors/failure.dart';
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
