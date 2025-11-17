
import 'package:equatable/equatable.dart';

import '../../../../../core/data/models/auth_failure_model.dart';
import '../../../../../core/data/models/auth_success_model.dart';

abstract class ContactUsState extends Equatable {
  const ContactUsState();

  @override
  List<Object?> get props => [];
}

class ContactUsInitalState extends ContactUsState {}

class ContactUsLoadingState extends ContactUsState {}

class ContactUsSuccessState extends ContactUsState {
  final AuthSuccessModel contactUs;

  const ContactUsSuccessState({required this.contactUs});

  @override
  List<Object?> get props => [contactUs];
}

class ContactUsFailureState extends ContactUsState {
  final AuthFailureModel failure;

  const ContactUsFailureState(this.failure);

  @override
  List<Object?> get props => [failure];
}
