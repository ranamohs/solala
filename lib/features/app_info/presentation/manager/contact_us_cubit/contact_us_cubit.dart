
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/data/models/auth_failure_model.dart';
import '../../../../../core/data/models/auth_success_model.dart';
import '../../../data/repos/contact_us_repo/contact_us_repo.dart';
import 'contact_us_state.dart';

class ContactUsCubit extends Cubit<ContactUsState> {
  final ContactUsRepo contactUsRepo;

  ContactUsCubit({required this.contactUsRepo}) : super(ContactUsInitalState());

  Future<void> contactUs({
    required String name,
    required String email,
    required String message,
    required String subject,
    required String phoneNumber,
  }) async {
    emit(ContactUsLoadingState());

    final Either<AuthFailureModel, AuthSuccessModel> result =
        await contactUsRepo.contactUs(
          name: name,
          email: email,
          message: message,
          subject: subject,
          phoneNumber: phoneNumber,
        );

    result.fold((failure) => emit(ContactUsFailureState(failure)), (contactUs) {
      emit(ContactUsSuccessState(contactUs: contactUs));
    });
  }
}
