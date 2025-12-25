import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repos/forgot_password_repo.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordRepo forgotPasswordRepo;
  ForgotPasswordCubit({required this.forgotPasswordRepo}) : super(ForgotPasswordInitial());

  void sendVerificationCode({required String email, required BuildContext context}) async {
    emit(SendVerificationCodeLoading());
    final result = await forgotPasswordRepo.sendVerificationCode(email: email);
    result.fold(
          (failure) => emit(SendVerificationCodeFailure(errMessage: failure.errMessage)),
          (message) {
        final locale = context.locale.languageCode;
        emit(SendVerificationCodeSuccess(message: message[locale]));
      },
    );
  }

  void resetPassword({
    required String email,
    required String code,
    required String password,
    required String passwordConfirmation,
    required BuildContext context,
  }) async {
    emit(ResetPasswordLoading());
    final result = await forgotPasswordRepo.resetPassword(
      email: email,
      code: code,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
    result.fold(
          (failure) => emit(ResetPasswordFailure(errMessage: failure.errMessage)),
          (message) {
        final locale = context.locale.languageCode;
        emit(ResetPasswordSuccess(message: message[locale]));
      },
    );
  }
}
