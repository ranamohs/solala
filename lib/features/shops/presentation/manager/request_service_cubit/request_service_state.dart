

import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';

abstract class RequestServiceState extends Equatable {
  const RequestServiceState();

  @override
  List<Object?> get props => [];
}

class SelectedServiceInitialState extends RequestServiceState {}

class SelectedServiceLoadingState extends RequestServiceState {}

class SelectedServiceSuccessState extends RequestServiceState {
  //final SelectedServiceSuccessModel data;

  const SelectedServiceSuccessState();

  @override
  List<Object?> get props => [];
}

class SelectedServiceFailureState extends RequestServiceState {
  final Failure failure;

  const SelectedServiceFailureState(this.failure);

  @override
  List<Object?> get props => [failure];
}
