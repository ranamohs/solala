import 'package:equatable/equatable.dart';

import '../../../data/models/update_profile_failure_model.dart';
import '../../../data/models/update_profile_success_model.dart';

abstract class UpdateProfileState extends Equatable {
  const UpdateProfileState();

  @override
  List<Object?> get props => [];
}

class UpdateProfileInitial extends UpdateProfileState {}

class UpdateProfileLoading extends UpdateProfileState {}

class UpdateProfileSuccess extends UpdateProfileState {
  final UpdateProfileSuccessModel success;

  const UpdateProfileSuccess({required this.success});

  @override
  List<Object?> get props => [success];
}

class UpdateProfileFailure extends UpdateProfileState {
  final UpdateProfileFailureModel failure;

  const UpdateProfileFailure(this.failure);

  @override
  List<Object?> get props => [failure];
}
