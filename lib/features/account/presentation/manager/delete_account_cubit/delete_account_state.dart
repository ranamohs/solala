import 'package:equatable/equatable.dart';

import '../../../../../core/data/models/basic_model.dart';

abstract class DeleteAccountState extends Equatable {
  const DeleteAccountState();

  @override
  List<Object?> get props => [];
}

class DeleteAccountInitialState extends DeleteAccountState {}

class DeleteAccountLoadingState extends DeleteAccountState {}

class DeleteAccountSuccessState extends DeleteAccountState {
  final BasicModel success;

  const DeleteAccountSuccessState({required this.success});

  @override
  List<Object?> get props => [success];
}

class DeleteAccountFailureState extends DeleteAccountState {
  final BasicModel failure;

  const DeleteAccountFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}
