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
  final String message;

  const LoginSuccessState({required this.message});

  @override
  List<Object?> get props => [message];
}

class LoginFailureState extends LoginState {
  final String errMessage;

  const LoginFailureState({required this.errMessage});

  @override
  List<Object?> get props => [errMessage];
}
