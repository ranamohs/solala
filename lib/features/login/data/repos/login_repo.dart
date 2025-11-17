import 'package:solala/features/login/data/models/login_success_model.dart';
import 'package:solala/core/data/models/auth_failure_model.dart';
import 'package:dartz/dartz.dart';

abstract class LoginRepo {
  Future<Either<AuthFailureModel, LoginSuccessModel>> login({required String phoneNumber,required String password});
}
