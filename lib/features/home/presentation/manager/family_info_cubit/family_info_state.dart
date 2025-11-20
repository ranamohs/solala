import 'package:equatable/equatable.dart';
import 'package:solala/core/errors/failure.dart';

import '../../../data/models/family_info_model/family_info_model.dart';

abstract class FamilyInfoState extends Equatable {
  const FamilyInfoState();

  @override
  List<Object> get props => [];
}

class FamilyInfoInitial extends FamilyInfoState {}

class FamilyInfoLoading extends FamilyInfoState {}

class FamilyInfoSuccess extends FamilyInfoState {
  final FamilyInfoModel familyInfoModel;

  const FamilyInfoSuccess(this.familyInfoModel);

  @override
  List<Object> get props => [familyInfoModel];
}

class FamilyInfoFailure extends FamilyInfoState {
  final Failure failure;

  const FamilyInfoFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
