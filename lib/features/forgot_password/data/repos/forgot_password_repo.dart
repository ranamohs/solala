import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';


abstract class ForgotPasswordRepo {
  Future<Either<Failure, Map<String, dynamic>>> sendVerificationCode({required String email});
  Future<Either<Failure, Map<String, dynamic>>> resetPassword({
    required String email,
    required String code,
    required String password,
    required String passwordConfirmation,
  });
}
