abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

class SendVerificationCodeLoading extends ForgotPasswordState {}

class SendVerificationCodeSuccess extends ForgotPasswordState {
  final String message;

  SendVerificationCodeSuccess({required this.message});
}

class SendVerificationCodeFailure extends ForgotPasswordState {
  final String errMessage;

  SendVerificationCodeFailure({required this.errMessage});
}

class ResetPasswordLoading extends ForgotPasswordState {}

class ResetPasswordSuccess extends ForgotPasswordState {
  final String message;

  ResetPasswordSuccess({required this.message});
}

class ResetPasswordFailure extends ForgotPasswordState {
  final String errMessage;

  ResetPasswordFailure({required this.errMessage});
}
