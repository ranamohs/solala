import 'package:solala/core/data/models/auth_failure_model.dart';
import 'package:solala/features/login/data/models/login_success_model.dart';
import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {
  final LoginSuccessModel login;

  const LoginSuccessState({required this.login});

  @override
  List<Object?> get props => [login];
}

class LoginFailureState extends LoginState {
  final AuthFailureModel failedModel;

  const LoginFailureState(this.failedModel);

  @override
  List<Object?> get props => [failedModel];
}
