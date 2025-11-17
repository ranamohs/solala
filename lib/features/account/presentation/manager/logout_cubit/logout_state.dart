import 'package:equatable/equatable.dart';

import '../../../../../core/data/models/basic_model.dart';

abstract class LogoutState extends Equatable {
  const LogoutState();

  @override
  List<Object?> get props => [];
}

class LogoutInitialState extends LogoutState {}

class LogoutLoadingState extends LogoutState {}

class LogoutSuccessState extends LogoutState {
  final BasicModel success;

  const LogoutSuccessState({required this.success});

  @override
  List<Object?> get props => [success];
}

class LogoutFailureState extends LogoutState {
  final BasicModel failure;

  const LogoutFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}
