import 'package:solala/core/data/models/auth_failure_model.dart';
import 'package:solala/features/register/data/models/register_success_model.dart';
import 'package:equatable/equatable.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterInitialState extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class RegisterSuccessState extends RegisterState {
  final RegisterSuccessModel register;

  const RegisterSuccessState({required this.register});

  @override
  List<Object?> get props => [register];
}

class RegisterFailureState extends RegisterState {
  final AuthFailureModel failedModel;

  const RegisterFailureState(this.failedModel);

  @override
  List<Object?> get props => [failedModel];
}

class JoinFamilyLoadingState extends RegisterState {}

class JoinFamilySuccessState extends RegisterState {}

class JoinFamilyLoadingProfileState extends RegisterState {}

class JoinFamilyFailureState extends RegisterState {
  final AuthFailureModel failedModel;

  const JoinFamilyFailureState(this.failedModel);

  @override
  List<Object?> get props => [failedModel];
}

class VerifyLoginCodeLoadingState extends RegisterState {}

class VerifyLoginCodeSuccessState extends RegisterState {
  final RegisterSuccessModel register;

  const VerifyLoginCodeSuccessState({required this.register});

  @override
  List<Object?> get props => [register];
}

class VerifyLoginCodeFailureState extends RegisterState {
  final AuthFailureModel failedModel;

  const VerifyLoginCodeFailureState(this.failedModel);

  @override
  List<Object?> get props => [failedModel];
}
